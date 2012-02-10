From: Chester <somethingsome2000@gmail.com>
Subject: Re: btrfs unmountable after failed suspend
Date: Thu, 9 Feb 2012 18:54:42 -0600
Message-ID: <CAAE6i0h+E0vQ4D6gr7MQiwS00hnQGk5R7ubkRa00NdkoaNxcNA@mail.gmail.com>
References: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
 <CAAE6i0jEaXmgmnmyUOrOr+5RyvPce25QZFALan+JBQ80K=UwNQ@mail.gmail.com>
 <CAAE6i0hXA7rzZ=VCnezfyHQFn=+UcfrmUsfR-GQZcgvxFW+qJQ@mail.gmail.com>
 <20120208125536.GI16796@shiny> <CAAE6i0ggEyVGh94L7n00Mm-YZTq26de2kZspU+AQKiaA=JD+8g@mail.gmail.com>
 <20120208202658.GH8384@shiny> <CAAE6i0hWxsSKLoN8zyJv9H4tu5R5B3KXvbgZzHDcMHYC4JX3mA@mail.gmail.com>
 <CAAE6i0isDwiA_vyg=KX_sodu7gyux7wJhEM5OXjD=4jgRqwj+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Chester <somethingsome2000@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0isDwiA_vyg=KX_sodu7gyux7wJhEM5OXjD=4jgRqwj+g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Output for btrfs-debug-tree for that specific block in dmesg

