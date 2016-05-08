Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35491 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbcEHPfW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 May 2016 11:35:22 -0400
Received: by mail-oi0-f54.google.com with SMTP id x19so186962997oix.2
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 08:35:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fb65d9d2-3ac9-a155-af13-62fe8d41a49b@chefmail.de>
References: <1ba2f46d66b988069f861df8526e4cba@email.freenet.de>
	<ngm2ou$he4$1@ger.gmane.org>
	<fb65d9d2-3ac9-a155-af13-62fe8d41a49b@chefmail.de>
Date: Sun, 8 May 2016 09:35:20 -0600
Message-ID: <CAJCQCtRzyZK3jhN=LdMLNS9DZOwuX4qchx_mAthySq1FEDRpdw@mail.gmail.com>
Subject: Re: btrfs-tools: missing device delete/remove cancel option on disk failure
From: Chris Murphy <lists@colorremedies.com>
To: g6094199@freenet.de
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 8, 2016 at 5:53 AM,  <g6094199@freenet.de> wrote:

>
> i guess this log is out of diskussion:
>
> [44388.089321] sd 8:0:0:0: [sdf] tag#0 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK
> [44388.089334] sd 8:0:0:0: [sdf] tag#0 CDB: Read(10) 28 00 00 43 1c 48
> 00 00 08 00
> [44388.089340] blk_update_request: I/O error, dev sdf, sector 35185216
>
> ...
>
> May  7 06:39:31 NAS-Sash kernel: [35777.520490] sd 8:0:0:0: [sdf] tag#0
> FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> May  7 06:39:31 NAS-Sash kernel: [35777.520500] sd 8:0:0:0: [sdf] tag#0
> Sense Key : Medium Error [current]
> May  7 06:39:31 NAS-Sash kernel: [35777.520508] sd 8:0:0:0: [sdf] tag#0
> Add. Sense: Unrecovered read error
> May  7 06:39:31 NAS-Sash kernel: [35777.520516] sd 8:0:0:0: [sdf] tag#0
> CDB: Read(10) 28 00 03 84 ee 30 00 00 04 00
> May  7 06:39:31 NAS-Sash kernel: [35777.520522] blk_update_request:
> critical medium error, dev sdf, sector 472347008
> May  7 06:39:35 NAS-Sash kernel: [35781.364117] sd 8:0:0:0: [sdf] tag#0
> FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> May  7 06:39:35 NAS-Sash kernel: [35781.364138] sd 8:0:0:0: [sdf] tag#0
> Sense Key : Medium Error [current]
> May  7 06:39:35 NAS-Sash kernel: [35781.364146] sd 8:0:0:0: [sdf] tag#0
> Add. Sense: Unrecovered read error
> May  7 06:39:35 NAS-Sash kernel: [35781.364154] sd 8:0:0:0: [sdf] tag#0
> CDB: Read(10) 28 00 03 84 ee 30 00 00 04 00

What drive is this? Is it one of the new drives? It's very unusual
that this new drive which should be getting mostly writes (what is
there to read?) during a 'dev delete' or 'replace' operation, but in
particular to have a read error this soon after data has been written.
I suspect maybe it's some other drive.

>
> and different vendors use the raw error rate differently. some count up
> constantly, some do only log real destructive errors.
>
> but i had the luck that the system froze completely. not even an log
> entry. now the file system is broken.....arg!




>
> now i need some advice what to do next....best practice wise? try to
> mount degraded and copy off all data? then i will net at least 9TB of
> new storage... :-(

If you don't have a backup already, you're kinda twice behind best
practices, aren't you? One you should have one anyway, two you should
have one before doing anything risky like growing the array or doing
device replacements.

The best practice at this point would be to mount with -o degraded,ro
I wouldn't even do rw mounts. The less you change things the better
off the file system is. And then copy the data to a new array before
making any changes to the original volume. And hopefully mounting
degraded,ro works, if not then it's btrfs restore (offline scrape)
time.



-- 
Chris Murphy
