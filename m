Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pl1.haspere.com ([209.177.156.123]:55975 "EHLO pl1.haspere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbbAFPEE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 10:04:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 06 Jan 2015 09:04:03 -0600
From: Dyweni - BTRFS <Y4BwxfPC4k5h@dyweni.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, chris@colorremedies.com
Subject: Re: BTRFS: Transaction aborted (error -5)
Reply-To: Y4BwxfPC4k5h@dyweni.com
In-Reply-To: <CAJCQCtSqTzOywjiZXeSdrw2nLYzyMZBnWSMmzbtVgeZthizv4w@mail.gmail.com>
References: <4ac53d9eeb92abf031b2b68c1b130215@pl1.haspere.com>
 <CAJCQCtSqTzOywjiZXeSdrw2nLYzyMZBnWSMmzbtVgeZthizv4w@mail.gmail.com>
Message-ID: <29f367e22e5607854cc3c20730f099ac@localhost>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


> Try to mount with -o recovery with either kernel (newer is pretty much
> always better). If that doesn't work then you should try upgrading
> btrfs-progs to 3.18 (released dozens of hours ago) and run 'btrfs
> check' on the volume and report the results. I don't recommend using
> --repair option just yet.


mounting with -o recovery yields the same errors in dmesg output as 
without
the -o recovery.

This is even after upgrading the kernel to 3.18.1 and btrfs-progs to 
3.18.

BTRFS check yields this:


# btrfs check /dev/sdd1
Checking filesystem on /dev/sdd1
UUID: adad9bea-fc42-4411-bfda-345111934fda
checking extents
checksum verify failed on 588447744 found 6E0D3115 wanted F90C810B
checksum verify failed on 588447744 found 6E0D3115 wanted F90C810B
checksum verify failed on 588447744 found 24492BB3 wanted F90C810B
checksum verify failed on 588447744 found 6E0D3115 wanted F90C810B
Csum didn't match
owner ref check failed [588447744 16384]
ref mismatch on [151193784320 32768] extent item 0, found 1
Backref 151193784320 root 277 owner 36161 offset 3833856 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151193784320 root 277 owner 36161 
offset 3833856 found 1 wanted 0 back 0xad8be18
backpointer mismatch on [151193784320 32768]
ref mismatch on [151193817088 32768] extent item 0, found 1
Backref 151193817088 root 277 owner 36161 offset 3915776 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151193817088 root 277 owner 36161 
offset 3915776 found 1 wanted 0 back 0xad8bf00
backpointer mismatch on [151193817088 32768]
ref mismatch on [151193849856 180224] extent item 0, found 1
Backref 151193849856 root 277 owner 36355 offset 3112960 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151193849856 root 277 owner 36355 
offset 3112960 found 1 wanted 0 back 0xab333f0
backpointer mismatch on [151193849856 180224]
ref mismatch on [151194030080 3145728] extent item 0, found 7
Backref 151194030080 root 277 owner 36187 offset 1048576 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151194030080 root 277 owner 36187 
offset 1048576 found 7 wanted 0 back 0x9b82580
backpointer mismatch on [151194030080 3145728]
ref mismatch on [151197175808 32768] extent item 0, found 1
Backref 151197175808 root 277 owner 36361 offset 2523136 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151197175808 root 277 owner 36361 
offset 2523136 found 1 wanted 0 back 0xa0f5568
backpointer mismatch on [151197175808 32768]
ref mismatch on [151197208576 32768] extent item 0, found 1
Backref 151197208576 root 277 owner 36361 offset 2572288 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151197208576 root 277 owner 36361 
offset 2572288 found 1 wanted 0 back 0xa783490
backpointer mismatch on [151197208576 32768]
ref mismatch on [151197241344 32768] extent item 0, found 1
Backref 151197241344 root 277 owner 36361 offset 2621440 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151197241344 root 277 owner 36361 
offset 2621440 found 1 wanted 0 back 0xa4d67e8
backpointer mismatch on [151197241344 32768]
ref mismatch on [151197274112 32768] extent item 0, found 1
Backref 151197274112 root 277 owner 36361 offset 2703360 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151197274112 root 277 owner 36361 
offset 2703360 found 1 wanted 0 back 0x925de30
backpointer mismatch on [151197274112 32768]
ref mismatch on [151197306880 16384] extent item 0, found 1
Backref 151197306880 root 277 owner 36361 offset 3637248 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151197306880 root 277 owner 36361 
offset 3637248 found 1 wanted 0 back 0x916a658
backpointer mismatch on [151197306880 16384]
ref mismatch on [151197323264 983040] extent item 0, found 3
Backref 151197323264 root 277 owner 36208 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151197323264 root 277 owner 36208 
offset 0 found 3 wanted 0 back 0xb18a1e0
backpointer mismatch on [151197323264 983040]
ref mismatch on [151198306304 32768] extent item 0, found 1
Backref 151198306304 root 277 owner 36086 offset 3780608 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198306304 root 277 owner 36086 
offset 3780608 found 1 wanted 0 back 0xb30f878
backpointer mismatch on [151198306304 32768]
ref mismatch on [151198339072 98304] extent item 0, found 1
Backref 151198339072 root 277 owner 36396 offset 901120 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198339072 root 277 owner 36396 
offset 901120 found 1 wanted 0 back 0x99bfc58
backpointer mismatch on [151198339072 98304]
ref mismatch on [151198437376 16384] extent item 0, found 1
Backref 151198437376 root 277 owner 36396 offset 1015808 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198437376 root 277 owner 36396 
offset 1015808 found 1 wanted 0 back 0x99bfd40
backpointer mismatch on [151198437376 16384]
ref mismatch on [151198453760 16384] extent item 0, found 1
Backref 151198453760 root 277 owner 36396 offset 1048576 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198453760 root 277 owner 36396 
offset 1048576 found 1 wanted 0 back 0x99bfe28
backpointer mismatch on [151198453760 16384]
ref mismatch on [151198470144 114688] extent item 0, found 1
Backref 151198470144 root 277 owner 36396 offset 1081344 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198470144 root 277 owner 36396 
offset 1081344 found 1 wanted 0 back 0x99bff10
backpointer mismatch on [151198470144 114688]
ref mismatch on [151198584832 16384] extent item 0, found 1
Backref 151198584832 root 277 owner 36396 offset 1294336 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198584832 root 277 owner 36396 
offset 1294336 found 1 wanted 0 back 0x99bfff8
backpointer mismatch on [151198584832 16384]
ref mismatch on [151198601216 16384] extent item 0, found 1
Backref 151198601216 root 277 owner 36187 offset 1179648 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198601216 root 277 owner 36187 
offset 1179648 found 1 wanted 0 back 0x9b82668
backpointer mismatch on [151198601216 16384]
ref mismatch on [151198617600 16384] extent item 0, found 1
Backref 151198617600 root 277 owner 36187 offset 1638400 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198617600 root 277 owner 36187 
offset 1638400 found 1 wanted 0 back 0x9b82920
backpointer mismatch on [151198617600 16384]
ref mismatch on [151198633984 180224] extent item 0, found 1
Backref 151198633984 root 277 owner 39502 offset 81920 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198633984 root 277 owner 39502 
offset 81920 found 1 wanted 0 back 0x9c208f0
backpointer mismatch on [151198633984 180224]
ref mismatch on [151198814208 53248] extent item 0, found 4
Backref 151198814208 parent 487440384 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198814208 parent 487440384 owner 0 
offset 0 found 1 wanted 0 back 0xa67ed30
Backref 151198814208 parent 510558208 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198814208 parent 510558208 owner 0 
offset 0 found 1 wanted 0 back 0xafe7ed0
Backref 151198814208 parent 558415872 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198814208 parent 558415872 owner 0 
offset 0 found 1 wanted 0 back 0xa3c4408
Backref 151198814208 root 277 owner 41529 offset 3493888 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198814208 root 277 owner 41529 
offset 3493888 found 1 wanted 0 back 0x94adf80
backpointer mismatch on [151198814208 53248]
ref mismatch on [151198867456 16384] extent item 0, found 4
Backref 151198867456 parent 487440384 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198867456 parent 487440384 owner 0 
offset 0 found 1 wanted 0 back 0xa506050
Backref 151198867456 parent 510558208 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198867456 parent 510558208 owner 0 
offset 0 found 1 wanted 0 back 0xafe7fa8
Backref 151198867456 parent 558415872 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198867456 parent 558415872 owner 0 
offset 0 found 1 wanted 0 back 0xae64ba8
Backref 151198867456 root 277 owner 41529 offset 3584000 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198867456 root 277 owner 41529 
offset 3584000 found 1 wanted 0 back 0x95aa098
backpointer mismatch on [151198867456 16384]
ref mismatch on [151198896128 81920] extent item 0, found 1
Backref 151198896128 root 277 owner 39498 offset 819200 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198896128 root 277 owner 39498 
offset 819200 found 1 wanted 0 back 0x90ee3d8
backpointer mismatch on [151198896128 81920]
ref mismatch on [151198978048 40960] extent item 0, found 4
Backref 151198978048 parent 487440384 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198978048 parent 487440384 owner 0 
offset 0 found 1 wanted 0 back 0xa505f68
Backref 151198978048 parent 510558208 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198978048 parent 510558208 owner 0 
offset 0 found 1 wanted 0 back 0xafe7f60
Backref 151198978048 parent 558415872 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198978048 parent 558415872 owner 0 
offset 0 found 1 wanted 0 back 0xae64b60
Backref 151198978048 root 277 owner 41529 offset 3547136 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151198978048 root 277 owner 41529 
offset 3547136 found 1 wanted 0 back 0x949f190
backpointer mismatch on [151198978048 40960]
ref mismatch on [151199043584 32768] extent item 0, found 1
Backref 151199043584 root 277 owner 39429 offset 2981888 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151199043584 root 277 owner 39429 
offset 2981888 found 1 wanted 0 back 0x93109f0
backpointer mismatch on [151199043584 32768]
ref mismatch on [151199076352 16384] extent item 0, found 1
Backref 151199076352 root 277 owner 39429 offset 3375104 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151199076352 root 277 owner 39429 
offset 3375104 found 1 wanted 0 back 0x957bae0
backpointer mismatch on [151199076352 16384]
ref mismatch on [151199092736 16384] extent item 0, found 1
Backref 151199092736 root 277 owner 39444 offset 638976 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151199092736 root 277 owner 39444 
offset 638976 found 1 wanted 0 back 0x9783238
backpointer mismatch on [151199092736 16384]
ref mismatch on [151199121408 4194304] extent item 0, found 1
Backref 151199121408 root 277 owner 32024 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151199121408 root 277 owner 32024 
offset 0 found 1 wanted 0 back 0x90c4460
backpointer mismatch on [151199121408 4194304]
ref mismatch on [151203315712 4194304] extent item 0, found 1
Backref 151203315712 root 277 owner 32025 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151203315712 root 277 owner 32025 
offset 0 found 1 wanted 0 back 0x90c44a8
backpointer mismatch on [151203315712 4194304]
ref mismatch on [151207510016 4194304] extent item 0, found 1
Backref 151207510016 root 277 owner 32026 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151207510016 root 277 owner 32026 
offset 0 found 1 wanted 0 back 0x94abda8
backpointer mismatch on [151207510016 4194304]
ref mismatch on [151211704320 1540096] extent item 0, found 1
Backref 151211704320 root 277 owner 32027 offset 2654208 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151211704320 root 277 owner 32027 
offset 2654208 found 1 wanted 0 back 0x94abdf0
backpointer mismatch on [151211704320 1540096]
ref mismatch on [151213244416 4194304] extent item 0, found 33
Backref 151213244416 root 277 owner 36195 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151213244416 root 277 owner 36195 
offset 0 found 33 wanted 0 back 0x9dd6290
backpointer mismatch on [151213244416 4194304]
ref mismatch on [151217438720 704512] extent item 0, found 2
Backref 151217438720 root 277 owner 36376 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151217438720 root 277 owner 36376 
offset 0 found 2 wanted 0 back 0xa400dd8
backpointer mismatch on [151217438720 704512]
ref mismatch on [151218143232 98304] extent item 0, found 1
Backref 151218143232 root 277 owner 36187 offset 1048576 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151218143232 root 277 owner 36187 
offset 1048576 found 1 wanted 0 back 0x9b82498
backpointer mismatch on [151218143232 98304]
ref mismatch on [151218241536 16384] extent item 0, found 1
Backref 151218241536 root 277 owner 36195 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151218241536 root 277 owner 36195 
offset 0 found 1 wanted 0 back 0x9dd61a8
backpointer mismatch on [151218241536 16384]
ref mismatch on [151218270208 3571712] extent item 0, found 1
Backref 151218270208 root 277 owner 34539 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151218270208 root 277 owner 34539 
offset 0 found 1 wanted 0 back 0xa20f620
backpointer mismatch on [151218270208 3571712]
ref mismatch on [151221841920 81920] extent item 0, found 1
Backref 151221841920 root 277 owner 35699 offset 2949120 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151221841920 root 277 owner 35699 
offset 2949120 found 1 wanted 0 back 0x95f99c8
backpointer mismatch on [151221841920 81920]
ref mismatch on [151221923840 32768] extent item 0, found 1
Backref 151221923840 root 277 owner 35645 offset 3457024 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151221923840 root 277 owner 35645 
offset 3457024 found 1 wanted 0 back 0x9b0daa0
backpointer mismatch on [151221923840 32768]
ref mismatch on [151221960704 4194304] extent item 0, found 1
Backref 151221960704 root 277 owner 32035 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151221960704 root 277 owner 32035 
offset 0 found 1 wanted 0 back 0xa95f580
backpointer mismatch on [151221960704 4194304]
ref mismatch on [151226155008 4194304] extent item 0, found 33
Backref 151226155008 root 277 owner 36196 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151226155008 root 277 owner 36196 
offset 0 found 33 wanted 0 back 0x9dd8248
backpointer mismatch on [151226155008 4194304]
ref mismatch on [151230349312 4194304] extent item 0, found 9
Backref 151230349312 root 277 owner 36197 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151230349312 root 277 owner 36197 
offset 0 found 9 wanted 0 back 0xaaf2780
backpointer mismatch on [151230349312 4194304]
ref mismatch on [151234543616 16384] extent item 0, found 1
Backref 151234543616 root 277 owner 36195 offset 32768 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151234543616 root 277 owner 36195 
offset 32768 found 1 wanted 0 back 0x9dd6378
backpointer mismatch on [151234543616 16384]
ref mismatch on [151234560000 4194304] extent item 0, found 1
Backref 151234560000 root 277 owner 34542 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151234560000 root 277 owner 34542 
offset 0 found 1 wanted 0 back 0xa4e4ca0
backpointer mismatch on [151234560000 4194304]
ref mismatch on [151238754304 4194304] extent item 0, found 1
Backref 151238754304 root 277 owner 34543 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151238754304 root 277 owner 34543 
offset 0 found 1 wanted 0 back 0x967da38
backpointer mismatch on [151238754304 4194304]
ref mismatch on [151242948608 4194304] extent item 0, found 1
Backref 151242948608 root 277 owner 34544 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151242948608 root 277 owner 34544 
offset 0 found 1 wanted 0 back 0x9f41888
backpointer mismatch on [151242948608 4194304]
ref mismatch on [151247142912 4194304] extent item 0, found 1
Backref 151247142912 root 277 owner 34545 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151247142912 root 277 owner 34545 
offset 0 found 1 wanted 0 back 0xab1d5a0
backpointer mismatch on [151247142912 4194304]
ref mismatch on [151251337216 311296] extent item 0, found 1
Backref 151251337216 root 277 owner 39346 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151251337216 root 277 owner 39346 
offset 0 found 1 wanted 0 back 0xa889be0
backpointer mismatch on [151251337216 311296]
ref mismatch on [151251648512 49152] extent item 0, found 1
Backref 151251648512 root 277 owner 39488 offset 524288 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151251648512 root 277 owner 39488 
offset 524288 found 1 wanted 0 back 0xaa39008
backpointer mismatch on [151251648512 49152]
ref mismatch on [151251705856 65536] extent item 0, found 1
Backref 151251705856 root 277 owner 35701 offset 229376 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151251705856 root 277 owner 35701 
offset 229376 found 1 wanted 0 back 0xa93e940
backpointer mismatch on [151251705856 65536]
ref mismatch on [151251779584 4194304] extent item 0, found 1
Backref 151251779584 root 277 owner 32036 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151251779584 root 277 owner 32036 
offset 0 found 1 wanted 0 back 0xb2b3be8
backpointer mismatch on [151251779584 4194304]
ref mismatch on [151255973888 4194304] extent item 0, found 1
Backref 151255973888 root 277 owner 32037 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151255973888 root 277 owner 32037 
offset 0 found 1 wanted 0 back 0xa413ea0
backpointer mismatch on [151255973888 4194304]
ref mismatch on [151260168192 4194304] extent item 0, found 1
Backref 151260168192 root 277 owner 32038 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151260168192 root 277 owner 32038 
offset 0 found 1 wanted 0 back 0xa2a63c0
backpointer mismatch on [151260168192 4194304]
ref mismatch on [151264362496 4194304] extent item 0, found 1
Backref 151264362496 root 277 owner 32039 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151264362496 root 277 owner 32039 
offset 0 found 1 wanted 0 back 0x96a09b8
backpointer mismatch on [151264362496 4194304]
ref mismatch on [151268556800 4194304] extent item 0, found 1
Backref 151268556800 root 277 owner 34546 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151268556800 root 277 owner 34546 
offset 0 found 1 wanted 0 back 0x99e28c8
backpointer mismatch on [151268556800 4194304]
ref mismatch on [151272759296 4194304] extent item 0, found 1
Backref 151272759296 root 277 owner 32040 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151272759296 root 277 owner 32040 
offset 0 found 1 wanted 0 back 0x9f57cb0
backpointer mismatch on [151272759296 4194304]
ref mismatch on [151276953600 4194304] extent item 0, found 1
Backref 151276953600 root 277 owner 32041 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151276953600 root 277 owner 32041 
offset 0 found 1 wanted 0 back 0xadc69b0
backpointer mismatch on [151276953600 4194304]
ref mismatch on [151281147904 1966080] extent item 0, found 4
Backref 151281147904 root 277 owner 36213 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151281147904 root 277 owner 36213 
offset 0 found 4 wanted 0 back 0x9739f10
backpointer mismatch on [151281147904 1966080]
ref mismatch on [151283113984 2228224] extent item 0, found 6
Backref 151283113984 root 277 owner 36213 offset 1966080 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151283113984 root 277 owner 36213 
offset 1966080 found 6 wanted 0 back 0xa795710
backpointer mismatch on [151283113984 2228224]
ref mismatch on [151285350400 4194304] extent item 0, found 1
Backref 151285350400 root 277 owner 34547 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151285350400 root 277 owner 34547 
offset 0 found 1 wanted 0 back 0xa02d120
backpointer mismatch on [151285350400 4194304]
ref mismatch on [151289552896 4194304] extent item 0, found 1
Backref 151289552896 root 277 owner 32050 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151289552896 root 277 owner 32050 
offset 0 found 1 wanted 0 back 0x93309f8
backpointer mismatch on [151289552896 4194304]
ref mismatch on [151293747200 4194304] extent item 0, found 3
Backref 151293747200 root 277 owner 36221 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151293747200 root 277 owner 36221 
offset 0 found 3 wanted 0 back 0xabf6e98
backpointer mismatch on [151293747200 4194304]
ref mismatch on [151297941504 4096] extent item 0, found 4
Backref 151297941504 parent 489537536 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151297941504 parent 489537536 owner 0 
offset 0 found 1 wanted 0 back 0xb344348
Backref 151297941504 parent 531447808 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151297941504 parent 531447808 owner 0 
offset 0 found 1 wanted 0 back 0xa1b0fa0
Backref 151297941504 parent 568475648 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151297941504 parent 568475648 owner 0 
offset 0 found 1 wanted 0 back 0xa2ae548
Backref 151297941504 root 277 owner 41529 offset 1716224 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151297941504 root 277 owner 41529 
offset 1716224 found 1 wanted 0 back 0x9484610
backpointer mismatch on [151297941504 4096]
ref mismatch on [151297949696 4194304] extent item 0, found 1
Backref 151297949696 root 277 owner 32051 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151297949696 root 277 owner 32051 
offset 0 found 1 wanted 0 back 0xb069348
backpointer mismatch on [151297949696 4194304]
ref mismatch on [151302144000 4194304] extent item 0, found 5
Backref 151302144000 root 277 owner 36222 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151302144000 root 277 owner 36222 
offset 0 found 5 wanted 0 back 0xaff87b0
backpointer mismatch on [151302144000 4194304]
ref mismatch on [151306338304 4194304] extent item 0, found 3
Backref 151306338304 root 277 owner 36223 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151306338304 root 277 owner 36223 
offset 0 found 3 wanted 0 back 0x92ef1e8
backpointer mismatch on [151306338304 4194304]
ref mismatch on [151310532608 2818048] extent item 0, found 10
Backref 151310532608 root 277 owner 38278 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151310532608 root 277 owner 38278 
offset 0 found 10 wanted 0 back 0xaae0200
backpointer mismatch on [151310532608 2818048]
ref mismatch on [151313350656 90112] extent item 0, found 4
Backref 151313350656 parent 489537536 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151313350656 parent 489537536 owner 0 
offset 0 found 1 wanted 0 back 0xb344178
Backref 151313350656 parent 531447808 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151313350656 parent 531447808 owner 0 
offset 0 found 1 wanted 0 back 0x9676670
Backref 151313350656 parent 568475648 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151313350656 parent 568475648 owner 0 
offset 0 found 1 wanted 0 back 0x9ed5a10
Backref 151313350656 root 277 owner 41529 offset 1622016 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151313350656 root 277 owner 41529 
offset 1622016 found 1 wanted 0 back 0x94a30b0
backpointer mismatch on [151313350656 90112]
ref mismatch on [151313444864 98304] extent item 0, found 3
Backref 151313444864 root 277 owner 38292 offset 671744 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151313444864 root 277 owner 38292 
offset 671744 found 3 wanted 0 back 0x9899ce8
backpointer mismatch on [151313444864 98304]
ref mismatch on [151313543168 49152] extent item 0, found 1
Backref 151313543168 root 277 owner 38292 offset 983040 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151313543168 root 277 owner 38292 
offset 983040 found 1 wanted 0 back 0xaa66ea8
backpointer mismatch on [151313543168 49152]
ref mismatch on [151313592320 16384] extent item 0, found 1
Backref 151313592320 root 277 owner 38141 offset 786432 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151313592320 root 277 owner 38141 
offset 786432 found 1 wanted 0 back 0xab64720
backpointer mismatch on [151313592320 16384]
ref mismatch on [151313612800 933888] extent item 0, found 7
Backref 151313612800 root 277 owner 38281 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151313612800 root 277 owner 38281 
offset 0 found 7 wanted 0 back 0x9fec2c8
backpointer mismatch on [151313612800 933888]
ref mismatch on [151314546688 49152] extent item 0, found 1
Backref 151314546688 root 277 owner 38292 offset 1064960 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151314546688 root 277 owner 38292 
offset 1064960 found 1 wanted 0 back 0xad2fdb0
backpointer mismatch on [151314546688 49152]
ref mismatch on [151314595840 32768] extent item 0, found 1
Backref 151314595840 root 277 owner 38292 offset 1130496 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151314595840 root 277 owner 38292 
offset 1130496 found 1 wanted 0 back 0x9a82110
backpointer mismatch on [151314595840 32768]
ref mismatch on [151314628608 49152] extent item 0, found 1
Backref 151314628608 root 277 owner 38292 offset 1179648 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151314628608 root 277 owner 38292 
offset 1179648 found 1 wanted 0 back 0x91b56c0
backpointer mismatch on [151314628608 49152]
ref mismatch on [151314677760 32768] extent item 0, found 1
Backref 151314677760 root 277 owner 38292 offset 1245184 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151314677760 root 277 owner 38292 
offset 1245184 found 1 wanted 0 back 0xa5153c0
backpointer mismatch on [151314677760 32768]
ref mismatch on [151314710528 32768] extent item 0, found 1
Backref 151314710528 root 277 owner 38292 offset 1376256 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151314710528 root 277 owner 38292 
offset 1376256 found 1 wanted 0 back 0xa93e988
backpointer mismatch on [151314710528 32768]
ref mismatch on [151314743296 151552] extent item 0, found 1
Backref 151314743296 root 277 owner 36249 offset 4042752 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151314743296 root 277 owner 36249 
offset 4042752 found 1 wanted 0 back 0x91e6f08
backpointer mismatch on [151314743296 151552]
ref mismatch on [151314894848 196608] extent item 0, found 2
Backref 151314894848 root 277 owner 36237 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151314894848 root 277 owner 36237 
offset 0 found 2 wanted 0 back 0x9020908
backpointer mismatch on [151314894848 196608]
ref mismatch on [151315091456 65536] extent item 0, found 1
Backref 151315091456 root 277 owner 36237 offset 491520 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151315091456 root 277 owner 36237 
offset 491520 found 1 wanted 0 back 0x9df6298
backpointer mismatch on [151315091456 65536]
ref mismatch on [151315156992 32768] extent item 0, found 1
Backref 151315156992 root 277 owner 36187 offset 1212416 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151315156992 root 277 owner 36187 
offset 1212416 found 1 wanted 0 back 0x9b82750
backpointer mismatch on [151315156992 32768]
ref mismatch on [151315189760 49152] extent item 0, found 1
Backref 151315189760 root 277 owner 36187 offset 1294336 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151315189760 root 277 owner 36187 
offset 1294336 found 1 wanted 0 back 0x9b82838
backpointer mismatch on [151315189760 49152]
ref mismatch on [151315238912 16384] extent item 0, found 1
Backref 151315238912 root 277 owner 36195 offset 409600 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151315238912 root 277 owner 36195 
offset 409600 found 1 wanted 0 back 0x9dd6ab8
backpointer mismatch on [151315238912 16384]
ref mismatch on [151315255296 8192] extent item 0, found 1
Backref 151315255296 root 277 owner 36859 offset 4009984 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151315255296 root 277 owner 36859 
offset 4009984 found 1 wanted 0 back 0x9e1ccf8
backpointer mismatch on [151315255296 8192]
ref mismatch on [151315267584 4022272] extent item 0, found 1
Backref 151315267584 root 277 owner 34584 offset 172032 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151315267584 root 277 owner 34584 
offset 172032 found 1 wanted 0 back 0xa3eb7d8
backpointer mismatch on [151315267584 4022272]
ref mismatch on [151319298048 4194304] extent item 0, found 1
Backref 151319298048 root 277 owner 32053 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151319298048 root 277 owner 32053 
offset 0 found 1 wanted 0 back 0x92ec170
backpointer mismatch on [151319298048 4194304]
ref mismatch on [151323492352 4194304] extent item 0, found 1
Backref 151323492352 root 277 owner 32052 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151323492352 root 277 owner 32052 
offset 0 found 1 wanted 0 back 0x92e1328
backpointer mismatch on [151323492352 4194304]
ref mismatch on [151327686656 4194304] extent item 0, found 1
Backref 151327686656 root 277 owner 32054 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151327686656 root 277 owner 32054 
offset 0 found 1 wanted 0 back 0x9072680
backpointer mismatch on [151327686656 4194304]
ref mismatch on [151331880960 4194304] extent item 0, found 1
Backref 151331880960 root 277 owner 32055 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151331880960 root 277 owner 32055 
offset 0 found 1 wanted 0 back 0x9078560
backpointer mismatch on [151331880960 4194304]
ref mismatch on [151336075264 4194304] extent item 0, found 1
Backref 151336075264 root 277 owner 34554 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151336075264 root 277 owner 34554 
offset 0 found 1 wanted 0 back 0x9d14b38
backpointer mismatch on [151336075264 4194304]
ref mismatch on [151340277760 4194304] extent item 0, found 1
Backref 151340277760 root 277 owner 32056 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151340277760 root 277 owner 32056 
offset 0 found 1 wanted 0 back 0xad266a0
backpointer mismatch on [151340277760 4194304]
ref mismatch on [151344472064 4194304] extent item 0, found 1
Backref 151344472064 root 277 owner 34555 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151344472064 root 277 owner 34555 
offset 0 found 1 wanted 0 back 0x9b01820
backpointer mismatch on [151344472064 4194304]
ref mismatch on [151348674560 4194304] extent item 0, found 1
Backref 151348674560 root 277 owner 32065 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151348674560 root 277 owner 32065 
offset 0 found 1 wanted 0 back 0xa801938
backpointer mismatch on [151348674560 4194304]
ref mismatch on [151352868864 4194304] extent item 0, found 2
Backref 151352868864 root 277 owner 36237 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151352868864 root 277 owner 36237 
offset 0 found 2 wanted 0 back 0xa4994b0
backpointer mismatch on [151352868864 4194304]
ref mismatch on [151357063168 2228224] extent item 0, found 1
Backref 151357063168 root 277 owner 36238 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151357063168 root 277 owner 36238 
offset 0 found 1 wanted 0 back 0xabb7b48
backpointer mismatch on [151357063168 2228224]
ref mismatch on [151359291392 4194304] extent item 0, found 9
Backref 151359291392 root 277 owner 38292 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151359291392 root 277 owner 38292 
offset 0 found 9 wanted 0 back 0x9bb46e8
backpointer mismatch on [151359291392 4194304]
ref mismatch on [151363485696 98304] extent item 0, found 1
Backref 151363485696 root 277 owner 38298 offset 589824 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363485696 root 277 owner 38298 
offset 589824 found 1 wanted 0 back 0x9902320
backpointer mismatch on [151363485696 98304]
ref mismatch on [151363584000 32768] extent item 0, found 1
Backref 151363584000 root 277 owner 38298 offset 704512 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363584000 root 277 owner 38298 
offset 704512 found 1 wanted 0 back 0x9902408
backpointer mismatch on [151363584000 32768]
ref mismatch on [151363616768 98304] extent item 0, found 1
Backref 151363616768 root 277 owner 38038 offset 589824 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363616768 root 277 owner 38038 
offset 589824 found 1 wanted 0 back 0x8fac4b8
backpointer mismatch on [151363616768 98304]
ref mismatch on [151363715072 32768] extent item 0, found 1
Backref 151363715072 root 277 owner 38038 offset 704512 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363715072 root 277 owner 38038 
offset 704512 found 1 wanted 0 back 0xb0a7cd8
backpointer mismatch on [151363715072 32768]
ref mismatch on [151363747840 45056] extent item 0, found 1
Backref 151363747840 root 277 owner 38165 offset 4030464 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363747840 root 277 owner 38165 
offset 4030464 found 1 wanted 0 back 0xaed2600
backpointer mismatch on [151363747840 45056]
ref mismatch on [151363792896 32768] extent item 0, found 1
Backref 151363792896 root 277 owner 38141 offset 1212416 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363792896 root 277 owner 38141 
offset 1212416 found 1 wanted 0 back 0xac24c08
backpointer mismatch on [151363792896 32768]
ref mismatch on [151363825664 32768] extent item 0, found 1
Backref 151363825664 root 277 owner 38141 offset 1261568 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363825664 root 277 owner 38141 
offset 1261568 found 1 wanted 0 back 0x90f41f8
backpointer mismatch on [151363825664 32768]
ref mismatch on [151363858432 16384] extent item 0, found 1
Backref 151363858432 root 277 owner 38141 offset 1310720 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363858432 root 277 owner 38141 
offset 1310720 found 1 wanted 0 back 0xa65be18
backpointer mismatch on [151363858432 16384]
ref mismatch on [151363874816 16384] extent item 0, found 1
Backref 151363874816 root 277 owner 38141 offset 1343488 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363874816 root 277 owner 38141 
offset 1343488 found 1 wanted 0 back 0xa4845a8
backpointer mismatch on [151363874816 16384]
ref mismatch on [151363891200 49152] extent item 0, found 1
Backref 151363891200 root 277 owner 38141 offset 1376256 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363891200 root 277 owner 38141 
offset 1376256 found 1 wanted 0 back 0xa5b3f10
backpointer mismatch on [151363891200 49152]
ref mismatch on [151363940352 49152] extent item 0, found 1
Backref 151363940352 root 277 owner 38141 offset 1458176 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363940352 root 277 owner 38141 
offset 1458176 found 1 wanted 0 back 0x92f53e8
backpointer mismatch on [151363940352 49152]
ref mismatch on [151363989504 32768] extent item 0, found 1
Backref 151363989504 root 277 owner 38141 offset 1523712 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151363989504 root 277 owner 38141 
offset 1523712 found 1 wanted 0 back 0x94dacb8
backpointer mismatch on [151363989504 32768]
ref mismatch on [151364022272 16384] extent item 0, found 1
Backref 151364022272 root 277 owner 38141 offset 1572864 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151364022272 root 277 owner 38141 
offset 1572864 found 1 wanted 0 back 0xa9337d8
backpointer mismatch on [151364022272 16384]
ref mismatch on [151364038656 12288] extent item 0, found 1
Backref 151364038656 root 277 owner 38165 offset 3936256 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151364038656 root 277 owner 38165 
offset 3936256 found 1 wanted 0 back 0x93548c8
backpointer mismatch on [151364038656 12288]
ref mismatch on [151364050944 405504] extent item 0, found 2
Backref 151364050944 root 277 owner 36859 offset 3723264 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151364050944 root 277 owner 36859 
offset 3723264 found 2 wanted 0 back 0xb33f640
backpointer mismatch on [151364050944 405504]
ref mismatch on [151364456448 65536] extent item 0, found 1
Backref 151364456448 root 277 owner 36859 offset 4128768 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151364456448 root 277 owner 36859 
offset 4128768 found 1 wanted 0 back 0x9e22df0
backpointer mismatch on [151364456448 65536]
ref mismatch on [151364521984 294912] extent item 0, found 3
Backref 151364521984 root 277 owner 36972 offset 327680 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151364521984 root 277 owner 36972 
offset 327680 found 3 wanted 0 back 0x9bfd1a0
backpointer mismatch on [151364521984 294912]
ref mismatch on [151364816896 311296] extent item 0, found 2
Backref 151364816896 root 277 owner 36972 offset 671744 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151364816896 root 277 owner 36972 
offset 671744 found 2 wanted 0 back 0xa0c6c88
backpointer mismatch on [151364816896 311296]
ref mismatch on [151365136384 32768] extent item 0, found 1
Backref 151365136384 root 277 owner 36250 offset 98304 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365136384 root 277 owner 36250 
offset 98304 found 1 wanted 0 back 0xa07a250
backpointer mismatch on [151365136384 32768]
ref mismatch on [151365169152 32768] extent item 0, found 1
Backref 151365169152 root 277 owner 36446 offset 65536 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365169152 root 277 owner 36446 
offset 65536 found 1 wanted 0 back 0xa8f0bd8
backpointer mismatch on [151365169152 32768]
ref mismatch on [151365201920 16384] extent item 0, found 1
Backref 151365201920 root 277 owner 36446 offset 131072 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365201920 root 277 owner 36446 
offset 131072 found 1 wanted 0 back 0xaed0f10
backpointer mismatch on [151365201920 16384]
ref mismatch on [151365218304 16384] extent item 0, found 1
Backref 151365218304 root 277 owner 36250 offset 1490944 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365218304 root 277 owner 36250 
offset 1490944 found 1 wanted 0 back 0x9474a30
backpointer mismatch on [151365218304 16384]
ref mismatch on [151365234688 16384] extent item 0, found 1
Backref 151365234688 root 277 owner 36250 offset 1785856 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365234688 root 277 owner 36250 
offset 1785856 found 1 wanted 0 back 0xa8ca350
backpointer mismatch on [151365234688 16384]
ref mismatch on [151365251072 131072] extent item 0, found 1
Backref 151365251072 root 277 owner 36250 offset 2015232 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365251072 root 277 owner 36250 
offset 2015232 found 1 wanted 0 back 0xad573b0
backpointer mismatch on [151365251072 131072]
ref mismatch on [151365382144 16384] extent item 0, found 1
Backref 151365382144 root 277 owner 36250 offset 2736128 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365382144 root 277 owner 36250 
offset 2736128 found 1 wanted 0 back 0x9838898
backpointer mismatch on [151365382144 16384]
ref mismatch on [151365398528 32768] extent item 0, found 1
Backref 151365398528 root 277 owner 36187 offset 1769472 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365398528 root 277 owner 36187 
offset 1769472 found 1 wanted 0 back 0x9b82a08
backpointer mismatch on [151365398528 32768]
ref mismatch on [151365431296 32768] extent item 0, found 1
Backref 151365431296 root 277 owner 36187 offset 2244608 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365431296 root 277 owner 36187 
offset 2244608 found 1 wanted 0 back 0x9b82af0
backpointer mismatch on [151365431296 32768]
ref mismatch on [151365464064 12288] extent item 0, found 4
Backref 151365464064 parent 489537536 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365464064 parent 489537536 owner 0 
offset 0 found 1 wanted 0 back 0xb344260
Backref 151365464064 parent 531447808 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365464064 parent 531447808 owner 0 
offset 0 found 1 wanted 0 back 0xa1b0f58
Backref 151365464064 parent 568475648 owner 0 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365464064 parent 568475648 owner 0 
offset 0 found 1 wanted 0 back 0xa2ae500
Backref 151365464064 root 277 owner 41529 offset 1708032 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151365464064 root 277 owner 41529 
offset 1708032 found 1 wanted 0 back 0x94845c8
backpointer mismatch on [151365464064 12288]
ref mismatch on [151365476352 4194304] extent item 0, found 1
Backref 151365476352 root 277 owner 32064 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151365476352 root 277 owner 32064 
offset 0 found 1 wanted 0 back 0x91c1888
backpointer mismatch on [151365476352 4194304]
ref mismatch on [151369670656 167936] extent item 0, found 1
Backref 151369670656 root 277 owner 38299 offset 1437696 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151369670656 root 277 owner 38299 
offset 1437696 found 1 wanted 0 back 0x99039c8
backpointer mismatch on [151369670656 167936]
ref mismatch on [151369838592 81920] extent item 0, found 1
Backref 151369838592 root 277 owner 38306 offset 229376 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151369838592 root 277 owner 38306 
offset 229376 found 1 wanted 0 back 0x91a5008
backpointer mismatch on [151369838592 81920]
ref mismatch on [151369920512 32768] extent item 0, found 1
Backref 151369920512 root 277 owner 38362 offset 3325952 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151369920512 root 277 owner 38362 
offset 3325952 found 1 wanted 0 back 0x973aad8
backpointer mismatch on [151369920512 32768]
ref mismatch on [151369965568 65536] extent item 0, found 1
Backref 151369965568 root 277 owner 38163 offset 1474560 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151369965568 root 277 owner 38163 
offset 1474560 found 1 wanted 0 back 0xb321a78
backpointer mismatch on [151369965568 65536]
ref mismatch on [151370031104 49152] extent item 0, found 1
Backref 151370031104 root 277 owner 38163 offset 1753088 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370031104 root 277 owner 38163 
offset 1753088 found 1 wanted 0 back 0xb321b60
backpointer mismatch on [151370031104 49152]
ref mismatch on [151370080256 16384] extent item 0, found 1
Backref 151370080256 root 277 owner 38163 offset 1933312 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370080256 root 277 owner 38163 
offset 1933312 found 1 wanted 0 back 0xa6fdba0
backpointer mismatch on [151370080256 16384]
ref mismatch on [151370096640 16384] extent item 0, found 1
Backref 151370096640 root 277 owner 38163 offset 2031616 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370096640 root 277 owner 38163 
offset 2031616 found 1 wanted 0 back 0xa6fdc88
backpointer mismatch on [151370096640 16384]
ref mismatch on [151370113024 16384] extent item 0, found 1
Backref 151370113024 root 277 owner 38163 offset 2195456 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370113024 root 277 owner 38163 
offset 2195456 found 1 wanted 0 back 0xb345040
backpointer mismatch on [151370113024 16384]
ref mismatch on [151370129408 32768] extent item 0, found 1
Backref 151370129408 root 277 owner 38163 offset 3457024 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370129408 root 277 owner 38163 
offset 3457024 found 1 wanted 0 back 0xb345128
backpointer mismatch on [151370129408 32768]
ref mismatch on [151370162176 16384] extent item 0, found 1
Backref 151370162176 root 277 owner 38163 offset 3506176 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370162176 root 277 owner 38163 
offset 3506176 found 1 wanted 0 back 0xa5fe538
backpointer mismatch on [151370162176 16384]
ref mismatch on [151370178560 65536] extent item 0, found 1
Backref 151370178560 root 277 owner 38377 offset 1605632 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370178560 root 277 owner 38377 
offset 1605632 found 1 wanted 0 back 0x92d9490
backpointer mismatch on [151370178560 65536]
ref mismatch on [151370244096 98304] extent item 0, found 1
Backref 151370244096 root 277 owner 38377 offset 1769472 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370244096 root 277 owner 38377 
offset 1769472 found 1 wanted 0 back 0x94891e8
backpointer mismatch on [151370244096 98304]
ref mismatch on [151370342400 32768] extent item 0, found 1
Backref 151370342400 root 277 owner 38377 offset 1900544 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370342400 root 277 owner 38377 
offset 1900544 found 1 wanted 0 back 0x949b038
backpointer mismatch on [151370342400 32768]
ref mismatch on [151370375168 32768] extent item 0, found 1
Backref 151370375168 root 277 owner 38377 offset 2277376 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370375168 root 277 owner 38377 
offset 2277376 found 1 wanted 0 back 0xa677248
backpointer mismatch on [151370375168 32768]
ref mismatch on [151370407936 81920] extent item 0, found 1
Backref 151370407936 root 277 owner 38386 offset 950272 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370407936 root 277 owner 38386 
offset 950272 found 1 wanted 0 back 0xad55d60
backpointer mismatch on [151370407936 81920]
ref mismatch on [151370489856 32768] extent item 0, found 1
Backref 151370489856 root 277 owner 38386 offset 1196032 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370489856 root 277 owner 38386 
offset 1196032 found 1 wanted 0 back 0xa8d9a60
backpointer mismatch on [151370489856 32768]
ref mismatch on [151370522624 32768] extent item 0, found 1
Backref 151370522624 root 277 owner 38386 offset 1540096 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370522624 root 277 owner 38386 
offset 1540096 found 1 wanted 0 back 0xa8d9ee8
backpointer mismatch on [151370522624 32768]
ref mismatch on [151370555392 32768] extent item 0, found 1
Backref 151370555392 root 277 owner 38386 offset 1654784 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370555392 root 277 owner 38386 
offset 1654784 found 1 wanted 0 back 0xa9cc850
backpointer mismatch on [151370555392 32768]
ref mismatch on [151370588160 49152] extent item 0, found 1
Backref 151370588160 root 277 owner 38386 offset 1703936 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370588160 root 277 owner 38386 
offset 1703936 found 1 wanted 0 back 0xa9cc938
backpointer mismatch on [151370588160 49152]
ref mismatch on [151370637312 49152] extent item 0, found 1
Backref 151370637312 root 277 owner 38386 offset 1785856 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370637312 root 277 owner 38386 
offset 1785856 found 1 wanted 0 back 0xad56100
backpointer mismatch on [151370637312 49152]
ref mismatch on [151370686464 32768] extent item 0, found 1
Backref 151370686464 root 277 owner 38383 offset 2965504 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370686464 root 277 owner 38383 
offset 2965504 found 1 wanted 0 back 0x9a5dcc8
backpointer mismatch on [151370686464 32768]
ref mismatch on [151370719232 32768] extent item 0, found 1
Backref 151370719232 root 277 owner 38383 offset 3014656 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370719232 root 277 owner 38383 
offset 3014656 found 1 wanted 0 back 0xa9cbf40
backpointer mismatch on [151370719232 32768]
ref mismatch on [151370752000 81920] extent item 0, found 1
Backref 151370752000 root 277 owner 38387 offset 950272 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370752000 root 277 owner 38387 
offset 950272 found 1 wanted 0 back 0xad56840
backpointer mismatch on [151370752000 81920]
ref mismatch on [151370833920 32768] extent item 0, found 1
Backref 151370833920 root 277 owner 38387 offset 1196032 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370833920 root 277 owner 38387 
offset 1196032 found 1 wanted 0 back 0xa8d4d58
backpointer mismatch on [151370833920 32768]
ref mismatch on [151370866688 32768] extent item 0, found 1
Backref 151370866688 root 277 owner 38387 offset 1540096 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370866688 root 277 owner 38387 
offset 1540096 found 1 wanted 0 back 0xaddcb10
backpointer mismatch on [151370866688 32768]
ref mismatch on [151370899456 32768] extent item 0, found 1
Backref 151370899456 root 277 owner 38387 offset 1654784 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370899456 root 277 owner 38387 
offset 1654784 found 1 wanted 0 back 0xaaa6180
backpointer mismatch on [151370899456 32768]
ref mismatch on [151370932224 24576] extent item 0, found 1
Backref 151370932224 root 277 owner 38165 offset 3186688 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370932224 root 277 owner 38165 
offset 3186688 found 1 wanted 0 back 0x9d48648
backpointer mismatch on [151370932224 24576]
ref mismatch on [151370956800 16384] extent item 0, found 1
Backref 151370956800 root 277 owner 38124 offset 4177920 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370956800 root 277 owner 38124 
offset 4177920 found 1 wanted 0 back 0x92872e0
backpointer mismatch on [151370956800 16384]
ref mismatch on [151370981376 16384] extent item 0, found 1
Backref 151370981376 root 277 owner 38141 offset 1605632 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370981376 root 277 owner 38141 
offset 1605632 found 1 wanted 0 back 0x968f768
backpointer mismatch on [151370981376 16384]
ref mismatch on [151370997760 16384] extent item 0, found 1
Backref 151370997760 root 277 owner 38141 offset 1638400 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151370997760 root 277 owner 38141 
offset 1638400 found 1 wanted 0 back 0x9957e48
backpointer mismatch on [151370997760 16384]
ref mismatch on [151371014144 32768] extent item 0, found 1
Backref 151371014144 root 277 owner 38141 offset 1671168 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371014144 root 277 owner 38141 
offset 1671168 found 1 wanted 0 back 0x9408878
backpointer mismatch on [151371014144 32768]
ref mismatch on [151371046912 49152] extent item 0, found 1
Backref 151371046912 root 277 owner 38141 offset 1720320 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371046912 root 277 owner 38141 
offset 1720320 found 1 wanted 0 back 0x9ca09f8
backpointer mismatch on [151371046912 49152]
ref mismatch on [151371096064 16384] extent item 0, found 1
Backref 151371096064 root 277 owner 38141 offset 2211840 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371096064 root 277 owner 38141 
offset 2211840 found 1 wanted 0 back 0xad785c8
backpointer mismatch on [151371096064 16384]
ref mismatch on [151371112448 32768] extent item 0, found 1
Backref 151371112448 root 277 owner 38141 offset 2408448 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371112448 root 277 owner 38141 
offset 2408448 found 1 wanted 0 back 0x94caaa8
backpointer mismatch on [151371112448 32768]
ref mismatch on [151371145216 32768] extent item 0, found 1
Backref 151371145216 root 277 owner 38389 offset 2588672 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371145216 root 277 owner 38389 
offset 2588672 found 1 wanted 0 back 0x9a46898
backpointer mismatch on [151371145216 32768]
ref mismatch on [151371177984 16384] extent item 0, found 1
Backref 151371177984 root 277 owner 38141 offset 2719744 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371177984 root 277 owner 38141 
offset 2719744 found 1 wanted 0 back 0x9c98c48
backpointer mismatch on [151371177984 16384]
ref mismatch on [151371194368 16384] extent item 0, found 1
Backref 151371194368 root 277 owner 38141 offset 3276800 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371194368 root 277 owner 38141 
offset 3276800 found 1 wanted 0 back 0x9090dc8
backpointer mismatch on [151371194368 16384]
ref mismatch on [151371210752 16384] extent item 0, found 1
Backref 151371210752 root 277 owner 38141 offset 3932160 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371210752 root 277 owner 38141 
offset 3932160 found 1 wanted 0 back 0xaa97338
backpointer mismatch on [151371210752 16384]
ref mismatch on [151371227136 16384] extent item 0, found 1
Backref 151371227136 root 277 owner 38142 offset 786432 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371227136 root 277 owner 38142 
offset 786432 found 1 wanted 0 back 0xafa77c8
backpointer mismatch on [151371227136 16384]
ref mismatch on [151371243520 49152] extent item 0, found 1
Backref 151371243520 root 277 owner 38142 offset 147456 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371243520 root 277 owner 38142 
offset 147456 found 1 wanted 0 back 0x9dd2b48
backpointer mismatch on [151371243520 49152]
ref mismatch on [151371292672 16384] extent item 0, found 1
Backref 151371292672 root 277 owner 38181 offset 0 num_refs 0 not found 
in extent tree
Incorrect local backref count on 151371292672 root 277 owner 38181 
offset 0 found 1 wanted 0 back 0xb4346c8
backpointer mismatch on [151371292672 16384]
ref mismatch on [151371309056 65536] extent item 0, found 1
Backref 151371309056 root 277 owner 38181 offset 32768 num_refs 0 not 
found in extent tree
Incorrect local backref count on 151371309056 root 277 owner 38181 
offset 32768 found 1 wanted 0 back 0xa88ec40
backpointer mismatch on [151371309056 65536]
Errors found in extent allocation tree or chunk allocation
checksum verify failed on 588447744 found 6E0D3115 wanted F90C810B
checksum verify failed on 588447744 found 6E0D3115 wanted F90C810B
checksum verify failed on 588447744 found 24492BB3 wanted F90C810B
checksum verify failed on 588447744 found 6E0D3115 wanted F90C810B
Csum didn't match




