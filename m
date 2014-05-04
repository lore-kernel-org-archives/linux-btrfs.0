Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:52858 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaEDBTV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 May 2014 21:19:21 -0400
Received: from babycakes.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 85EA620903
	for <linux-btrfs@vger.kernel.org>; Sun,  4 May 2014 11:19:18 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: metadata vs data errors
Date: Sun, 4 May 2014 11:19:15 +1000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201405041119.17103.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# btrfs scrub status /mnt/backup/
scrub status for 97972ab2-02f7-42dd-a23b-d92efbf9d9b5
        scrub started at Thu May  1 14:29:57 2014 and finished after 97253 
seconds
        total bytes scrubbed: 1.11TB with 13684 errors
        error details: read=13684
        corrected errors: 2113, uncorrectable errors: 11571, unverified 
errors: 0

Above is the output from a scrub of a damaged disk.  It was formatted with 
default options (dup for metadata and single for data) so obviously the 
corrected errors are all for metadata.

May  1 18:23:51 server kernel: [14216.461759] BTRFS: i/o error at logical 
505396924416 on dev /dev/sde, sector 989216904: metadata leaf (level 0) in 
tree 823                                                                                                                                                                                                    
May  1 18:23:51 server kernel: [14216.461762] BTRFS: i/o error at logical 
505396924416 on dev /dev/sde, sector 989216904: metadata leaf (level 0) in 
tree 823                                                                                                                                                                                                    
May  1 18:23:54 server kernel: [14219.704819] BTRFS: i/o error at logical 
505398464512 on dev /dev/sde, sector 989219912: metadata leaf (level 0) in 
tree 823                                                                                                                                                                                                    
May  1 18:23:54 server kernel: [14219.704825] BTRFS: i/o error at logical 
505398464512 on dev /dev/sde, sector 989219912: metadata leaf (level 0) in 
tree 823                                                                                                                                                                                                    
May  1 18:24:30 server kernel: [14255.174994] BTRFS: i/o error at logical 
505614372864 on dev /dev/sde, sector 991738760: metadata leaf (level 0) in 
tree 2                                                                                                                                                                                                      
May  1 18:24:30 server kernel: [14255.174998] BTRFS: i/o error at logical 
505614372864 on dev /dev/sde, sector 991738760: metadata leaf (level 0) in 
tree 2

To discover whether there were any metadata errors I grepped for "metadata" in 
the kernel message log and found lots of lines like the above.  Will all 
errors that involve metadata match a grep for "metadata" in the kernel message 
log?

I think it would be good to have a scrub count of the number of uncorrectable 
metadata vs data errors.  When there are uncorrectable data errors you know 
the name of the file (it's in the kernel message log) and can recover just 
that file.  When there are uncorrectable metadata errors you don't.

Also would it be possible to log the names of directories that are affected by 
uncorrectable metadata errors?  When BTRFS scales up to the systems where a 
"find /" takes days to complete and run 24*7 there won't be an option to just 
restore from backup.  In this case the root of every subvol appears undamaged 
so BTRFS should be able to tell me part of the path related to metadata 
corruption.

# btrfs subvol list /mnt/backup/                                                                                                                                                                                                                                                                                                               
ID 823 gen 3212 top level 5 path backup                                                                                                                                                                                                                                                                                                                          
ID 826 gen 1832 top level 5 path backup-2013-05-21

Above is the start of the output of a subvol list, there is no ID 2.  What 
does the "tree 2" in the above kernel error log mean?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
