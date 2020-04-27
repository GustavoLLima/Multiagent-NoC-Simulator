breed [routers router]
breed [espioes espiao]
extensions [csv]

routers-own
[
;  north-buffer
;  east-buffer
;  south-buffer
;  west-buffer
;  PE-buffer

  occupancy-rate
  buffer-in

  buffer-out

  temporary-buffer-PE

  busy


  list-temporario

  routing-table

  sum-heatmap-occ-i
  sum-heatmap-occ-o
  sum-heatmap-occ-io

  sum-heatmap-max-i
  sum-heatmap-max-o
  sum-heatmap-max-io
]

globals
[
  ;temporario
  temporario
  cheio

  execution-time

  total-flits-received
  total-packets-received

  min-latency
  min-hops

  acc-latency
  acc-hops
  first-flit-ever
  avg-latency
  avg-hops

  max-latency
  max-hops

  cycles-left-to-generate

  packet-number

  file-name

  list-orientated-source-id
  list-orientated-destination-x
  list-orientated-destination-y

  stop-simulation

  name-of-files
]

to setup

  ;temporario
  set cheio 0
  set temporario 0

  clear-all

  set first-flit-ever true

  generate-noc

  set cycles-left-to-generate ticks-to-new-traffic-generation

  set packet-number 0

;  ask routers
;  [
;    set north-buffer ["N"]
;    set east-buffer ["E"]
;    set south-buffer ["S"]
;    set west-buffer ["W"]
;    set PE-buffer ["PE"]
;
;    set routing-table []
;
;    set list-temporario []
;
;    set list-temporario lput north-buffer list-temporario
;    set list-temporario lput east-buffer list-temporario
;    set list-temporario lput south-buffer list-temporario
;    set list-temporario lput west-buffer list-temporario
;    set list-temporario lput PE-buffer list-temporario
;
;  ]

  ask routers
  [
    set occupancy-rate 0
    set routing-table []
    set busy [-1 -1 -1 -1 -1]
    set buffer-in []
    set buffer-out []
    set temporary-buffer-PE []

    set sum-heatmap-occ-i 0
    set sum-heatmap-occ-o 0
    set sum-heatmap-occ-io 0

    set sum-heatmap-max-i 0
    set sum-heatmap-max-o 0
    set sum-heatmap-max-io 0
  ]

;  let time (remove-item 6(remove-item 7(remove-item 8 (remove "-"(remove " "(remove "."(remove ":" date-and-time)))))))
;  let date (remove "-" (substring date-and-time 16 27))
;  let time (remove "." remove ":" remove " " (substring date-and-time 0 15))
  let name-of-file date-and-time
  set name-of-file (replace-item 2 name-of-file "-")
  set name-of-file (replace-item 5 name-of-file "-")
  set name-of-file (replace-item 8 name-of-file "-")
  set name-of-file (remove-item 7 name-of-file)
  set name-of-file (remove-item 7 name-of-file)
  set name-of-file (remove-item 7 name-of-file)
  set name-of-file (remove-item 7 name-of-file)
  set name-of-file (remove-item 8 name-of-file)
  set file-name (word name-of-file".csv")


  ;set file-name 15
  ;set file-name word file-name ".csv"



;  set list-orientated-source-id [1 3 5]
;  set list-orientated-destination-x [-49 -49 -49]
;  set list-orientated-destination-y [48 48 48]

  set list-orientated-source-id []
  set list-orientated-destination-x []
  set list-orientated-destination-y []



;  ask router 0
;  [
;    ;a
;
;    set temporary-buffer-PE [[0 "H" 0 -50 48 0 0] [0 "B" 0 -50 48 0 0] [0 "T" 0 -50 48 0 0]]
;  ]
;  ask router 2
;  [
;    set temporary-buffer-PE [[1 "H" 0 -48 48 0 0] [1 "B" 0 -48 48 0 0] [1 "T" 0 -48 48 0 0]]
;  ]

  reset-ticks

  set stop-simulation false

  ask patches [
    set pcolor 8
  ]
end

to update-arbitrator
  ifelse (arbitrator = "Round-Robin")
  [
    ifelse(ticks = 0)
    [
      ask routers
      [
        ;; ESSE IF É SÓ PARA TESTES
        ifelse (who = 0)
        [
        set buffer-in []
        ;set buffer-in lput ["N" [18 "H" 2 -50 49 11 1] [18 "B" 2 -50 49 11 1]] buffer-in
        ;set buffer-in lput ["N" [18 "H" 2 -50 49 11 1]] buffer-in
        set buffer-in lput ["N"] buffer-in
        set buffer-in lput ["E"] buffer-in
        set buffer-in lput ["S"] buffer-in
;        set buffer-in lput ["W" [-2 "H" -1 -50 48 0 -1] [-2 "B" -1 -50 48 0 -1] [-2 "T" -1 -50 48 0 -1]] buffer-in
;        set buffer-in lput ["PE" [0 "H" -1 -50 48 0 -1] [0 "B" -1 -50 48 0 -1] [0 "T" -1 -50 48 0 -1]] buffer-in
        set buffer-in lput ["W"] buffer-in


        set buffer-in lput ["PE"] buffer-in



        ]
        [
          set buffer-in []
          ;set buffer-in lput ["N" [18 "H" 2 -50 49 11 1] [18 "B" 2 -50 49 11 1]] buffer-in
          ;set buffer-in lput ["N" [18 "H" 2 -50 49 11 1]] buffer-in
          set buffer-in lput ["N"] buffer-in
          set buffer-in lput ["E"] buffer-in
          set buffer-in lput ["S"] buffer-in
          set buffer-in lput ["W"] buffer-in
          set buffer-in lput ["PE"] buffer-in
        ]

        set buffer-out []
        set buffer-out lput ["N"] buffer-out
        set buffer-out lput ["E"] buffer-out
        set buffer-out lput ["S"] buffer-out
        set buffer-out lput ["W"] buffer-out
        set buffer-out lput ["PE"] buffer-out
      ]
    ]
    [
      ask routers
      [
        let temporary-list []
        set temporary-list item 0 buffer-in
        set buffer-in remove-item 0 buffer-in
        set buffer-in lput temporary-list buffer-in
      ]
    ]
  ]
  [
    ;;Para implementar outros árbitros
  ]
end


to generate-noc
  ;;Posicionamento dos roteadores
  let initial-x -50
  let initial-y 50

;let initial-x 0
;let initial-y 0
  let lines number_of_lines
  let columns number_of_columns
  while [lines > 0]
  [
    while [columns > 0]
    [
      create-routers 1
      [
        set shape "square"
        set color white
        set size 0.5

        setxy initial-x initial-y
      ]
      set initial-x initial-x + 1
      set columns (columns - 1)
    ]
    set initial-x -50
;    set initial-x 0
    set initial-y (initial-y - 1)
    set columns number_of_columns
    set lines (lines - 1)
  ]
end

to orientated-send

  ask router (destination-id)
  [
    set list-orientated-source-id lput source-id list-orientated-source-id
    set list-orientated-destination-x lput xcor list-orientated-destination-x
    set list-orientated-destination-y lput ycor list-orientated-destination-y
  ]

;  set list-orientated-source-id lput 1 list-orientated-source-id
;  set list-orientated-destination-x lput -49 list-orientated-destination-x
;  set list-orientated-destination-y lput 48 list-orientated-destination-y
;
;  set list-orientated-source-id lput 3 list-orientated-source-id
;  set list-orientated-destination-x lput -49 list-orientated-destination-x
;  set list-orientated-destination-y lput 48 list-orientated-destination-y
;
;  set list-orientated-source-id lput 5 list-orientated-source-id
;  set list-orientated-destination-x lput -49 list-orientated-destination-x
;  set list-orientated-destination-y lput 48 list-orientated-destination-y
end

to manual-send
  let x-destination 0
  let y-destination 0


  ask router (destination-id)
  [
    set x-destination xcor
    set y-destination ycor
  ]

  ask router (source-id)
  [
    ifelse (((length temporary-buffer-PE) + packet-size) <= (temporary-buffer-size))
    [
      set temporary-buffer-PE lput (list packet-number "H" ticks x-destination y-destination 0 ticks) temporary-buffer-PE

      let number-of-bodies (packet-size - 2)

      while [number-of-bodies > 0]
      [
        set temporary-buffer-PE lput (list packet-number "B" ticks x-destination y-destination 0 ticks) temporary-buffer-PE
        set number-of-bodies (number-of-bodies - 1)
      ]

      set temporary-buffer-PE lput (list packet-number "T" ticks x-destination y-destination 0 ticks) temporary-buffer-PE

      set packet-number (packet-number + 1)
    ]
    [
      ;
    ]
  ]
  ;orientated-source-id
  ;orientated-destination-id
end

to generate-new-packets

  ifelse (traffic-type = "Random-By-Radius")
  [
    set temporario (temporario + 1)
    ;let number-of-bodies (packet-size - 2)

;    while [number-of-bodies > 0]
;    [
;      ask one-of routers
;      [
;        let x-source xcor
;        let y-source ycor
;
;        ask one-of other routers in-radius radius
;        [
;          let x-destination xcor
;          let y-destination ycor
;
;          ;temporary-buffer-PE
;
;          set temporary-buffer-PE lput [packet-number "B" -1 -50 48 0 -1] temporary-buffer-PE
;
;          set packet-number (packet-number + 1)
;
;
;        ]
;      ]
;
;      set number-of-bodies (number-of-bodies - 1)
;    ]

    ask one-of routers
    [
      ifelse (((length temporary-buffer-PE) + packet-size) <= (temporary-buffer-size))
      [
        ;Esse será o destino
        let x-destination xcor
        let y-destination ycor


        ask one-of other routers in-radius radius
        [
          ;Esse será a origem (onda a mensagem será gerada)
          ;let x-source xcor
          ;let y-source ycor

          ;temporary-buffer-PE
          ;[-2 "H" -1 -50 48 0 -1]

          set temporary-buffer-PE lput (list packet-number "H" ticks x-destination y-destination 0 ticks) temporary-buffer-PE

          let number-of-bodies (packet-size - 2)

          while [number-of-bodies > 0]
          [
            set temporary-buffer-PE lput (list packet-number "B" ticks x-destination y-destination 0 ticks) temporary-buffer-PE
            set number-of-bodies (number-of-bodies - 1)
          ]

          set temporary-buffer-PE lput (list packet-number "T" ticks x-destination y-destination 0 ticks) temporary-buffer-PE

          set packet-number (packet-number + 1)
        ]
      ]
      [
        set cheio (cheio + 1)
      ]
    ]


  ]
  [
    ifelse (traffic-type = "Orientated")
    [
      set temporario (temporario + 1)

      if (length list-orientated-source-id > 0)
      [
        ;
        ;list-orientated-source-id
        ;list-orientated-destination-x
        ;list-orientated-destination-y

        let i random (length list-orientated-source-id)
        ;
        ;      print (item i list-orientated-source-id)
        ;      print (item i list-orientated-destination-x)
        ;      print (item i list-orientated-destination-y)

        ask router (item i list-orientated-source-id)
        [
          ifelse (((length temporary-buffer-PE) + packet-size) <= (temporary-buffer-size))
          [
            set temporary-buffer-PE lput (list packet-number "H" ticks (item i list-orientated-destination-x) (item i list-orientated-destination-y) 0 ticks) temporary-buffer-PE

            let number-of-bodies (packet-size - 2)

            while [number-of-bodies > 0]
            [
              set temporary-buffer-PE lput (list packet-number "B" ticks (item i list-orientated-destination-x) (item i list-orientated-destination-y) 0 ticks) temporary-buffer-PE
              set number-of-bodies (number-of-bodies - 1)
            ]

            set temporary-buffer-PE lput (list packet-number "T" ticks (item i list-orientated-destination-x) (item i list-orientated-destination-y) 0 ticks) temporary-buffer-PE

            ;        print "roteador"
            ;        print who
            ;        print temporary-buffer-PE

            set packet-number (packet-number + 1)
          ]
          [
            set cheio (cheio + 1)
          ]
        ]

        ;print "--"
      ]


    ]
    [
      ; Para implementar novos tipos de tráfego
    ]
  ]
end


to go

;  ask router 7
;  [
;    print buffer-in
;  ]

  if (number_of_lines * number_of_columns < 2)
  [
    user-message (word "The simulation must have at least two routers")
    set stop-simulation true
    stop
  ]

  if (ticks = simulation-length)
  [
    file-close
    ;user-message (temporario)
    ;user-message (cheio)

    print-heatmap
    set stop-simulation true
    stop
  ]

  ;Gerar Tráfego
  if (generate-traffic)
  [
    ifelse (cycles-left-to-generate = 1)
    [
      let number-of-new-packets packets-per-generation
      while [number-of-new-packets > 0]
      [
        generate-new-packets

        set number-of-new-packets (number-of-new-packets - 1)
      ]
      set cycles-left-to-generate ticks-to-new-traffic-generation
    ]
    [
      set cycles-left-to-generate (cycles-left-to-generate - 1)
    ]
  ]

