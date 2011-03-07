From: corey richey <thewhitetruck@gmail.com>
Subject: I emailed yesterday about 2.6.35 unable to mount after a power
 outage. I upgraded to 2.7.2 and I can mount again.
Date: Sun, 6 Mar 2011 16:09:38 -0800
Message-ID: <AANLkTinEKG9DWmqWjxRjbBBM_sxhVtoae2Yn3YNAqK99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I emailed yesterday about 2.6.35 unable to mount after a power outage.
I upgraded to 2.7.2 and I can mount again. It looks like I can read
and write onto the mounted volume.

But btrfsck still aborts. I am wondering if I should balance or not? I
can't seem to take a snapshot and there is to much data to rsync gzip
anywhere. I realize there is no fsck that can correct errors in btrfs
yet wondering if balance will fix my errors here is my btrfsck output.

failed to read /dev/sr0
parent transid verify failed on 949899927552 wanted 27464 found 27272
parent transid verify failed on 949899927552 wanted 27464 found 27272
parent transid verify failed on 949971595264 wanted 27472 found 27395
parent transid verify failed on 949971595264 wanted 27472 found 27395
parent transid verify failed on 949928099840 wanted 27472 found 27398
parent transid verify failed on 949928099840 wanted 27472 found 27398
parent transid verify failed on 949971615744 wanted 27472 found 27395
parent transid verify failed on 949971615744 wanted 27472 found 27395
parent transid verify failed on 949971619840 wanted 27472 found 27395
parent transid verify failed on 949971619840 wanted 27472 found 27395
parent transid verify failed on 949972004864 wanted 27472 found 27395
parent transid verify failed on 949972004864 wanted 27472 found 27395
parent transid verify failed on 949971476480 wanted 27472 found 27395
parent transid verify failed on 949971476480 wanted 27472 found 27395
parent transid verify failed on 949980672000 wanted 27407 found 27394
parent transid verify failed on 949980672000 wanted 27407 found 27394
parent transid verify failed on 949980364800 wanted 27415 found 27392
parent transid verify failed on 949980364800 wanted 27415 found 27392
parent transid verify failed on 949983412224 wanted 27423 found 27394
parent transid verify failed on 949983412224 wanted 27423 found 27394
parent transid verify failed on 949981847552 wanted 27450 found 27394
parent transid verify failed on 949981847552 wanted 27450 found 27394
parent transid verify failed on 949981470720 wanted 27464 found 27394
parent transid verify failed on 949981470720 wanted 27464 found 27394
parent transid verify failed on 949964521472 wanted 27465 found 27395
parent transid verify failed on 949964521472 wanted 27465 found 27395
parent transid verify failed on 949967962112 wanted 27470 found 27395
parent transid verify failed on 949967962112 wanted 27470 found 27395
parent transid verify failed on 949893734400 wanted 27471 found 27383
parent transid verify failed on 949893734400 wanted 27471 found 27383
parent transid verify failed on 949894778880 wanted 27471 found 27218
parent transid verify failed on 949894778880 wanted 27471 found 27218
parent transid verify failed on 949894934528 wanted 27471 found 27218
parent transid verify failed on 949894934528 wanted 27471 found 27218
parent transid verify failed on 949972148224 wanted 27468 found 27395
parent transid verify failed on 949972148224 wanted 27468 found 27395
parent transid verify failed on 949896486912 wanted 27471 found 27234
parent transid verify failed on 949896486912 wanted 27471 found 27234
parent transid verify failed on 949971591168 wanted 27471 found 27395
parent transid verify failed on 949971591168 wanted 27471 found 27395
parent transid verify failed on 949971116032 wanted 27471 found 27395
parent transid verify failed on 949971116032 wanted 27471 found 27395
parent transid verify failed on 949971075072 wanted 27471 found 27395
parent transid verify failed on 949971075072 wanted 27471 found 27395
parent transid verify failed on 949967835136 wanted 27472 found 27395
parent transid verify failed on 949967835136 wanted 27472 found 27395
leaf parent key incorrect 949903310848
bad block 949903310848
leaf parent key incorrect 949948174336
bad block 949948174336
parent transid verify failed on 949971087360 wanted 27472 found 27395
parent transid verify failed on 949971087360 wanted 27472 found 27395
parent transid verify failed on 949970014208 wanted 27472 found 27395
parent transid verify failed on 949970014208 wanted 27472 found 27395
parent transid verify failed on 949966995456 wanted 27418 found 27395
parent transid verify failed on 949966995456 wanted 27418 found 27395
bad block 949969018880
parent transid verify failed on 949934911488 wanted 27472 found 27354
parent transid verify failed on 949934911488 wanted 27472 found 27354
parent transid verify failed on 949962989568 wanted 27442 found 27395
parent transid verify failed on 949962989568 wanted 27442 found 27395
parent transid verify failed on 949971513344 wanted 27472 found 27395
parent transid verify failed on 949971513344 wanted 27472 found 27395
parent transid verify failed on 949971623936 wanted 27471 found 27395
parent transid verify failed on 949971623936 wanted 27471 found 27395
parent transid verify failed on 949971382272 wanted 27472 found 27395
parent transid verify failed on 949971382272 wanted 27472 found 27395
parent transid verify failed on 949965828096 wanted 27445 found 27395
parent transid verify failed on 949965828096 wanted 27445 found 27395
parent transid verify failed on 949969412096 wanted 27426 found 27395
parent transid verify failed on 949969412096 wanted 27426 found 27395
parent transid verify failed on 949970583552 wanted 27472 found 27395
parent transid verify failed on 949970583552 wanted 27472 found 27395
parent transid verify failed on 949959938048 wanted 27403 found 27395
parent transid verify failed on 949959938048 wanted 27403 found 27395
parent transid verify failed on 949970563072 wanted 27472 found 27395
parent transid verify failed on 949970563072 wanted 27472 found 27395
parent transid verify failed on 949971853312 wanted 27471 found 27395
parent transid verify failed on 949971853312 wanted 27471 found 27395
parent transid verify failed on 949974736896 wanted 27464 found 27395
parent transid verify failed on 949974736896 wanted 27464 found 27395
parent transid verify failed on 949974740992 wanted 27464 found 27395
parent transid verify failed on 949974740992 wanted 27464 found 27395
parent transid verify failed on 949970554880 wanted 27472 found 27395
parent transid verify failed on 949970554880 wanted 27472 found 27395
parent transid verify failed on 949970567168 wanted 27472 found 27395
parent transid verify failed on 949970567168 wanted 27472 found 27395
parent transid verify failed on 949964406784 wanted 27415 found 27395
parent transid verify failed on 949964406784 wanted 27415 found 27395
leaf parent key incorrect 949954445312
bad block 949954445312
parent transid verify failed on 949970432000 wanted 27472 found 27395
parent transid verify failed on 949970432000 wanted 27472 found 27395
parent transid verify failed on 949964673024 wanted 27420 found 27395
parent transid verify failed on 949964673024 wanted 27420 found 27395
parent transid verify failed on 949971210240 wanted 27460 found 27395
parent transid verify failed on 949971210240 wanted 27460 found 27395
parent transid verify failed on 949971079168 wanted 27472 found 27395
parent transid verify failed on 949971079168 wanted 27472 found 27395
parent transid verify failed on 949969911808 wanted 27447 found 27395
parent transid verify failed on 949969911808 wanted 27447 found 27395
parent transid verify failed on 949971247104 wanted 27472 found 27395
parent transid verify failed on 949971247104 wanted 27472 found 27395
parent transid verify failed on 949970681856 wanted 27458 found 27395
parent transid verify failed on 949970681856 wanted 27458 found 27395
parent transid verify failed on 949970690048 wanted 27458 found 27395
parent transid verify failed on 949970690048 wanted 27458 found 27395
parent transid verify failed on 949970018304 wanted 27472 found 27395
parent transid verify failed on 949970018304 wanted 27472 found 27395
parent transid verify failed on 949970857984 wanted 27468 found 27395
parent transid verify failed on 949970857984 wanted 27468 found 27395
parent transid verify failed on 949969272832 wanted 27472 found 27395
parent transid verify failed on 949969272832 wanted 27472 found 27395
parent transid verify failed on 949969248256 wanted 27472 found 27395
parent transid verify failed on 949969248256 wanted 27472 found 27395
parent transid verify failed on 949971595264 wanted 27472 found 27395
parent transid verify failed on 949971595264 wanted 27472 found 27395
parent transid verify failed on 949928099840 wanted 27472 found 27398
parent transid verify failed on 949928099840 wanted 27472 found 27398
parent transid verify failed on 949971615744 wanted 27472 found 27395
parent transid verify failed on 949971615744 wanted 27472 found 27395
parent transid verify failed on 949971619840 wanted 27472 found 27395
parent transid verify failed on 949971619840 wanted 27472 found 27395
parent transid verify failed on 949967962112 wanted 27470 found 27395
parent transid verify failed on 949967962112 wanted 27470 found 27395
parent transid verify failed on 949893734400 wanted 27471 found 27383
parent transid verify failed on 949893734400 wanted 27471 found 27383
parent transid verify failed on 949894778880 wanted 27471 found 27218
parent transid verify failed on 949894778880 wanted 27471 found 27218
parent transid verify failed on 949934911488 wanted 27472 found 27354
parent transid verify failed on 949934911488 wanted 27472 found 27354
parent transid verify failed on 949969649664 wanted 27468 found 27395
parent transid verify failed on 949969649664 wanted 27468 found 27395
parent transid verify failed on 949972004864 wanted 27472 found 27395
parent transid verify failed on 949972004864 wanted 27472 found 27395
parent transid verify failed on 949969661952 wanted 27468 found 27395
parent transid verify failed on 949969661952 wanted 27468 found 27395
parent transid verify failed on 949894934528 wanted 27471 found 27218
parent transid verify failed on 949894934528 wanted 27471 found 27218
parent transid verify failed on 949895487488 wanted 27471 found 27218
parent transid verify failed on 949895487488 wanted 27471 found 27218
parent transid verify failed on 949969670144 wanted 27468 found 27395
parent transid verify failed on 949969670144 wanted 27468 found 27395
parent transid verify failed on 949969674240 wanted 27468 found 27395
parent transid verify failed on 949969674240 wanted 27468 found 27395
parent transid verify failed on 949962035200 wanted 27442 found 27395
parent transid verify failed on 949962035200 wanted 27442 found 27395
parent transid verify failed on 949962989568 wanted 27442 found 27395
parent transid verify failed on 949962989568 wanted 27442 found 27395
parent transid verify failed on 949971476480 wanted 27472 found 27395
parent transid verify failed on 949971476480 wanted 27472 found 27395
parent transid verify failed on 949970026496 wanted 27468 found 27395
parent transid verify failed on 949970026496 wanted 27468 found 27395
parent transid verify failed on 949972238336 wanted 27468 found 27395
parent transid verify failed on 949972238336 wanted 27468 found 27395
parent transid verify failed on 949970063360 wanted 27468 found 27395
parent transid verify failed on 949970063360 wanted 27468 found 27395
parent transid verify failed on 949972156416 wanted 27468 found 27395
parent transid verify failed on 949972156416 wanted 27468 found 27395
parent transid verify failed on 949972148224 wanted 27468 found 27395
parent transid verify failed on 949972148224 wanted 27468 found 27395
parent transid verify failed on 949972013056 wanted 27468 found 27395
parent transid verify failed on 949972013056 wanted 27468 found 27395
parent transid verify failed on 949972000768 wanted 27468 found 27395
parent transid verify failed on 949972000768 wanted 27468 found 27395
parent transid verify failed on 949971996672 wanted 27468 found 27395
parent transid verify failed on 949971996672 wanted 27468 found 27395
parent transid verify failed on 949968322560 wanted 27442 found 27395
parent transid verify failed on 949968322560 wanted 27442 found 27395
parent transid verify failed on 949972242432 wanted 27468 found 27395
parent transid verify failed on 949972242432 wanted 27468 found 27395
parent transid verify failed on 949971488768 wanted 27472 found 27395
parent transid verify failed on 949971488768 wanted 27472 found 27395
parent transid verify failed on 949972160512 wanted 27468 found 27395
parent transid verify failed on 949972160512 wanted 27468 found 27395
parent transid verify failed on 949971513344 wanted 27472 found 27395
parent transid verify failed on 949971513344 wanted 27472 found 27395
leaf parent key incorrect 949888622592
bad block 949888622592
parent transid verify failed on 949896486912 wanted 27471 found 27234
parent transid verify failed on 949896486912 wanted 27471 found 27234
leaf parent key incorrect 949890494464
bad block 949890494464
parent transid verify failed on 949965340672 wanted 27469 found 27395
parent transid verify failed on 949965340672 wanted 27469 found 27395
parent transid verify failed on 949971623936 wanted 27471 found 27395
parent transid verify failed on 949971623936 wanted 27471 found 27395
parent transid verify failed on 949971591168 wanted 27471 found 27395
parent transid verify failed on 949971591168 wanted 27471 found 27395
bad block 949894778880
Extent back ref already exists for 949894782976 parent 0 root 5
Extent back ref already exists for 949894795264 parent 0 root 5
Extent back ref already exists for 693984104448 parent 0 root 5
Extent back ref already exists for 949894799360 parent 0 root 5
Extent back ref already exists for 949894803456 parent 0 root 5
Extent back ref already exists for 949894807552 parent 0 root 5
Extent back ref already exists for 949894787072 parent 0 root 5
Extent back ref already exists for 949894791168 parent 0 root 5
Extent back ref already exists for 693936832512 parent 0 root 5
Extent back ref already exists for 693935030272 parent 0 root 5
Extent back ref already exists for 693935067136 parent 0 root 5
Extent back ref already exists for 693935394816 parent 0 root 5
Extent back ref already exists for 693950889984 parent 0 root 5
Extent back ref already exists for 693961506816 parent 0 root 5
Extent back ref already exists for 693936734208 parent 0 root 5
Extent back ref already exists for 693936152576 parent 0 root 5
Extent back ref already exists for 693947363328 parent 0 root 5
Extent back ref already exists for 693935783936 parent 0 root 5
Extent back ref already exists for 693937065984 parent 0 root 5
Extent back ref already exists for 786468610048 parent 0 root 5
Extent back ref already exists for 786484523008 parent 0 root 5
Extent back ref already exists for 693935583232 parent 0 root 5
Extent back ref already exists for 693937119232 parent 0 root 5
Extent back ref already exists for 693935599616 parent 0 root 5
Extent back ref already exists for 693943177216 parent 0 root 5
Extent back ref already exists for 786483236864 parent 0 root 5
Extent back ref already exists for 786485866496 parent 0 root 5
Extent back ref already exists for 693946454016 parent 0 root 5
Extent back ref already exists for 693947625472 parent 0 root 5
Extent back ref already exists for 693939990528 parent 0 root 5
Extent back ref already exists for 693952856064 parent 0 root 5
Extent back ref already exists for 693942624256 parent 0 root 5
Extent back ref already exists for 693935480832 parent 0 root 5
Extent back ref already exists for 693946998784 parent 0 root 5
Extent back ref already exists for 693943115776 parent 0 root 5
Extent back ref already exists for 693943107584 parent 0 root 5
Extent back ref already exists for 693951111168 parent 0 root 5
Extent back ref already exists for 693961498624 parent 0 root 5
Extent back ref already exists for 693937307648 parent 0 root 5
Extent back ref already exists for 786431172608 parent 0 root 5
Extent back ref already exists for 693946130432 parent 0 root 5
Extent back ref already exists for 693946576896 parent 0 root 5
Extent back ref already exists for 693943582720 parent 0 root 5
Extent back ref already exists for 693952503808 parent 0 root 5
Extent back ref already exists for 693938462720 parent 0 root 5
Extent back ref already exists for 693939204096 parent 0 root 5
Extent back ref already exists for 693939298304 parent 0 root 5
Extent back ref already exists for 693947645952 parent 0 root 5
Extent back ref already exists for 693953318912 parent 0 root 5
Extent back ref already exists for 693944082432 parent 0 root 5
parent transid verify failed on 949971116032 wanted 27471 found 27395
parent transid verify failed on 949971116032 wanted 27471 found 27395
parent transid verify failed on 949971075072 wanted 27471 found 27395
parent transid verify failed on 949971075072 wanted 27471 found 27395
leaf parent key incorrect 949895487488
bad block 949895487488
parent transid verify failed on 949967835136 wanted 27472 found 27395
parent transid verify failed on 949967835136 wanted 27472 found 27395
parent transid verify failed on 949969670144 wanted 27468 found 27395
parent transid verify failed on 949969670144 wanted 27468 found 27395
leaf 949969670144 items 28 free space 1867 generation 27468 owner 2
fs uuid fa1d901a-c398-4301-9245-f22ea22be759
chunk uuid 641cefae-a07f-48eb-a673-6bc5816c0dac
	item 0 key (786481156096 EXTENT_ITEM 4096) itemoff 3944 itemsize 51
		extent refs 1 gen 19476 flags 2
		tree block key (18446744073709551606 80 881277677568) level 0
		tree block backref root 7
	item 1 key (786481160192 EXTENT_ITEM 4096) itemoff 3893 itemsize 51
		extent refs 1 gen 26771 flags 2
		tree block key (694000418816 a8 4096) level 0
		tree block backref root 2
	item 2 key (786481164288 EXTENT_ITEM 4096) itemoff 3842 itemsize 51
		extent refs 1 gen 20481 flags 2
		tree block key (18446744073709551606 80 899971055616) level 0
		tree block backref root 7
	item 3 key (786481168384 EXTENT_ITEM 4096) itemoff 3791 itemsize 51
		extent refs 1 gen 21074 flags 2
		tree block key (18446744073709551606 80 908677992448) level 0
		tree block backref root 7
	item 4 key (786481172480 EXTENT_ITEM 4096) itemoff 3740 itemsize 51
		extent refs 1 gen 20685 flags 2
		tree block key (18446744073709551606 80 905634287616) level 0
		tree block backref root 7
	item 5 key (786481176576 EXTENT_ITEM 4096) itemoff 3689 itemsize 51
		extent refs 1 gen 19505 flags 2
		tree block key (18446744073709551606 80 884082794496) level 0
		tree block backref root 7
	item 6 key (786481180672 EXTENT_ITEM 4096) itemoff 3638 itemsize 51
		extent refs 1 gen 19505 flags 2
		tree block key (18446744073709551606 80 884086829056) level 0
		tree block backref root 7
	item 7 key (786481184768 EXTENT_ITEM 4096) itemoff 3587 itemsize 51
		extent refs 1 gen 19505 flags 2
		tree block key (18446744073709551606 80 884090863616) level 0
		tree block backref root 7
	item 8 key (786481188864 EXTENT_ITEM 4096) itemoff 3536 itemsize 51
		extent refs 1 gen 20521 flags 2
		tree block key (18446744073709551606 80 901407907840) level 0
		tree block backref root 7
	item 9 key (786481192960 EXTENT_ITEM 4096) itemoff 3485 itemsize 51
		extent refs 1 gen 20685 flags 2
		tree block key (18446744073709551606 80 905638322176) level 0
		tree block backref root 7
	item 10 key (786481197056 EXTENT_ITEM 4096) itemoff 3434 itemsize 51
		extent refs 1 gen 19554 flags 2
		tree block key (18446744073709551606 80 887029669888) level 0
		tree block backref root 7
	item 11 key (786481205248 EXTENT_ITEM 4096) itemoff 3383 itemsize 51
		extent refs 1 gen 20703 flags 2
		tree block key (44325 6c 3106660352) level 0
		tree block backref root 5
	item 12 key (786481209344 EXTENT_ITEM 4096) itemoff 3332 itemsize 51
		extent refs 1 gen 20673 flags 2
		tree block key (18446744073709551606 80 904213573632) level 0
		tree block backref root 7
	item 13 key (786481213440 EXTENT_ITEM 4096) itemoff 3281 itemsize 51
		extent refs 1 gen 14613 flags 2
		tree block key (18446744073709551606 80 836150652928) level 0
		tree block backref root 7
	item 14 key (786481217536 EXTENT_ITEM 4096) itemoff 3230 itemsize 51
		extent refs 1 gen 20874 flags 2
		tree block key (18446744073709551606 80 908274536448) level 0
		tree block backref root 7
	item 15 key (786481221632 EXTENT_ITEM 4096) itemoff 3179 itemsize 51
		extent refs 1 gen 21800 flags 2
		tree block key (44595 6c 0) level 0
		tree block backref root 5
	item 16 key (786481225728 EXTENT_ITEM 4096) itemoff 3128 itemsize 51
		extent refs 1 gen 19532 flags 2
		tree block key (18446744073709551606 80 886230278144) level 0
		tree block backref root 7
	item 17 key (786481229824 EXTENT_ITEM 4096) itemoff 3077 itemsize 51
		extent refs 1 gen 20438 flags 2
		tree block key (18446744073709551606 80 897165389824) level 0
		tree block backref root 7
	item 18 key (786481233920 EXTENT_ITEM 4096) itemoff 3026 itemsize 51
		extent refs 1 gen 20438 flags 2
		tree block key (18446744073709551606 80 897169424384) level 0
		tree block backref root 7
	item 19 key (786481238016 EXTENT_ITEM 4096) itemoff 2975 itemsize 51
		extent refs 1 gen 20478 flags 2
		tree block key (18446744073709551606 80 899038523392) level 0
		tree block backref root 7
	item 20 key (786481242112 EXTENT_ITEM 4096) itemoff 2924 itemsize 51
		extent refs 1 gen 20890 flags 2
		tree block key (18446744073709551606 80 908347158528) level 0
		tree block backref root 7
	item 21 key (786481246208 EXTENT_ITEM 4096) itemoff 2873 itemsize 51
		extent refs 1 gen 20646 flags 2
		tree block key (18446744073709551606 80 902950207488) level 0
		tree block backref root 7
	item 22 key (786481250304 EXTENT_ITEM 4096) itemoff 2822 itemsize 51
		extent refs 1 gen 19531 flags 2
		tree block key (18446744073709551606 80 885887340544) level 0
		tree block backref root 7
	item 23 key (786481266688 EXTENT_ITEM 4096) itemoff 2771 itemsize 51
		extent refs 1 gen 20689 flags 2
		tree block key (18446744073709551606 80 906736271360) level 0
		tree block backref root 7
	item 24 key (786481270784 EXTENT_ITEM 4096) itemoff 2720 itemsize 51
		extent refs 1 gen 19597 flags 2
		tree block key (18446744073709551606 80 889528160256) level 0
		tree block backref root 7
	item 25 key (786481274880 EXTENT_ITEM 4096) itemoff 2669 itemsize 51
		extent refs 1 gen 20689 flags 2
		tree block key (18446744073709551606 80 906740305920) level 0
		tree block backref root 7
	item 26 key (786481278976 EXTENT_ITEM 4096) itemoff 2618 itemsize 51
		extent refs 1 gen 20520 flags 2
		tree block key (18446744073709551606 80 901298974720) level 0
		tree block backref root 7
	item 27 key (786481283072 EXTENT_ITEM 4096) itemoff 2567 itemsize 51
		extent refs 1 gen 20520 flags 2
		tree block key (18446744073709551606 80 901303009280) level 0
		tree block backref root 7
failed to find block number 786481254400
Aborted
