Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:42132 "EHLO
        smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752875AbdHXTnF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 15:43:05 -0400
Date: Thu, 24 Aug 2017 22:40:54 +0300
In-Reply-To: <onkbkk$qs1$1@blaine.gmane.org>
References: <20170822132208.GD14804@rus.uni-stuttgart.de> <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com> <20170822142451.GI14804@rus.uni-stuttgart.de> <20170822214531.44538589@natsu> <20170822165725.GL14804@rus.uni-stuttgart.de> <ab52f32.7ade2c3f.15e0af46ee9@gmail.com> <20170822180155.GM14804@rus.uni-stuttgart.de> <22940.31139.194399.982315@tree.ty.sabi.co.uk> <20170822204811.GO14804@rus.uni-stuttgart.de> <20170823071821.GA28319@rus.uni-stuttgart.de> <f75e66d.7ade2c40.15e0e3ced5c@gmail.com> <onkbkk$qs1$1@blaine.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: number of subvolumes
To: Ferry Toth <ftoth@telfort.nl>, linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <BD7091A7-DE7F-4A86-9BDE-8BA63060CBAF@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> We find that typically apt is very slow on a machine with 50 or so snapshots and raid10. Slow as in probably 10x slower as doing the same update on a machine with 'single' and no snapshots.
>
> Other operations seem to be the same speed, especially disk benchmarks do not seem to indicate any performance degradation.

For meaningful discussion it is important to take into account the fact that dpkg infamously calls fsync after changing every bit of information, so basically you're measuring fsync speed. Which is slow on btrfs (compared to simpler filesystems), but unrelated to normal work.

I've got two near-identical servers here with several containers each different only on in filesystem: btrfs-raid1 on one (for historical reasons) and ext4/mdadm-raid1 on another, no snapshots, no reflinks. Each time containers on ext4 update several times faster, but in everyday operation there's no significant difference.
-- 

With Best Regards,
Marat Khalili