;  print "***"
;  print "inicio do ciclo"
;  print ticks
;  ask routers
;  [
;    print "--"
;    print who
;    print "bin"
;    print buffer-in
;    print "bout"
;    print buffer-out
;    print "temporary"
;    print temporary-buffer-PE
;    print "--"
;  ]
;  print "***"


  if (ticks = 0)
  [
    reset-timer
  ]

  ;print "--------------------------------------------------------------"
  ;print "No tick"
  ;print ticks
;  ask routers
;  [
;    ;print "-------------------------------"
;    ;print "roteador"
;    ;print who
;    ;print "Inicio"
;    ;print "buffer-in"
;    ;print buffer-in
;    ;print "buffer-out"
;    ;print buffer-out
;    ;print "busy"
;    ;print busy
;    ;print "tabela de roteamento"
;    ;print routing-table
;    ;print "-------------------------------"
;  ]
;  ;print "-------------------------------"

  ;;print "---"
  ;;print "diminuindo ciclos"
  ;Diminuir ciclos - tabela de roteamento, buffer de saida


  ;ask router 0
  ask routers
  [
    update-arbitrator

    if (ticks > 0)
    [

      ;Passar flits do buffer temporário do PE para o PE real (entrada)



      if (length temporary-buffer-PE > 0)
      [
        let aa 0

        while [aa < length buffer-in]
        [
          ;;print item 0 (item aa buffer-in)
          if (item 0 (item aa buffer-in) = "PE")
          [
            ;        if (length item aa buffer-in <= buffer-in-size)
            ;        [
            ;
            ;        ]

            ;          ;print "**"
            ;          ;print length item aa buffer-in
            ;          ;print buffer-in-size
            ;          ;print "**"

            ;print "b-in antes de mexer"
            ;print buffer-in
            ;print "temporary-buffer-PE antes de mexer"
            ;print temporary-buffer-PE

            while [length item aa buffer-in <= buffer-in-size AND length temporary-buffer-PE > 0]
            [
;              print "aehoo"
;              print who
              ;            ;print "**"
              ;            ;print length item aa buffer-in
              ;            ;print buffer-in-size
              ;            ;print "**"

              let aaa item 0 temporary-buffer-PE
              ;            print "---"
              ;            print "aaa"
              ;            print aaa
              set aaa (replace-item 2 aaa ticks)
              set aaa (replace-item 6 aaa ticks)
              ;            print "aaa novo"
              ;            print aaa
              ;
              ;            print "---"
              let bbb item aa buffer-in
              set bbb (lput aaa bbb)

              ;            ;print "bbb:"
              ;            ;print bbb

              ;            set buffer-in (replace-item c1 buffer-in (remove-item 1 (item c1 buffer-in)))


              set buffer-in (replace-item aa buffer-in bbb)

;              print buffer-in

              ;            set buffer-in replace-item aa bbb buffer-in
              set temporary-buffer-PE but-first temporary-buffer-PE
            ]

            ;          print "temporario e bin depois de mover"
            ;          print temporary-buffer-PE
            ;          print buffer-in

            ;print "b-in depois de mexer"
            ;print buffer-in
            ;print "temporary-buffer-PE depois de mexer"
            ;print temporary-buffer-PE
          ]

          set aa (aa + 1)
        ]
      ]

      ;    if (who = 0)
      ;    [
      ;      print "temporario e bin depois de mover"
      ;      print temporary-buffer-PE
      ;      print buffer-in
      ;    ]




      ;Pra testes
      ;    set routing-table fput [20 "PE" 1] routing-table
      ;    set routing-table fput [50 "PE" 1] routing-table

      let num-cycles ""

      let c1 0

      ;;print "tabela de roteamento antes"
      ;;print routing-table



      while [c1 < length routing-table]
      [
        ;;;print "-"
        ;;;print item c1 routing-table

        if ((item 2 (item c1 routing-table)) > 0)
        [
          set num-cycles (item 2 (item c1 routing-table)) - 1
          ;;;print num-cycles
          set routing-table (replace-item c1 routing-table (replace-item 2 (item c1 routing-table) num-cycles))
        ]


        ;set buffer-in (replace-item c1 buffer-in (remove-item 1 (item c1 buffer-in)))

        ;;;print routing-table

        set c1 (c1 + 1)
        ;;;print "-"
      ]

      ;;print "tabela de roteamento depois"
      ;;print routing-table

      set num-cycles ""
      set c1 0

      ;set buffer-out [["N" [18 "H" 2 -50 49 11 1 10]] ["E"] ["S" [18 "H" 2 -50 49 11 1 15] [18 "H" 2 -50 49 11 1 20]] ["W"] ["PE"]]

      ;;print "buffer-out antes"
      ;;print buffer-out


      ;;print "começando a processar buffer-out"
      ;;print "c1"
      ;;print c1





      while [c1 < length buffer-out]
      [
        ;;;print "-"


        ;set num-cycles (item 2 (item c1 routing-table)) - 1
        ;;;print num-cycles
        ;set routing-table (replace-item c1 routing-table (replace-item 2 (item c1 routing-table) num-cycles))

        ;;;print routing-table

        ;;print "processando a porta"
        ;;print item 0 (item c1 buffer-out)

        if (length item c1 buffer-out > 1)
        [
          ;;print "na porta"
          ;;print item 0 (item c1 buffer-out)
          ;;print "tem X mensagens"
          ;;print length item c1 buffer-out

          let c2 1

          while [c2 < (length item c1 buffer-out)]
          [
            ;;print "imprimindo as mensagens individualmente"
            ;;print item c2 (item c1 buffer-out)

            if ((item 7 (item c2 (item c1 buffer-out))) > 0)
            [
              set num-cycles (item 7 (item c2 (item c1 buffer-out))) - 1
              ;;print "num-cycles"
              ;;print num-cycles
              ;          ;set routing-table (replace-item c1 routing-table (replace-item 2 (item c1 routing-table) num-cycles))
              ;
              ;          ;fez alguma diferença, mas ainda não funciona
              ;          ;set buffer-out (replace-item c1 buffer-out (replace-item c2 (item c1 buffer-out) num-cycles) )
              ;
              ;
              let kk []
              set kk item c2 (item c1 buffer-out)
              ;;print "kk"
              set kk (replace-item 7 (item c2 (item c1 buffer-out)) num-cycles)
              ;;print kk
              ;
              ;;print "aaa"
              ;;print item c2 (item c1 buffer-out)
              ;set buffer-out (replace-item c1 (item c1 buffer-out) kk)
              set buffer-out (replace-item c1 buffer-out (replace-item c2 (item c1 buffer-out) kk))

              ;set routing-table (replace-item c1 routing-table (replace-item 2 (item c1 routing-table) num-cycles))

              ;;print "bo"
              ;;print buffer-out
              ;
              ;          ;set buffer-out (replace-item c1 buffer-out (replace-item c2 (replace-item c1 (item 7 (item c2 (item c1 buffer-out))) num-cycles) item c1 buffer-out) )
              ;
              ;          ;;print "bo"
              ;          ;;print buffer-out
              ;
              ;
              ;
              ;          ;set buffer-out (replace-item c1 buffer-out (replace-item c2 (replace-item 7 (item c2 (item c1 buffer-out)) num-cycles) (item c2 (item c1 buffer-out) ) ))
            ]


            set c2 (c2 + 1)

          ]

        ]

        set c1 (c1 + 1)
      ]

      ;;print "buffer-out depois"
      ;;print buffer-out

    ]

  ]

;  ask router 0
;  [
;    print "temporario e bin depois de mover, final da transferência"
;    print temporary-buffer-PE
;    print buffer-in
;  ]


  ;;print "---"


