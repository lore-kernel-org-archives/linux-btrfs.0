Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34142 "EHLO
	mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbcCOXLp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 19:11:45 -0400
Received: by mail-lf0-f48.google.com with SMTP id e138so6232031lfe.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 16:11:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
	<72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
	<CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
	<ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
	<CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
	<5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
Date: Wed, 16 Mar 2016 00:11:43 +0100
Message-ID: <CAPmG0jZwapQ1=V-dHMEEwMYQUjb4+1M102eo96XQeJQV1JoxeQ@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Henk Slager <eye1tm@gmail.com>
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 1:47 AM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
> Some update since last time (few weeks ago).
>
> All filesystems are mounted with noatime, I've also added mounting
> optimization - so there is no problem with remounting filesystem every time,
> it is done only once.
>
> Remounting optimization helped by reducing 1 complete snapshot +
> send/receive cycle by some seconds, but otherwise it is still very slow when
> `btrfs receive` is active.

OK, great that the umount+mount is gone. I think most time is
unfortunately spent in seeks; I think over time and due to various
factors, both free space and files are highly fragmented on your disk.
It could also be that the disk is bit older and has or is starting to
use its spare sectors.

> I'm not considering bcache + btrfs as potential setup because I do not
> currently have free SSD for it and basically spending SSD besides HDD for
> backup partition feels like a bit of overkill (especially for desktop use).

Yes I think so too; For backup, I am also a bit reluctant to use
bcache. But the big difference is that you do a snapshot transfer
every 15minute while I do that only every 24hour. So I almost dont
care how long the send|receive takes in the middle of the night. I
also almost never look at the backups, and when I do, indeed scanning
through a 1000 snapshots fs on spinning disk takes time. If a script
does that every 15mins, and the fs uses LZO compression and there is
another active partition then you will have to deal with the slowness.
And if the files are mostly small, like source-trees, it gets even
worse. So it is about 100x more creates+deletes of subvolumes. To be
honest, it is just requiring too much from a HDD I think, knowing that
btrfs is CoW. On a fresh fs it might work OK in the beginning, but
over time...

You could adapt the script or backup method not to search every time,
but to just write the next diff send|receive and only step back and
search if this fails.

Or keeping more 15min snapshots only on SSD and lower the rate of
send|receive them to HDD

Another thing you could do is skip the receive step; So just pipe the
15min snapshot diff to a stream file and just leave it on the backup
HDD until you need files from the backup. Only then do a series of
incremental receives of the streams. An every now and then a full
(non-incremental) send.

> My current kernel is 4.5.0 stable, btrfs-tools still 4.4-1 from Ubuntu 16.04
> repository as of today.
>
> As I'm reading mailing list there are other folks having similar performance
> issues. So can we debug things to find the root cause and fix it at some
> point?

Indeed there are multiple reports with similar symptoms. I think it is
not really that one should see it as an error or root cause or some
fault. It is further optimization and then specifically for harddisks.
Or implementing additional concepts just for harddisks. For (parity)
RAID (by btrfs itself, not DM or MD etc), one can exploit parallelism,
but it is not trivial to get that fully optimized for all device
configurations and tasks.

> My C/C++/Kernel/BTRFS knowledges are scarce, which is why some assistance
> here is needed from someone more experienced.

It is all about HDD seek times in the first place. There are many
thoughts, articles and benchmarks about this over the years on the
internet, but I just found this one from last year about XFS:
https://lkml.org/lkml/2015/4/29/776
