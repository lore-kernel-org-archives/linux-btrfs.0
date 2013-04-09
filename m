Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.19]:36182 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476Ab3DIR27 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Apr 2013 13:28:59 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2303.sfr.fr (SMTP Server) with ESMTP id A2DC87000098
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Apr 2013 19:19:01 +0200 (CEST)
Received: from [127.0.0.1] (246.5.22.109.rev.sfr.net [109.22.5.246])
	by msfrf2303.sfr.fr (SMTP Server) with ESMTP id 4821570000A6
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Apr 2013 19:19:00 +0200 (CEST)
Message-ID: <51644D81.4090400@free.fr>
Date: Tue, 09 Apr 2013 19:18:57 +0200
From: Maxime Nicco <maxime.nicco@free.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Bad tree block, on root filesystem after reset
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Today my laptop messed-up my display configuration between 2 screens. I 
had to reset it, but my btrfs root partition is no longer mountable.
I have the following output in dmesg :

device fsid f9264db3-f277-47b6-bd8f-57d0a67c93a7 devid 1 transid 78577 
/dev/sda2
btrfs: force clearing of disk cache
btrfs bad tree block start 0 18565984256
btrfs bad tree block start 0 18565984256
trfs: failed to read tree root on sda2
btrfs: open_ctree failed

I downloaded the latest btrfs-progs, but getting strange output from 
several of the programs:

# ./btrfs-debug-tree /dev/sda2
btrfs-debug-tree: root-tree.c:46: btrfs_find_last_root: Assertion 
`!(path->slots[0] == 0)' failed.

But find-root program found things

# ./btrfs-find-root /dev/sda2
Super think's the tree root is at 18564399104, chunk root 20971520
Well block 13139611648 seems great, but generation doesn't match, 
have=78267, want=78578
Well block 13154590720 seems great, but generation doesn't match, 
have=78266, want=78578
Well block 13160091648 seems great, but generation doesn't match, 
have=78265, want=78578
Well block 23123091456 seems great, but generation doesn't match, 
have=78456, want=78578
Well block 23598575616 seems great, but generation doesn't match, 
have=78506, want=78578
Well block 23600107520 seems great, but generation doesn't match, 
have=78507, want=78578
Well block 23601156096 seems great, but generation doesn't match, 
have=78508, want=78578
Well block 23601225728 seems great, but generation doesn't match, 
have=78509, want=78578
No more metdata to scan, exiting

I tried restoring my data with

# btrfs-restore -v -t 13154590720 /dev/sda2 /mnt/sda2/@home/recovery/
parent transid verify failed on 13154590720 wanted 78578 found 78266
parent transid verify failed on 13154590720 wanted 78578 found 78266
parent transid verify failed on 13154590720 wanted 78578 found 78266
parent transid verify failed on 13154590720 wanted 78578 found 78266
Ignoring transid failure
Check tree block failed, want=29360128, have=0
Check tree block failed, want=29360128, have=0
Check tree block failed, want=29360128, have=0
Check tree block failed, want=29360128, have=0
Check tree block failed, want=29360128, have=0
read block failed check_tree_block
Couldn't setup device tree
btrfs-restore: extent_io.c:602: free_extent_buffer: Assertion 
`!(eb->refs < 0)' failed.


Is there anything I can do to debug or grab a few bits before reformatting?

Thanks,

Maxime