;  let segura-lista []
;
;  ask routers
;  [
;
;    ;let primeiro remainder ticks 5
;    ;;;;print "---"
;    ;;;;print "no ciclo"
;    ;;;;print ticks
;    ;;;;print list-temporario
;
;    set segura-lista item 0 list-temporario
;    set list-temporario remove-item 0 list-temporario
;    set list-temporario lput segura-lista list-temporario
;
;;    ;;;;print "depois de mexer ficou"
;;    ;;;;print list-temporario
;
;    ;;;;print "---"
;  ]

  ;ask router 0
  ask routers
  [
    ;;;;print who
    ;;;;print "---"
    ;;;;print "no tick"
    ;;;;print ticks
    ;;;;print buffer-in
    ;;;;print "---"

    ;;Executando cada porta, segundo a ordem do árbitro
    let processed-port ""

    let c1 0
    let n []

    while [c1 < length buffer-in]
    [
      set n item c1 buffer-in

      set processed-port item 0 n
      ;;;;;print "porta"
      ;;;;;print processed-port
      ;;;;;print length n

      ;;Tem mensagem no buffer?
      if (length n > 1)
      [
        let flit item 0 (sublist n 1 2)
        ;;;;;print flit
        ;;;;;print item 2 flit
        if (ticks != item 2 flit)
        [
;          ;;;;print "pode processar, mensagem chegou no ciclo"
;          ;;;;print item 2 flit
;          ;;;;print "ciclo atual"
;          ;;;;print ticks

          let a1 0
          let not-in-routing-table true

          while [a1 < length routing-table]
          [
            ;print item a1 routing-table
            if (item 0 (item a1 routing-table) = item 0 flit)
            [
              set not-in-routing-table false
            ]
            set a1 (a1 + 1)
          ]

          ;set routing-table lput (list ID destination-port routing-cost) routing-table

          ;;Flit é header? Ainda não está na tabela de roteamento?
          if (item 1 flit = "H" and not-in-routing-table)
          [
            ;;Se sim, calcula e escreve na tabela de roteamento

            update-routing-table (item 0 flit) (item 3 flit) (item 4 flit)

;            let id-flit 0
;            set id-flit item 0 flit
;            set routing-table lput (list id-flit "S" 2) routing-table
            ;;;;print "tabela de roteamento"
            ;;;;print routing-table
          ]

          ;;Consultar tabela de roteamento para ver se o custo já está 0 e, se sim, por qual porta o flit sai
          let port-to-send 0
          let routing-done false
          foreach routing-table
          [
            a ->
            ;;ID flit = ID registro da tabela de roteamento E custo da tabela de roteamento = 0?
            if (item 0 flit = item 0 a AND item 2 a = 0)
            [
              set port-to-send item 1 a
              set routing-done true
            ]
          ]

          if (routing-done)
          [
            ;;;;;print "acessando o indice"
            ;;;;;print port-to-send
            ;;;;;print item port-to-send busy

            ;;;;print "antes do if"
            ;;;;print busy

            if (item port-to-send busy = -1)
            [
              set busy replace-item port-to-send busy item 0 flit
            ]

            ;;;;print "lista busy"
            ;;;;print busy

            if (item port-to-send busy = item 0 flit)
            [
              ;set busy replace-item port-to-send busy item 0 flit
              ;;;;print "entrou aqui"
              ;;;;;print buffer-out
              ;;;;;print length buffer-out

              ;;;;print length (item port-to-send buffer-out)

              if (length (item port-to-send buffer-out) <= buffer-out-size)
              [
                ;;print "---"
                ;;print "flit sendo processado:"
                ;;print flit
                ;;print "---"
;                ;;;;print "tem espaço no buffer"
;                ;;;;print "n:"
;                ;;;;print n
;;               ;;;;print "item 1 n"
;;               ;;;;print item 1 n
                ;;;;print item port-to-send buffer-out
                ;;;;print buffer-out

                ;set buffer-out replace-item port-to-send buffer-out (sentence item 1 n router-to-router-cost)

;                let temporary-direction ""
;                set temporary-direction item 0 (item port-to-send buffer-out)

                ;;print "*** buffer out antes de tirar do in e por no out ***"
                ;;print buffer-out

                let temporary-direction item port-to-send buffer-out
                ;;print "***********************"
                ;;print "temporary sem o custo"
                ;;print temporary-direction
                ;;print "temporary com o custo"
                set temporary-direction lput (sentence flit router-to-router-cost) temporary-direction
                ;;print temporary-direction

                ;set buffer-out replace-item port-to-send buffer-out (list temporary-direction (sentence item 1 n router-to-router-cost))
                set buffer-out replace-item port-to-send buffer-out temporary-direction


                ;set temporary-direction lput () temporary-direction

                ;set buffer-in (replace-item port-to-send buffer-in (lput temporary item indice buffer-in))


                ;;;;print temporary-direction

                ;;;;;print "ta indo longe"





                ;;print "*** buffer out depois de tirar do in e por no out ***"
                ;;print buffer-out

                ;;;;print buffer-out

                set buffer-in remove (sublist n 1 2) buffer-in

;                ;;print "n:"
;                ;;print n
;                ;;print item c1 buffer-in

                ;;print "antes de tirar"
                ;;print buffer-in

                set buffer-in (replace-item c1 buffer-in (remove-item 1 (item c1 buffer-in)))

                ;;print "sera que foi?"
                ;;print buffer-in

                ;set buffer-in (replace-item indice buffer-in (lput temporary item indice buffer-in))

                ;set mylist (replace-item 3 mylist (remove-item 2 (item 3 mylist)))
                ;set buffer-in (replace-item 3 mylist (remove-item 2 (item 3 buffer-in)))







                ;set item port-to-send buffer-out lput 0 item port-to-send buffer-out
                ;set buffer-out

                ;set n remove-item 1 n
;                ;;;;print "n = "
;                ;;;;print n
;                ;;;;print sublist n 1 2
;                set buffer-in remove n buffer-in

                ;;;;;print sublist n 1 2
                ;set buffer-in remove (sublist n 1 2) buffer-in
                ;set buffer-in remove-item
              ]
            ]

;            ;;;;print busy
;
;            ;;;;print "saida"
;            ;;;;print buffer-out

          ]

;          ;;;;print "vai sair pela porta"
;          ;;;;print port-to-send
        ]
      ]

      set c1 (c1 + 1)
    ]


;    foreach buffer-in
;    [
;;      n ->
;;      ;;;;print item 1 n
;;      ifelse(n = "W")
;;      [
;;        ;;;;print "aehoo"
;;      ]
;;      [
;;        ;;;;print "aah"
;;      ]
;
;
;      n ->
;      set processed-port item 0 n
;      ;;;;;print "porta"
;      ;;;;;print processed-port
;      ;;;;;print length n
;
;      ;;Tem mensagem no buffer?
;      if (length n > 1)
;      [
;        let flit item 0 (sublist n 1 2)
;        ;;;;;print flit
;        ;;;;;print item 2 flit
;        if (ticks != item 2 flit)
;        [
;;          ;;;;print "pode processar, mensagem chegou no ciclo"
;;          ;;;;print item 2 flit
;;          ;;;;print "ciclo atual"
;;          ;;;;print ticks
;
;          ;;Flit é tail?
;          if (item 1 flit = "H")
;          [
;            ;;Se é tail, calcula e escreve na tabela de roteamento
;
;            update-routing-table (item 0 flit) (item 3 flit) (item 4 flit)
;
;;            let id-flit 0
;;            set id-flit item 0 flit
;;            set routing-table lput (list id-flit "S" 2) routing-table
;            ;;;;print "tabela de roteamento"
;            ;;;;print routing-table
;          ]
;
;          ;;Consultar tabela de roteamento para ver se o custo já está 0 e, se sim, por qual porta o flit sai
;          let port-to-send 0
;          let routing-done false
;          foreach routing-table
;          [
;            a ->
;            ;;ID flit = ID registro da tabela de roteamento E custo da tabela de roteamento = 0?
;            if (item 0 flit = item 0 a AND item 2 a = 0)
;            [
;              set port-to-send item 1 a
;              set routing-done true
;            ]
;          ]
;
;          if (routing-done)
;          [
;            ;;;;;print "acessando o indice"
;            ;;;;;print port-to-send
;            ;;;;;print item port-to-send busy
;
;            ;;;;print "antes do if"
;            ;;;;print busy
;
;            if (item port-to-send busy = 0)
;            [
;              set busy replace-item port-to-send busy item 0 flit
;            ]
;
;            ;;;;print "lista busy"
;            ;;;;print busy
;
;            if (item port-to-send busy = item 0 flit)
;            [
;              ;set busy replace-item port-to-send busy item 0 flit
;              ;;;;print "entrou aqui"
;              ;;;;;print buffer-out
;              ;;;;;print length buffer-out
;
;              ;;;;print length (item port-to-send buffer-out)
;
;              if (length (item port-to-send buffer-out) <= buffer-out-size)
;              [
;;                ;;;;print "tem espaço no buffer"
;;                ;;;;print "n:"
;;                ;;;;print n
;;;                ;;;;print "item 1 n"
;;;                ;;;;print item 1 n
;                ;;;;print item port-to-send buffer-out
;                ;;;;print buffer-out
;
;                ;set buffer-out replace-item port-to-send buffer-out (sentence item 1 n router-to-router-cost)
;
;                let temporary-direction ""
;                set temporary-direction item 0 (item port-to-send buffer-out)
;                ;;;;print temporary-direction
;
;                ;;;;;print "ta indo longe"
;
;                set buffer-out replace-item port-to-send buffer-out (list temporary-direction (sentence item 1 n router-to-router-cost))
;                ;;;;print buffer-out
;
;                set buffer-in remove (sublist n 1 2) buffer-in
;
;                ;set mylist (replace-item 3 mylist (remove-item 2 (item 3 mylist)))
;                ;set buffer-in (replace-item 3 mylist (remove-item 2 (item 3 buffer-in)))
;
;
;
;
;
;
;
;                ;set item port-to-send buffer-out lput 0 item port-to-send buffer-out
;                ;set buffer-out
;
;                ;set n remove-item 1 n
;;                ;;;;print "n = "
;;                ;;;;print n
;;                ;;;;print sublist n 1 2
;;                set buffer-in remove n buffer-in
;
;                ;;;;;print sublist n 1 2
;                ;set buffer-in remove (sublist n 1 2) buffer-in
;                ;set buffer-in remove-item
;              ]
;            ]
;
;;            ;;;;print busy
;;
;;            ;;;;print "saida"
;;            ;;;;print buffer-out
;
;          ]
;
;;          ;;;;print "vai sair pela porta"
;;          ;;;;print port-to-send
;        ]
;      ]
;    ]










    ;;;;;print position "N" buffer-in

    ;show position buffer-in "W"
;    foreach buffer-in
;    [
;      id-port ->
;      if(id-port ="W")
;      [
;        ;;;;print "deuboa"
;      ]
;;      show n
;
;      ;show item 0 buffer-in
;    ]
;
;    let ii 0
;    while[ii < 5]
;    [
;      ;;;;print item 0 (sublist buffer-in 0 1)
;      set ii (ii + 1)
;    ]



    ;;print "---------"
    ;;print "buffer-in:"
    ;;print buffer-in
    ;;print "buffer-out:"
    ;;print buffer-out
    ;;print "---------"
  ]

  ;;;;print "---"
  ;;;;print "processamento buffer-out"

  ask routers
  [
    ;;;;print buffer-out

    let la 0
    let c []

    ;foreach buffer-out
    while [la < length buffer-out]
    [
      ;c ->
      set c item la buffer-out

      ;;Se esse tamanho > 1, tem mensagem para sair
      if (length c > 1)
      [

        ;;;;;print item 7 (item 1 c)
        if (item 7 (item 1 c) = 0)
        [
          ;; A partir daqui tem mensagem pra sair, e está pronta para sair
          let rotation false
          let move-1 false
          let going-to-port false

          let send-sucess false
          let index-to-delete false

          ifelse (item 0 c = "N")
          [
            ;;;;print "vai sair pro norte"
;            ask patch-at-heading-and-distance 0 1
;            [
;              ask turtles-here
;              [
;                set id-destiny who
;              ]
;            ]

            set rotation 0
            set move-1 1
            set going-to-port "S"

          ]
          [
            ifelse (item 0 c = "E")
            [
              ;;;;print "vai sair pro oeste"
;              ask patch-at-heading-and-distance 90 1
;              [
;                ask turtles-here
;                [
;                  set id-destiny who
;                ]
;              ]

              set rotation 90
              set move-1 1
              set going-to-port "W"
            ]
            [
              ifelse (item 0 c = "S")
              [
                ;;;print "vai sair pro sul"

;                ask patch-at-heading-and-distance 180 1
;                [
;                  ask turtles-here
;                  [
;                    set id-destiny who
;                  ]
;                ]
                set rotation 180
                set move-1 1
                set going-to-port "N"
              ]
              [
                ifelse (item 0 c = "W")
                [
                  ;;;print "vai sair pro leste"
;                  ask patch-at-heading-and-distance 270 1
;                  [
;                    ask turtles-here
;                    [
;                      set id-destiny who
;                    ]
;                  ]

                  set rotation 270
                  set move-1 1
                  set going-to-port "E"
                ]
                [
                  ;item 1 (item 1 c) = "T")
                  ;;vai pro PE, ver certo o que fazer

                  ;;print "vai sair pro PE"

                  ;print "chegou flit"
;                  print item 1 c
;                  print "chegou flit do pacote"
;                  print item 0 (item 1 c)
                  set total-flits-received (total-flits-received + 1)

                  ;print "flit recebido"
                  ;print (item 1 c)

                  let latency (ticks - item 6 ((item 1 c)))
                  let hops item 5 ((item 1 c))

                  ifelse (first-flit-ever)
                  [
                    ;Sobre latência
                    set min-latency latency
                    set avg-latency latency
                    set max-latency latency
                    set acc-latency latency

                    ;Sobre hops
                    set min-hops hops
                    set avg-hops hops
                    set max-hops hops
                    set acc-hops hops

                    set first-flit-ever false
                  ]
                  [
;                    ;print "TA ENTRANDOOOOOOO - LATÊNCIA ATUAL"
;                    ;print latency
                    ;Sobre latência
                    if (latency < min-latency)
                    [
                      set min-latency latency
                    ]

                    if (latency > max-latency)
                    [
                      set max-latency latency
                    ]

                    set acc-latency (acc-latency + latency)

                    set avg-latency (acc-latency / total-flits-received)

                    ;Sobre hops
                    if (hops < min-hops)
                    [
                      set min-hops hops
                    ]

                    if (hops > max-hops)
                    [
                      set max-hops hops
                    ]

                    set acc-hops (acc-hops + hops)

                    set avg-hops (acc-hops / total-flits-received)
                  ]

                  if (item 1 (item 1 c) = "T")
                  [
                    set total-packets-received (total-packets-received + 1)
                  ]



                  set send-sucess true
                  set index-to-delete la
                ]
              ]
            ]
          ]

          ;;;print "if do final"
          ;;;print rotation
          ;;;print move-1




          if (rotation != false AND move-1 != false)
          [
            ask patch-at-heading-and-distance rotation move-1
            [
              ask turtles-here
              [
                ;;Entrando no próximo agente

                ;;;print "buffer de entrada do agente"
                ;;;;print buffer-in

                let nx 0
                let n1 []

                ;foreach buffer-in

                ;;print item nx buffer-in

                while [nx < length buffer-in]
                [
                  ;n1 ->
                  set n1 item nx buffer-in
                  ;;print n1
                  ;;;;print item 0 n
                  if (item 0 n1 = going-to-port)
                  [
                    ;;;;print length n
                    if (length n1 <= buffer-in-size)
                    [
                      ;;;;print "tem espaço pra guardar a mensagem"

                      ;;;;print "c"
                      let temporary item 1 c
                      ;;print "antes de mexer no temporary"
                      ;;print temporary

                      ;print "temporary antes de mexer"
                      ;print temporary

                      set temporary replace-item 2 temporary (ticks)
                      set temporary replace-item 5 temporary (item 5 temporary + 1)
                      set temporary but-last temporary

                      ;print "temporary depois de mexer"
                      ;print temporary
                      ;;print "temporary depois de mexer"
                      ;;print temporary

                      let indice 0

                      ;;print "antes de mudar"
                      ;;print buffer-in

                      while [indice < length buffer-in]
                      [
                        if (item 0 (item indice buffer-in) = going-to-port)
                          [
                            ;;;print "temos um começo"

                            ;set mylist (replace-item 3 mylist (lput [9 9] (item 3 mylist)))
                            ;;print "a porta que tem que ser processada é a"
                            ;;print going-to-port
                            ; esse ta relativamente perto
                            ;set buffer-in (replace-item indice buffer-in (lput [9 9] buffer-in))

                            ;adiciona a mensagem no buffer do próximo roteador, já incrementando hops e atualizando ciclo que chegou
                            set buffer-in (replace-item indice buffer-in (lput temporary item indice buffer-in))
                            set send-sucess true

                            set index-to-delete la

                            ;;Falta tirar do outro

                            ;;print buffer-out


                          ]
                        set indice (indice + 1 )
                      ]

                      ;set n lput  n


                      ;;;print "n"
                      ;;;print n
                      ;;print "buffer do roteador"
                      ;;print who
                      ;;print buffer-in


                    ]
                  ]

                  set nx (nx + 1)
                ]
              ]
            ]



          ]

          ;Se enviou a mensagem, precisa excluir
          if (send-sucess AND index-to-delete != false)
          [
            ;;print "esta mensagem precisa ser excluida"
            ;;print (item 1 (item index-to-delete buffer-out))
            ;;print "a mensagem sera excluida do roteador"
            ;;print who


            let item-temporario []
            set item-temporario (item index-to-delete buffer-out)
;            ;print "Item-temporario"
;            ;print item-temporario
            set item-temporario remove-item 1 item-temporario



;            ;print item-temporario

;            ;print "Antes de excluir, MENSAGEM"
;            ;print (item 0 (item 1 (item index-to-delete buffer-out)))

            ;;print busy

            ;se é tail, tem que tirar da routing table e excluir do buffer, então, retirando da routing table
            if (item 1 (item 1 c) = "T")
            [
              ;;print "ta entrando nesse if"

              let a1 0
              let deleted-item false

              ;;print "routing table antes de tirar"
              ;;print routing-table
              while [a1 < length routing-table AND deleted-item = false]
              [
                ;;print "entrando no while do if"
                ;;print item a1 routing-table
                if (item 0 (item a1 routing-table) = (item 0 (item 1 (item index-to-delete buffer-out))))
                [
                  ;;print "está entrando no if do if"
                  set routing-table remove-item a1 routing-table
                  set deleted-item true
                ]
                set a1 (a1 + 1)
              ]

              ;;print "routing table depois de tirar"
              ;;print routing-table
            ]

            ;;print "antes de excluir"
            ;;print buffer-out
            set buffer-out replace-item index-to-delete buffer-out item-temporario
            ;;print "depois de excluir"
            ;;print buffer-out
          ]

          ;;print "busy do roteador"
          ;;print who
          ;;print "antes e depois"

          ;;TROCAR PRA T, ISSO É SÓ PRA TESTAR
          if(send-sucess AND item 1 (item 1 c) = "T")
          [
            ;;print busy
            ifelse (item 0 c = "N")
            [
              set busy replace-item 0 busy -1
            ]
            [
              ifelse (item 0 c = "E")
              [
                set busy replace-item 1 busy -1
              ]
              [
                ifelse (item 0 c = "S")
                [
                  set busy replace-item 2 busy -1
                ]
                [
                  ifelse (item 0 c = "W")
                  [
                    set busy replace-item 3 busy -1
                  ]
                  [
                    ;Precisa desse pro PE
                    ifelse (item 0 c = "PE")
                    [
                      set busy replace-item 4 busy -1
                    ]
                    [
                    ]
                  ]
                ]
              ]
            ]



          ]



          ;if (length (item port-to-send buffer-out) <= buffer-out-size)

          ;ifelse item
        ]
      ]

      set la (la + 1)
    ]

    ;;;;print buffer-out
  ]