And available here ( http://pastebin.com/AgdvS5JM ) in case the lines
wrap and look ugly

leaf 653297209344 items 43 free space 673 generation 332442 owner 2
fs uuid 0f5b2f4f-1aa0-4e6f-b904-e5b4d4588144
chunk uuid 27536f0d-993b-4da3-85eb-1c9b08c435cb
	item 0 key (653284786176 EXTENT_ITEM 4096) itemoff 3926 itemsize 69
		extent refs 3 gen 330325 flags 2
		tree block key (5587 c 5579) level 0
		tree block backref root 256
		shared block backref parent 742205943808
		shared block backref parent 737977237504
	item 1 key (653284790272 EXTENT_ITEM 4096) itemoff 3875 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (654686625792 a8 4096) level 0
		tree block backref root 2
	item 2 key (653284794368 EXTENT_ITEM 4096) itemoff 3824 itemsize 51
		extent refs 1 gen 332438 flags 2
		tree block key (18446744073709551606 80 390195183616) level 1
		tree block backref root 7
	item 3 key (653284798464 EXTENT_ITEM 4096) itemoff 3773 itemsize 51
		extent refs 1 gen 332438 flags 2
		tree block key (18446744073709551606 80 390443347968) level 0
		tree block backref root 7
	item 4 key (653284802560 EXTENT_ITEM 4096) itemoff 3722 itemsize 51
		extent refs 1 gen 332438 flags 2
		tree block key (400765636608 a8 155648) level 1
		tree block backref root 2
	item 5 key (653284806656 EXTENT_ITEM 4096) itemoff 3671 itemsize 51
		extent refs 1 gen 332438 flags 2
		tree block key (402394804224 a8 12288) level 0
		tree block backref root 2
	item 6 key (653284810752 EXTENT_ITEM 4096) itemoff 3602 itemsize 69
		extent refs 3 gen 329238 flags 2
		tree block key (50522 60 524) level 0
		tree block backref root 256
		shared block backref parent 742140727296
		shared block backref parent 738011779072
	item 7 key (653284831232 EXTENT_ITEM 4096) itemoff 3551 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (654686961664 a8 4096) level 0
		tree block backref root 2
	item 8 key (653284818944 EXTENT_ITEM 4096) itemoff 3500 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (654687121408 a8 4096) level 0
		tree block backref root 2
	item 9 key (653284823040 EXTENT_ITEM 4096) itemoff 3449 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (654688612352 a8 4096) level 0
		tree block backref root 2
	item 10 key (653284827136 EXTENT_ITEM 4096) itemoff 3398 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (654690684928 a8 4096) level 0
		tree block backref root 2
	item 11 key (653284831232 EXTENT_ITEM 4096) itemoff 3347 itemsize 51
		extent refs 1 gen 330677 flags 258
		tree block key (257 54 2990375638) level 0
		shared block backref parent 737976102912
	item 12 key (653284835328 EXTENT_ITEM 4096) itemoff 3296 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (654691397632 a8 4096) level 0
		tree block backref root 2
	item 13 key (653284839424 EXTENT_ITEM 4096) itemoff 3245 itemsize 51
		extent refs 1 gen 330677 flags 258
		tree block key (257 54 2138317573) level 0
		shared block backref parent 737976102912
	item 14 key (653284843520 EXTENT_ITEM 4096) itemoff 3194 itemsize 51
		extent refs 1 gen 332430 flags 2
		tree block key (283 c 1641737) level 0
		tree block backref root 257
	item 15 key (653284847616 EXTENT_ITEM 4096) itemoff 3143 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (737085390848 a8 4096) level 0
		tree block backref root 2
	item 16 key (653284855808 EXTENT_ITEM 4096) itemoff 3092 itemsize 51
		extent refs 1 gen 329210 flags 2
		tree block key (219304 54 429834975) level 0
		tree block backref root 1511
	item 17 key (653284864000 EXTENT_ITEM 4096) itemoff 3041 itemsize 51
		extent refs 1 gen 329210 flags 2
		tree block key (12504 c 202665) level 0
		tree block backref root 1511
	item 18 key (653284868096 EXTENT_ITEM 4096) itemoff 2990 itemsize 51
		extent refs 1 gen 329207 flags 2
		tree block key (10468 1 0) level 0
		tree block backref root 1511
	item 19 key (653284872192 EXTENT_ITEM 4096) itemoff 2939 itemsize 51
		extent refs 1 gen 329213 flags 2
		tree block key (184862 60 688) level 0
		tree block backref root 1511
	item 20 key (653284876288 EXTENT_ITEM 4096) itemoff 2888 itemsize 51
		extent refs 1 gen 332363 flags 2
		tree block key (377190010880 a8 12288) level 0
		tree block backref root 2
	item 21 key (653284880384 EXTENT_ITEM 4096) itemoff 2837 itemsize 51
		extent refs 1 gen 332406 flags 2
		tree block key (1589771 1 0) level 0
		tree block backref root 257
	item 22 key (653284884480 EXTENT_ITEM 4096) itemoff 2786 itemsize 51
		extent refs 1 gen 329215 flags 2
		tree block key (15062 1 0) level 0
		tree block backref root 1511
	item 23 key (653284892672 EXTENT_ITEM 4096) itemoff 2735 itemsize 51
		extent refs 1 gen 323553 flags 258
		tree block key (52069 1 0) level 0
		tree block backref root 260
	item 24 key (653284896768 EXTENT_ITEM 4096) itemoff 2666 itemsize 69
		extent refs 3 gen 323540 flags 258
		tree block key (208047 6c 0) level 0
		tree block backref root 1511
		tree block backref root 262
		shared block backref parent 656081068032
	item 25 key (653284900864 EXTENT_ITEM 4096) itemoff 2615 itemsize 51
		extent refs 1 gen 332430 flags 2
		tree block key (1075845 1 0) level 2
		tree block backref root 257
	item 26 key (653284904960 EXTENT_ITEM 4096) itemoff 2564 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (724886913024 a8 4096) level 0
		tree block backref root 2
	item 27 key (653284909056 EXTENT_ITEM 4096) itemoff 2513 itemsize 51
		extent refs 1 gen 332438 flags 2
		tree block key (425495932928 a8 45056) level 1
		tree block backref root 2
	item 28 key (653284913152 EXTENT_ITEM 4096) itemoff 2462 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (724889038848 a8 4096) level 0
		tree block backref root 2
	item 29 key (653284917248 EXTENT_ITEM 4096) itemoff 2411 itemsize 51
		extent refs 1 gen 332438 flags 2
		tree block key (438298386432 a8 20480) level 0
		tree block backref root 2
	item 30 key (653284921344 EXTENT_ITEM 4096) itemoff 2360 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (724890869760 a8 4096) level 0
		tree block backref root 2
	item 31 key (653284925440 EXTENT_ITEM 4096) itemoff 2309 itemsize 51
		extent refs 1 gen 332361 flags 2
		tree block key (585 54 1690954686) level 0
		tree block backref root 257
	item 32 key (653284929536 EXTENT_ITEM 4096) itemoff 2258 itemsize 51
		extent refs 1 gen 332406 flags 2
		tree block key (1589801 1 0) level 0
		tree block backref root 257
	item 33 key (653284933632 EXTENT_ITEM 4096) itemoff 2207 itemsize 51
		extent refs 1 gen 330673 flags 2
		tree block key (18446744073709551606 80 420865138688) level 1
		tree block backref root 7
	item 34 key (653284937728 EXTENT_ITEM 4096) itemoff 2156 itemsize 51
		extent refs 1 gen 330673 flags 2
		tree block key (18446744073709551606 80 421055201280) level 0
		tree block backref root 7
	item 35 key (653284945920 EXTENT_ITEM 4096) itemoff 2105 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (724898709504 a8 4096) level 0
		tree block backref root 2
	item 36 key (653284950016 EXTENT_ITEM 4096) itemoff 2054 itemsize 51
		extent refs 1 gen 332223 flags 2
		tree block key (370322698240 a8 8192) level 1
		tree block backref root 2
	item 37 key (653284954112 EXTENT_ITEM 4096) itemoff 2003 itemsize 51
		extent refs 1 gen 329207 flags 2
		tree block key (10053 6c 0) level 0
		tree block backref root 1511
	item 38 key (653284958208 EXTENT_ITEM 4096) itemoff 1952 itemsize 51
		extent refs 1 gen 332223 flags 2
		tree block key (370362576896 a8 12288) level 0
		tree block backref root 2
	item 39 key (653284962304 EXTENT_ITEM 4096) itemoff 1901 itemsize 51
		extent refs 1 gen 330673 flags 2
		tree block key (18446744073709551606 80 421068566528) level 0
		tree block backref root 7
	item 40 key (653284966400 EXTENT_ITEM 4096) itemoff 1850 itemsize 51
		extent refs 1 gen 332218 flags 2
		tree block key (724912443392 a8 4096) level 0
		tree block backref root 2
	item 41 key (653284970496 EXTENT_ITEM 4096) itemoff 1799 itemsize 51
		extent refs 1 gen 332361 flags 2
		tree block key (585 54 1944515731) level 0
		tree block backref root 257
	item 42 key (653284974592 EXTENT_ITEM 4096) itemoff 1748 itemsize 51
		extent refs 1 gen 324601 flags 2
		tree block key (18446744073709551606 80 728263335936) level 0
		tree block backref root 7
