Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:32936 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbcFXQrn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 12:47:43 -0400
Received: by mail-oi0-f41.google.com with SMTP id u201so122765111oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 09:47:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5356822.A3RRKHDHNy@linux-omuo>
References: <loom.20160623T205347-371@post.gmane.org> <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 24 Jun 2016 10:47:40 -0600
Message-ID: <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
To: Vasco Almeida <vascomalmeida@sapo.pt>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 9:52 AM, Vasco Almeida <vascomalmeida@sapo.pt> wrote:

>>
>> From the pasted kernel messages:
>> > Linux version 3.18.34-std473-amd64 (root@rl-sysrcd-p11) (gcc version 4.8.5
>> > (Gentoo 4.8.5 p1.3, pie-0.6.2) ) #2 SMP Tue May 24 20:34:19 UTC 2016
>> 3.18.34 is ancient. Find something newer and try to remount normally.
> Present information concerns openSUSE Leap 42.1 (x86_64) mount of root file
> system at boot time. That should mount it normally. Hope that fits what you
> mean.

OK but it's not mounting it normally, it's still being forced readonly
at btrfs_drop_snapshot and the only thing I'm coming up with search
wise is that it's related to qgroups. Have you enabled quotas on this
file system ever?


> btrfs-progs v4.1.2+20151002

A lot of changes have happened since 4.1.2 I would still use something
newer and try to repair it.


>
> $ /usr/sbin/btrfs fi df /
> Data, single: total=10.01GiB, used=9.06GiB
> System, DUP: total=64.00MiB, used=16.00KiB
> Metadata, DUP: total=1.12GiB, used=596.69MiB
> GlobalReserve, single: total=208.00MiB, used=0.00B
>
> I forgot to mention in last e-mail that I ran Marc MERLIN's scrubbing script
> [1] after mounting the device with "-o ro,recovery" on System Rescue CD.
> Even after that device is forced readonly.

OK but System Rescue CD uses an old kernel by btrfs standards, even
account for all the backports in that particular version:
4.7.3) 2016-06-04:
Standard kernels: Long-Term-Supported linux-3.18.34 (rescue32 + rescue64)

So that's why I'm suggesting you use something newer, like 4.5.x, same
for btrfs-progs. The old versions aren't working. There's no assurance
it'll work with new versions, but that it doesn't get fixed up with
old versions means you either try new versions or you rebuild the file
system. *shrug*


> I would like to find a solution to be able to mount normally readwrite again
> and hopefully understand what caused the issue.

My best guess is qgroup related, there were a lot of problems with
multiple quota implementations and snapshots and openSUSE does take
many many snapshots. So that could be it. But without a reproducer
it's hard to say what caused it.


-- 
Chris Murphy