;  ;print "--------------------------------------------------------------"
;  ;print "No tick"
;  ;print ticks
  ask routers
  [
    ;print "-------------------------------"
    ;print "roteador"
    ;print who
    ;print "final do ciclo"
    ;print "buffer-in"
    ;print buffer-in
    ;print "buffer-out"
    ;print buffer-out
    ;print "busy"
    ;print busy
    ;print "tabela de roteamento"
    ;print routing-table
    ;print "-------------------------------"
  ]
  ;print "-------------------------------"

  ;;Calcular taxa-ocupação-*

  let total-flits-in-buffers 0

  ask routers
  [
    let i 0

    let max-flits-in-port 0
    let max-port ""

    while [i < length buffer-in]
    [
      if (item 0 (item i buffer-in) != "PE")
      [
        if ((length (item i buffer-in) - 1 ) > max-flits-in-port)
        [
          ;print "entrou no in"
          set max-flits-in-port (length (item i buffer-in) - 1 )
          set max-port "in"
        ]
      ]


      ;set total-flits-in-buffers (total-flits-in-buffers + (length (item i buffer-in) - 1 ))
      set i (i + 1)
    ]

    set i 0

  while [i < length buffer-out]
  [
    if (item 0 (item i buffer-out) != "PE")
    [
        ;print item 0 (item i buffer-out)
      if ((length (item i buffer-out) - 1 ) > max-flits-in-port)
      [
        set max-flits-in-port (length (item i buffer-out) - 1 )
        set max-port "out"
          ;print "entrou no out"
    ]
  ]


  ;set total-flits-in-buffers (total-flits-in-buffers + (length (item i buffer-in) - 1 ))
  set i (i + 1)
]

;    print "---"
;    print "bin"
;    print buffer-in
;    print "buffer-out"
;    print buffer-out
;    print "max-flits"
;    print max-flits-in-port
;    print "max-port"
;    print max-port
;    print "---"

ifelse (max-port = "in")
[
  set occupancy-rate ((100 * max-flits-in-port) / (buffer-in-size))
]
[
  ifelse (max-port = "out")
  [
        ;print "aehoo"
    set occupancy-rate ((100 * max-flits-in-port) / (buffer-out-size))
  ]
  [
       set occupancy-rate 0
  ]
]

    ;print "taxa de ocupação"
    ;print occupancy-rate

    set total-flits-in-buffers 0
  ]

  occupancy-rate-color

  set execution-time timer



;  ask routers
;  [
;    print "--"
;    print who
;    print "bin"
;    print buffer-in
;    print "bout"
;    print buffer-out
;    print "temporary"
;    print temporary-buffer-PE
;    print "--"
;  ]

;  ask router 0
; [
;    print "--"
;    print "final do ciclo"
;    print ticks
;    print "roteador"
;    print who
;    print "bin"
;    print buffer-in
;    print "bout"
;    print buffer-out
;    print "temporary"
;    print temporary-buffer-PE
;    print "--"
; ]


  tick

  print-csv

  sum-to-heatmap
end

to occupancy-rate-color
  ask routers
  [
    ifelse (occupancy-rate = 0)
    [
      set color white
    ]
    [
      ifelse (occupancy-rate > 0 AND occupancy-rate < 25)
      [
        set color blue
      ]
      [
        ifelse (occupancy-rate >= 25 AND occupancy-rate < 50)
        [
          set color green
        ]
        [
          ifelse (occupancy-rate >= 50 AND occupancy-rate < 75)
          [
            set color yellow
          ]
          [
            ifelse (occupancy-rate >= 75 AND occupancy-rate < 100)
            [
              set color red
            ]
            [
              set color black
            ]
          ]
        ]
      ]
    ]
  ]
end

to update-routing-table [ID X-destination Y-destination]
  ;;print X-destination
  ;;print Y-destination
  ;;print xcor
  ;;print ycor

  let destination-port ""

  ifelse (routing-algorithm = "XY")
  [
    ;; Mesmo X?
    ifelse (X-destination = xcor)
    [
      ;;Mesmo Y?
      ifelse (Y-destination = ycor)
      [
        ;;X e Y iguais, é o destino
        ;set destination-port "PE"
        set destination-port 4

        ;print "é para o PE, conferir o que fazer"
      ]
      [
        ;;Mesmo X, Y diferente, então testa
        ;;Y-destino é maior que Y-atual?
        ifelse (Y-destination > ycor)
        [
          ;;Envia para cima (N)
          ;set destination-port "N"
          set destination-port 0
        ]
        [
          ;;Y-destino é menor que Y-atual, então envia para baixo (S)
          ;set destination-port "S"
          set destination-port 2
        ]
      ]
    ]
    [
      ;;X diferente, então testa
      ;;X destino > X atual?
      ifelse (X-destination > xcor)
      [
        ;;Envia para direita (E)
        ;set destination-port "E"
        set destination-port 1
      ]
      [
        ;;X destino < X atual, então
        ;;Envia para esquerda (W)
        ;set destination-port "W"
        set destination-port 3
      ]
    ]
  ]
  [
    ifelse (routing-algorithm = "WF")
    [
      ;Casos determinísticos
      if(X-destination = xcor AND Y-destination = ycor)
      [
        ;Chegou, vai para PE
        set destination-port 4
      ]

      if(X-destination < xcor)
      [
        ;W
        set destination-port 3
      ]

      if(X-destination > xcor AND Y-destination = ycor)
      [
        ;E
        set destination-port 1
      ]

      if (X-destination = xcor AND Y-destination < ycor)
      [
        ;S
        set destination-port 2
      ]

      if (X-destination = xcor AND Y-destination > ycor)
      [
        ;N
        set destination-port 0
      ]



      ;Casos adaptativos
      if(X-destination > xcor AND Y-destination < ycor)
      [
        ;E ou S

        ifelse (item 1 busy = -1)
        [
          ;E
          set destination-port 1
        ]
        [
          ifelse (item 2 busy = -1)
          [
            ;S
            set destination-port 2
          ]
          [
            ;As duas portas estão ocupadas. Escolher a que tem o buffer-out menos ocupado...

            let flits-in-first-port (length (item 1 buffer-out) - 1 )
            let flits-in-second-port (length (item 2 buffer-out) - 1 )

          ifelse (flits-in-first-port < flits-in-second-port)
        [
          ;E
          set destination-port 1
        ]
        [
          ;S
          set destination-port 2
        ]
      ]
    ]
  ]

  if(X-destination > xcor AND Y-destination > ycor)
  [
    ; E ou N

    ifelse (item 1 busy = -1)
    [
      ;E
      set destination-port 1
    ]
    [
      ifelse (item 0 busy = -1)
      [
        ;N
        set destination-port 0
      ]
      [
        ;As duas portas estão ocupadas. Escolher a que tem o buffer-out menos ocupado...

        let flits-in-first-port (length (item 1 buffer-out) - 1 )
      let flits-in-second-port (length (item 0 buffer-out) - 1 )

    ifelse (flits-in-first-port < flits-in-second-port)
    [
      ;E
      set destination-port 1
    ]
    [
      ;N
      set destination-port 0
    ]
  ]
]
]

    ]
    [
      ;;Para implementar novos algoritmos de roteamento
    ]
  ]

  ;;print "algoritmo de roteamento escolheu sair para a porta"
  ;;print destination-port

  set routing-table lput (list ID destination-port routing-cost) routing-table


end

;  ifelse (primeiro = 0)
;  [
;    ;set list-temporario [0 1 2 3 4]
;    set list-temporario fput north-buffer list-temporario
;    set list-temporario fput east-buffer list-temporario
;    set list-temporario fput south-buffer list-temporario
;    set list-temporario fput west-buffer list-temporario
;    set list-temporario fput PE-buffer list-temporario
;  ]
;  [
;    ifelse (primeiro = 1)
;    [
;      ;set list-temporario [1 2 3 4 0]
;      set list-temporario fput east-buffer list-temporario
;      set list-temporario fput south-buffer list-temporario
;      set list-temporario fput west-buffer list-temporario
;      set list-temporario fput PE-buffer list-temporario
;      set list-temporario fput north-buffer list-temporario
;    ]
;    [
;      ifelse (primeiro = 2)
;      [
;        ;set list-temporario [2 3 4 0 1]
;        set list-temporario fput south-buffer list-temporario
;        set list-temporario fput west-buffer list-temporario
;        set list-temporario fput PE-buffer list-temporario
;        set list-temporario fput north-buffer list-temporario
;        set list-temporario fput east-buffer list-temporario
;      ]
;      [
;        ifelse (primeiro = 3)
;        [
;          ;set list-temporario [3 4 0 1 2]
;          set list-temporario fput west-buffer list-temporario
;          set list-temporario fput PE-buffer list-temporario
;          set list-temporario fput north-buffer list-temporario
;          set list-temporario fput east-buffer list-temporario
;          set list-temporario fput south-buffer list-temporario
;        ]
;        [
;          ifelse (primeiro = 4)
;          [
;            ;set list-temporario [4 0 1 2 3]
;            set list-temporario fput PE-buffer list-temporario
;            set list-temporario fput north-buffer list-temporario
;            set list-temporario fput east-buffer list-temporario
;            set list-temporario fput south-buffer list-temporario
;            set list-temporario fput west-buffer list-temporario
;          ]
;          [
;            ;
;          ]
;        ]
;      ]
;    ]
;  ]



;  ;;print "no tick"
;  ;;print ticks
;  ;;print list-temporario





;  ask routers
;  [
;    set list-temporario fput north-buffer list-temporario
;  ]

  ;tick
;end


to print-csv

  ;;Para teste
  ;if (ticks mod 75 = 0 AND ticks != 0)
;  if (ticks = 70)
;  [
;    foreach sort-on [who] routers [ the-router ->
;      ask the-router [
;        print "**********************************************************************************************"
;        print "Router:"
;        print who
;        print "Buffer-in"
;        print buffer-in
;        print "Buffer-out"
;        print buffer-out
;        print "**********************************************************************************************"
;      ]
;    ]
;  ]

