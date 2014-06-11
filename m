Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:51165 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaFKCGN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Jun 2014 22:06:13 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id E784B2031F
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Jun 2014 12:06:05 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Reply-To: russell@coker.com.au
Subject: 3.13.6-1 user-space freeze on subvol removal - fixed in 3.14.4
Date: Wed, 11 Jun 2014 12:05:59 +1000
Message-ID: <2323799.KmhYrVNjAe@russell.coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Last night I discovered a bug in my subvol removal script on one of my 
servers.  I fixed the bug and ran the script to delete ~1500 subvols and the 
system locked up.  It would respond to pings and accept TCP connections but 
nothing else.  Existing ssh sessions didn't respond and connections to port 22 
got a TCP connection but not even the start of the ssh handshake (IE sshd was 
hung).

Today I visited the server and connected a keyboard, I couldn't get a keyboard 
response to even unblank the screen (it's at a virtual console and X isn't 
installed.

I rebooted the system and found that the bug fix to the subvol removal script 
was lost, the old version of the file was in place.  So all changes to the 
filesystem from 10+ seconds before the subvol removal were discarded.

INFO: rcu_sched self detected stall on CPU { 1}  (t=5250 jiffies g=7989 c=7988 
q=3)
BUG: soft lockup - CPU#0 stuck for 23s! [sync:2424]
BUG: soft lockup - CPU#1 stuck for 23s! [btrfs-transacti:287]
BUG: soft lockup - CPU#0 stuck for 23s! [sync:2424]
BUG: soft lockup - CPU#1 stuck for 23s! [btrfs-transacti:287]
INFO: rcu_sched self detected stall on CPU { 1}  (t=21003 jiffies g=7989 c=7988 
q=3)
BUG: soft lockup - CPU#0 stuck for 23s! [sync:2424]
BUG: soft lockup - CPU#1 stuck for 23s! [btrfs-transacti:287]
BUG: soft lockup - CPU#0 stuck for 23s! [sync:2424]
BUG: soft lockup - CPU#1 stuck for 23s! [btrfs-transacti:287]

After booting up I ran the new script and told it to delete only ~440 subvoles 
and got the above messages on the console.  Those messages keep repeating with 
the only differences being the value of the t= parameter and the number of 
seconds (which varies between 22 and 23 seconds).  At that time the keyboard 
didn't get any response from the system and sshd didn't even start it's 
protocol (user-space seems dead).

I had to do a hardware reset as CTRL-ALT-DEL and briefly pressing the power 
button had no affect.

After that I installed kernel 3.14.4 and deleted 442 subvols and then soon 
after another 1104 without any problems.

I've noticed before that generally newer kernels have been fixing the various 
crashes related to snapshot creation and removal, but this is the first time 
I've done a clean repeatable test to show 3.14 working where 3.13 failed.

I had been hesitant to upgrade to 3.14 because I've seen it fail horribly with 
Xen, but in this case it worked well with Xen.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

