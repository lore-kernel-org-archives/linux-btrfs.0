Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:38681 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbcDHQtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 12:49:11 -0400
Received: by mail-ig0-f177.google.com with SMTP id ui10so21082618igc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 09:49:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7303236.im7zcVY3uK@merkaba>
References: <7303236.im7zcVY3uK@merkaba>
Date: Fri, 8 Apr 2016 10:49:10 -0600
Message-ID: <CAJCQCtScRvSR2kQhhyyWRTThgfqE3pmOkECr1mxA+Bx6GScvtg@mail.gmail.com>
Subject: Re: btrfs send/receive using generation number as source
From: Chris Murphy <lists@colorremedies.com>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 8, 2016 at 5:01 AM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> Hello!
>
> As far as I understood, for differential btrfs send/receive – I didn´t use it
> yet – I need to keep a snapshot on the source device to then tell btrfs send
> to send the differences between the snapshot and the current state.
>
> Now the BTRFS filesystems on my SSDs are often quite full, thus I do not keep
> any snapshots except for one during rsync or borgbackup script run-time.
>
> Is it possible to tell btrfs send to use generation number xyz to calculate
> the difference? This way, I wouldn´t have to keep a snapshot around, I
> believe.
>
> I bet not, at the time cause -c wants a snapshot. Ah and it wants a snapshot
> of the same state on the destination as well. Well on the destination I let
> the script make a snapshot after the backup so… what I would need is to
> remember the generation number of the source snapshot that the script creates
> to backup from and then tell btrfs send that generation number + the
> destination snapshots.
>
> Well, or get larger SSDs or get rid of some data on them.

Well if you can't even keep one ro snapshot around, it suggests you
need more space. Otherwise the minimal strategy is:


Yesterday's source has subvols:
root.current
root.20160406

So you'd do

btrfs sub snap -r root.current root.20160407
btrfs send -p root.20160406 root.20160407  | btrfs receive xxx
btrfs sub del root.20160406

Today it's

btrfs sub snap -r root.current root.20160408
btrfs send -p root.20160407 root.20160408  | btrfs receive xxx
btrfs sub del root.20160407


Tomorrow:

btrfs sub snap -r root.current root.20160409
btrfs send -p root.20160408 root.20160409  | btrfs receive xxx
btrfs sub del root.20160408


Locally you always have one snapshot to rollback to or make selective
reflink copies of files from.


-- 
Chris Murphy