;  file-open "output.csv"
;
;  if (ticks = 0)
;  [
;    let first-line []
;
;    ;csv:to-file "taxa-ocupacao-geral.csv" lista
;
;    foreach sort-on [who] routers [ the-router ->
;      ask the-router [
;        ;set first-line (lput (word "Router" who "") first-line)
;        set first-line (lput (word "Router"who"InNorth") first-line)
;        set first-line (lput (word "Router"who"InEast") first-line)
;        set first-line (lput (word "Router"who"InSouth") first-line)
;        set first-line (lput (word "Router"who"InWest") first-line)
;        set first-line (lput (word "Router"who"InPE") first-line)
;
;        set first-line (lput (word "Router"who"OutNorth") first-line)
;        set first-line (lput (word "Router"who"OutEast") first-line)
;        set first-line (lput (word "Router"who"OutSouth") first-line)
;        set first-line (lput (word "Router"who"OutWest") first-line)
;        set first-line (lput (word "Router"who"OutPE") first-line)
;      ]
;    ]
;    print first-line
;
;    file-print csv:to-row first-line
;
;  ]
;
;
;  let line []
;
;  foreach sort-on [who] routers [ the-router ->
;    ask the-router [
;
;      ;      let i 0
;      ;      set total-flits-in-buffers 0
;      ;
;      ;      while [i < length buffer-in]
;      ;      [
;      ;        set total-flits-in-buffers (total-flits-in-buffers + (length (item i buffer-in) - 1 ))
;      ;        set i (i + 1)
;      ;      ]
;      ;
;      ;      set i 0
;      ;
;      ;      while [i < length buffer-out]
;      ;      [
;      ;        set total-flits-in-buffers (total-flits-in-buffers + (length (item i buffer-out) - 1 ))
;      ;        set i (i + 1)
;      ;      ]
;
;
;      ;set line (lput (occupancy-rate) line)
;
;      let aa 0
;      let sera1 [0 0 0 0 0]
;      let sera2 [0 0 0 0 0]
;      ;print sera
;
;      while [aa < length buffer-in]
;      [
;        ifelse (item 0 (item aa buffer-in) = "N")
;        [
;          set sera1 (replace-item 0 sera1 (length (item aa buffer-in) - 1 ))
;        ]
;        [
;          ifelse (item 0 (item aa buffer-in) = "E")
;          [
;            set sera1 (replace-item 1 sera1 (length (item aa buffer-in) - 1 ))
;          ]
;          [
;            ifelse (item 0 (item aa buffer-in) = "S")
;            [
;              set sera1 (replace-item 2 sera1 (length (item aa buffer-in) - 1 ))
;            ]
;            [
;              ifelse (item 0 (item aa buffer-in) = "W")
;              [
;                set sera1 (replace-item 3 sera1 (length (item aa buffer-in) - 1 ))
;              ]
;              [
;                ;PE
;                set sera1 (replace-item 4 sera1 (length (item aa buffer-in) - 1 ))
;              ]
;            ]
;          ]
;        ]
;
;        set sera2 (replace-item aa sera2 (length (item aa buffer-out) - 1 ))
;
;        set aa (aa + 1)
;      ]
;      ;          print "b-in"
;      ;          print buffer-in
;      ;          print "sera1"
;      ;          print sera1
;      ;          print "b-out"
;      ;          print buffer-out
;      ;          print "sera2"
;      ;          print sera2
;
;      ;set line lput ((sentence sera1 sera2)) line
;      ;set line sentence line []
;
;
;
;      ;set line (sentence sera1 sera2 line)
;      set line (sentence line sera1 sera2)
;    ]
;  ]
;
;  print "Tick"
;  print ticks
;  print "Line:"
;  print line
;
;  file-print csv:to-row line

  if (print-log-csv)
  [

    ;let aa (word date-and-time".csv")
    ;file-open "output.csv"
    file-open file-name

    if (ticks = 1)
    [
      ;print "************* TA ENTRANDO ********************"
      let first-line []
      set first-line (lput ("Cycle") first-line)

      ;csv:to-file "taxa-ocupacao-geral.csv" lista

      foreach sort-on [who] routers [ the-router ->
        ask the-router [
          ;set first-line (lput (word "Router" who "") first-line)
          set first-line (lput (word "Router"who"InNorth") first-line)
          set first-line (lput (word "Router"who"InEast") first-line)
          set first-line (lput (word "Router"who"InSouth") first-line)
          set first-line (lput (word "Router"who"InWest") first-line)
          set first-line (lput (word "Router"who"InPE") first-line)

          set first-line (lput (word "Router"who"OutNorth") first-line)
          set first-line (lput (word "Router"who"OutEast") first-line)
          set first-line (lput (word "Router"who"OutSouth") first-line)
          set first-line (lput (word "Router"who"OutWest") first-line)
          set first-line (lput (word "Router"who"OutPE") first-line)
        ]
      ]
      ;print first-line

      file-print csv:to-row first-line

    ]

    if (ticks mod cycles-to-print-csv = 0)
    [



      let line []
      set line lput ticks line

      foreach sort-on [who] routers [ the-router ->
        ask the-router [

          ;      let i 0
          ;      set total-flits-in-buffers 0
          ;
          ;      while [i < length buffer-in]
          ;      [
          ;        set total-flits-in-buffers (total-flits-in-buffers + (length (item i buffer-in) - 1 ))
          ;        set i (i + 1)
          ;      ]
          ;
          ;      set i 0
          ;
          ;      while [i < length buffer-out]
          ;      [
          ;        set total-flits-in-buffers (total-flits-in-buffers + (length (item i buffer-out) - 1 ))
          ;        set i (i + 1)
          ;      ]


          ;set line (lput (occupancy-rate) line)

          let aa 0
          let sera1 [0 0 0 0 0]
          let sera2 [0 0 0 0 0]
          ;print sera

          while [aa < length buffer-in]
          [
            ifelse (item 0 (item aa buffer-in) = "N")
            [
              set sera1 (replace-item 0 sera1 (length (item aa buffer-in) - 1 ))
            ]
            [
              ifelse (item 0 (item aa buffer-in) = "E")
              [
                set sera1 (replace-item 1 sera1 (length (item aa buffer-in) - 1 ))
              ]
              [
                ifelse (item 0 (item aa buffer-in) = "S")
                [
                  set sera1 (replace-item 2 sera1 (length (item aa buffer-in) - 1 ))
                ]
                [
                  ifelse (item 0 (item aa buffer-in) = "W")
                  [
                    set sera1 (replace-item 3 sera1 (length (item aa buffer-in) - 1 ))
                  ]
                  [
                    ;PE
                    set sera1 (replace-item 4 sera1 (length (item aa buffer-in) - 1 ))
                  ]
                ]
              ]
            ]

            set sera2 (replace-item aa sera2 (length (item aa buffer-out) - 1 ))

            set aa (aa + 1)
          ]
;          print "b-in"
;          print buffer-in
;          print "sera1"
;          print sera1
;          print "b-out"
;          print buffer-out
;          print "sera2"
;          print sera2

          ;set line lput ((sentence sera1 sera2)) line
          ;set line sentence line []
          set line (sentence line sera1 sera2)
;          print line
        ]
      ]

      file-print csv:to-row line
    ]
  ]

end



to fechar
  file-close
end

to print-heatmap

  set name-of-files (word ""number_of_lines "x" number_of_columns " - raio " radius " - " packets-per-generation " packets - " routing-algorithm)

  print "set title ''"
  print "unset key"
  print "set tic scale 0"
  print "set pal def (0 'white', 1 'black')"
  print "set cbrange [0:1]"
  print "set cblabel 'Escala'"
  print "unset cbtics"
  ;print "set xrange [-0.5:6.5]"
  ;print "set yrange [-0.5:6.5]"
  print (word "set xrange [-0.5:" (number_of_lines - 0.5) "]")
  print (word "set yrange [-0.5:" (number_of_columns - 0.5) "]")
  print "$map1 << EOD"

  create-espioes 1

;  ask one-of espioes
;  [
;    let initial-x -50
;    let initial-y 50 - (number_of_lines - 1)
;
;    let lines number_of_lines
;    let columns number_of_columns
;
;    print "Heatmap Ocupação I - Soma"
;    while [lines > 0]
;    [
;      let i 0
;      let lista []
;      while [columns > 0]
;      [
;        set xcor initial-x
;        set ycor initial-y
;        ask routers-here
;        [
;          ;print who
;          set lista lput sum-heatmap-occ-i lista
;        ]
;        set initial-x initial-x + 1
;        set columns (columns - 1)
;
;        set i (i + 1)
;      ]
;      set initial-x -50
;      set initial-y (initial-y + 1)
;      set columns number_of_columns
;      set lines (lines - 1)
;
;      print lista
;    ]
;  ]

  ;print "Heatmap Ocupação I"
  ask one-of espioes
  [
    let initial-x -50
    let initial-y 50 - (number_of_lines - 1)

    let lines number_of_lines
    let columns number_of_columns

    let first-ever true
    while [lines > 0]
    [
      let i 0
      let first-element-of-line true
      while [columns > 0]
      [
        set xcor initial-x
        set ycor initial-y
        ask routers-here
        [
          ifelse (first-ever)
          [
            type sum-heatmap-occ-i / ( (ticks - 1000) * (buffer-in-size * 4))
            set first-ever false
          ]
          [
            if (columns != number_of_columns)
            [
              type " "
              set first-element-of-line false
            ]

            if (first-element-of-line)
            [
              type "\n"
              set first-element-of-line false
            ]
            type sum-heatmap-occ-i / ( (ticks - 1000) * (buffer-in-size * 4))
          ]


          ;type sum-heatmap-occ-i / ( (ticks - 1000) * (buffer-in-size * 4))
        ]
        set initial-x initial-x + 1
        set columns (columns - 1)

        set i (i + 1)
      ]
      set initial-x -50
      set initial-y (initial-y + 1)
      set columns number_of_columns
      set lines (lines - 1)
    ]
  ]

  print "\nEOD"
  print "set view map"
  print "splot '$map1' matrix with image"
  print "set terminal png"

  ;let nome_bolado (word ""number_of_lines "x" number_of_columns " - raio " radius " - " packets-per-generation " packets")

  type "set output '"
  type name-of-files
  type " - "
  type "Heatmap - Taxa de Ocupacao - I.png'"
  type "\n"

  ;print "set output 'Heatmap - Taxa de Ocupacao - I.png'"
  print "replot"

;  print "Heatmap Ocupação O - Soma"
;  ask one-of espioes
;  [
;    let initial-x -50
;    let initial-y 50 - (number_of_lines - 1)
;
;    let lines number_of_lines
;    let columns number_of_columns
;
;
;    while [lines > 0]
;    [
;      let i 0
;      let lista []
;      while [columns > 0]
;      [
;        set xcor initial-x
;        set ycor initial-y
;        ask routers-here
;        [
;          ;print who
;          set lista lput sum-heatmap-occ-o lista
;        ]
;        set initial-x initial-x + 1
;        set columns (columns - 1)
;
;        set i (i + 1)
;      ]
;      set initial-x -50
;      set initial-y (initial-y + 1)
;      set columns number_of_columns
;      set lines (lines - 1)
;
;      print lista
;    ]
;  ]

  ;print "Heatmap Ocupação O"
  print "$map1 << EOD"
  ask one-of espioes
  [
    let initial-x -50
    let initial-y 50 - (number_of_lines - 1)

    let lines number_of_lines
    let columns number_of_columns

    let first-ever true
    while [lines > 0]
    [
      let i 0
      let first-element-of-line true
      while [columns > 0]
      [
        set xcor initial-x
        set ycor initial-y
        ask routers-here
        [
          ;print who
          ;set lista lput (sum-heatmap-occ-o / ( (ticks - 1000) * (buffer-out-size * 4))) lista

          ifelse (first-ever)
          [
            type sum-heatmap-occ-o / ( (ticks - 1000) * (buffer-out-size * 4))
            set first-ever false
          ]
          [
            if (columns != number_of_columns)
            [
              type " "
              set first-element-of-line false
            ]

            if (first-element-of-line)
            [
              type "\n"
              set first-element-of-line false
            ]
            type sum-heatmap-occ-o / ( (ticks - 1000) * (buffer-out-size * 4))
          ]
        ]
        set initial-x initial-x + 1
        set columns (columns - 1)

        set i (i + 1)
      ]
      set initial-x -50
      set initial-y (initial-y + 1)
      set columns number_of_columns
      set lines (lines - 1)

      ;print lista
    ]
  ]
  print "\nEOD"
  print "set view map"
  print "splot '$map1' matrix with image"
  print "set terminal png"
  ;print "set output 'Heatmap - Taxa de Ocupacao - O.png'"

  type "set output '"
  type name-of-files
  type " - "
  type "Heatmap - Taxa de Ocupacao - O.png'"
  type "\n"

  print "replot"

