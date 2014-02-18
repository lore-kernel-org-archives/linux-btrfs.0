Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:65394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaBRVzb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 16:55:31 -0500
Message-ID: <5303D6C8.80103@friedels.name>
Date: Tue, 18 Feb 2014 22:55:20 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name>	<0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>	<52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba>	<52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name>	<A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>	<52F73E2B.9080103@friedels.name>	<837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>	<82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>	<53010EF9.60805@friedels.name>	<21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com> <pan$475be$cb0c1165$a3d91acc$c206709@cox.net>
In-Reply-To: <pan$475be$cb0c1165$a3d91acc$c206709@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

  >> It looks like everything is single except for 4GB of data which is 
still
>> raid0. Weird. There should be a bunch of messages in dmesg during a
>> normal/successful balance, and either something mentioned or missing
>> might provide a clue why some chunks weren't converted.
  >
> Agreed.

time ./btrfs balance start  -dconvert=single,soft /mnt/BTRFS/Video/
ERROR: error during balancing '/mnt/BTRFS/Video/' - No space left on device
There may be more info in syslog - try dmesg | tail

real    0m23.803s
user    0m0.000s
sys     0m1.070s

dmesg:
[697498.761318] btrfs: relocating block group 19874593112064 flags 9
[697507.614140] btrfs: relocating block group 19715679322112 flags 9
[697516.218690] btrfs: 2 enospc errors during balance


>> Unmounted, what do you get for btrfs check?
>
> Agreed, but it's worth an explanation and explicit warning just in case...

Many errors. For better readability, you find the complete output at the 
end of this mail.

...
Extent back ref already exists for 20463459852288 parent 22989777764352 
root 0
Extent back ref already exists for 22727791968256 parent 22989777764352 
root 0
...
Extent back ref already exists for 20463415173120 parent 22989923053568 
root 0
ref mismatch on [20463062638592 4096] extent item 1, found 2
Incorrect global backref count on 20463062638592 found 1 wanted 2
backpointer mismatch on [20463062638592 4096]
...
root 17050 inode 14259 errors 100, file extent discount
found 990180465844 bytes used err is 1


> btrfs check is read-only by default -- it'll tell you what it thinks is
> wrong, but won't attempt to correct anything.  Adding --repair tells it
> to try to correct the errors it found, but the recommendation is do NOT
> use --repair unless it's a last-ditch effort after other things failed,
> and preferably only after a btrfs dev says to, because sometimes it can
> make things worse instead of better.

Ok, I didn't do that now.
But I had done that before...

As a reminder:
This all started with the problem that my system became 
unresponsive/slow sometimes. I thus ran a btrfsck.

Below some samples from about one month ago:
----------
Extent back ref already exists for 2994950590464 parent 863072366592 root 0

ref mismatch on [32935936 4096] extent item 1, found 2
repair deleting extent record: key 32935936 168 4096
adding new tree backref on start 32935936 len 4096 parent 2994784206848 
root 2994784206848
Incorrect global backref count on 32935936 found 1 wanted 2
backpointer mismatch on [32935936 4096]
ref mismatch on [32997376 4096] extent item 1, found 2
repair deleting extent record: key 32997376 168 4096
adding new tree backref on start 32997376 len 4096 parent 2994824708096 
root 2994824708096
Incorrect global backref count on 32997376 found 1 wanted 2
backpointer mismatch on [32997376 4096]

Incorrect global backref count on 8988365651968 found 1 wanted 0
backpointer mismatch on [8988365651968 4096]
repaired damaged extent references
checking free space cache
checking fs roots
root 256 inode 9579 errors 100, file extent discount
root 256 inode 9580 errors 100, file extent discount
root 256 inode 14258 errors 100, file extent discount
root 256 inode 14259 errors 100, file extent discount
root 4444 inode 9579 errors 100, file extent discount
root 4444 inode 9580 errors 100, file extent discount
root 4444 inode 14258 errors 100, file extent discount
root 4444 inode 14259 errors 100, file extent discount
enabling repair mode
Checking filesystem on /dev/sdc1
UUID: 989306aa-d291-4752-8477-0baf94f8c42f
cache and super generation don't match, space cache will be invalidated
found 827360733827 bytes used err is 1
total csum bytes: 4446455380
total tree bytes: 5506977792
total fs tree bytes: 137293824
total extent tree bytes: 258691072
btree space waste bytes: 496921489
file data blocks allocated: 6440132583424
   referenced 6424163344384
Btrfs v3.12
-----the full output is attached------


