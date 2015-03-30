Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:48844 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbbC3RmW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 13:42:22 -0400
Message-ID: <55198AF9.7090403@skagestad.org>
Date: Mon, 30 Mar 2015 19:42:17 +0200
From: =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: fdmanana@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Linux 4.0.0-rc5 - [ 1851.858652] BTRFS: error (device sda1) in
 cleanup_transaction:1686: errno=-17 Object already exists
References: <550FEC73.9010507@skagestad.org>	<CAL3q7H5E3ftp+02frB2Q3N+pt-wQmLS+1TWgYobqXZg=pu0O0A@mail.gmail.com>	<55100CE5.5020602@itpas.no> <1427118454.5707.5@mail.thefacebook.com> <55101A35.6020406@skagestad.org> <55103155.3040202@skagestad.org>
In-Reply-To: <55103155.3040202@skagestad.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Just a follow up on this report.

The file system in question is a raid1 across 2x320G old Western Digital 
WD3200KS.
I janked them out of the server to run a fsck on another computer (after 
a proper shutdown).

One of the disks did not get properly detected on the secondary computer.
Hopefully the fsck of the single disk is still of some value to you.

As you can see, there are several issues with the fs.
The system has occasionally had hard reboots.

The fs does not have any real value for me. Everything worth anything is 
backed up.
I'll keep the drive around in case it's of any value for some devs.

As noted before: this (corrupted) fs only get errors when booting into 
4.0-rc5. With 4.0-rc4 or earlier it works as if nothing is wrong.

The output of btrfs check follows

--
Torbjørn