;  print "Heatmap Ocupação I/O - Soma"
;  ask one-of espioes
;  [
;    let initial-x -50
;    let initial-y 50 - (number_of_lines - 1)
;
;    let lines number_of_lines
;    let columns number_of_columns
;
;
;    while [lines > 0]
;    [
;      let i 0
;      let lista []
;      while [columns > 0]
;      [
;        set xcor initial-x
;        set ycor initial-y
;        ask routers-here
;        [
;          ;print who
;          set lista lput (sum-heatmap-occ-i + sum-heatmap-occ-o) lista
;        ]
;        set initial-x initial-x + 1
;        set columns (columns - 1)
;
;        set i (i + 1)
;      ]
;      set initial-x -50
;      set initial-y (initial-y + 1)
;      set columns number_of_columns
;      set lines (lines - 1)
;
;      print lista
;    ]
;  ]

  ;print "Heatmap Ocupação I/O"
  print "$map1 << EOD"
  ask one-of espioes
  [
    let initial-x -50
    let initial-y 50 - (number_of_lines - 1)

    let lines number_of_lines
    let columns number_of_columns

    let first-ever true
    while [lines > 0]
    [
      let i 0
      let first-element-of-line true
      while [columns > 0]
      [
        set xcor initial-x
        set ycor initial-y
        ask routers-here
        [
          ;print who
          ;set lista lput ((sum-heatmap-occ-i + sum-heatmap-occ-o) / ( (ticks - 1000) * ((buffer-in-size * 4) + (buffer-out-size * 4)))) lista

          ifelse (first-ever)
          [
            type (sum-heatmap-occ-i + sum-heatmap-occ-o) / ( (ticks - 1000) * ((buffer-in-size * 4) + (buffer-out-size * 4)))
            set first-ever false
          ]
          [
            if (columns != number_of_columns)
            [
              type " "
              set first-element-of-line false
            ]

            if (first-element-of-line)
            [
              type "\n"
              set first-element-of-line false
            ]
            type (sum-heatmap-occ-i + sum-heatmap-occ-o) / ( (ticks - 1000) * ((buffer-in-size * 4) + (buffer-out-size * 4)))
          ]
        ]
        set initial-x initial-x + 1
        set columns (columns - 1)

        set i (i + 1)
      ]
      set initial-x -50
      set initial-y (initial-y + 1)
      set columns number_of_columns
      set lines (lines - 1)

      ;print lista
    ]
  ]
  print "\nEOD"
  print "set view map"
  print "splot '$map1' matrix with image"
  print "set terminal png"
  ;print "set output 'Heatmap - Taxa de Ocupacao - IO.png'"

  type "set output '"
  type name-of-files
  type " - "
  type "Heatmap - Taxa de Ocupacao - IO.png'"
  type "\n"

  print "replot"

;  print "Heatmap Máximo - I - Soma"
;  ask one-of espioes
;  [
;    let initial-x -50
;    let initial-y 50 - (number_of_lines - 1)
;
;    let lines number_of_lines
;    let columns number_of_columns
;
;
;    while [lines > 0]
;    [
;      let i 0
;      let lista []
;      while [columns > 0]
;      [
;        set xcor initial-x
;        set ycor initial-y
;        ask routers-here
;        [
;          ;print who
;          set lista lput (sum-heatmap-max-i) lista
;        ]
;        set initial-x initial-x + 1
;        set columns (columns - 1)
;
;        set i (i + 1)
;      ]
;      set initial-x -50
;      set initial-y (initial-y + 1)
;      set columns number_of_columns
;      set lines (lines - 1)
;
;      print lista
;    ]
;  ]

  ;print "Heatmap Máxima I"
  print "$map1 << EOD"
  ask one-of espioes
  [
    let initial-x -50
    let initial-y 50 - (number_of_lines - 1)

    let lines number_of_lines
    let columns number_of_columns

    let first-ever true
    while [lines > 0]
    [
      let i 0
      let first-element-of-line true
      while [columns > 0]
      [
        set xcor initial-x
        set ycor initial-y
        ask routers-here
        [
          ;print who
          ;set lista lput (sum-heatmap-max-i / ( (ticks - 1000) * (buffer-in-size))) lista

          ifelse (first-ever)
          [
            type sum-heatmap-max-i / ( (ticks - 1000) * (buffer-in-size))
            set first-ever false
          ]
          [
            if (columns != number_of_columns)
            [
              type " "
              set first-element-of-line false
            ]

            if (first-element-of-line)
            [
              type "\n"
              set first-element-of-line false
            ]
            type sum-heatmap-max-i / ( (ticks - 1000) * (buffer-in-size))
          ]
        ]
        set initial-x initial-x + 1
        set columns (columns - 1)

        set i (i + 1)
      ]
      set initial-x -50
      set initial-y (initial-y + 1)
      set columns number_of_columns
      set lines (lines - 1)

      ;print lista
    ]
  ]
  print "\nEOD"
  print "set view map"
  print "splot '$map1' matrix with image"
  print "set terminal png"
  ;print "set output 'Heatmap - Taxa Maxima - I.png'"

  type "set output '"
  type name-of-files
  type " - "
  type "Heatmap - Taxa Maxima - I.png'"
  type "\n"

  print "replot"

;  print "Heatmap Maxima O - Soma"
;  ask one-of espioes
;  [
;    let initial-x -50
;    let initial-y 50 - (number_of_lines - 1)
;
;    let lines number_of_lines
;    let columns number_of_columns
;
;
;    while [lines > 0]
;    [
;      let i 0
;      let lista []
;      while [columns > 0]
;      [
;        set xcor initial-x
;        set ycor initial-y
;        ask routers-here
;        [
;          ;print who
;          set lista lput sum-heatmap-max-o lista
;        ]
;        set initial-x initial-x + 1
;        set columns (columns - 1)
;
;        set i (i + 1)
;      ]
;      set initial-x -50
;      set initial-y (initial-y + 1)
;      set columns number_of_columns
;      set lines (lines - 1)
;
;      print lista
;    ]
;  ]

  ;print "Heatmap Maxima O"
  print "$map1 << EOD"
  ask one-of espioes
  [
    let initial-x -50
    let initial-y 50 - (number_of_lines - 1)

    let lines number_of_lines
    let columns number_of_columns

    let first-ever true
    while [lines > 0]
    [
      let i 0
      let first-element-of-line true
      while [columns > 0]
      [
        set xcor initial-x
        set ycor initial-y
        ask routers-here
        [
          ;print who
          ;set lista lput (sum-heatmap-max-o / ( (ticks - 1000) * (buffer-out-size))) lista

          ifelse (first-ever)
          [
            type sum-heatmap-max-o / ( (ticks - 1000) * (buffer-out-size))
            set first-ever false
          ]
          [
            if (columns != number_of_columns)
            [
              type " "
              set first-element-of-line false
            ]

            if (first-element-of-line)
            [
              type "\n"
              set first-element-of-line false
            ]
            type sum-heatmap-max-o / ( (ticks - 1000) * (buffer-out-size))
          ]
        ]
        set initial-x initial-x + 1
        set columns (columns - 1)

        set i (i + 1)
      ]
      set initial-x -50
      set initial-y (initial-y + 1)
      set columns number_of_columns
      set lines (lines - 1)

      ;print lista
    ]
  ]
  print "\nEOD"
  print "set view map"
  print "splot '$map1' matrix with image"
  print "set terminal png"
  ;print "set output 'Heatmap - Taxa Maxima - O.png'"

  type "set output '"
  type name-of-files
  type " - "
  type "Heatmap - Taxa Maxima - O.png'"
  type "\n"

  print "replot"

;  print "Heatmap Maxima I/O - Soma"
;  ask one-of espioes
;  [
;    let initial-x -50
;    let initial-y 50 - (number_of_lines - 1)
;
;    let lines number_of_lines
;    let columns number_of_columns
;
;
;    while [lines > 0]
;    [
;      let i 0
;      let lista []
;      while [columns > 0]
;      [
;        set xcor initial-x
;        set ycor initial-y
;        ask routers-here
;        [
;          ;print who
;          set lista lput (sum-heatmap-max-i + sum-heatmap-max-o) lista
;        ]
;        set initial-x initial-x + 1
;        set columns (columns - 1)
;
;        set i (i + 1)
;      ]
;      set initial-x -50
;      set initial-y (initial-y + 1)
;      set columns number_of_columns
;      set lines (lines - 1)
;
;      print lista
;    ]
;  ]

  ;print "Heatmap Maxima I/O"
  print "$map1 << EOD"
  ask one-of espioes
  [
    let initial-x -50
    let initial-y 50 - (number_of_lines - 1)

    let lines number_of_lines
    let columns number_of_columns

    let first-ever true
    while [lines > 0]
    [
      let i 0
      let first-element-of-line true
      while [columns > 0]
      [
        set xcor initial-x
        set ycor initial-y
        ask routers-here
        [
          ;print who
          ;set lista lput ((sum-heatmap-max-i + sum-heatmap-max-o) / ( (ticks - 1000) * ((buffer-in-size) + (buffer-out-size)))) lista

          ifelse (first-ever)
          [
            type (sum-heatmap-max-i + sum-heatmap-max-o) / ( (ticks - 1000) * ((buffer-in-size) + (buffer-out-size)))
            set first-ever false
          ]
          [
            if (columns != number_of_columns)
            [
              type " "
              set first-element-of-line false
            ]

            if (first-element-of-line)
            [
              type "\n"
              set first-element-of-line false
            ]
            type (sum-heatmap-max-i + sum-heatmap-max-o) / ( (ticks - 1000) * ((buffer-in-size) + (buffer-out-size)))
          ]
        ]
        set initial-x initial-x + 1
        set columns (columns - 1)

        set i (i + 1)
      ]
      set initial-x -50
      set initial-y (initial-y + 1)
      set columns number_of_columns
      set lines (lines - 1)

      ;print lista
    ]
  ]
  print "\nEOD"
  print "set view map"
  print "splot '$map1' matrix with image"
  print "set terminal png"
  ;print "set output 'Heatmap - Taxa Maxima - IO.png'"

  type "set output '"
  type name-of-files
  type " - "
  type "Heatmap - Taxa Maxima - IO.png'"
  type "\n"

  print "replot"





  print "#flits-generated:"
  print (word "#" (packet-number * packet-size))
  print "#packets-generated:"
  print (word "#" packet-number)
  print "#total-flits-received:"
  print (word "#" total-flits-received)
  print "#total-packets-received:"
  print (word "#" total-packets-received)
  print "#execution time:"
  print (word "#" execution-time)
  print "#min hops:"
  print (word "#" min-hops)
  print "#avg hops:"
  print (word "#" avg-hops)
  print "#max hops:"
  print (word "#" max-hops)
  print "#min latency:"
  print (word "#" min-latency)
  print "#avg latency:"
  print (word "#" avg-latency)
  print "#max latency:"
  print (word "#" max-latency)
  print ""

  print "#number_of_lines:"
  print (word "#" number_of_lines)
  print "#number_of_columns:"
  print (word "#" number_of_columns)
  print "#radius:"
  print (word "#" radius)
  print "#packets-per-generation:"
  print (word "#" packets-per-generation)

  print "#deveria gerar:"
  print (word "#" temporario)

  print "#nao foram geradas:"
  print (word "#" cheio)

  export-interface (word "" name-of-files ".png")

  export-output (word "" name-of-files ".plt")




  ask espioes
  [
    die
  ]










;  foreach sort-on [who] routers [ the-router ->
;   ask the-router [
;    print "--"
;    print sum-heatmap-occ-i
;    print sum-heatmap-occ-o
;    print "--"
;  ]
;  ]


end


to sum-to-heatmap

  if (ticks >= 1000)
  [

    ask routers
    [

      let aa 0

      let max-i-in-cycle 0
      let max-o-in-cycle 0

      while [aa < length buffer-in]
      [
        ; Soma para taxa de ocupação de entrada
        if (item 0 (item aa buffer-in) != "PE")
        [
          set sum-heatmap-occ-i (sum-heatmap-occ-i + (length (item aa buffer-in) - 1))

          if ((length (item aa buffer-in) - 1) > max-i-in-cycle)
          [
            set max-i-in-cycle (length (item aa buffer-in) - 1)
          ]
        ]
        ; Soma para taxa de ocupação de entrada
        if (item 0 (item aa buffer-out) != "PE")
        [
          set sum-heatmap-occ-o (sum-heatmap-occ-o + (length (item aa buffer-out) - 1))

          if ((length (item aa buffer-out) - 1) > max-o-in-cycle)
          [
            set max-o-in-cycle (length (item aa buffer-out) - 1)
          ]
        ]



        set aa (aa + 1)
      ]

      set sum-heatmap-max-i (sum-heatmap-max-i + max-i-in-cycle)
      set sum-heatmap-max-o (sum-heatmap-max-o + max-o-in-cycle)
    ]
  ]

end



