Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51514 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab2HZF1Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Aug 2012 01:27:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1T5VNR-00086I-Qx
	for linux-btrfs@vger.kernel.org; Sun, 26 Aug 2012 07:27:13 +0200
Received: from p4fe47dd4.dip.t-dialin.net ([79.228.125.212])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Aug 2012 07:27:13 +0200
Received: from ml by p4fe47dd4.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Aug 2012 07:27:13 +0200
To: linux-btrfs@vger.kernel.org
From: Alfred Zastrow <ml@zastrow4u.de>
Subject: Re: BTRFS filesystem is not mountable after crash
Date: Sun, 26 Aug 2012 07:27:02 +0200
Message-ID: <k1cc36$tj$1@ger.gmane.org>
References: <k0ub0m$pvp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <k0ub0m$pvp$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 20.08.2012 23:42, schrieb Alfred Zastrow:
> Hi devs,
>
> I've a serious problem with my 160 gb SSD which is not mountable
> anymore. A backup for most of the date is there, but not for the latest
> ones.  :-(
> The crash occurred during a download (system hangs totaly, hard reset)
> with a Fedora 3.5.2 linux kernel. The btrfs partition was working quite
> good for about one year.
>
> here is a try to attach the device and mount manually:
> -----------------------------------------------------
> [ 3123.582387] sd 1:0:0:0: Attached scsi generic sg2 type 0
> [ 3123.582833]  sdb: sdb1
> [ 3123.583085] sd 1:0:0:0: [sdb] Attached SCSI disk
> [ 3169.789800] Btrfs loaded
> [ 3169.791156] device fsid 4d00f0e6-e9d7-42d9-8514-827d8f01f7d3 devid 1
> transid 192331 /dev/sdb1
> [ 3169.796334] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt
> 16, gen 0
> [ 3169.840296] Btrfs detected SSD devices, enabling SSD mode
> [ 3169.841541] btrfs bad tree block start 0 29450240
> [ 3169.841545] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt
> 17, gen 0
> [ 3169.841605] btrfs bad tree block start 0 29450240
> [ 3169.841609] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt
> 18, gen 0
> [ 3123.582387] sd 1:0:0:0: Attached scsi generic sg2 type 0
> [ 3123.582833]  sdb: sdb1
> [ 3123.583085] sd 1:0:0:0: [sdb] Attached SCSI disk
> [ 3169.789800] Btrfs loaded
> [ 3169.791156] device fsid 4d00f0e6-e9d7-42d9-8514-827d8f01f7d3 devid 1
> transid 192331 /dev/sdb1
> [ 3169.796334] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt
> 16, gen 0
> [ 3169.840296] Btrfs detected SSD devices, enabling SSD mode
> [ 3169.841541] btrfs bad tree block start 0 29450240
> [ 3169.841545] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt
> 17, gen 0
> [ 3169.841605] btrfs bad tree block start 0 29450240
> [ 3169.841609] btrfs: bdev /dev/sdb1 errs: wr 0, rd 0, flush 0, corrupt
> 18, gen 0
>
>
> the latest btrfs-restore from Chris' GIT (same result with Josefs restore
> ----------------------------------
> [root@z2 btrfs-progs-chris]# ./btrfs-restore -i /dev/sdb1 /mnt
> Root objectid is 5
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> read block failed check_tree_block
> Error searching -5
>
>
>
>
> btrfsck (latest from Chris) shows a lot of these mismatches and crashes
> at the end  :-(
> -----------------------------------------------------------
> [...]
> backpointer mismatch on [152106881024 12288]
> owner ref check failed [152106881024 12288]
> ref mismatch on [152106893312 12288] extent item 1, found 0
> Incorrect local backref count on 152106893312 root 5 owner 267 offset
> 34226176 found 0 wanted 1 back 0x57024e0
> backpointer mismatch on [152106893312 12288]
> owner ref check failed [152106893312 12288]
> ref mismatch on [152106905600 12288] extent item 1, found 0
> Incorrect local backref count on 152106905600 root 5 owner 267 offset
> 34623488 found 0 wanted 1 back 0x57025c0
> backpointer mismatch on [152106905600 12288]
> owner ref check failed [152106905600 12288]
> ref mismatch on [152106917888 12288] extent item 1, found 0
> Incorrect local backref count on 152106917888 root 5 owner 267 offset
> 34672640 found 0 wanted 1 back 0x57026a0
> backpointer mismatch on [152106917888 12288]
> owner ref check failed [152106917888 12288]
> ref mismatch on [152106930176 16384] extent item 1, found 0
> Incorrect local backref count on 152106930176 root 5 owner 267 offset
> 34734080 found 0 wanted 1 back 0x5702780
> backpointer mismatch on [152106930176 16384]
> owner ref check failed [152106930176 16384]
> ref mismatch on [152106946560 24576] extent item 1, found 0
> Incorrect local backref count on 152106946560 root 5 owner 267 offset
> 36159488 found 0 wanted 1 back 0x5702860
> backpointer mismatch on [152106946560 24576]
> owner ref check failed [152106946560 24576]
> ref mismatch on [152106971136 28672] extent item 1, found 0
> Incorrect local backref count on 152106971136 root 5 owner 267 offset
> 37212160 found 0 wanted 1 back 0x5702940
> backpointer mismatch on [152106971136 28672]
> owner ref check failed [152106971136 28672]
> ref mismatch on [152106999808 12288] extent item 1, found 0
> Incorrect local backref count on 152106999808 root 5 owner 267 offset
> 37679104 found 0 wanted 1 back 0x5702a20
> backpointer mismatch on [152106999808 12288]
> owner ref check failed [152106999808 12288]
> ref mismatch on [152107012096 8192] extent item 1, found 0
> Incorrect local backref count on 152107012096 root 5 owner 267 offset
> 37707776 found 0 wanted 1 back 0x5702b00
> backpointer mismatch on [152107012096 8192]
> owner ref check failed [152107012096 8192]
> ref mismatch on [152107020288 36864] extent item 1, found 0
> Incorrect local backref count on 152107020288 root 5 owner 267 offset
> 37777408 found 0 wanted 1 back 0x5702be0
> backpointer mismatch on [152107020288 36864]
> owner ref check failed [152107020288 36864]
> ref mismatch on [152107057152 24576] extent item 1, found 0
> Incorrect local backref count on 152107057152 root 5 owner 267 offset
> 38776832 found 0 wanted 1 back 0x5702cc0
> backpointer mismatch on [152107057152 24576]
> owner ref check failed [152107057152 24576]
> ref mismatch on [152107081728 8192] extent item 1, found 0
> Incorrect local backref count on 152107081728 root 5 owner 267 offset
> 39444480 found 0 wanted 1 back 0x5702da0
> backpointer mismatch on [152107081728 8192]
> owner ref check failed [152107081728 8192]
> ref mismatch on [152107089920 16384] extent item 1, found 0
> Incorrect local backref count on 152107089920 root 5 owner 267 offset
> 39817216 found 0 wanted 1 back 0x5702e80
> backpointer mismatch on [152107089920 16384]
> owner ref check failed [152107089920 16384]
> ref mismatch on [152107126784 12288] extent item 1, found 0
> Incorrect local backref count on 152107126784 root 5 owner 267 offset
> 41345024 found 0 wanted 1 back 0x5702f60
> backpointer mismatch on [152107126784 12288]
> owner ref check failed [152107126784 12288]
> ref mismatch on [152107139072 4096] extent item 1, found 0
> Incorrect local backref count on 152107139072 root 5 owner 267 offset
> 41631744 found 0 wanted 1 back 0x5706510
> backpointer mismatch on [152107139072 4096]
> owner ref check failed [152107139072 4096]
> ref mismatch on [152107241472 49152] extent item 1, found 0
> Incorrect local backref count on 152107241472 root 5 owner 267 offset
> 44765184 found 0 wanted 1 back 0x57065f0
> backpointer mismatch on [152107241472 49152]
> owner ref check failed [152107241472 49152]
> Errors found in extent allocation tree
> checking fs roots
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> read block failed check_tree_block
> Speicherzugriffsfehler (Speicherabzug geschrieben)
>
>
> find-root from Joseph:
> -----------------------
> [root@z2 btrfs-progs-josef]# ./find-root /dev/sdb1
> Super think's the tree root is at 32030720, chunk root 20971520
> Generation: 192331 Root bytenr: 29446144 Root objectid: 2
> Generation: 192331 Root bytenr: 32464896 Root objectid: 4
> Generation: 192331 Root bytenr: 29360128 Root objectid: 5
> Generation: 192331 Root bytenr: 29581312 Root objectid: 7
> Generation: 192331 Root bytenr: 29380608 Root objectid:
> 18446744073709551607
> Well block 29437952 seems great, but generation doesn't match,
> have=192331, want=192333
> Generation: 192332 Root bytenr: 30793728 Root objectid: 2
> Generation: 192332 Root bytenr: 31121408 Root objectid: 4
> Generation: 192332 Root bytenr: 29360128 Root objectid: 5
> Generation: 192332 Root bytenr: 29581312 Root objectid: 7
> Generation: 192332 Root bytenr: 29380608 Root objectid:
> 18446744073709551607
> Well block 30732288 seems great, but generation doesn't match,
> have=192332, want=192333
> Generation: 192333 Root bytenr: 32432128 Root objectid: 2
> Generation: 192333 Root bytenr: 31121408 Root objectid: 4
> Generation: 192333 Root bytenr: 29360128 Root objectid: 5
> Generation: 192333 Root bytenr: 29581312 Root objectid: 7
> Generation: 192333 Root bytenr: 29380608 Root objectid:
> 18446744073709551607
> Found tree root at 32030720
>
>
> debug-tree shows the same problematic block on the console, the
> generated list is written up to the end  without crash
> -------------------------------------------
> [root@z2 btrfs-progs-chris]# ./btrfs-debug-tree /dev/sdb1 >123
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> Check tree block failed, want=29450240, have=0
> read block failed check_tree_block
> failed to read 29450240 in tree 5
>
>
>
>
> [...]
>
>                                  310797516/296M              100%
>          item 0 key (EXTENT_CSUM EXTENT_CSUM 156340977664) itemoff 563
> itemsize 3432
>                  extent csum item
> leaf 75816960 items 2 free space 2081 generation 190286 owner 7
> fs uuid 4d00f0e6-e9d7-42d9-8514-827d8f01f7d3
> chunk uuid 7e64d936-3686-4e79-890e-aa9a090eb95d
>          item 0 key (EXTENT_CSUM EXTENT_CSUM 156344492032) itemoff 2643
> itemsize 1352
>                  extent csum item
>          item 1 key (EXTENT_CSUM EXTENT_CSUM 156345876480) itemoff 2131
> itemsize 512
>                  extent csum item
> leaf 75796480 items 1 free space 178 generation 190286 owner 7
> fs uuid 4d00f0e6-e9d7-42d9-8514-827d8f01f7d3
> chunk uuid 7e64d936-3686-4e79-890e-aa9a090eb95d
>          item 0 key (EXTENT_CSUM EXTENT_CSUM 156346400768) itemoff 203
> itemsize 3792
>                  extent csum item
> data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0)
> leaf 29380608 items 2 free space 3773 generation 5 owner
> 18446744073709551607
> fs uuid 4d00f0e6-e9d7-42d9-8514-827d8f01f7d3
> chunk uuid 7e64d936-3686-4e79-890e-aa9a090eb95d
>          item 0 key (256 INODE_ITEM 0) itemoff 3835 itemsize 160
>                  inode generation 4 transid 0 size 0 block group 0 mode
> 40555 links 1
>          item 1 key (256 INODE_REF 256) itemoff 3823 itemsize 12
>                  inode ref index 0 namelen 2 name: ..
> total bytes 160039960576
> bytes used 103460102144
> uuid 4d00f0e6-e9d7-42d9-8514-827d8f01f7d3
> Btrfs Btrfs v0.19
>
>
>
> Is there any hope for me?
>
> best regards
> Alfred
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


Hello,

has realy nobody a hint for me?

br
Alfred


