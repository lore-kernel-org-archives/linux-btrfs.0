Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:49912 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932734AbdKCDYv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 23:24:51 -0400
Received: by mail-wm0-f42.google.com with SMTP id b189so2418105wmd.4
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 20:24:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171102214613.10af365e@jupiter.sol.kaishome.de>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
 <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru> <CAH=dxU7APYANHn3PjqepY9dr9F3RRhzE1OSgtar9tN-74haS9g@mail.gmail.com>
 <20171102214613.10af365e@jupiter.sol.kaishome.de>
From: Dave <davestechshop@gmail.com>
Date: Thu, 2 Nov 2017 23:24:29 -0400
Message-ID: <CAH=dxU59aq-KFKPb0qhMvd3B=OXdScK223HzcMcvUkFwcas-SQ@mail.gmail.com>
Subject: Re: Need help with incremental backup strategy (snapshots,
 defragmentingt & performance)
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 2, 2017 at 4:46 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
> Am Wed, 1 Nov 2017 02:51:58 -0400
> schrieb Dave <davestechshop@gmail.com>:
>
>> >
>> >> To reconcile those conflicting goals, the only idea I have come up
>> >> with so far is to use btrfs send-receive to perform incremental
>> >> backups
>> >
>> > As already said by Romain Mamedov, rsync is viable alternative to
>> > send-receive with much less hassle. According to some reports it
>> > can even be faster.
>>
>> Thanks for confirming. I must have missed those reports. I had never
>> considered this idea until now -- but I like it.
>>
>> Are there any blogs or wikis where people have done something similar
>> to what we are discussing here?
>
> I used rsync before, backup source and destination both were btrfs. I
> was experiencing the same btrfs bug from time to time on both devices,
> luckily not at the same time.
>
> I instead switched to using borgbackup, and xfs as the destination (to
> not fall the same-bug-in-two-devices pitfall).

I'm going to stick with btrfs everywhere. My reasoning is that my
biggest pitfalls will be related to lack of knowledge. So focusing on
learning one filesystem better (vs poorly learning two) is the better
strategy for me, given my limited time. (I'm not an IT professional of
any sort.)

Is there any problem with the Borgbackup repository being on btrfs?

> Borgbackup achieves a
> much higher deduplication density and compression, and as such also is
> able to store much more backup history in the same storage space. The
> first run is much slower than rsync (due to enabled compression) but
> successive runs are much faster (like 20 minutes per backup run instead
> of 4-5 hours).
>
> I'm currently storing 107 TB of backup history in just 2.2 TB backup
> space, which counts a little more than one year of history now,
> containing 56 snapshots. This is my retention policy:
>
>   * 5 yearly snapshots
>   * 12 monthly snapshots
>   * 14 weekly snapshots (worth around 3 months)
>   * 30 daily snapshots
>
> Restore is fast enough, and a snapshot can even be fuse-mounted (tho,
> in that case mounted access can be very slow navigating directories).
>
> With latest borgbackup version, the backup time increased to around 1
> hour from 15-20 minutes in the previous version. That is due to
> switching the file cache strategy from mtime to ctime. This can be
> tuned to get back to old performance, but it may miss some files during
> backup if you're doing awkward things to file timestamps.
>
> I'm also backing up some servers with it now, then use rsync to sync
> the borg repository to an offsite location.
>
> Combined with same-fs local btrfs snapshots with short retention times,
> this could be a viable solution for you.

Yes, I appreciate the idea. I'm going to evaluate both rsync and Borgbackup.

The advantage of rsync, I think, is that it will likely run in just a
couple minutes. That will allow me to run it hourly and to keep my
live volume almost entire free of snapshots and fully defragmented.
It's also very simple as I already have rsync. And since I'm going to
run btrfs on the backup volume, I can perform hourly snapshots there
and use Snapper to manage retention. It's all very simple and relies
on tools I already have and know.

However, the advantages of Borgbackup you mentioned (much higher
deduplication density and compression) make it worth considering.
Maybe Borgbackup won't take long to complete successive (incremental)
backups on my system. I'll have to try it to see. It's a very nice
looking project. I'm surprised I never heard of it before.