to all_tests-escalabilidade
  ;no-display
  ;display

  let first-line []
  set first-line lput ("Quantidade de Roteadores") first-line
  set first-line lput ("Com Atualizacao, sem log") first-line
  set first-line lput ("Sem atualizacao, log a cada 1 ciclo") first-line
  set first-line lput ("Sem atualizacao, log a cada 10 ciclos") first-line
  set first-line lput ("Sem atualizacao, log a cada 50 ciclos") first-line

  file-open "escalabilidade.csv"

  file-print csv:to-row first-line

  file-close

  let line []
  ;Teste 1 = 3x3, c/ atualização, s/log
  setup
  set number_of_lines 3
  set number_of_columns 3
  set print-log-csv false
  ;cycles-to-print-csv
  display

  set line lput (number_of_lines * number_of_columns) line

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

;  let line []
;  set line lput execution-time line
;  file-open "escalabilidade.csv"
;  file-print csv:to-row line
;  file-close

  set line lput execution-time line

  wait 1

  ;Teste 2 = 3x3, s/atualização, log a cada 1 ciclo
  setup
  set number_of_lines 3
  set number_of_columns 3
  set print-log-csv true
  set cycles-to-print-csv 1
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 3 = 3x3, s/atualização, log a cada 10 ciclo
  setup
  set number_of_lines 3
  set number_of_columns 3
  set print-log-csv true
  set cycles-to-print-csv 10
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 4 = 3x3, s/atualização, log a cada 50 ciclo
  setup
  set number_of_lines 3
  set number_of_columns 3
  set print-log-csv true
  set cycles-to-print-csv 50
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  file-open "escalabilidade.csv"
  file-print csv:to-row line
  file-close

  ;---- FIM 3X3 ---;


  set line []
  ;Teste 1 = 5x5, c/ atualização, s/log
  setup
  set number_of_lines 5
  set number_of_columns 5
  set print-log-csv false
  ;cycles-to-print-csv
  display

  set line lput (number_of_lines * number_of_columns) line

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

;  let line []
;  set line lput execution-time line
;  file-open "escalabilidade.csv"
;  file-print csv:to-row line
;  file-close

  set line lput execution-time line

  wait 1

  ;Teste 2 = 5x5, s/atualização, log a cada 1 ciclo
  setup
  set number_of_lines 5
  set number_of_columns 5
  set print-log-csv true
  set cycles-to-print-csv 1
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 3 = 5x5, s/atualização, log a cada 10 ciclo
  setup
  set number_of_lines 5
  set number_of_columns 5
  set print-log-csv true
  set cycles-to-print-csv 10
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 4 = 5x5, s/atualização, log a cada 50 ciclo
  setup
  set number_of_lines 5
  set number_of_columns 5
  set print-log-csv true
  set cycles-to-print-csv 50
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  file-open "escalabilidade.csv"
  file-print csv:to-row line
  file-close

  ;---- FIM 5x5 ---;

  set line []
  ;Teste 1 = 7x7, c/ atualização, s/log
  setup
  set number_of_lines 7
  set number_of_columns 7
  set print-log-csv false
  ;cycles-to-print-csv
  display

  set line lput (number_of_lines * number_of_columns) line

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

;  let line []
;  set line lput execution-time line
;  file-open "escalabilidade.csv"
;  file-print csv:to-row line
;  file-close

  set line lput execution-time line

  wait 1

  ;Teste 2 = 7x7, s/atualização, log a cada 1 ciclo
  setup
  set number_of_lines 7
  set number_of_columns 7
  set print-log-csv true
  set cycles-to-print-csv 1
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 3 = 7x7, s/atualização, log a cada 10 ciclo
  setup
  set number_of_lines 7
  set number_of_columns 7
  set print-log-csv true
  set cycles-to-print-csv 10
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 4 = 7x7, s/atualização, log a cada 50 ciclo
  setup
  set number_of_lines 7
  set number_of_columns 7
  set print-log-csv true
  set cycles-to-print-csv 50
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  file-open "escalabilidade.csv"
  file-print csv:to-row line
  file-close

  ;---- FIM 7x7 ---;


  set line []
  ;Teste 1 = 10x10, c/ atualização, s/log
  setup
  set number_of_lines 10
  set number_of_columns 10
  set print-log-csv false
  ;cycles-to-print-csv
  display

  set line lput (number_of_lines * number_of_columns) line

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

;  let line []
;  set line lput execution-time line
;  file-open "escalabilidade.csv"
;  file-print csv:to-row line
;  file-close

  set line lput execution-time line

  wait 1

  ;Teste 2 = 10x10, s/atualização, log a cada 1 ciclo
  setup
  set number_of_lines 10
  set number_of_columns 10
  set print-log-csv true
  set cycles-to-print-csv 1
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 3 = 10x10, s/atualização, log a cada 10 ciclo
  setup
  set number_of_lines 10
  set number_of_columns 10
  set print-log-csv true
  set cycles-to-print-csv 10
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 4 = 10x10, s/atualização, log a cada 50 ciclo
  setup
  set number_of_lines 10
  set number_of_columns 10
  set print-log-csv true
  set cycles-to-print-csv 50
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  file-open "escalabilidade.csv"
  file-print csv:to-row line
  file-close

  ;---- FIM 10x10 ---;

  set line []
  ;Teste 1 = 15x15, c/ atualização, s/log
  setup
  set number_of_lines 15
  set number_of_columns 15
  set print-log-csv false
  ;cycles-to-print-csv
  display

  set line lput (number_of_lines * number_of_columns) line

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

;  let line []
;  set line lput execution-time line
;  file-open "escalabilidade.csv"
;  file-print csv:to-row line
;  file-close

  set line lput execution-time line

  wait 1

  ;Teste 2 = 15x15, s/atualização, log a cada 1 ciclo
  setup
  set number_of_lines 15
  set number_of_columns 15
  set print-log-csv true
  set cycles-to-print-csv 1
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 3 = 15x15, s/atualização, log a cada 10 ciclo
  setup
  set number_of_lines 15
  set number_of_columns 15
  set print-log-csv true
  set cycles-to-print-csv 10
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 4 = 15x15, s/atualização, log a cada 50 ciclo
  setup
  set number_of_lines 15
  set number_of_columns 15
  set print-log-csv true
  set cycles-to-print-csv 50
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  file-open "escalabilidade.csv"
  file-print csv:to-row line
  file-close

  ;---- FIM 15x15 ---;

  set line []
  ;Teste 1 = 20x20, c/ atualização, s/log
  setup
  set number_of_lines 20
  set number_of_columns 20
  set print-log-csv false
  ;cycles-to-print-csv
  display

  set line lput (number_of_lines * number_of_columns) line

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

;  let line []
;  set line lput execution-time line
;  file-open "escalabilidade.csv"
;  file-print csv:to-row line
;  file-close

  set line lput execution-time line

  wait 1

  ;Teste 2 = 20x20, s/atualização, log a cada 1 ciclo
  setup
  set number_of_lines 20
  set number_of_columns 20
  set print-log-csv true
  set cycles-to-print-csv 1
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 3 = 20x20, s/atualização, log a cada 10 ciclo
  setup
  set number_of_lines 20
  set number_of_columns 20
  set print-log-csv true
  set cycles-to-print-csv 10
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 4 = 20x20, s/atualização, log a cada 50 ciclo
  setup
  set number_of_lines 20
  set number_of_columns 20
  set print-log-csv true
  set cycles-to-print-csv 50
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  file-open "escalabilidade.csv"
  file-print csv:to-row line
  file-close

  ;---- FIM 20x20 ---;


  set line []
  ;Teste 1 = 25x25, c/ atualização, s/log
  setup
  set number_of_lines 25
  set number_of_columns 25
  set print-log-csv false
  ;cycles-to-print-csv
  display

  set line lput (number_of_lines * number_of_columns) line

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

;  let line []
;  set line lput execution-time line
;  file-open "escalabilidade.csv"
;  file-print csv:to-row line
;  file-close

  set line lput execution-time line

  wait 1

  ;Teste 2 = 25x25, s/atualização, log a cada 1 ciclo
  setup
  set number_of_lines 25
  set number_of_columns 25
  set print-log-csv true
  set cycles-to-print-csv 1
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 3 = 25x25, s/atualização, log a cada 10 ciclo
  setup
  set number_of_lines 25
  set number_of_columns 25
  set print-log-csv true
  set cycles-to-print-csv 10
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 4 = 25x25, s/atualização, log a cada 50 ciclo
  setup
  set number_of_lines 25
  set number_of_columns 25
  set print-log-csv true
  set cycles-to-print-csv 50
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  file-open "escalabilidade.csv"
  file-print csv:to-row line
  file-close

  ;---- FIM 25x25 ---;


  set line []
  ;Teste 1 = 30x30, c/ atualização, s/log
  setup
  set number_of_lines 30
  set number_of_columns 30
  set print-log-csv false
  ;cycles-to-print-csv
  display

  set line lput (number_of_lines * number_of_columns) line

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

;  let line []
;  set line lput execution-time line
;  file-open "escalabilidade.csv"
;  file-print csv:to-row line
;  file-close

  set line lput execution-time line

  wait 1

  ;Teste 2 = 30x30, s/atualização, log a cada 1 ciclo
  setup
  set number_of_lines 30
  set number_of_columns 30
  set print-log-csv true
  set cycles-to-print-csv 1
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 3 = 30x30, s/atualização, log a cada 10 ciclo
  setup
  set number_of_lines 30
  set number_of_columns 30
  set print-log-csv true
  set cycles-to-print-csv 10
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  ;Teste 4 = 30x30, s/atualização, log a cada 50 ciclo
  setup
  set number_of_lines 30
  set number_of_columns 30
  set print-log-csv true
  set cycles-to-print-csv 50
  no-display

  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  set line lput execution-time line

  wait 1

  file-open "escalabilidade.csv"
  file-print csv:to-row line
  file-close

  ;---- FIM 30x30 ---;







  user-message("Fim de todas simulações")
end

to all_tests-5x5
  ;set name-of-files (word ""number_of_lines "x" number_of_columns " - raio " radius " - " packets-per-generation " packets")
  ;export-interface (word "" nome_bolado ".png")
  ;print nome_bolado

  ;;-------------------------
  ;;5x5, raio 1, carga 1/10 - 3 pacotes

  setup
  set number_of_lines 5
  set number_of_columns 5
  set radius 1
  set packets-per-generation 3
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;5x5, raio 1, carga 1/10 - 5 pacotes

  setup
  set number_of_lines 5
  set number_of_columns 5
  set radius 1
  set packets-per-generation 5
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;5x5, raio 4, carga 1/10 - 3 pacotes

  setup
  set number_of_lines 5
  set number_of_columns 5
  set radius 4
  set packets-per-generation 3
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;5x5, raio 4, carga 1/10 - 5 pacotes

  setup
  set number_of_lines 5
  set number_of_columns 5
  set radius 4
  set packets-per-generation 5
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;5x5, raio 8, carga 1/10 - 3 pacotes

  setup
  set number_of_lines 5
  set number_of_columns 5
  set radius 8
  set packets-per-generation 3
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;5x5, raio 8, carga 1/10 - 5 pacotes

  setup
  set number_of_lines 5
  set number_of_columns 5
  set radius 8
  set packets-per-generation 5
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;-------------------------


  user-message("Fim de todos os testes")


end

to all_tests
  ;set name-of-files (word ""number_of_lines "x" number_of_columns " - raio " radius " - " packets-per-generation " packets")
  ;export-interface (word "" nome_bolado ".png")
  ;print nome_bolado

  ;;-------------------------
  ;;15x15, raio 1, carga 1/10 - 23 pacotes

  set routing-algorithm "WF"

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 1
  set packets-per-generation 23
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 1, carga 1/5 - 45 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 1
  set packets-per-generation 45
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 11, carga 1/10 - 23 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 11
  set packets-per-generation 23
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 11, carga 1/5 - 45 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 11
  set packets-per-generation 45
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 22, carga 1/10 - 23 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 22
  set packets-per-generation 23
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 1, carga 1/5 - 45 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 22
  set packets-per-generation 45
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1



  ;;-------------------------


  user-message("Fim de todos os testes")


end



to all_tests-antes-wf
  ;set name-of-files (word ""number_of_lines "x" number_of_columns " - raio " radius " - " packets-per-generation " packets")
  ;export-interface (word "" nome_bolado ".png")
  ;print nome_bolado

  ;;-------------------------
  ;;15x15, raio 1, carga 1/10 - 23 pacotes

  ;;set routing-algorithm "WF"

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 1
  set packets-per-generation 23
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 1, carga 1/5 - 45 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 1
  set packets-per-generation 45
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 11, carga 1/10 - 23 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 11
  set packets-per-generation 23
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 11, carga 1/5 - 45 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 11
  set packets-per-generation 45
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 22, carga 1/10 - 23 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 22
  set packets-per-generation 23
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;15x15, raio 1, carga 1/5 - 45 pacotes

  setup
  set number_of_lines 15
  set number_of_columns 15
  set radius 22
  set packets-per-generation 45
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1



  ;;-------------------------


  user-message("Fim de todos os testes")


