Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35513 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbcBXWcP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 17:32:15 -0500
Received: by mail-lb0-f170.google.com with SMTP id bc4so18932291lbc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 14:32:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
	<72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
Date: Wed, 24 Feb 2016 23:32:13 +0100
Message-ID: <CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 6:44 PM, Nazar Mokrynskyi <nazar@mokrynskyi.com> wrote:
> Looks like btrfstune -x did nothing, probably, it was already used at
> creation time, I'm using rcX versions of kernel all the time and rolling
> version of Ubuntu, so this is very likely to be the case.

The command    btrfs-show-super   shows the features of the
filesystem. You have a 'dummy' single profiles on the HDD fs and that
gives me a hint that you likely have used older tools to create the
fs. The current kernel does not set this feature flag on disk. If the
flag was already set, then no difference in performance.

If it was not set, then from now on, new metadata extents should be
skinny, which saves on total memory size and processing for (the
larger) filesystems. But for your existing data (snapshot subvolumes
in your  case) the metadata is then still non-skinny. So you won't
notice an instant difference only after all exiting fileblocks are
re-written or removed.
You will probably have a measurable difference if you equally fill 2
filesystems, one with and the other without the flag.

> One thing I've noticed is much slower mount/umount on HDD than on SSD:
>
>> nazar-pc@nazar-pc ~> time sudo umount /backup
>> 0.00user 0.00system 0:00.01elapsed 36%CPU (0avgtext+0avgdata
>> 7104maxresident)k
>> 0inputs+0outputs (0major+784minor)pagefaults 0swaps
>> nazar-pc@nazar-pc ~> time sudo mount /backup
>> 0.00user 0.00system 0:00.03elapsed 23%CPU (0avgtext+0avgdata
>> 7076maxresident)k
>> 0inputs+0outputs (0major+803minor)pagefaults 0swaps
>> nazar-pc@nazar-pc ~> time sudo umount /backup_hdd
>> 0.00user 0.11system 0:01.04elapsed 11%CPU (0avgtext+0avgdata
>> 7092maxresident)k
>> 0inputs+15296outputs (0major+787minor)pagefaults 0swaps
>> nazar-pc@nazar-pc ~> time sudo mount /backup_hdd
>> 0.00user 0.02system 0:04.45elapsed 0%CPU (0avgtext+0avgdata
>> 7140maxresident)k
>> 14648inputs+0outputs (0major+795minor)pagefaults 0swaps
>
> It is especially long (tenth of seconds with hight HDD load) when called
> after some time, not consequently.
>
> Once it took something like 20 seconds to unmount filesystem and around 10
> seconds to mount it.

Those are quite typical values for an already heavily used btrfs on a HDD.

>> About memory - 16 GiB of RAM should be enough I guess:) Can I measure
>> somehow if seeking is a problem?

I don't know a tool that can measure seek times and gather statistics
over and extended period of time and relate that to filesystem
internal actions. It would be best if all this were done by the HDD
firmware (under command of the filesystem code). One can make a model
of it I think, but the question is how good that is for modern drives.
