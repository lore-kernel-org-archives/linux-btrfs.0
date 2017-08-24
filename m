Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34977 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753827AbdHXV40 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 17:56:26 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dl06r-0005Ul-4e
        for linux-btrfs@vger.kernel.org; Thu, 24 Aug 2017 23:56:17 +0200
To: linux-btrfs@vger.kernel.org
From: Ferry Toth <ftoth@telfort.nl>
Subject: Re: number of subvolumes
Date: Thu, 24 Aug 2017 21:56:07 +0000 (UTC)
Message-ID: <onni1n$bic$2@blaine.gmane.org>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
        <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
        <20170822142451.GI14804@rus.uni-stuttgart.de>
        <20170822214531.44538589@natsu>
        <20170822165725.GL14804@rus.uni-stuttgart.de>
        <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
        <20170822180155.GM14804@rus.uni-stuttgart.de>
        <22940.31139.194399.982315@tree.ty.sabi.co.uk>
        <20170822204811.GO14804@rus.uni-stuttgart.de>
        <20170823071821.GA28319@rus.uni-stuttgart.de>
        <f75e66d.7ade2c40.15e0e3ced5c@gmail.com> <onkbkk$qs1$1@blaine.gmane.org>
        <BD7091A7-DE7F-4A86-9BDE-8BA63060CBAF@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Op Thu, 24 Aug 2017 22:40:54 +0300, schreef Marat Khalili:

>> We find that typically apt is very slow on a machine with 50 or so
>> snapshots and raid10. Slow as in probably 10x slower as doing the same
>> update on a machine with 'single' and no snapshots.
>>
>> Other operations seem to be the same speed, especially disk benchmarks
>> do not seem to indicate any performance degradation.
> 
> For meaningful discussion it is important to take into account the fact

Doing daily updates on a desktop is not uncommon and when 3 minutes 
become 30 then many would call that meaningfull.

Similar for a single office server, which is upgraded twice a year, where 
an upgrade normally would take an hour or 2, but now more than a working 
day. In the meantime, take samba and postgresql offline, preventing 
people to work for a few hours.

My point is: fsync is not targeted specifically in many common disk bench 
marks (phoronix?), it might be posible that there is no trigger to spend 
much time on optimizations in that area. That doesn't make it meaningless.

> that dpkg infamously calls fsync after changing every bit of
> information, so basically you're measuring fsync speed. Which is slow on
> btrfs (compared to simpler filesystems), but unrelated to normal work.

OTOH it would be nice if dpkg would at last start making use btrfs 
snapshot features and abandon these unnecssary fsyncs completely, instead 
restoring a failed install from a snapshot. This would probably result in 
a performance improve compared to ext4.

> I've got two near-identical servers here with several containers each
> different only on in filesystem: btrfs-raid1 on one (for historical
> reasons) and ext4/mdadm-raid1 on another, no snapshots, no reflinks.
> Each time containers on ext4 update several times faster, but in
> everyday operation there's no significant difference.
> --
> 
> With Best Regards,
> Marat Khalili


