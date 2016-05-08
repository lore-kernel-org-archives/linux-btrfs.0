Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:55107 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbcEHLzs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 May 2016 07:55:48 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout0.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.85 #1)
	id 1azNJJ-0007Cb-SH
	for linux-btrfs@vger.kernel.org; Sun, 08 May 2016 13:55:45 +0200
Received: from localhost ([::1]:44280 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1azNJJ-0000xA-OL
	for linux-btrfs@vger.kernel.org; Sun, 08 May 2016 13:55:45 +0200
Received: from mx0.freenet.de ([195.4.92.10]:47164)
	by mjail2.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1azNHK-0004yr-9t
	for linux-btrfs@vger.kernel.org; Sun, 08 May 2016 13:53:42 +0200
Received: from ppp-88-217-11-137.dynamic.mnet-online.de ([88.217.11.137]:33476 helo=[192.168.1.217])
	by mx0.freenet.de with esmtpsa (ID master.b.at.raven@chefmail.de) (TLSv1.2:DHE-RSA-AES128-SHA:128) (port 465) (Exim 4.85 #1)
	id 1azNHK-0006zb-4O
	for linux-btrfs@vger.kernel.org; Sun, 08 May 2016 13:53:42 +0200
Subject: Re: btrfs-tools: missing device delete/remove cancel option on disk
 failure
References: <1ba2f46d66b988069f861df8526e4cba@email.freenet.de>
 <ngm2ou$he4$1@ger.gmane.org>
To: linux-btrfs@vger.kernel.org
From: g6094199@freenet.de
Message-ID: <fb65d9d2-3ac9-a155-af13-62fe8d41a49b@chefmail.de>
Date: Sun, 8 May 2016 13:53:41 +0200
MIME-Version: 1.0
In-Reply-To: <ngm2ou$he4$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 08.05.2016 um 02:54 schrieb Martin:
> On 07/05/16 10:39, g6094199@freenet.de wrote:
>> a brand new disk which has an upcounting raw error rate
> Note that is the "raw error rate".
>
> For a brand new disk being run for the first time at maximum data
> writes, the "raw error rate" may well be expected to increase. Hard
> disks deliberately make use of error correction for normal operation.
>
> More importantly, what do the other smart values show?
>
> For myself, my concern would only be raised for sector failures.
>
>
> And... A very good test for a new disk is to first run "badblocks" to
> test the disk surface. Read the man page first. (Hint: Non-destructive
> is slow, destructive write is fast...)
>
> Good luck,
> Martin
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

i guess this log is out of diskussion:

[44388.089321] sd 8:0:0:0: [sdf] tag#0 FAILED Result:
hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK
[44388.089334] sd 8:0:0:0: [sdf] tag#0 CDB: Read(10) 28 00 00 43 1c 48
00 00 08 00
[44388.089340] blk_update_request: I/O error, dev sdf, sector 35185216

...

May  7 06:39:31 NAS-Sash kernel: [35777.520490] sd 8:0:0:0: [sdf] tag#0
FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
May  7 06:39:31 NAS-Sash kernel: [35777.520500] sd 8:0:0:0: [sdf] tag#0
Sense Key : Medium Error [current]
May  7 06:39:31 NAS-Sash kernel: [35777.520508] sd 8:0:0:0: [sdf] tag#0
Add. Sense: Unrecovered read error
May  7 06:39:31 NAS-Sash kernel: [35777.520516] sd 8:0:0:0: [sdf] tag#0
CDB: Read(10) 28 00 03 84 ee 30 00 00 04 00
May  7 06:39:31 NAS-Sash kernel: [35777.520522] blk_update_request:
critical medium error, dev sdf, sector 472347008
May  7 06:39:35 NAS-Sash kernel: [35781.364117] sd 8:0:0:0: [sdf] tag#0
FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
May  7 06:39:35 NAS-Sash kernel: [35781.364138] sd 8:0:0:0: [sdf] tag#0
Sense Key : Medium Error [current]
May  7 06:39:35 NAS-Sash kernel: [35781.364146] sd 8:0:0:0: [sdf] tag#0
Add. Sense: Unrecovered read error
May  7 06:39:35 NAS-Sash kernel: [35781.364154] sd 8:0:0:0: [sdf] tag#0
CDB: Read(10) 28 00 03 84 ee 30 00 00 04 00

and different vendors use the raw error rate differently. some count up
constantly, some do only log real destructive errors.

but i had the luck that the system froze completely. not even an log
entry. now the file system is broken.....arg!

now i need some advice what to do next....best practice wise? try to
mount degraded and copy off all data? then i will net at least 9TB of
new storage... :-(


sash




