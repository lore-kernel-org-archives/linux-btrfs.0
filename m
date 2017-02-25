Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:36358 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbdBYTHp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Feb 2017 14:07:45 -0500
Received: by mail-yw0-f179.google.com with SMTP id v200so22159347ywc.3
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Feb 2017 11:07:34 -0800 (PST)
Received: from [192.168.1.128] (dhcp-7.rro232.fastlab.unca.edu. [152.18.145.7])
        by smtp.gmail.com with ESMTPSA id p4sm4793028ywe.30.2017.02.25.11.00.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Feb 2017 11:00:06 -0800 (PST)
From: Kenneth Bogert <kbogert@unca.edu>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Subvolume corruption after restart on Raid1 array
Date: Sat, 25 Feb 2017 14:00:05 -0500
References: <FD81BC09-DB74-45F5-87AD-574E98C80374@unca.edu>
 <C6BE2251-0151-4818-866D-46D68C657DCB@unca.edu>
 <36F10428-FA2D-42F2-9065-8AFD7B6AF902@unca.edu>
 <d6787fb0-3bfc-987c-bdd8-33c154faa443@mendix.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <d6787fb0-3bfc-987c-bdd8-33c154faa443@mendix.com>
Message-Id: <866013FF-5C20-476D-AD54-6226098589A1@unca.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Feb 23, 2017, at 7:15 PM, Hans van Kranenburg <hans.van.kranenburg@mendix.com> wrote:
> 
> On 02/23/2017 05:42 PM, Kenneth Bogert wrote:
>> 
>>> On Feb 17, 2017, at 1:39 PM, Kenneth Bogert <kbogert@unca.edu> wrote:
>>> 
>>> On Feb 11, 2017, at 12:34 PM, Kenneth Bogert <kbogert@unca.edu> wrote:
>>>> 
>>>> kernel: BTRFS error (device sdb): parent transid verify failed on 1721409388544 wanted 19188 found 83121
>>>> [...]
>> 
>> Is anyone interested in this problem?  If not, I’m planning on rebuilding this filesystem this weekend.
> 
> Only this: "kernel: BTRFS error (device sdb): parent transid verify
> failed on 1721409388544 wanted 19188 found 83121" already makes me think
> there's something gone horribly wrong here. And, my guess is that it
> more likely has to do something with hardware than the btrfs program code.
> 
> If there's one bit that flipped it might be possible to rescue a
> filesystem manually, but these transid mismatches sound like the
> filesystem is encountering whole blocks of data that should never been
> there in the first place. A whole bunch of writes never ended up on
> disk, while a disk controller assured they would etc.
> 

Looking more in-depth into the issue, it appears the subvolume’s node on disk has been overwritten by an extent leaf node.  This explains why a lower transid is expected:

* btrfs-debug-tree -t 5 /dev/sda5

fs tree key (FS_TREE ROOT_ITEM 0) 
leaf 1719148756992 items 88 free space 9279 generation 83701 owner 5
fs uuid 21e09dd8-a54d-49ec-95cb-93fdd94f0c17
chunk uuid 066b3696-4677-4188-a8bf-41430d470fb0

:snip:
	item 7 key (256 DIR_ITEM 1613064667) itemoff 15894 itemsize 36
		location key (260 ROOT_ITEM -1) type DIR
		transid 40 data_len 0 name_len 6
		name: Movies

But viewing tree ID 260:

* btrfs-debug-tree -t 260 /dev/sda5

file tree key (260 ROOT_ITEM 0) 
leaf 1721409388544 items 173 free space 2306 generation 83121 owner 2
fs uuid 21e09dd8-a54d-49ec-95cb-93fdd94f0c17
chunk uuid 066b3696-4677-4188-a8bf-41430d470fb0
	item 0 key (1094746275840 EXTENT_ITEM 20480) itemoff 16246 itemsize 37
		extent refs 1 gen 72728 flags DATA
		shared data backref parent 1721662996480 count 1
…

This is apparently extents of a file that was open (a VM image) around the time of the restart. The file was shared over NFS to a Xenserver which was running it, but the VM was stopped before the restart.


For comparison, the snapshot of the subvolume shows:

* btrfs-debug-tree -t 2127 /dev/sda5

file tree key (2127 ROOT_ITEM 73808) 
node 1721460637696 level 1 items 17 free 476 generation 73808 owner 2127
fs uuid 21e09dd8-a54d-49ec-95cb-93fdd94f0c17
chunk uuid 066b3696-4677-4188-a8bf-41430d470fb0
	key (256 INODE_ITEM 0) block 1721409421312 (105066493) gen 19188
	key (256 DIR_INDEX 27) block 1721415778304 (105066881) gen 19188
	key (262 EXTENT_DATA 67211264) block 1719916314624 (104975361) gen 8524
	key (286 EXTENT_DATA 803299328) block 1719918362624 (104975486) gen 8524
	key (307 EXTENT_DATA 134217728) block 1719372939264 (104942196) gen 8522
	key (330 EXTENT_DATA 59768832) block 1719617585152 (104957128) gen 8523
	key (356 EXTENT_DATA 320073728) block 1719302012928 (104937867) gen 8522
	key (375 DIR_INDEX 4) block 1719919640576 (104975564) gen 8524
	key (388 DIR_ITEM 991737881) block 1719869472768 (104972502) gen 8524
	key (388 DIR_ITEM 2994564992) block 1719869489152 (104972503) gen 8524
	key (388 DIR_INDEX 118) block 1719657889792 (104959588) gen 8523
	key (401 INODE_ITEM 0) block 1719743889408 (104964837) gen 8524
	key (447 INODE_REF 388) block 1719481237504 (104948806) gen 8523
	key (495 INODE_ITEM 0) block 1719422746624 (104945236) gen 8523
	key (542 EXTENT_DATA 0) block 1719759962112 (104965818) gen 8524
	key (583 EXTENT_DATA 508674048) block 1719431282688 (104945757) gen 8523
	key (602 INODE_REF 257) block 1721409404928 (105066492) gen 19188
leaf 1721409421312 items 93 free space 8087 generation 19188 owner 260
fs uuid 21e09dd8-a54d-49ec-95cb-93fdd94f0c17
chunk uuid 066b3696-4677-4188-a8bf-41430d470fb0
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		inode generation 40 transid 19188 size 4316 nbytes 0
		block group 0 mode 40757 links 1 uid 0 gid 0 rdev 0
		sequence 0 flags 0x52(none)
		atime 1483029517.350532358 (2016-12-29 08:38:37)
		ctime 1483476789.845537792 (2017-01-03 12:53:09)
		mtime 1483476789.845537792 (2017-01-03 12:53:09)
		otime 1482889255.764891208 (2016-12-27 17:40:55)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		inode ref index 0 namelen 2 name: ..



There you can see the references to generation 19188.

> The lack of response should probably not be interpreted as "not caring",
> but more like "I really don't know" and just like not mailing a whole
> list with a "me too!" post, people won't mail "I don't know, dude, let's
> go bowling" too much. Or, it might be possible, but only realistically
> done when travelling to you, getting to work with your computer and then
> spending hours to find out what to do.
> 
> -- 
> Hans van Kranenburg

Yes I understand, just hoping for a miracle I guess.  With the filesystem in apparently good condition except for this one issue I was hoping there would be an easy fix.  I’m now rebuilding it slowly, but I figured I would post the last bit of information I was able to find in the hope it helps someone in the future.

Kenneth Bogert