btrfs check /dev/sde1
warning, device 2 is missing
warning devid 2 not found already
Checking filesystem on /dev/sde1
UUID: 6a681300-faef-4195-a1b3-6699c7a5aa5e
checking extents
checking free space cache
Error reading 77403848704, -1
failed to load free space cache for block group 19356712960
Error reading 32565755904, -1
failed to load free space cache for block group 20430454784
Error reading 32435732480, -1
failed to load free space cache for block group 23651680256
Error reading 84039802880, -1
failed to load free space cache for block group 26872905728
Error reading 84059484160, -1
failed to load free space cache for block group 30094131200
Error reading 84058771456, -1
failed to load free space cache for block group 31167873024
Error reading 79972204544, -1
failed to load free space cache for block group 32241614848
Error reading 77436489728, -1
failed to load free space cache for block group 33315356672
Error reading 82679889920, -1
failed to load free space cache for block group 34389098496
Error reading 82680545280, -1
failed to load free space cache for block group 35462840320
Error reading 84741390336, -1
failed to load free space cache for block group 36536582144
Error reading 84741652480, -1
failed to load free space cache for block group 37610323968
Error reading 33868480512, -1
failed to load free space cache for block group 38684065792
Error reading 82676482048, -1
failed to load free space cache for block group 39757807616
Error reading 82707415040, -1
failed to load free space cache for block group 40831549440
Error reading 82711347200, -1
failed to load free space cache for block group 41905291264
Error reading 84232962048, -1
failed to load free space cache for block group 42979033088
Error reading 84232437760, -1
failed to load free space cache for block group 44052774912
Error reading 82706640896, -1
failed to load free space cache for block group 45160071168
Error reading 82698240000, -1
failed to load free space cache for block group 46233812992
Error reading 82922373120, -1
failed to load free space cache for block group 47307554816
Error reading 82698764288, -1
failed to load free space cache for block group 48381296640
Error reading 82699550720, -1
failed to load free space cache for block group 49455038464
Error reading 82922635264, -1
failed to load free space cache for block group 50528780288
Error reading 82695487488, -1
failed to load free space cache for block group 51602522112
Error reading 84738768896, -1
failed to load free space cache for block group 52676263936
Error reading 84531548160, -1
failed to load free space cache for block group 53750005760
Error reading 82701123584, -1
failed to load free space cache for block group 54823747584
Error reading 82701647872, -1
failed to load free space cache for block group 55897489408
Error reading 82702221312, -1
failed to load free space cache for block group 56971231232
Error reading 84713619456, -1
failed to load free space cache for block group 58044973056
Error reading 79986659328, -1
failed to load free space cache for block group 59118714880
Error reading 82703613952, -1
failed to load free space cache for block group 62339940352
Error reading 82703876096, -1
failed to load free space cache for block group 67708649472
Error reading 82704814080, -1
failed to load free space cache for block group 69856133120
Error reading 82701385728, -1
failed to load free space cache for block group 70929874944
Error reading 84714405888, -1
failed to load free space cache for block group 73077358592
Error reading 82705076224, -1
failed to load free space cache for block group 74151100416
Error reading 82706366464, -1
failed to load free space cache for block group 75224842240
Error reading 82923159552, -1
failed to load free space cache for block group 76298584064
Error reading 82714259456, -1
failed to load free space cache for block group 77372325888
Error reading 82708226048, -1
failed to load free space cache for block group 78446067712
Error reading 82693390336, -1
failed to load free space cache for block group 79519809536
Error reading 82945351680, -1
failed to load free space cache for block group 80593551360
Error reading 82699812864, -1
failed to load free space cache for block group 81667293184
Error reading 82633158656, -1
failed to load free space cache for block group 82741035008
Error reading 82922897408, -1
failed to load free space cache for block group 83814776832
Error reading 84204675072, -1
failed to load free space cache for block group 88109744128
Error reading 84204937216, -1
failed to load free space cache for block group 89183485952
Error reading 84531810304, -1
failed to load free space cache for block group 90257227776
Error reading 84220116992, -1
failed to load free space cache for block group 91330969600
Error reading 33929195520, -1
failed to load free space cache for block group 92404711424
Error reading 84532072448, -1
failed to load free space cache for block group 93478453248
Error reading 84051034112, -1
failed to load free space cache for block group 95625936896
Error reading 84532334592, -1
failed to load free space cache for block group 96699678720
Error reading 84689895424, -1
failed to load free space cache for block group 97773420544
Error reading 84206112768, -1
failed to load free space cache for block group 98847162368
Error reading 84546416640, -1
failed to load free space cache for block group 102068387840
Error reading 84203134976, -1
failed to load free space cache for block group 104215871488
Error reading 82711609344, -1
failed to load free space cache for block group 105289613312
Error reading 82713858048, -1
failed to load free space cache for block group 106363355136
Error reading 84686471168, -1
failed to load free space cache for block group 107437096960
Error reading 84207403008, -1
failed to load free space cache for block group 111732064256
Error reading 33932611584, -1
failed to load free space cache for block group 112805806080
Error reading 82922110976, -1
failed to load free space cache for block group 113879547904
Error reading 84547198976, -1
failed to load free space cache for block group 114953289728
Error reading 84711768064, -1
failed to load free space cache for block group 116027031552
Error reading 82993995776, -1
failed to load free space cache for block group 122469482496
Error reading 33966653440, -1
failed to load free space cache for block group 123543224320
Error reading 83973832704, -1
failed to load free space cache for block group 126764449792
Error reading 82697977856, -1
failed to load free space cache for block group 127838191616
Error reading 126775787520, -1
failed to load free space cache for block group 128911933440
Error reading 126776049664, -1
failed to load free space cache for block group 129985675264
Error reading 126776311808, -1
failed to load free space cache for block group 131059417088
Error reading 126776573952, -1
failed to load free space cache for block group 132133158912
Error reading 126776836096, -1
failed to load free space cache for block group 133206900736
Error reading 126777098240, -1
failed to load free space cache for block group 134280642560
Error reading 126777360384, -1
failed to load free space cache for block group 135354384384
Error reading 126777622528, -1
failed to load free space cache for block group 136428126208
Error reading 126777884672, -1
failed to load free space cache for block group 137501868032
Error reading 126778146816, -1
failed to load free space cache for block group 138575609856
Error reading 126778408960, -1
failed to load free space cache for block group 139649351680
Error reading 126778671104, -1
failed to load free space cache for block group 140723093504
Error reading 126778933248, -1
failed to load free space cache for block group 141796835328
Error reading 126779195392, -1
failed to load free space cache for block group 142870577152
Error reading 126779457536, -1
failed to load free space cache for block group 143944318976
Error reading 126779719680, -1
failed to load free space cache for block group 145018060800
Error reading 126779981824, -1
failed to load free space cache for block group 146091802624
Error reading 126780243968, -1
failed to load free space cache for block group 147165544448
Error reading 126780506112, -1
failed to load free space cache for block group 148239286272
Error reading 126780768256, -1
failed to load free space cache for block group 149313028096
Error reading 126781030400, -1
failed to load free space cache for block group 150386769920
Error reading 126781292544, -1
failed to load free space cache for block group 151460511744
Error reading 126781554688, -1
failed to load free space cache for block group 152534253568
Error reading 126781816832, -1
failed to load free space cache for block group 153607995392
Error reading 126782078976, -1
failed to load free space cache for block group 154681737216
Error reading 126782341120, -1
failed to load free space cache for block group 155755479040
Error reading 126782603264, -1
failed to load free space cache for block group 156829220864
Error reading 126782865408, -1
failed to load free space cache for block group 157902962688
checking fs roots
root 615 inode 11074 errors 200, dir isize wrong
root 615 inode 11094 errors 200, dir isize wrong
root 615 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 642 inode 11074 errors 200, dir isize wrong
root 642 inode 11094 errors 200, dir isize wrong
root 643 inode 11074 errors 200, dir isize wrong
root 643 inode 11094 errors 200, dir isize wrong
root 644 inode 11074 errors 200, dir isize wrong
root 644 inode 11094 errors 200, dir isize wrong
root 645 inode 11074 errors 200, dir isize wrong
root 645 inode 11094 errors 200, dir isize wrong
root 646 inode 11074 errors 200, dir isize wrong
root 646 inode 11094 errors 200, dir isize wrong
root 647 inode 11074 errors 200, dir isize wrong
root 647 inode 11094 errors 200, dir isize wrong
root 648 inode 11074 errors 200, dir isize wrong
root 648 inode 11094 errors 200, dir isize wrong
root 654 inode 11074 errors 200, dir isize wrong
root 654 inode 11094 errors 200, dir isize wrong
root 656 inode 11074 errors 200, dir isize wrong
root 656 inode 11094 errors 200, dir isize wrong
root 657 inode 11074 errors 200, dir isize wrong
root 657 inode 11094 errors 200, dir isize wrong
root 658 inode 11074 errors 200, dir isize wrong
root 658 inode 11094 errors 200, dir isize wrong
root 659 inode 11074 errors 200, dir isize wrong
root 659 inode 11094 errors 200, dir isize wrong
root 660 inode 11074 errors 200, dir isize wrong
root 660 inode 11094 errors 200, dir isize wrong
root 663 inode 11074 errors 200, dir isize wrong
root 663 inode 11094 errors 200, dir isize wrong
root 665 inode 11074 errors 200, dir isize wrong
root 665 inode 11094 errors 200, dir isize wrong
root 668 inode 11074 errors 200, dir isize wrong
root 668 inode 11094 errors 200, dir isize wrong
root 670 inode 11074 errors 200, dir isize wrong
root 670 inode 11094 errors 200, dir isize wrong
root 672 inode 11074 errors 200, dir isize wrong
root 672 inode 11094 errors 200, dir isize wrong
root 674 inode 11074 errors 200, dir isize wrong
root 674 inode 11094 errors 200, dir isize wrong
root 676 inode 11074 errors 200, dir isize wrong
root 676 inode 11094 errors 200, dir isize wrong
root 679 inode 11074 errors 200, dir isize wrong
root 679 inode 11094 errors 200, dir isize wrong
root 679 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 682 inode 11074 errors 200, dir isize wrong
root 682 inode 11094 errors 200, dir isize wrong
root 682 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 685 inode 11074 errors 200, dir isize wrong
root 685 inode 11094 errors 200, dir isize wrong
root 685 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 687 inode 11074 errors 200, dir isize wrong
root 687 inode 11094 errors 200, dir isize wrong
root 687 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 689 inode 11074 errors 200, dir isize wrong
root 689 inode 11094 errors 200, dir isize wrong
root 689 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 691 inode 11074 errors 200, dir isize wrong
root 691 inode 11094 errors 200, dir isize wrong
root 691 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 693 inode 11074 errors 200, dir isize wrong
root 693 inode 11094 errors 200, dir isize wrong
root 693 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 695 inode 11074 errors 200, dir isize wrong
root 695 inode 11094 errors 200, dir isize wrong
root 695 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 697 inode 11074 errors 200, dir isize wrong
root 697 inode 11094 errors 200, dir isize wrong
root 697 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 699 inode 11074 errors 200, dir isize wrong
root 699 inode 11094 errors 200, dir isize wrong
root 699 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 701 inode 11074 errors 200, dir isize wrong
root 701 inode 11094 errors 200, dir isize wrong
root 701 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 733 inode 11074 errors 200, dir isize wrong
root 733 inode 11094 errors 200, dir isize wrong
root 733 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 735 inode 11074 errors 200, dir isize wrong
root 735 inode 11094 errors 200, dir isize wrong
root 735 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 737 inode 11074 errors 200, dir isize wrong
root 737 inode 11094 errors 200, dir isize wrong
root 737 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 739 inode 11074 errors 200, dir isize wrong
root 739 inode 11094 errors 200, dir isize wrong
root 739 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 741 inode 11074 errors 200, dir isize wrong
root 741 inode 11094 errors 200, dir isize wrong
root 741 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 743 inode 11074 errors 200, dir isize wrong
root 743 inode 11094 errors 200, dir isize wrong
root 743 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 745 inode 11074 errors 200, dir isize wrong
root 745 inode 11094 errors 200, dir isize wrong
root 745 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 747 inode 11074 errors 200, dir isize wrong
root 747 inode 11094 errors 200, dir isize wrong
root 747 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
root 748 inode 11074 errors 200, dir isize wrong
root 748 inode 11094 errors 200, dir isize wrong
root 748 inode 5297043 errors 2000, link count wrong
     unresolved ref dir 622479 index 2 namelen 32 name 
2d65589066f4dac8c3c5d06bf096dbf6 filetype 0 errors 3, no dir item, no 
dir index
found 72661483941 bytes used err is 1
total csum bytes: 69609632
total tree bytes: 1410691072
total fs tree bytes: 1158287360
total extent tree bytes: 152211456
btree space waste bytes: 334476308
file data blocks allocated: 137857265664
  referenced 92274180096
btrfs-progs v3.19.1

