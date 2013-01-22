Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw2a.glodns.net ([196.220.48.60]:60974 "EHLO fw2a.glodns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3AVTn1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 14:43:27 -0500
Received: from localhost (unknown [127.0.0.1])
	by fw2a.glodns.net (Postfix) with ESMTP id F2D2028C130
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 19:43:24 +0000 (UTC)
Received: from fw2a.glodns.net ([196.220.48.60])
	by localhost (fw2a.glodns.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qj2gqmdbFlyZ for <linux-btrfs@vger.kernel.org>;
	Tue, 22 Jan 2013 21:43:19 +0200 (SAST)
Received: from control.glodns.net (unknown [196.220.42.40])
	by fw2a.glodns.net (Postfix) with ESMTP id 1993328C061
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 21:43:19 +0200 (SAST)
Message-ID: <50FEEB9E.2060305@swiftspirit.co.za>
Date: Tue, 22 Jan 2013 21:42:22 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: inconsistent output on sub list
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Linux watricky 3.6.11-1-ARCH #1 SMP PREEMPT Tue Dec 18 08:57:15 CET 2012 
x86_64 GNU/Linux

In working on a snapshot maintenance script I've noticed some odd 
behaviour. Note the smbshare path. I've put this into its own subvolume 
as I don't plan on snapshotting it.

In the first command's output, this path is printed correctly, however 
in the second output it has "4.snap" appended, similar to the names of 
the snapshots I made 22 hours ago.

If this is a documented issue with a fix then no worries. But if not and 
anyone wants me to check into any further specifics, please let me know.

 > [root@watricky mnt]# btrfs subvolume list / -a
 > ID 258 gen 4226 top level 384 path media/smbshare
 > ID 259 gen 4337 top level 384 path home
 > ID 384 gen 4321 top level 5 path <FS_TREE>/__active
 > ID 392 gen 4337 top level 384 path var
 > ID 393 gen 4267 top level 384 path usr
 > ID 428 gen 4267 top level 5 path 
<FS_TREE>/__snapshot/__active.20130121-23h44.snap
 > ID 429 gen 3980 top level 5 path 
<FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
 > ID 430 gen 4043 top level 5 path 
<FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
 > ID 431 gen 4267 top level 5 path 
<FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
 > [root@watricky mnt]# btrfs subvolume list /home -a
 > ID 258 gen 4226 top level 5 path <FS_TREE>/__active/media/smbshare4.snap
 > ID 259 gen 4337 top level 5 path <FS_TREE>/__active/home
 > ID 384 gen 4321 top level 5 path <FS_TREE>/__active
 > ID 392 gen 4337 top level 5 path <FS_TREE>/__active/var
 > ID 393 gen 4267 top level 5 path <FS_TREE>/__active/usr
 > ID 428 gen 4267 top level 5 path 
<FS_TREE>/__snapshot/__active.20130121-23h44.snap
 > ID 429 gen 3980 top level 5 path 
<FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
 > ID 430 gen 4043 top level 5 path 
<FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
 > ID 431 gen 4267 top level 5 path 
<FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
 > [root@watricky mnt]#

Note that the only directly mounted share is __active, mounted at /.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

