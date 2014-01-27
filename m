Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:45370 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaA0H7U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 02:59:20 -0500
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 5B15E2186F
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 18:59:17 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: deleting files and qgroups
Date: Mon, 27 Jan 2014 18:59:16 +1100
Message-ID: <6820542.RmHzTAgQHU@russell.coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(sysadm_t:s0-s0:c0.c1023)root@play:/tmp# btrfs qgroup limit 20m /tmp
(sysadm_t:s0-s0:c0.c1023)root@play:/tmp# du -h test
931M    test
(sysadm_t:s0-s0:c0.c1023)root@play:/tmp# rm test
rm: cannot remove 'test': Disk quota exceeded
(sysadm_t:s0-s0:c0.c1023)root@play:/tmp# echo -n > test
-bash: test: Disk quota exceeded

Is the above expected?  If there's excess disk space usage I'd like to set a 
qgroup first then delete or truncate files.

As an aside, is it expected that a SE Linux Play Machine (with hostile "root" 
user) should survive with BTRFS?  I'm preparing a new Play Machine which will 
run BTRFS and use qgroups, are there any bugs or missing features I should be 
aware of?

I realise that qgroups are an area of BTRFS that hasn't been tested a lot and 
that using them to restrict actively hostile users is probably more 
experimental than most BTRFS stuff.  But I'm happy to get a broken system if we 
learn something useful.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

