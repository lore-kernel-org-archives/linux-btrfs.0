Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:33592 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071AbcCDWhl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 17:37:41 -0500
Received: by mail-ig0-f193.google.com with SMTP id hb3so615649igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 14:37:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <c2e396477401f3441bdc364456b399f4@smoula.net>
References: <c2e396477401f3441bdc364456b399f4@smoula.net>
Date: Fri, 4 Mar 2016 15:37:40 -0700
Message-ID: <CAJCQCtRP6yNOk-oDy9dOiuTL1e19SB9H9cjueEZVsCwJS4vC6w@mail.gmail.com>
Subject: Re: ENOSPC while creating snapshot
From: Chris Murphy <lists@colorremedies.com>
To: nexus@smoula.net
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 4, 2016 at 2:10 PM,  <nexus@smoula.net> wrote:
> Hello,
>
> I'm encountering weird enospc problem while writing to filesystem and
> creating snapshot at a same time:
>
> Steps to reproduce:
>
> start writing data to filesystem:
>
> # LC_ALL=C dd if=/dev/zero of=/foobar
> dd: writing to '/foobar': No space left on device
> 3003803+0 records in
> 3003802+0 records out
> 1537946624 bytes (1.5 GB, 1.4 GiB) copied, 10.8072 s, 142 MB/s
>
> in other terminal create read-only (or r/w - results are the same)
> # btrfs sub snap -r / /.snap1
> Create a readonly snapshot of '/' in '//.snap1'
>
> while creating this snapshot, ENOSPC is produced.


Known issue. There's a thread already about it somewhere around here
in the last 4-6 weeks.


(rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,enospc_debug,commit=900,subvolid=5,subvol=/)

Most likely unrelated but commit time of 15 minutes? Umm, OK why?


-- 
Chris Murphy