end




to all_tests-10x10
  ;set name-of-files (word ""number_of_lines "x" number_of_columns " - raio " radius " - " packets-per-generation " packets")
  ;export-interface (word "" nome_bolado ".png")
  ;print nome_bolado

  ;;-------------------------
  ;;10x10, raio 1, carga 1/10 - 10 pacotes

  setup
  set number_of_lines 10
  set number_of_columns 10
  set radius 1
  set packets-per-generation 10
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;-------------------------
  ;;10x10, raio 1, carga 1/5 - 20 pacotes

  setup
  set number_of_lines 10
  set number_of_columns 10
  set radius 1
  set packets-per-generation 20
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;10x10, raio 8, carga 1/10 - 10 pacotes

  setup
  set number_of_lines 10
  set number_of_columns 10
  set radius 8
  set packets-per-generation 10
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;-------------------------
  ;;10x10, raio 8, carga 1/5 - 20 pacotes

  setup
  set number_of_lines 10
  set number_of_columns 10
  set radius 8
  set packets-per-generation 20
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;10x10, raio 16, carga 1/10 - 10 pacotes

  setup
  set number_of_lines 10
  set number_of_columns 10
  set radius 16
  set packets-per-generation 10
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1

  ;;-------------------------
  ;;10x10, raio 16, carga 1/5 - 20 pacotes

  setup
  set number_of_lines 10
  set number_of_columns 10
  set radius 16
  set packets-per-generation 20
  setup
  while [stop-simulation = false]
  [
    go
  ]

  wait 1



  ;;-------------------------


  user-message("Fim de todos os testes")


end

to bg
  ask patches [
    set pcolor 8
  ]
end



to teste2

;  if (ticks mod cycles-to-print-csv = 0)
;  [
;    print "oe"
;  ]

;  file-open "output.csv"
;  file-print csv:to-row (list ["um"]["dois"]["tres"])
;  file-print csv:to-row (list 4 5 6)
;  file-print csv:to-row (list "a" "b" "c")
;  file-flush
;  file-close

  file-open "output.csv"

  if (ticks = 0)
  [
    let first-line []

    ;csv:to-file "taxa-ocupacao-geral.csv" lista

    foreach sort-on [who] routers [ the-router ->
      ask the-router [
        ;set first-line (lput (word "Router" who "") first-line)
        set first-line (lput (word "Router"who"IN") first-line)
        set first-line (lput (word "Router"who"IE") first-line)
        set first-line (lput (word "Router"who"IS") first-line)
        set first-line (lput (word "Router"who"IW") first-line)
        set first-line (lput (word "Router"who"IPE") first-line)

        set first-line (lput (word "Router"who"ON") first-line)
        set first-line (lput (word "Router"who"OE") first-line)
        set first-line (lput (word "Router"who"OS") first-line)
        set first-line (lput (word "Router"who"OW") first-line)
        set first-line (lput (word "Router"who"OPE") first-line)
      ]
    ]
    print first-line

    file-print csv:to-row first-line

  ]


  let line []

  foreach sort-on [who] routers [ the-router ->
    ask the-router [

;      let i 0
;      set total-flits-in-buffers 0
;
;      while [i < length buffer-in]
;      [
;        set total-flits-in-buffers (total-flits-in-buffers + (length (item i buffer-in) - 1 ))
;        set i (i + 1)
;      ]
;
;      set i 0
;
;      while [i < length buffer-out]
;      [
;        set total-flits-in-buffers (total-flits-in-buffers + (length (item i buffer-out) - 1 ))
;        set i (i + 1)
;      ]


      ;set line (lput (occupancy-rate) line)

      let aa 0
      let sera1 [0 0 0 0 0]
      let sera2 [0 0 0 0 0]
      ;print sera

      while [aa < length buffer-in]
      [
        ifelse (item 0 (item aa buffer-in) = "N")
        [
          set sera1 (replace-item 0 sera1 (length (item aa buffer-in) - 1 ))
        ]
        [
          ifelse (item 0 (item aa buffer-in) = "E")
          [
            set sera1 (replace-item 1 sera1 (length (item aa buffer-in) - 1 ))
          ]
          [
            ifelse (item 0 (item aa buffer-in) = "S")
            [
              set sera1 (replace-item 2 sera1 (length (item aa buffer-in) - 1 ))
            ]
            [
              ifelse (item 0 (item aa buffer-in) = "W")
              [
                set sera1 (replace-item 3 sera1 (length (item aa buffer-in) - 1 ))
              ]
              [
                ;PE
                set sera1 (replace-item 4 sera1 (length (item aa buffer-in) - 1 ))
              ]
            ]
          ]
        ]

        set sera2 (replace-item aa sera2 (length (item aa buffer-out) - 1 ))

        set aa (aa + 1)
      ]
      print "b-in"
      print buffer-in
      print "sera1"
      print sera1
      print "b-out"
      print buffer-out
      print "sera2"
      print sera2

      ;set line lput ((sentence sera1 sera2)) line
      ;set line sentence line []
      set line (sentence sera1 sera2 line)
      print line
    ]
  ]

  file-print csv:to-row line

  ;file-flush
  ;file-close

  ;print line

;  ask routers
;  [
;    ;print (word "Router" who "")
;    set linha (lput (word "Router" who "") linha)
;    ;print buffer-in
;    ;print buffer-out
;  ]

;  file-open "output.csv"
;  file-print csv:to-row (list ["um"]["dois"]["tres"])
;  file-print csv:to-row (list 4 5 6)
;  file-print csv:to-row (list "a" "b" "c")
;  file-flush
;  file-close

;  let mylist [[1 2] [1 2] [1 2]]
;    foreach mylist
;    [
;      n ->
;      set n lput [3 4] n
;    ]
;
;    ;print mylist

;  let mylist [2 7 5 "Bob" [3 [1 1] -2]]
;; mylist is now [2 7 5 Bob [3 0 -2]]
;set mylist replace-item 2 mylist 10
;; mylist is now [2 7 10 Bob [3 0 -2]]
;
;  set mylist lput 42 mylist
;; mylist is now [2 7 10 Bob [3 0 -2] 42]
;
;  set mylist but-last mylist
;; mylist is now [2 7 10 Bob [3 0 -2]]
;
;  set mylist but-first mylist
; mylist is now [7 10 Bob [3 0 -2]]


  ;set mylist (replace-item 3 mylist (replace-item 2 (item 3 mylist) 9))

;  set mylist (replace-item 3 mylist
;                  (remove-item 2 (item 3 mylist)))

  ;print mylist

;  set mylist (replace-item 3 mylist (lput [9 9] (item 3 mylist)))

;  foreach mylist
;  [
;    n ->
;    if (is-list? n)
;    [
;      foreach n
;      [
;        m ->
;        if (is-list? m)
;        [
;          ;print m
;
;          set n remove m n
;        ]
;      ]
;
;      ;;print "ae"
;      ;;print "n:"
;      ;;print n
;      ;set mylist remove n mylist
;
;
;    ]
;  ]

  ;print mylist

;  foreach mylist
;  [
;    n ->
;    set n ()
;  ]

;  let naosei 0
;
;  while [naosei < length mylist]
;  [
;    ;print item naosei mylist
;
;    if (is-list?(item naosei mylist) AND (but-first (item naosei mylist) = 2))
;    [
;      ;print "aehoo"
;    ]
;
;    set naosei (naosei + 1)
;  ]

  ;set mylist (replace-item 3 mylist (remove-item 2 (item 3 mylist)))

  ;;print mylist





;  let mylist [1 2 3 [1 2] 2 10 2]
;  ;;print mylist
;  ;;print empty? mylist
;  ;;print first mylist
;  set mylist fput 10 mylist
;  ;;print mylist
;  ;;print last mylist
;  ;;print length mylist
;  set mylist lput 500 mylist
;  ;;print mylist
;  ;;print last mylist
;  ;;print position [1 2] mylist
;  set mylist remove 10 mylist
;  ;;print mylist
;  set mylist remove-item 2 mylist
;  ;;print mylist
;  set mylist replace-item 0 mylist 111
;  ;;print mylist
;  ;;print sublist mylist 0 2
;
;  let ae first mylist
;  ;;;;print second ae
;  set mylist []
;  ;;print empty? mylist
;
;  ;;print "---------------------------------"
;
;  let buffer []
;  ;;print buffer
;  set buffer fput [18 3 1] buffer
;  ;;print buffer
;
;  let roteamento [10 10 10]
;  set roteamento fput (first buffer) roteamento
;  ;;print roteamento
;
;  set roteamento lput [20 3 1] roteamento
;  ;;print roteamento
;
;  set roteamento remove-item 0 roteamento
;  ;;print roteamento





;  let buffer []
;  ;;print buffer
;  set buffer fput [18 3 1] buffer
;  ;;print buffer
;
;  let roteamento []
;  let variavel first buffer
;  ;set roteamento fput (list variavel 55) roteamento
;  set variavel sublist variavel 0 2
;  set variavel lput 55 variavel
;
;  ;;print variavel

end
@#$#@#$#@
GRAPHICS-WINDOW
569
10
1890
1332
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-50
50
-50
50
0
0
1
ticks
30.0

BUTTON
7
10
70
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
72
10
135
43
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
139
10
216
43
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
50
210
83
number_of_lines
number_of_lines
1
100
8.0
1
1
routers
HORIZONTAL

SLIDER
7
87
211
120
number_of_columns
number_of_columns
1
100
8.0
1
1
routers
HORIZONTAL

SLIDER
8
125
211
158
buffer-in-size
buffer-in-size
1
100
8.0
1
1
flits
HORIZONTAL

SLIDER
8
165
212
198
buffer-out-size
buffer-out-size
1
100
8.0
1
1
flits
HORIZONTAL

CHOOSER
6
252
212
297
arbitrator
arbitrator
"Round-Robin"
0

CHOOSER
6
303
211
348
routing-algorithm
routing-algorithm
"XY" "WF"
0

SLIDER
5
356
208
389
routing-cost
routing-cost
0
100
0.0
1
1
cycles
HORIZONTAL

SLIDER
6
395
210
428
router-to-router-cost
router-to-router-cost
0
100
0.0
1
1
cycles
HORIZONTAL

MONITOR
253
123
352
168
NIL
total-flits-received
1
1
11

MONITOR
366
124
510
169
NIL
total-packets-received
17
1
11

MONITOR
365
179
508
224
NIL
min-latency
1
1
11

MONITOR
365
233
507
278
NIL
avg-latency
1
1
11

MONITOR
365
286
507
331
NIL
max-latency
1
1
11

MONITOR
252
178
351
223
NIL
min-hops
11
1
11

MONITOR
249
232
350
277
NIL
avg-hops
1
1
11

MONITOR
250
286
351
331
NIL
max-hops
1
1
11

MONITOR
252
12
351
57
NIL
execution-time
2
1
11

CHOOSER
244
388
466
433
traffic-type
traffic-type
"Random-By-Radius" "Orientated"
0

SLIDER
244
511
469
544
ticks-to-new-traffic-generation
ticks-to-new-traffic-generation
1
100
1.0
1
1
cycles
HORIZONTAL

SLIDER
243
550
469
583
packets-per-generation
packets-per-generation
1
150
45.0
1
1
packets
HORIZONTAL

SWITCH
247
351
465
384
generate-traffic
generate-traffic
0
1
-1000

SLIDER
246
473
469
506
packet-size
packet-size
3
100
3.0
1
1
flits
HORIZONTAL

SLIDER
244
436
467
469
radius
radius
1
100
22.0
1
1
NIL
HORIZONTAL

MONITOR
253
68
352
113
flits-generated
packet-number * packet-size
1
1
11

MONITOR
364
69
510
114
packets-generated
packet-number
1
1
11

SLIDER
5
434
207
467
simulation-length
simulation-length
1
100000
10000.0
1
1
cycles
HORIZONTAL

SLIDER
5
521
204
554
cycles-to-print-csv
cycles-to-print-csv
1
100
1.0
1
1
NIL
HORIZONTAL

SWITCH
8
483
203
516
print-log-csv
print-log-csv
0
1
-1000

INPUTBOX
3
591
80
651
source-id
5.0
1
0
Number

INPUTBOX
86
592
164
652
destination-id
7.0
1
0
Number

BUTTON
299
606
419
639
NIL
orientated-send
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
189
606
291
639
NIL
manual-send
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
7
205
214
238
temporary-buffer-size
temporary-buffer-size
1
1000
10.0
1
1
flits
HORIZONTAL

BUTTON
460
774
538
807
NIL
all_tests\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
389
783
452
816
NIL
bg
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
