Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:38204 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752227AbdHVSih (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 14:38:37 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:55266)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dkE4R-0003dP-Qn
        for linux-btrfs@vger.kernel.org; Tue, 22 Aug 2017 19:38:35 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dkE2F-0003A6-Hr
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 19:36:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22940.31139.194399.982315@tree.ty.sabi.co.uk>
Date: Tue, 22 Aug 2017 19:36:19 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: netapp-alike snapshots?
In-Reply-To: <20170822180155.GM14804@rus.uni-stuttgart.de>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
        <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
        <20170822142451.GI14804@rus.uni-stuttgart.de>
        <20170822214531.44538589@natsu>
        <20170822165725.GL14804@rus.uni-stuttgart.de>
        <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
        <20170822180155.GM14804@rus.uni-stuttgart.de>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

>>>> It is beneficial to not have snapshots in-place. With a local
>>>> directory of snapshots, [ ... ]

Indeed and there is a fair description of some options for
subvolume nesting policies here which may be interesting to the
original poster:

  https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Layout

It is unsurprising to me that there are tradeoffs involved in
every choice. I find the "Flat" layout particularly desirable.

>>> Netapp snapshots are invisible for tools doing opendir()/
>>> readdir() One could simulate this with symlinks for the
>>> snapshot directory: store the snapshot elsewhere (not inplace)
>>> and create a symlink to it, in every directory.

More precisely in every subvolume root directory.

>>> My users want the snapshots locally in a .snapshot
>>> subdirectory.

Btrfs snapshots can only be done for a whole subvolume. Subvolumes
and snapshots can be created by users, but too many snapshots (see
below) can cause trouble. For somewhat good reasons subvolumes
including snapshots cannot be deleted by users though unless mount
option 'user_subvol_rm_allowed' is used.

>>> Because Netapp do it this way - for at least 20 years and we
>>> have a multi-PB Netapp storage environment. No chance to change
>>> this.

Send patches :-).

> Not only du works recursivly, but also find and with option
> also ls, grep, etc.

Note also that subvolume root directory inodes are indeed root
directory inodes so they can be 'mount'ed and therefore the
transition from a subvolume into a contained subvolume can be
detected at the mountpoint.

So 'find' has the '-xdev' option and 'du' has the '-x' options and
so similarly nearly all other tools, so perhaps someone expects
that to happen :-).

> And it would require a bind mount for EVERY directory. There can
> be hundreds... thousends!

Assumptions that all Btrfs features such as snapshots are
infinitely scalable at no cost may be optimistic:

  https://btrfs.wiki.kernel.org/index.php/Gotchas#Having_many_subvolumes_can_be_very_slow
