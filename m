Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35232 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259Ab3KMOpd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 09:45:33 -0500
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id C54A221908
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Nov 2013 01:45:30 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: NMI from btrfs cron jobs in 3.11.6
Date: Thu, 14 Nov 2013 01:45:29 +1100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JC5gSfPagG5GXS9"
Message-Id: <201311140145.29255.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_JC5gSfPagG5GXS9
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Nov 14 00:00:01 workstation /USR/SBIN/CRON[30993]: (root) CMD 
(/usr/local/sbin/btrfs-make-snapshot minutes /home >> /var/log/snapshot.log)                                                                                                                                                                                                                      
Nov 14 00:00:01 workstation /USR/SBIN/CRON[30994]: (root) CMD 
(/usr/local/sbin/btrfs-make-snapshot days /home >> /var/log/snapshot.log)                                                                                                                                                                                                                         
Nov 14 00:00:01 workstation /USR/SBIN/CRON[30995]: (root) CMD 
(/usr/local/sbin/btrfs-remove-snapshots 100 100 /home/ / >> 
/var/log/snapshot.log)

Below is a grep for NMI in my kernel message log.  I'm running Debian kernel 
3.11.6-2 on a quad-core AMD64 system.  Above is the relevant section of the 
cron log.  It appears that running two scripts that create snapshots at the 
same time as a script that removes maybe 97 snapshots causes an NMI.  I've 
attached the kernel message log from today, I can give you logs from other 
days if they are useful.

Nov 11 00:00:58 workstation kernel: [896466.616001] sending NMI to all CPUs:
Nov 11 00:00:58 workstation kernel: [896466.616016] NMI backtrace for cpu 0
Nov 11 00:00:58 workstation kernel: [896466.616001] NMI backtrace for cpu 2
Nov 11 00:00:58 workstation kernel: [896466.616479] NMI backtrace for cpu 3
Nov 11 00:00:58 workstation kernel: [896466.616637] NMI backtrace for cpu 1
Nov 12 00:00:58 workstation kernel: [982863.428000] sending NMI to all CPUs:
Nov 12 00:00:58 workstation kernel: [982863.428000] NMI backtrace for cpu 1
Nov 12 00:00:58 workstation kernel: [982863.428340] NMI backtrace for cpu 0
Nov 12 00:00:58 workstation kernel: [982863.428647] NMI backtrace for cpu 2
Nov 12 00:00:58 workstation kernel: [982863.428725] NMI backtrace for cpu 3
Nov 13 00:00:57 workstation kernel: [1069265.036001] sending NMI to all CPUs:
Nov 13 00:00:57 workstation kernel: [1069265.036018] NMI backtrace for cpu 1
Nov 13 00:00:57 workstation kernel: [1069265.036341] NMI backtrace for cpu 0
Nov 13 00:00:57 workstation kernel: [1069265.036001] NMI backtrace for cpu 2
Nov 13 00:00:57 workstation kernel: [1069265.036723] NMI backtrace for cpu 3
Nov 13 22:21:04 workstation kernel: [1149672.214144] INFO: NMI handler 
(perf_event_nmi_handler) took too long to run: 6.060 msecs
Nov 14 00:00:56 workstation kernel: [1155663.796001] sending NMI to all CPUs:
Nov 14 00:00:56 workstation kernel: [1155663.796001] NMI backtrace for cpu 2
Nov 14 00:00:56 workstation kernel: [1155663.796269] NMI backtrace for cpu 3
Nov 14 00:00:56 workstation kernel: [1155663.796007] NMI backtrace for cpu 1
Nov 14 00:00:56 workstation kernel: [1155663.796581] NMI backtrace for cpu 0

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

--Boundary-00=_JC5gSfPagG5GXS9
Content-Type: application/x-gzip;
  name="oops.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="oops.gz"

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
yYvRDBKskjQvM8Do/xGb/w/JQ1QDAzwAAA==

--Boundary-00=_JC5gSfPagG5GXS9--