Chris Murphy did suggest some things like
-mount with repair option (didn't help)
-check smartctrl (ok)
-scrub (no change)

For that reason I decided to get rid of this filesystem. But I need to 
free one of the discs for this.


> Based on that, I'd suggest
>
> btrfs balance start -dconvert=single,soft /mnt/BTRFS/Video/
>
> Given that there's only 4 GiB left to convert, it should go MUCH faster
> than the 10 hours the multiple TiB took.

Ok, that's valuable knowledge, as this saves lots of time.



Greetings,
Hendrik

Below the full output of todays btrfsck:

./btrfsck /dev/sdb1
Checking filesystem on /dev/sdb1
UUID: 989306aa-d291-4752-8477-0baf94f8c42f
checking extents
Extent back ref already exists for 20463459852288 parent 22989777764352 
root 0
Extent back ref already exists for 22727791968256 parent 22989777764352 
root 0
Extent back ref already exists for 22990383153152 parent 22989777764352 
root 0
Extent back ref already exists for 22989638897664 parent 22989777764352 
root 0
Extent back ref already exists for 22727392038912 parent 22989777764352 
root 0
Extent back ref already exists for 22990049484800 parent 22989777764352 
root 0
Extent back ref already exists for 22727394050048 parent 22989777764352 
root 0
Extent back ref already exists for 22728068673536 parent 22989777764352 
root 0
Extent back ref already exists for 22728592928768 parent 22989777764352 
root 0
Extent back ref already exists for 22727395975168 parent 22989777764352 
root 0
Extent back ref already exists for 22727395983360 parent 22989777764352 
root 0
Extent back ref already exists for 22727395979264 parent 22989777764352 
root 0
Extent back ref already exists for 22727395987456 parent 22989777764352 
root 0
Extent back ref already exists for 22727395991552 parent 22989777764352 
root 0
Extent back ref already exists for 22727395995648 parent 22989777764352 
root 0
Extent back ref already exists for 22727395999744 parent 22989777764352 
root 0
Extent back ref already exists for 22726591852544 parent 22989777764352 
root 0
Extent back ref already exists for 22990516260864 parent 22989777764352 
root 0
Extent back ref already exists for 22990577917952 parent 22989777764352 
root 0
Extent back ref already exists for 22727397859328 parent 22989777764352 
root 0
Extent back ref already exists for 22727397855232 parent 22989777764352 
root 0
Extent back ref already exists for 22727397863424 parent 22989777764352 
root 0
Extent back ref already exists for 22728458592256 parent 22989777764352 
root 0
Extent back ref already exists for 22727397609472 parent 22989777764352 
root 0
Extent back ref already exists for 22989850673152 parent 22989777764352 
root 0
Extent back ref already exists for 22727923941376 parent 22989777764352 
root 0
Extent back ref already exists for 22727397867520 parent 22989777764352 
root 0
Extent back ref already exists for 22727397613568 parent 22989777764352 
root 0
Extent back ref already exists for 22727397871616 parent 22989777764352 
root 0
Extent back ref already exists for 22990270459904 parent 22989777764352 
root 0
Extent back ref already exists for 22727559303168 parent 22989777764352 
root 0
Extent back ref already exists for 22727397617664 parent 22989777764352 
root 0
Extent back ref already exists for 22727397634048 parent 22989777764352 
root 0
Extent back ref already exists for 22727397629952 parent 22989777764352 
root 0
Extent back ref already exists for 22727924060160 parent 22989777764352 
root 0
Extent back ref already exists for 20463088771072 parent 22989777764352 
root 0
Extent back ref already exists for 22989638901760 parent 22989777764352 
root 0
Extent back ref already exists for 22727493369856 parent 22989777764352 
root 0
Extent back ref already exists for 22727104884736 parent 22989777764352 
root 0
Extent back ref already exists for 22989979959296 parent 22989777764352 
root 0
Extent back ref already exists for 22728433455104 parent 22989777764352 
root 0
Extent back ref already exists for 22726856859648 parent 22989777764352 
root 0
Extent back ref already exists for 20463062638592 parent 22989777764352 
root 0
Extent back ref already exists for 20463065632768 parent 22989777764352 
root 0
Extent back ref already exists for 22727869063168 parent 22989777764352 
root 0
Extent back ref already exists for 20463504248832 parent 22989777764352 
root 0
Extent back ref already exists for 22728591757312 parent 22989777764352 
root 0
Extent back ref already exists for 22727924064256 parent 22989777764352 
root 0
Extent back ref already exists for 22727046537216 parent 22989777764352 
root 0
Extent back ref already exists for 20463815450624 parent 22989777764352 
root 0
Extent back ref already exists for 20463085563904 parent 22989777764352 
root 0
Extent back ref already exists for 22726721363968 parent 22989777764352 
root 0
Extent back ref already exists for 22727828881408 parent 22989777764352 
root 0
Extent back ref already exists for 22727828885504 parent 22989777764352 
root 0
Extent back ref already exists for 22728593092608 parent 22989777764352 
root 0
Extent back ref already exists for 22727399534592 parent 22989777764352 
root 0
Extent back ref already exists for 22727828918272 parent 22989777764352 
root 0
Extent back ref already exists for 22990577303552 parent 22989777764352 
root 0
Extent back ref already exists for 22727767691264 parent 22989777764352 
root 0
Extent back ref already exists for 22726584791040 parent 22989777764352 
root 0
Extent back ref already exists for 22989850677248 parent 22989777764352 
root 0
Extent back ref already exists for 22726929747968 parent 22989777764352 
root 0
Extent back ref already exists for 20463560003584 parent 22989777764352 
root 0
Extent back ref already exists for 22727522791424 parent 22989777764352 
root 0
Extent back ref already exists for 20463740538880 parent 22989777764352 
root 0
Extent back ref already exists for 22727399620608 parent 22989777764352 
root 0
Extent back ref already exists for 22990127919104 parent 22989777764352 
root 0
Extent back ref already exists for 22727047536640 parent 22989777764352 
root 0
Extent back ref already exists for 22728068694016 parent 22989777764352 
root 0
Extent back ref already exists for 22727214133248 parent 22989777764352 
root 0
Extent back ref already exists for 22726525747200 parent 22989777764352 
root 0
Extent back ref already exists for 20463477268480 parent 22989777764352 
root 0
Extent back ref already exists for 22727973011456 parent 22989777764352 
root 0
Extent back ref already exists for 22728439918592 parent 22989777764352 
root 0
Extent back ref already exists for 22727972970496 parent 22989777764352 
root 0
Extent back ref already exists for 22728587952128 parent 22989777764352 
root 0
Extent back ref already exists for 22726929244160 parent 22989777764352 
root 0
Extent back ref already exists for 22726929248256 parent 22989777764352 
root 0
Extent back ref already exists for 22727828897792 parent 22989777764352 
root 0
Extent back ref already exists for 20464035745792 parent 22989777764352 
root 0
Extent back ref already exists for 22727828901888 parent 22989777764352 
root 0
Extent back ref already exists for 22727828905984 parent 22989777764352 
root 0
Extent back ref already exists for 22727828910080 parent 22989777764352 
root 0
Extent back ref already exists for 22728414253056 parent 22989777764352 
root 0
Extent back ref already exists for 22728059179008 parent 22989777764352 
root 0
Extent back ref already exists for 22728434843648 parent 22989777764352 
root 0
Extent back ref already exists for 22728335515648 parent 22989777764352 
root 0
Extent back ref already exists for 22728433627136 parent 22989777764352 
root 0
Extent back ref already exists for 22727229071360 parent 22989777764352 
root 0
Extent back ref already exists for 22728100175872 parent 22989777764352 
root 0
Extent back ref already exists for 22726506930176 parent 22989777764352 
root 0
Extent back ref already exists for 22727642562560 parent 22989777764352 
root 0
Extent back ref already exists for 20464037945344 parent 22989777764352 
root 0
Extent back ref already exists for 20463971205120 parent 22989777764352 
root 0
Extent back ref already exists for 20464037908480 parent 22989777764352 
root 0
Extent back ref already exists for 22727828938752 parent 22989777764352 
root 0
Extent back ref already exists for 20464037912576 parent 22989777764352 
root 0
Extent back ref already exists for 20464066527232 parent 22989777764352 
root 0
Extent back ref already exists for 20464066576384 parent 22989777764352 
root 0
Extent back ref already exists for 20463888011264 parent 22989777764352 
root 0
Extent back ref already exists for 22989741858816 parent 22989777764352 
root 0
Extent back ref already exists for 22727873511424 parent 22989777764352 
root 0
Extent back ref already exists for 20464037928960 parent 22989777764352 
root 0
Extent back ref already exists for 20464037916672 parent 22989777764352 
root 0
Extent back ref already exists for 20464037937152 parent 22989777764352 
root 0
Extent back ref already exists for 22990549094400 parent 22989777764352 
root 0
Extent back ref already exists for 20463081979904 parent 22989777764352 
root 0
Extent back ref already exists for 20463064051712 parent 22989777764352 
root 0
Extent back ref already exists for 22727522848768 parent 22989777764352 
root 0
Extent back ref already exists for 22727046541312 parent 22989777764352 
root 0
Extent back ref already exists for 22728325935104 parent 22989777764352 
root 0
Extent back ref already exists for 22728330858496 parent 22989777764352 
root 0
Extent back ref already exists for 22728201531392 parent 22989777764352 
root 0
Extent back ref already exists for 22726507606016 parent 22989777764352 
root 0
Extent back ref already exists for 22726754209792 parent 22989777764352 
root 0
Extent back ref already exists for 22989777768448 parent 22989777764352 
root 0
Extent back ref already exists for 22726918811648 parent 22989777764352 
root 0
Extent back ref already exists for 20463088701440 parent 22989777764352 
root 0
Extent back ref already exists for 22727748812800 parent 22989777764352 
root 0
Extent back ref already exists for 22727973179392 parent 22989777764352 
root 0
Extent back ref already exists for 22727935164416 parent 22989777764352 
root 0
Extent back ref already exists for 22727988588544 parent 22989901127680 
root 0
Extent back ref already exists for 22989901148160 parent 22989901127680 
root 0
Extent back ref already exists for 22727970435072 parent 22989901127680 
root 0
Extent back ref already exists for 22990169636864 parent 22989901127680 
root 0
Extent back ref already exists for 22727091236864 parent 22989901127680 
root 0
Extent back ref already exists for 22727970406400 parent 22989901127680 
root 0
Extent back ref already exists for 20463705088000 parent 22989901127680 
root 0
Extent back ref already exists for 22727969415168 parent 22989901127680 
root 0
Extent back ref already exists for 22727969947648 parent 22989901127680 
root 0
Extent back ref already exists for 22727007752192 parent 22989901127680 
root 0
Extent back ref already exists for 20464059932672 parent 22989901127680 
root 0
Extent back ref already exists for 20464059961344 parent 22989901127680 
root 0
Extent back ref already exists for 20464060006400 parent 22989901127680 
root 0
Extent back ref already exists for 20464060051456 parent 22989901127680 
root 0
Extent back ref already exists for 20464060055552 parent 22989901127680 
root 0
Extent back ref already exists for 20464060096512 parent 22989901127680 
root 0
Extent back ref already exists for 20464060211200 parent 22989901127680 
root 0
Extent back ref already exists for 22727985885184 parent 22989901127680 
root 0
Extent back ref already exists for 22728090324992 parent 22989901127680 
root 0
Extent back ref already exists for 22727987724288 parent 22989901127680 
root 0
Extent back ref already exists for 20464059654144 parent 22989901127680 
root 0
Extent back ref already exists for 22727988805632 parent 22989901127680 
root 0
Extent back ref already exists for 22728091582464 parent 22989901127680 
root 0
Extent back ref already exists for 22728227930112 parent 22989901127680 
root 0
Extent back ref already exists for 22726928609280 parent 22989901127680 
root 0
Extent back ref already exists for 22728092659712 parent 22989901127680 
root 0
Extent back ref already exists for 22727981469696 parent 22989901127680 
root 0
Extent back ref already exists for 22727981498368 parent 22989901127680 
root 0
Extent back ref already exists for 22727981506560 parent 22989901127680 
root 0
Extent back ref already exists for 22728091500544 parent 22989901127680 
root 0
Extent back ref already exists for 22728091508736 parent 22989901127680 
root 0
Extent back ref already exists for 22728091516928 parent 22989901127680 
root 0
Extent back ref already exists for 22728091336704 parent 22989901127680 
root 0
Extent back ref already exists for 22728091467776 parent 22989901127680 
root 0
Extent back ref already exists for 22728237932544 parent 22989901127680 
root 0
Extent back ref already exists for 22728237342720 parent 22989901127680 
root 0
Extent back ref already exists for 22728394371072 parent 22989901127680 
root 0
Extent back ref already exists for 22728394395648 parent 22989901127680 
root 0
Extent back ref already exists for 22726525861888 parent 22989923053568 
root 0
Extent back ref already exists for 20463246749696 parent 22989923053568 
root 0
Extent back ref already exists for 20463246761984 parent 22989923053568 
root 0
Extent back ref already exists for 20463246774272 parent 22989923053568 
root 0
Extent back ref already exists for 20463246786560 parent 22989923053568 
root 0
Extent back ref already exists for 20463246798848 parent 22989923053568 
root 0
Extent back ref already exists for 20463385513984 parent 22989923053568 
root 0
Extent back ref already exists for 20463357014016 parent 22989923053568 
root 0
Extent back ref already exists for 20463415046144 parent 22989923053568 
root 0
Extent back ref already exists for 20463415054336 parent 22989923053568 
root 0
Extent back ref already exists for 22726850498560 parent 22989923053568 
root 0
Extent back ref already exists for 20463415070720 parent 22989923053568 
root 0
Extent back ref already exists for 20463415083008 parent 22989923053568 
root 0
Extent back ref already exists for 20463415091200 parent 22989923053568 
root 0
Extent back ref already exists for 20463357095936 parent 22989923053568 
root 0
Extent back ref already exists for 20463357104128 parent 22989923053568 
root 0
Extent back ref already exists for 20463415111680 parent 22989923053568 
root 0
Extent back ref already exists for 20463415128064 parent 22989923053568 
root 0
Extent back ref already exists for 20463357140992 parent 22989923053568 
root 0
Extent back ref already exists for 20463415152640 parent 22989923053568 
root 0
Extent back ref already exists for 20463415193600 parent 22989923053568 
root 0
Extent back ref already exists for 20463357177856 parent 22989923053568 
root 0
Extent back ref already exists for 20463357186048 parent 22989923053568 
root 0
Extent back ref already exists for 20463246721024 parent 22989923053568 
root 0
Extent back ref already exists for 20463246725120 parent 22989923053568 
root 0
Extent back ref already exists for 20463270359040 parent 22989923053568 
root 0
Extent back ref already exists for 20463246745600 parent 22989923053568 
root 0
Extent back ref already exists for 20463246753792 parent 22989923053568 
root 0
Extent back ref already exists for 20463246757888 parent 22989923053568 
root 0
Extent back ref already exists for 20463246766080 parent 22989923053568 
root 0
Extent back ref already exists for 20463246770176 parent 22989923053568 
root 0
Extent back ref already exists for 20463246778368 parent 22989923053568 
root 0
Extent back ref already exists for 20463246782464 parent 22989923053568 
root 0
Extent back ref already exists for 20463246790656 parent 22989923053568 
root 0
Extent back ref already exists for 20463246794752 parent 22989923053568 
root 0
Extent back ref already exists for 20463246802944 parent 22989923053568 
root 0
Extent back ref already exists for 20463246811136 parent 22989923053568 
root 0
Extent back ref already exists for 20463415132160 parent 22989923053568 
root 0
Extent back ref already exists for 20463357018112 parent 22989923053568 
root 0
Extent back ref already exists for 20463357022208 parent 22989923053568 
root 0
Extent back ref already exists for 20463415042048 parent 22989923053568 
root 0
Extent back ref already exists for 20463415050240 parent 22989923053568 
root 0
Extent back ref already exists for 22989923340288 parent 22989923053568 
root 0
Extent back ref already exists for 20463415062528 parent 22989923053568 
root 0
Extent back ref already exists for 20463357054976 parent 22989923053568 
root 0
Extent back ref already exists for 20463415066624 parent 22989923053568 
root 0
Extent back ref already exists for 20463415074816 parent 22989923053568 
root 0
Extent back ref already exists for 20463357075456 parent 22989923053568 
root 0
Extent back ref already exists for 20463415087104 parent 22989923053568 
root 0
Extent back ref already exists for 20463357087744 parent 22989923053568 
root 0
Extent back ref already exists for 20463415095296 parent 22989923053568 
root 0
Extent back ref already exists for 20463415099392 parent 22989923053568 
root 0
Extent back ref already exists for 20463357108224 parent 22989923053568 
root 0
Extent back ref already exists for 20463415103488 parent 22989923053568 
root 0
Extent back ref already exists for 20463415107584 parent 22989923053568 
root 0
Extent back ref already exists for 20463415119872 parent 22989923053568 
root 0
Extent back ref already exists for 20463415136256 parent 22989923053568 
root 0
Extent back ref already exists for 20463357136896 parent 22989923053568 
root 0
Extent back ref already exists for 20463415144448 parent 22989923053568 
root 0
Extent back ref already exists for 20463415148544 parent 22989923053568 
root 0
Extent back ref already exists for 20463415173120 parent 22989923053568 
root 0
ref mismatch on [20463062638592 4096] extent item 1, found 2
Incorrect global backref count on 20463062638592 found 1 wanted 2
backpointer mismatch on [20463062638592 4096]
ref mismatch on [20463064051712 4096] extent item 1, found 2
Incorrect global backref count on 20463064051712 found 1 wanted 2
backpointer mismatch on [20463064051712 4096]
ref mismatch on [20463065632768 4096] extent item 1, found 2
Incorrect global backref count on 20463065632768 found 1 wanted 2
backpointer mismatch on [20463065632768 4096]
ref mismatch on [20463081979904 4096] extent item 1, found 2
Incorrect global backref count on 20463081979904 found 1 wanted 2
backpointer mismatch on [20463081979904 4096]
ref mismatch on [20463085563904 4096] extent item 1, found 2
Incorrect global backref count on 20463085563904 found 1 wanted 2
backpointer mismatch on [20463085563904 4096]
ref mismatch on [20463088701440 4096] extent item 1, found 2
Incorrect global backref count on 20463088701440 found 1 wanted 2
backpointer mismatch on [20463088701440 4096]
ref mismatch on [20463088771072 4096] extent item 1, found 2
Incorrect global backref count on 20463088771072 found 1 wanted 2
backpointer mismatch on [20463088771072 4096]
ref mismatch on [20463246721024 4096] extent item 1, found 2
Incorrect global backref count on 20463246721024 found 1 wanted 2
backpointer mismatch on [20463246721024 4096]
ref mismatch on [20463246725120 4096] extent item 1, found 2
Incorrect global backref count on 20463246725120 found 1 wanted 2
backpointer mismatch on [20463246725120 4096]
ref mismatch on [20463246745600 4096] extent item 1, found 2
Incorrect global backref count on 20463246745600 found 1 wanted 2
backpointer mismatch on [20463246745600 4096]
ref mismatch on [20463246749696 4096] extent item 1, found 2
Incorrect global backref count on 20463246749696 found 1 wanted 2
backpointer mismatch on [20463246749696 4096]
ref mismatch on [20463246753792 4096] extent item 1, found 2
Incorrect global backref count on 20463246753792 found 1 wanted 2
backpointer mismatch on [20463246753792 4096]
ref mismatch on [20463246757888 4096] extent item 1, found 2
Incorrect global backref count on 20463246757888 found 1 wanted 2
backpointer mismatch on [20463246757888 4096]
ref mismatch on [20463246761984 4096] extent item 1, found 2
Incorrect global backref count on 20463246761984 found 1 wanted 2
backpointer mismatch on [20463246761984 4096]
ref mismatch on [20463246766080 4096] extent item 1, found 2
Incorrect global backref count on 20463246766080 found 1 wanted 2
backpointer mismatch on [20463246766080 4096]
ref mismatch on [20463246770176 4096] extent item 1, found 2
Incorrect global backref count on 20463246770176 found 1 wanted 2
backpointer mismatch on [20463246770176 4096]
ref mismatch on [20463246774272 4096] extent item 1, found 2
Incorrect global backref count on 20463246774272 found 1 wanted 2
backpointer mismatch on [20463246774272 4096]
ref mismatch on [20463246778368 4096] extent item 1, found 2
Incorrect global backref count on 20463246778368 found 1 wanted 2
backpointer mismatch on [20463246778368 4096]
ref mismatch on [20463246782464 4096] extent item 1, found 2
Incorrect global backref count on 20463246782464 found 1 wanted 2
backpointer mismatch on [20463246782464 4096]
ref mismatch on [20463246786560 4096] extent item 1, found 2
Incorrect global backref count on 20463246786560 found 1 wanted 2
backpointer mismatch on [20463246786560 4096]
ref mismatch on [20463246790656 4096] extent item 1, found 2
Incorrect global backref count on 20463246790656 found 1 wanted 2
backpointer mismatch on [20463246790656 4096]
ref mismatch on [20463246794752 4096] extent item 1, found 2
Incorrect global backref count on 20463246794752 found 1 wanted 2
backpointer mismatch on [20463246794752 4096]
ref mismatch on [20463246798848 4096] extent item 1, found 2
Incorrect global backref count on 20463246798848 found 1 wanted 2
backpointer mismatch on [20463246798848 4096]
ref mismatch on [20463246802944 4096] extent item 1, found 2
Incorrect global backref count on 20463246802944 found 1 wanted 2
backpointer mismatch on [20463246802944 4096]
ref mismatch on [20463246811136 4096] extent item 1, found 2
Incorrect global backref count on 20463246811136 found 1 wanted 2
backpointer mismatch on [20463246811136 4096]
ref mismatch on [20463270359040 4096] extent item 1, found 2
Incorrect global backref count on 20463270359040 found 1 wanted 2
backpointer mismatch on [20463270359040 4096]
ref mismatch on [20463357014016 4096] extent item 1, found 2
Incorrect global backref count on 20463357014016 found 1 wanted 2
backpointer mismatch on [20463357014016 4096]
ref mismatch on [20463357018112 4096] extent item 1, found 2
Incorrect global backref count on 20463357018112 found 1 wanted 2
backpointer mismatch on [20463357018112 4096]
ref mismatch on [20463357022208 4096] extent item 1, found 2
Incorrect global backref count on 20463357022208 found 1 wanted 2
backpointer mismatch on [20463357022208 4096]
ref mismatch on [20463357054976 4096] extent item 1, found 2
Incorrect global backref count on 20463357054976 found 1 wanted 2
backpointer mismatch on [20463357054976 4096]
ref mismatch on [20463357075456 4096] extent item 1, found 2
Incorrect global backref count on 20463357075456 found 1 wanted 2
backpointer mismatch on [20463357075456 4096]
ref mismatch on [20463357087744 4096] extent item 1, found 2
Incorrect global backref count on 20463357087744 found 1 wanted 2
backpointer mismatch on [20463357087744 4096]
ref mismatch on [20463357095936 4096] extent item 1, found 2
Incorrect global backref count on 20463357095936 found 1 wanted 2
backpointer mismatch on [20463357095936 4096]
ref mismatch on [20463357104128 4096] extent item 1, found 2
Incorrect global backref count on 20463357104128 found 1 wanted 2
backpointer mismatch on [20463357104128 4096]
ref mismatch on [20463357108224 4096] extent item 1, found 2
Incorrect global backref count on 20463357108224 found 1 wanted 2
backpointer mismatch on [20463357108224 4096]
ref mismatch on [20463357136896 4096] extent item 1, found 2
Incorrect global backref count on 20463357136896 found 1 wanted 2
backpointer mismatch on [20463357136896 4096]
ref mismatch on [20463357140992 4096] extent item 1, found 2
Incorrect global backref count on 20463357140992 found 1 wanted 2
backpointer mismatch on [20463357140992 4096]
ref mismatch on [20463357177856 4096] extent item 1, found 2
Incorrect global backref count on 20463357177856 found 1 wanted 2
backpointer mismatch on [20463357177856 4096]
ref mismatch on [20463357186048 4096] extent item 1, found 2
Incorrect global backref count on 20463357186048 found 1 wanted 2
backpointer mismatch on [20463357186048 4096]
ref mismatch on [20463385513984 4096] extent item 1, found 2
Incorrect global backref count on 20463385513984 found 1 wanted 2
backpointer mismatch on [20463385513984 4096]
ref mismatch on [20463415042048 4096] extent item 1, found 2
Incorrect global backref count on 20463415042048 found 1 wanted 2
backpointer mismatch on [20463415042048 4096]
ref mismatch on [20463415046144 4096] extent item 1, found 2
Incorrect global backref count on 20463415046144 found 1 wanted 2
backpointer mismatch on [20463415046144 4096]
ref mismatch on [20463415050240 4096] extent item 1, found 2
Incorrect global backref count on 20463415050240 found 1 wanted 2
backpointer mismatch on [20463415050240 4096]
ref mismatch on [20463415054336 4096] extent item 1, found 2
Incorrect global backref count on 20463415054336 found 1 wanted 2
backpointer mismatch on [20463415054336 4096]
ref mismatch on [20463415062528 4096] extent item 1, found 2
Incorrect global backref count on 20463415062528 found 1 wanted 2
backpointer mismatch on [20463415062528 4096]
ref mismatch on [20463415066624 4096] extent item 1, found 2
Incorrect global backref count on 20463415066624 found 1 wanted 2
backpointer mismatch on [20463415066624 4096]
ref mismatch on [20463415070720 4096] extent item 1, found 2
Incorrect global backref count on 20463415070720 found 1 wanted 2
backpointer mismatch on [20463415070720 4096]
ref mismatch on [20463415074816 4096] extent item 1, found 2
Incorrect global backref count on 20463415074816 found 1 wanted 2
backpointer mismatch on [20463415074816 4096]
ref mismatch on [20463415083008 4096] extent item 1, found 2
Incorrect global backref count on 20463415083008 found 1 wanted 2
backpointer mismatch on [20463415083008 4096]
ref mismatch on [20463415087104 4096] extent item 1, found 2
Incorrect global backref count on 20463415087104 found 1 wanted 2
backpointer mismatch on [20463415087104 4096]
ref mismatch on [20463415091200 4096] extent item 1, found 2
Incorrect global backref count on 20463415091200 found 1 wanted 2
backpointer mismatch on [20463415091200 4096]
ref mismatch on [20463415095296 4096] extent item 1, found 2
Incorrect global backref count on 20463415095296 found 1 wanted 2
backpointer mismatch on [20463415095296 4096]
ref mismatch on [20463415099392 4096] extent item 1, found 2
Incorrect global backref count on 20463415099392 found 1 wanted 2
backpointer mismatch on [20463415099392 4096]
ref mismatch on [20463415103488 4096] extent item 1, found 2
Incorrect global backref count on 20463415103488 found 1 wanted 2
backpointer mismatch on [20463415103488 4096]
ref mismatch on [20463415107584 4096] extent item 1, found 2
Incorrect global backref count on 20463415107584 found 1 wanted 2
backpointer mismatch on [20463415107584 4096]
ref mismatch on [20463415111680 4096] extent item 1, found 2
Incorrect global backref count on 20463415111680 found 1 wanted 2
backpointer mismatch on [20463415111680 4096]
ref mismatch on [20463415119872 4096] extent item 1, found 2
Incorrect global backref count on 20463415119872 found 1 wanted 2
backpointer mismatch on [20463415119872 4096]
ref mismatch on [20463415128064 4096] extent item 1, found 2
Incorrect global backref count on 20463415128064 found 1 wanted 2
backpointer mismatch on [20463415128064 4096]
ref mismatch on [20463415132160 4096] extent item 1, found 2
Incorrect global backref count on 20463415132160 found 1 wanted 2
backpointer mismatch on [20463415132160 4096]
ref mismatch on [20463415136256 4096] extent item 1, found 2
Incorrect global backref count on 20463415136256 found 1 wanted 2
backpointer mismatch on [20463415136256 4096]
ref mismatch on [20463415144448 4096] extent item 1, found 2
Incorrect global backref count on 20463415144448 found 1 wanted 2
backpointer mismatch on [20463415144448 4096]
ref mismatch on [20463415148544 4096] extent item 1, found 2
Incorrect global backref count on 20463415148544 found 1 wanted 2
backpointer mismatch on [20463415148544 4096]
ref mismatch on [20463415152640 4096] extent item 1, found 2
Incorrect global backref count on 20463415152640 found 1 wanted 2
backpointer mismatch on [20463415152640 4096]
ref mismatch on [20463415173120 4096] extent item 1, found 2
Incorrect global backref count on 20463415173120 found 1 wanted 2
backpointer mismatch on [20463415173120 4096]
ref mismatch on [20463415193600 4096] extent item 1, found 2
Incorrect global backref count on 20463415193600 found 1 wanted 2
backpointer mismatch on [20463415193600 4096]
ref mismatch on [20463459852288 4096] extent item 1, found 2
Incorrect global backref count on 20463459852288 found 1 wanted 2
backpointer mismatch on [20463459852288 4096]
ref mismatch on [20463477268480 4096] extent item 1, found 2
Incorrect global backref count on 20463477268480 found 1 wanted 2
backpointer mismatch on [20463477268480 4096]
ref mismatch on [20463504248832 4096] extent item 1, found 2
Incorrect global backref count on 20463504248832 found 1 wanted 2
backpointer mismatch on [20463504248832 4096]
ref mismatch on [20463560003584 4096] extent item 1, found 2
Incorrect global backref count on 20463560003584 found 1 wanted 2
backpointer mismatch on [20463560003584 4096]
ref mismatch on [20463705088000 4096] extent item 1, found 2
Incorrect global backref count on 20463705088000 found 1 wanted 2
backpointer mismatch on [20463705088000 4096]
ref mismatch on [20463740538880 4096] extent item 1, found 2
Incorrect global backref count on 20463740538880 found 1 wanted 2
backpointer mismatch on [20463740538880 4096]
ref mismatch on [20463815450624 4096] extent item 1, found 2
Incorrect global backref count on 20463815450624 found 1 wanted 2
backpointer mismatch on [20463815450624 4096]
ref mismatch on [20463888011264 4096] extent item 1, found 2
Incorrect global backref count on 20463888011264 found 1 wanted 2
backpointer mismatch on [20463888011264 4096]
ref mismatch on [20463971205120 4096] extent item 1, found 2
Incorrect global backref count on 20463971205120 found 1 wanted 2
backpointer mismatch on [20463971205120 4096]
ref mismatch on [20464035745792 4096] extent item 1, found 2
Incorrect global backref count on 20464035745792 found 1 wanted 2
backpointer mismatch on [20464035745792 4096]
ref mismatch on [20464037908480 4096] extent item 1, found 2
Incorrect global backref count on 20464037908480 found 1 wanted 2
backpointer mismatch on [20464037908480 4096]
ref mismatch on [20464037912576 4096] extent item 1, found 2
Incorrect global backref count on 20464037912576 found 1 wanted 2
backpointer mismatch on [20464037912576 4096]
ref mismatch on [20464037916672 4096] extent item 1, found 2
Incorrect global backref count on 20464037916672 found 1 wanted 2
backpointer mismatch on [20464037916672 4096]
ref mismatch on [20464037928960 4096] extent item 1, found 2
Incorrect global backref count on 20464037928960 found 1 wanted 2
backpointer mismatch on [20464037928960 4096]
ref mismatch on [20464037937152 4096] extent item 1, found 2
Incorrect global backref count on 20464037937152 found 1 wanted 2
backpointer mismatch on [20464037937152 4096]
ref mismatch on [20464037945344 4096] extent item 1, found 2
Incorrect global backref count on 20464037945344 found 1 wanted 2
backpointer mismatch on [20464037945344 4096]
ref mismatch on [20464059654144 4096] extent item 1, found 2
Incorrect global backref count on 20464059654144 found 1 wanted 2
backpointer mismatch on [20464059654144 4096]
ref mismatch on [20464059932672 4096] extent item 1, found 2
Incorrect global backref count on 20464059932672 found 1 wanted 2
backpointer mismatch on [20464059932672 4096]
ref mismatch on [20464059961344 4096] extent item 1, found 2
Incorrect global backref count on 20464059961344 found 1 wanted 2
backpointer mismatch on [20464059961344 4096]
ref mismatch on [20464060006400 4096] extent item 1, found 2
Incorrect global backref count on 20464060006400 found 1 wanted 2
backpointer mismatch on [20464060006400 4096]
ref mismatch on [20464060051456 4096] extent item 1, found 2
Incorrect global backref count on 20464060051456 found 1 wanted 2
backpointer mismatch on [20464060051456 4096]
ref mismatch on [20464060055552 4096] extent item 1, found 2
Incorrect global backref count on 20464060055552 found 1 wanted 2
backpointer mismatch on [20464060055552 4096]
ref mismatch on [20464060096512 4096] extent item 1, found 2
Incorrect global backref count on 20464060096512 found 1 wanted 2
backpointer mismatch on [20464060096512 4096]
ref mismatch on [20464060211200 4096] extent item 1, found 2
Incorrect global backref count on 20464060211200 found 1 wanted 2
backpointer mismatch on [20464060211200 4096]
ref mismatch on [20464066527232 4096] extent item 1, found 2
Incorrect global backref count on 20464066527232 found 1 wanted 2
backpointer mismatch on [20464066527232 4096]
ref mismatch on [20464066576384 4096] extent item 1, found 2
Incorrect global backref count on 20464066576384 found 1 wanted 2
backpointer mismatch on [20464066576384 4096]
ref mismatch on [22726506930176 4096] extent item 1, found 2
Incorrect global backref count on 22726506930176 found 1 wanted 2
backpointer mismatch on [22726506930176 4096]
ref mismatch on [22726507606016 4096] extent item 1, found 2
Incorrect global backref count on 22726507606016 found 1 wanted 2
backpointer mismatch on [22726507606016 4096]
ref mismatch on [22726525747200 4096] extent item 1, found 2
Incorrect global backref count on 22726525747200 found 1 wanted 2
backpointer mismatch on [22726525747200 4096]
ref mismatch on [22726525861888 4096] extent item 1, found 2
Incorrect global backref count on 22726525861888 found 1 wanted 2
backpointer mismatch on [22726525861888 4096]
ref mismatch on [22726584791040 4096] extent item 1, found 2
Incorrect global backref count on 22726584791040 found 1 wanted 2
backpointer mismatch on [22726584791040 4096]
ref mismatch on [22726591852544 4096] extent item 1, found 2
Incorrect global backref count on 22726591852544 found 1 wanted 2
backpointer mismatch on [22726591852544 4096]
ref mismatch on [22726721363968 4096] extent item 1, found 2
Incorrect global backref count on 22726721363968 found 1 wanted 2
backpointer mismatch on [22726721363968 4096]
ref mismatch on [22726754209792 4096] extent item 1, found 2
Incorrect global backref count on 22726754209792 found 1 wanted 2
backpointer mismatch on [22726754209792 4096]
ref mismatch on [22726850498560 4096] extent item 1, found 2
Incorrect global backref count on 22726850498560 found 1 wanted 2
backpointer mismatch on [22726850498560 4096]
ref mismatch on [22726856859648 4096] extent item 1, found 2
Incorrect global backref count on 22726856859648 found 1 wanted 2
backpointer mismatch on [22726856859648 4096]
ref mismatch on [22726918811648 4096] extent item 1, found 2
Incorrect global backref count on 22726918811648 found 1 wanted 2
backpointer mismatch on [22726918811648 4096]
ref mismatch on [22726928609280 4096] extent item 1, found 2
Incorrect global backref count on 22726928609280 found 1 wanted 2
backpointer mismatch on [22726928609280 4096]
ref mismatch on [22726929244160 4096] extent item 1, found 2
Incorrect global backref count on 22726929244160 found 1 wanted 2
backpointer mismatch on [22726929244160 4096]
ref mismatch on [22726929248256 4096] extent item 1, found 2
Incorrect global backref count on 22726929248256 found 1 wanted 2
backpointer mismatch on [22726929248256 4096]
ref mismatch on [22726929747968 4096] extent item 1, found 2
Incorrect global backref count on 22726929747968 found 1 wanted 2
backpointer mismatch on [22726929747968 4096]
ref mismatch on [22727007752192 4096] extent item 1, found 2
Incorrect global backref count on 22727007752192 found 1 wanted 2
backpointer mismatch on [22727007752192 4096]
ref mismatch on [22727046537216 4096] extent item 1, found 2
Incorrect global backref count on 22727046537216 found 1 wanted 2
backpointer mismatch on [22727046537216 4096]
ref mismatch on [22727046541312 4096] extent item 1, found 2
Incorrect global backref count on 22727046541312 found 1 wanted 2
backpointer mismatch on [22727046541312 4096]
ref mismatch on [22727047536640 4096] extent item 1, found 2
Incorrect global backref count on 22727047536640 found 1 wanted 2
backpointer mismatch on [22727047536640 4096]
ref mismatch on [22727091236864 4096] extent item 1, found 2
Incorrect global backref count on 22727091236864 found 1 wanted 2
backpointer mismatch on [22727091236864 4096]
ref mismatch on [22727104884736 4096] extent item 1, found 2
Incorrect global backref count on 22727104884736 found 1 wanted 2
backpointer mismatch on [22727104884736 4096]
ref mismatch on [22727214133248 4096] extent item 1, found 2
Incorrect global backref count on 22727214133248 found 1 wanted 2
backpointer mismatch on [22727214133248 4096]
ref mismatch on [22727229071360 4096] extent item 1, found 2
Incorrect global backref count on 22727229071360 found 1 wanted 2
backpointer mismatch on [22727229071360 4096]
ref mismatch on [22727392038912 4096] extent item 1, found 2
Incorrect global backref count on 22727392038912 found 1 wanted 2
backpointer mismatch on [22727392038912 4096]
ref mismatch on [22727394050048 4096] extent item 1, found 2
Incorrect global backref count on 22727394050048 found 1 wanted 2
backpointer mismatch on [22727394050048 4096]
ref mismatch on [22727395975168 4096] extent item 1, found 2
Incorrect global backref count on 22727395975168 found 1 wanted 2
backpointer mismatch on [22727395975168 4096]
ref mismatch on [22727395979264 4096] extent item 1, found 2
Incorrect global backref count on 22727395979264 found 1 wanted 2
backpointer mismatch on [22727395979264 4096]
ref mismatch on [22727395983360 4096] extent item 1, found 2
Incorrect global backref count on 22727395983360 found 1 wanted 2
backpointer mismatch on [22727395983360 4096]
ref mismatch on [22727395987456 4096] extent item 1, found 2
Incorrect global backref count on 22727395987456 found 1 wanted 2
backpointer mismatch on [22727395987456 4096]
ref mismatch on [22727395991552 4096] extent item 1, found 2
Incorrect global backref count on 22727395991552 found 1 wanted 2
backpointer mismatch on [22727395991552 4096]
ref mismatch on [22727395995648 4096] extent item 1, found 2
Incorrect global backref count on 22727395995648 found 1 wanted 2
backpointer mismatch on [22727395995648 4096]
ref mismatch on [22727395999744 4096] extent item 1, found 2
Incorrect global backref count on 22727395999744 found 1 wanted 2
backpointer mismatch on [22727395999744 4096]
ref mismatch on [22727397609472 4096] extent item 1, found 2
Incorrect global backref count on 22727397609472 found 1 wanted 2
backpointer mismatch on [22727397609472 4096]
ref mismatch on [22727397613568 4096] extent item 1, found 2
Incorrect global backref count on 22727397613568 found 1 wanted 2
backpointer mismatch on [22727397613568 4096]
ref mismatch on [22727397617664 4096] extent item 1, found 2
Incorrect global backref count on 22727397617664 found 1 wanted 2
backpointer mismatch on [22727397617664 4096]
ref mismatch on [22727397629952 4096] extent item 1, found 2
Incorrect global backref count on 22727397629952 found 1 wanted 2
backpointer mismatch on [22727397629952 4096]
ref mismatch on [22727397634048 4096] extent item 1, found 2
Incorrect global backref count on 22727397634048 found 1 wanted 2
backpointer mismatch on [22727397634048 4096]
ref mismatch on [22727397855232 4096] extent item 1, found 2
Incorrect global backref count on 22727397855232 found 1 wanted 2
backpointer mismatch on [22727397855232 4096]
ref mismatch on [22727397859328 4096] extent item 1, found 2
Incorrect global backref count on 22727397859328 found 1 wanted 2
backpointer mismatch on [22727397859328 4096]
ref mismatch on [22727397863424 4096] extent item 1, found 2
Incorrect global backref count on 22727397863424 found 1 wanted 2
backpointer mismatch on [22727397863424 4096]
ref mismatch on [22727397867520 4096] extent item 1, found 2
Incorrect global backref count on 22727397867520 found 1 wanted 2
backpointer mismatch on [22727397867520 4096]
ref mismatch on [22727397871616 4096] extent item 1, found 2
Incorrect global backref count on 22727397871616 found 1 wanted 2
backpointer mismatch on [22727397871616 4096]
ref mismatch on [22727399534592 4096] extent item 1, found 2
Incorrect global backref count on 22727399534592 found 1 wanted 2
backpointer mismatch on [22727399534592 4096]
ref mismatch on [22727399620608 4096] extent item 1, found 2
Incorrect global backref count on 22727399620608 found 1 wanted 2
backpointer mismatch on [22727399620608 4096]
ref mismatch on [22727493369856 4096] extent item 1, found 2
Incorrect global backref count on 22727493369856 found 1 wanted 2
backpointer mismatch on [22727493369856 4096]
ref mismatch on [22727522791424 4096] extent item 1, found 2
Incorrect global backref count on 22727522791424 found 1 wanted 2
backpointer mismatch on [22727522791424 4096]
ref mismatch on [22727522848768 4096] extent item 1, found 2
Incorrect global backref count on 22727522848768 found 1 wanted 2
backpointer mismatch on [22727522848768 4096]
ref mismatch on [22727559303168 4096] extent item 1, found 2
Incorrect global backref count on 22727559303168 found 1 wanted 2
backpointer mismatch on [22727559303168 4096]
ref mismatch on [22727642562560 4096] extent item 1, found 2
Incorrect global backref count on 22727642562560 found 1 wanted 2
backpointer mismatch on [22727642562560 4096]
ref mismatch on [22727748812800 4096] extent item 1, found 2
Incorrect global backref count on 22727748812800 found 1 wanted 2
backpointer mismatch on [22727748812800 4096]
ref mismatch on [22727767691264 4096] extent item 1, found 2
Incorrect global backref count on 22727767691264 found 1 wanted 2
backpointer mismatch on [22727767691264 4096]
ref mismatch on [22727791968256 4096] extent item 1, found 2
Incorrect global backref count on 22727791968256 found 1 wanted 2
backpointer mismatch on [22727791968256 4096]
ref mismatch on [22727828881408 4096] extent item 1, found 2
Incorrect global backref count on 22727828881408 found 1 wanted 2
backpointer mismatch on [22727828881408 4096]
ref mismatch on [22727828885504 4096] extent item 1, found 2
Incorrect global backref count on 22727828885504 found 1 wanted 2
backpointer mismatch on [22727828885504 4096]
ref mismatch on [22727828897792 4096] extent item 1, found 2
Incorrect global backref count on 22727828897792 found 1 wanted 2
backpointer mismatch on [22727828897792 4096]
ref mismatch on [22727828901888 4096] extent item 1, found 2
Incorrect global backref count on 22727828901888 found 1 wanted 2
backpointer mismatch on [22727828901888 4096]
ref mismatch on [22727828905984 4096] extent item 1, found 2
Incorrect global backref count on 22727828905984 found 1 wanted 2
backpointer mismatch on [22727828905984 4096]
ref mismatch on [22727828910080 4096] extent item 1, found 2
Incorrect global backref count on 22727828910080 found 1 wanted 2
backpointer mismatch on [22727828910080 4096]
ref mismatch on [22727828918272 4096] extent item 1, found 2
Incorrect global backref count on 22727828918272 found 1 wanted 2
backpointer mismatch on [22727828918272 4096]
ref mismatch on [22727828938752 4096] extent item 1, found 2
Incorrect global backref count on 22727828938752 found 1 wanted 2
backpointer mismatch on [22727828938752 4096]
ref mismatch on [22727869063168 4096] extent item 1, found 2
Incorrect global backref count on 22727869063168 found 1 wanted 2
backpointer mismatch on [22727869063168 4096]
ref mismatch on [22727873511424 4096] extent item 1, found 2
Incorrect global backref count on 22727873511424 found 1 wanted 2
backpointer mismatch on [22727873511424 4096]
ref mismatch on [22727923941376 4096] extent item 1, found 2
Incorrect global backref count on 22727923941376 found 1 wanted 2
backpointer mismatch on [22727923941376 4096]
ref mismatch on [22727924060160 4096] extent item 1, found 2
Incorrect global backref count on 22727924060160 found 1 wanted 2
backpointer mismatch on [22727924060160 4096]
ref mismatch on [22727924064256 4096] extent item 1, found 2
Incorrect global backref count on 22727924064256 found 1 wanted 2
backpointer mismatch on [22727924064256 4096]
ref mismatch on [22727935164416 4096] extent item 1, found 2
Incorrect global backref count on 22727935164416 found 1 wanted 2
backpointer mismatch on [22727935164416 4096]
ref mismatch on [22727969415168 4096] extent item 1, found 2
Incorrect global backref count on 22727969415168 found 1 wanted 2
backpointer mismatch on [22727969415168 4096]
ref mismatch on [22727969947648 4096] extent item 1, found 2
Incorrect global backref count on 22727969947648 found 1 wanted 2
backpointer mismatch on [22727969947648 4096]
ref mismatch on [22727970406400 4096] extent item 1, found 2
Incorrect global backref count on 22727970406400 found 1 wanted 2
backpointer mismatch on [22727970406400 4096]
ref mismatch on [22727970435072 4096] extent item 1, found 2
Incorrect global backref count on 22727970435072 found 1 wanted 2
backpointer mismatch on [22727970435072 4096]
ref mismatch on [22727972970496 4096] extent item 1, found 2
Incorrect global backref count on 22727972970496 found 1 wanted 2
backpointer mismatch on [22727972970496 4096]
ref mismatch on [22727973011456 4096] extent item 1, found 2
Incorrect global backref count on 22727973011456 found 1 wanted 2
backpointer mismatch on [22727973011456 4096]
ref mismatch on [22727973179392 4096] extent item 1, found 2
Incorrect global backref count on 22727973179392 found 1 wanted 2
backpointer mismatch on [22727973179392 4096]
ref mismatch on [22727981469696 4096] extent item 1, found 2
Incorrect global backref count on 22727981469696 found 1 wanted 2
backpointer mismatch on [22727981469696 4096]
ref mismatch on [22727981498368 4096] extent item 1, found 2
Incorrect global backref count on 22727981498368 found 1 wanted 2
backpointer mismatch on [22727981498368 4096]
ref mismatch on [22727981506560 4096] extent item 1, found 2
Incorrect global backref count on 22727981506560 found 1 wanted 2
backpointer mismatch on [22727981506560 4096]
ref mismatch on [22727985885184 4096] extent item 1, found 2
Incorrect global backref count on 22727985885184 found 1 wanted 2
backpointer mismatch on [22727985885184 4096]
ref mismatch on [22727987724288 4096] extent item 1, found 2
Incorrect global backref count on 22727987724288 found 1 wanted 2
backpointer mismatch on [22727987724288 4096]
ref mismatch on [22727988588544 4096] extent item 1, found 2
Incorrect global backref count on 22727988588544 found 1 wanted 2
backpointer mismatch on [22727988588544 4096]
ref mismatch on [22727988805632 4096] extent item 1, found 2
Incorrect global backref count on 22727988805632 found 1 wanted 2
backpointer mismatch on [22727988805632 4096]
ref mismatch on [22728059179008 4096] extent item 1, found 2
Incorrect global backref count on 22728059179008 found 1 wanted 2
backpointer mismatch on [22728059179008 4096]
ref mismatch on [22728068673536 4096] extent item 1, found 2
Incorrect global backref count on 22728068673536 found 1 wanted 2
backpointer mismatch on [22728068673536 4096]
ref mismatch on [22728068694016 4096] extent item 1, found 2
Incorrect global backref count on 22728068694016 found 1 wanted 2
backpointer mismatch on [22728068694016 4096]
ref mismatch on [22728090324992 4096] extent item 1, found 2
Incorrect global backref count on 22728090324992 found 1 wanted 2
backpointer mismatch on [22728090324992 4096]
ref mismatch on [22728091336704 4096] extent item 1, found 2
Incorrect global backref count on 22728091336704 found 1 wanted 2
backpointer mismatch on [22728091336704 4096]
ref mismatch on [22728091467776 4096] extent item 1, found 2
Incorrect global backref count on 22728091467776 found 1 wanted 2
backpointer mismatch on [22728091467776 4096]
ref mismatch on [22728091500544 4096] extent item 1, found 2
Incorrect global backref count on 22728091500544 found 1 wanted 2
backpointer mismatch on [22728091500544 4096]
ref mismatch on [22728091508736 4096] extent item 1, found 2
Incorrect global backref count on 22728091508736 found 1 wanted 2
backpointer mismatch on [22728091508736 4096]
ref mismatch on [22728091516928 4096] extent item 1, found 2
Incorrect global backref count on 22728091516928 found 1 wanted 2
backpointer mismatch on [22728091516928 4096]
ref mismatch on [22728091582464 4096] extent item 1, found 2
Incorrect global backref count on 22728091582464 found 1 wanted 2
backpointer mismatch on [22728091582464 4096]
ref mismatch on [22728092659712 4096] extent item 1, found 2
Incorrect global backref count on 22728092659712 found 1 wanted 2
backpointer mismatch on [22728092659712 4096]
ref mismatch on [22728100175872 4096] extent item 1, found 2
Incorrect global backref count on 22728100175872 found 1 wanted 2
backpointer mismatch on [22728100175872 4096]
ref mismatch on [22728201531392 4096] extent item 1, found 2
Incorrect global backref count on 22728201531392 found 1 wanted 2
backpointer mismatch on [22728201531392 4096]
ref mismatch on [22728227930112 4096] extent item 1, found 2
Incorrect global backref count on 22728227930112 found 1 wanted 2
backpointer mismatch on [22728227930112 4096]
ref mismatch on [22728237342720 4096] extent item 1, found 2
Incorrect global backref count on 22728237342720 found 1 wanted 2
backpointer mismatch on [22728237342720 4096]
ref mismatch on [22728237932544 4096] extent item 1, found 2
Incorrect global backref count on 22728237932544 found 1 wanted 2
backpointer mismatch on [22728237932544 4096]
ref mismatch on [22728325935104 4096] extent item 1, found 2
Incorrect global backref count on 22728325935104 found 1 wanted 2
backpointer mismatch on [22728325935104 4096]
ref mismatch on [22728330858496 4096] extent item 1, found 2
Incorrect global backref count on 22728330858496 found 1 wanted 2
backpointer mismatch on [22728330858496 4096]
ref mismatch on [22728335515648 4096] extent item 1, found 2
Incorrect global backref count on 22728335515648 found 1 wanted 2
backpointer mismatch on [22728335515648 4096]
ref mismatch on [22728394371072 4096] extent item 1, found 2
Incorrect global backref count on 22728394371072 found 1 wanted 2
backpointer mismatch on [22728394371072 4096]
ref mismatch on [22728394395648 4096] extent item 1, found 2
Incorrect global backref count on 22728394395648 found 1 wanted 2
backpointer mismatch on [22728394395648 4096]
ref mismatch on [22728414253056 4096] extent item 1, found 2
Incorrect global backref count on 22728414253056 found 1 wanted 2
backpointer mismatch on [22728414253056 4096]
ref mismatch on [22728433455104 4096] extent item 1, found 2
Incorrect global backref count on 22728433455104 found 1 wanted 2
backpointer mismatch on [22728433455104 4096]
ref mismatch on [22728433627136 4096] extent item 1, found 2
Incorrect global backref count on 22728433627136 found 1 wanted 2
backpointer mismatch on [22728433627136 4096]
ref mismatch on [22728434843648 4096] extent item 1, found 2
Incorrect global backref count on 22728434843648 found 1 wanted 2
backpointer mismatch on [22728434843648 4096]
ref mismatch on [22728439918592 4096] extent item 1, found 2
Incorrect global backref count on 22728439918592 found 1 wanted 2
backpointer mismatch on [22728439918592 4096]
ref mismatch on [22728458592256 4096] extent item 1, found 2
Incorrect global backref count on 22728458592256 found 1 wanted 2
backpointer mismatch on [22728458592256 4096]
ref mismatch on [22728587952128 4096] extent item 1, found 2
Incorrect global backref count on 22728587952128 found 1 wanted 2
backpointer mismatch on [22728587952128 4096]
ref mismatch on [22728591757312 4096] extent item 1, found 2
Incorrect global backref count on 22728591757312 found 1 wanted 2
backpointer mismatch on [22728591757312 4096]
ref mismatch on [22728592928768 4096] extent item 1, found 2
Incorrect global backref count on 22728592928768 found 1 wanted 2
backpointer mismatch on [22728592928768 4096]
ref mismatch on [22728593092608 4096] extent item 1, found 2
Incorrect global backref count on 22728593092608 found 1 wanted 2
backpointer mismatch on [22728593092608 4096]
ref mismatch on [22989638897664 4096] extent item 1, found 2
Incorrect global backref count on 22989638897664 found 1 wanted 2
backpointer mismatch on [22989638897664 4096]
ref mismatch on [22989638901760 4096] extent item 1, found 2
Incorrect global backref count on 22989638901760 found 1 wanted 2
backpointer mismatch on [22989638901760 4096]
ref mismatch on [22989741858816 4096] extent item 1, found 2
Incorrect global backref count on 22989741858816 found 1 wanted 2
backpointer mismatch on [22989741858816 4096]
ref mismatch on [22989777768448 4096] extent item 1, found 2
Incorrect global backref count on 22989777768448 found 1 wanted 2
backpointer mismatch on [22989777768448 4096]
ref mismatch on [22989850673152 4096] extent item 1, found 2
Incorrect global backref count on 22989850673152 found 1 wanted 2
backpointer mismatch on [22989850673152 4096]
ref mismatch on [22989850677248 4096] extent item 1, found 2
Incorrect global backref count on 22989850677248 found 1 wanted 2
backpointer mismatch on [22989850677248 4096]
ref mismatch on [22989901148160 4096] extent item 1, found 2
Incorrect global backref count on 22989901148160 found 1 wanted 2
backpointer mismatch on [22989901148160 4096]
ref mismatch on [22989923340288 4096] extent item 1, found 2
Incorrect global backref count on 22989923340288 found 1 wanted 2
backpointer mismatch on [22989923340288 4096]
ref mismatch on [22989979959296 4096] extent item 1, found 2
Incorrect global backref count on 22989979959296 found 1 wanted 2
backpointer mismatch on [22989979959296 4096]
ref mismatch on [22990049484800 4096] extent item 1, found 2
Incorrect global backref count on 22990049484800 found 1 wanted 2
backpointer mismatch on [22990049484800 4096]
ref mismatch on [22990127919104 4096] extent item 1, found 2
Incorrect global backref count on 22990127919104 found 1 wanted 2
backpointer mismatch on [22990127919104 4096]
ref mismatch on [22990169636864 4096] extent item 1, found 2
Incorrect global backref count on 22990169636864 found 1 wanted 2
backpointer mismatch on [22990169636864 4096]
ref mismatch on [22990270459904 4096] extent item 1, found 2
Incorrect global backref count on 22990270459904 found 1 wanted 2
backpointer mismatch on [22990270459904 4096]
ref mismatch on [22990383153152 4096] extent item 1, found 2
Incorrect global backref count on 22990383153152 found 1 wanted 2
backpointer mismatch on [22990383153152 4096]
ref mismatch on [22990516260864 4096] extent item 1, found 2
Incorrect global backref count on 22990516260864 found 1 wanted 2
backpointer mismatch on [22990516260864 4096]
ref mismatch on [22990549094400 4096] extent item 1, found 2
Incorrect global backref count on 22990549094400 found 1 wanted 2
backpointer mismatch on [22990549094400 4096]
ref mismatch on [22990577303552 4096] extent item 1, found 2
Incorrect global backref count on 22990577303552 found 1 wanted 2
backpointer mismatch on [22990577303552 4096]
ref mismatch on [22990577917952 4096] extent item 1, found 2
Incorrect global backref count on 22990577917952 found 1 wanted 2
backpointer mismatch on [22990577917952 4096]
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots
root 256 inode 9579 errors 100, file extent discount
root 256 inode 9580 errors 100, file extent discount
root 256 inode 14258 errors 100, file extent discount
root 256 inode 14259 errors 100, file extent discount
root 14155 inode 9579 errors 100, file extent discount
root 14155 inode 9580 errors 100, file extent discount
root 14155 inode 14258 errors 100, file extent discount
root 14155 inode 14259 errors 100, file extent discount
root 14251 inode 9579 errors 100, file extent discount
root 14251 inode 9580 errors 100, file extent discount
root 14251 inode 14258 errors 100, file extent discount
root 14251 inode 14259 errors 100, file extent discount
root 15239 inode 9579 errors 100, file extent discount
root 15239 inode 9580 errors 100, file extent discount
root 15239 inode 14258 errors 100, file extent discount
root 15239 inode 14259 errors 100, file extent discount
root 15283 inode 9579 errors 100, file extent discount
root 15283 inode 9580 errors 100, file extent discount
root 15283 inode 14258 errors 100, file extent discount
root 15283 inode 14259 errors 100, file extent discount
root 15405 inode 9579 errors 100, file extent discount
root 15405 inode 9580 errors 100, file extent discount
root 15405 inode 14258 errors 100, file extent discount
root 15405 inode 14259 errors 100, file extent discount
root 15512 inode 9579 errors 100, file extent discount
root 15512 inode 9580 errors 100, file extent discount
root 15512 inode 14258 errors 100, file extent discount
root 15512 inode 14259 errors 100, file extent discount
root 15601 inode 9579 errors 100, file extent discount
root 15601 inode 9580 errors 100, file extent discount
root 15601 inode 14258 errors 100, file extent discount
root 15601 inode 14259 errors 100, file extent discount
root 15679 inode 9579 errors 100, file extent discount
root 15679 inode 9580 errors 100, file extent discount
root 15679 inode 14258 errors 100, file extent discount
root 15679 inode 14259 errors 100, file extent discount
root 15761 inode 9579 errors 100, file extent discount
root 15761 inode 9580 errors 100, file extent discount
root 15761 inode 14258 errors 100, file extent discount
root 15761 inode 14259 errors 100, file extent discount
root 15891 inode 9579 errors 100, file extent discount
root 15891 inode 9580 errors 100, file extent discount
root 15891 inode 14258 errors 100, file extent discount
root 15891 inode 14259 errors 100, file extent discount
root 16093 inode 9579 errors 100, file extent discount
root 16093 inode 9580 errors 100, file extent discount
root 16093 inode 14258 errors 100, file extent discount
root 16093 inode 14259 errors 100, file extent discount
root 16215 inode 9579 errors 100, file extent discount
root 16215 inode 9580 errors 100, file extent discount
root 16215 inode 14258 errors 100, file extent discount
root 16215 inode 14259 errors 100, file extent discount
root 16296 inode 9579 errors 100, file extent discount
root 16296 inode 9580 errors 100, file extent discount
root 16296 inode 14258 errors 100, file extent discount
root 16296 inode 14259 errors 100, file extent discount
root 16364 inode 9579 errors 100, file extent discount
root 16364 inode 9580 errors 100, file extent discount
root 16364 inode 14258 errors 100, file extent discount
root 16364 inode 14259 errors 100, file extent discount
root 16434 inode 9579 errors 100, file extent discount
root 16434 inode 9580 errors 100, file extent discount
root 16434 inode 14258 errors 100, file extent discount
root 16434 inode 14259 errors 100, file extent discount
root 16500 inode 9579 errors 100, file extent discount
root 16500 inode 9580 errors 100, file extent discount
root 16500 inode 14258 errors 100, file extent discount
root 16500 inode 14259 errors 100, file extent discount
root 16557 inode 9579 errors 100, file extent discount
root 16557 inode 9580 errors 100, file extent discount
root 16557 inode 14258 errors 100, file extent discount
root 16557 inode 14259 errors 100, file extent discount
root 16611 inode 9579 errors 100, file extent discount
root 16611 inode 9580 errors 100, file extent discount
root 16611 inode 14258 errors 100, file extent discount
root 16611 inode 14259 errors 100, file extent discount
root 16662 inode 9579 errors 100, file extent discount
root 16662 inode 9580 errors 100, file extent discount
root 16662 inode 14258 errors 100, file extent discount
root 16662 inode 14259 errors 100, file extent discount
root 16714 inode 9579 errors 100, file extent discount
root 16714 inode 9580 errors 100, file extent discount
root 16714 inode 14258 errors 100, file extent discount
root 16714 inode 14259 errors 100, file extent discount
root 16769 inode 9579 errors 100, file extent discount
root 16769 inode 9580 errors 100, file extent discount
root 16769 inode 14258 errors 100, file extent discount
root 16769 inode 14259 errors 100, file extent discount
root 16817 inode 9579 errors 100, file extent discount
root 16817 inode 9580 errors 100, file extent discount
root 16817 inode 14258 errors 100, file extent discount
root 16817 inode 14259 errors 100, file extent discount
root 16868 inode 9579 errors 100, file extent discount
root 16868 inode 9580 errors 100, file extent discount
root 16868 inode 14258 errors 100, file extent discount
root 16868 inode 14259 errors 100, file extent discount
root 16922 inode 9579 errors 100, file extent discount
root 16922 inode 9580 errors 100, file extent discount
root 16922 inode 14258 errors 100, file extent discount
root 16922 inode 14259 errors 100, file extent discount
root 16981 inode 9579 errors 100, file extent discount
root 16981 inode 9580 errors 100, file extent discount
root 16981 inode 14258 errors 100, file extent discount
root 16981 inode 14259 errors 100, file extent discount
root 17050 inode 9579 errors 100, file extent discount
root 17050 inode 9580 errors 100, file extent discount
root 17050 inode 14258 errors 100, file extent discount
root 17050 inode 14259 errors 100, file extent discount
found 990180465844 bytes used err is 1
total csum bytes: 2488683616
total tree bytes: 2811412480
total fs tree bytes: 49156096
total extent tree bytes: 129392640
btree space waste bytes: 83287148
file data blocks allocated: 2585349308416
   referenced 2583623667712
Btrfs v3.12

