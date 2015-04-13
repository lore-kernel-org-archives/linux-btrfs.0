Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36835 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbbDMOGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:06:46 -0400
Received: by wizk4 with SMTP id k4so74026045wiz.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 07:06:45 -0700 (PDT)
Received: from ?IPv6:2a02:1812:1980:9b00:d17b:f93c:8b28:5398? ([2a02:1812:1980:9b00:d17b:f93c:8b28:5398])
        by mx.google.com with ESMTPSA id a6sm11657847wiy.17.2015.04.13.07.06.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Apr 2015 07:06:44 -0700 (PDT)
Message-ID: <552BCD6F.6080509@sjeng.org>
Date: Mon, 13 Apr 2015 16:06:39 +0200
From: Gian-Carlo Pascutto <gcp@sjeng.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Big disk space usage difference, even after defrag, on identical
 data
References: <55297D36.8090808@sjeng.org> <pan$f11f0$7ca65f9$58551aba$5ec77500@cox.net>
In-Reply-To: <pan$f11f0$7ca65f9$58551aba$5ec77500@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13-04-15 07:06, Duncan wrote:

>> So what can explain this? Where did the 66G go?
> 
> Out of curiosity, does a balance on the actively used btrfs help?
> 
> You mentioned defrag -v -r -clzo, but didn't use the -f (flush) or -t 
> (minimum size file) options.  Does adding -f -t1 help?

Unfortunately I can no longer try this, see the other reply why. But the
problem turned out to be some 1G-sized files, written using 3-5 extents,
that for whatever reason defrag was not touching.

> You aren't doing btrfs snapshots of either subvolume, are you?

No :-) I should've mentioned that.

> Defrag should force the rewrite of entire files and take care of this, 
> but obviously it's not returning to "clean" state.  I forgot what the 
> default minimum file size is if -t isn't set, maybe 128 MiB?  But a -t1 
> will force it to defrag even small files, and I recall at least one 
> thread here where the poster said it made all the difference for him, so 
> try that.  And the -f should force a filesystem sync afterward, so you 
> know the numbers from any report you run afterward match the final state.

Reading the corresponding manual, the -t explanation says that "any
extent bigger than this size will be considered already defragged". So I
guess setting -t1 might've fixed the problem too...but after checking
the source, I'm not so sure.

I didn't find the -t default in the manpages - after browsing through
the source, the default is in the kernel:
https://github.com/torvalds/linux/blob/4f671fe2f9523a1ea206f63fe60a7c7b3a56d5c7/fs/btrfs/ioctl.c#L1268
(Not sure what units those are.)

I wonder if this is relevant:
https://github.com/torvalds/linux/blob/4f671fe2f9523a1ea206f63fe60a7c7b3a56d5c7/fs/btrfs/ioctl.c#L2572

This seems to reset the -t flag if compress (-c) is set? This looks a
bit fishy?

> Meanwhile, you may consider using the nocow attribute on those database 
> files.  It will disable compression on them,

I'm using btrfs specifically to get compression, so this isn't an option.

> While initial usage will  be higher due to the lack of compression,
> as you've discovered, over time, on an actively updated database,
> compression isn't all that effective anyway.

I don't see why. If you're referring to the additional overhead of
continuously compressing and decompressing everything - yes, of course.
But in my case I have a mostly-append workload to a huge amount of
fairly compressible data that's on magnetic storage, so compression is a
win in disk space and perhaps even in performance.

I'm well aware of the many caveats in using btrfs for databases -
they're well documented and although I much appreciate your extended
explanation, it wasn't new to me.

It turns out that if your dataset isn't update heavy (so it doesn't
fragment to begin with), or has to be queried via indexed access (i.e.
mostly via random seeks), the fragmentation doesn't matter much anyway.
Conversely, btrfs appears to have better sync performance with multiple
threads, and allows one to disable part of the partial-page-write
protection logic in the database (full_page_writes=off for PostgreSQL),
because btrfs is already doing the COW to ensure those can't actually
happen [1].

The net result is a *boost* from about 40 tps (ext4) to 55 tps (btrfs),
which certainly is contrary to popular wisdom. Maybe btrfs would fall
off eventually as fragementation does set in gradually, but given that
there's an offline defragmentation tool that can run in the background,
I don't care.

[1] I wouldn't be too surprised if database COW, which consists of
journal-writing a copy of the data out of band, then rewriting it again
in the original place, is actually functionally equivalent do disabling
COW in the database and running btrfs + defrag. Obviously you shouldn't
keep COW enabled in btrfs *AND* the DB, requiring all data to be copied
around at least 3 times...which I'm afraid almost everyone does because
it's the default...

-- 
GCP
