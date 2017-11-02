Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:46432 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933083AbdKBBjm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 21:39:42 -0400
Received: by mail-wm0-f53.google.com with SMTP id m72so7903472wmc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 18:39:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9e274506-9780-bb74-8ba0-e5fa6c9663c3@gmail.com>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl> <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl> <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net> <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk> <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
 <9e274506-9780-bb74-8ba0-e5fa6c9663c3@gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Wed, 1 Nov 2017 21:39:20 -0400
Message-ID: <CAH=dxU5Xx4naY9VR5ri92afHXm9-04DLvOG=E5QLRtKn7Q5s5w@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 1, 2017 at 8:21 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>> The cache is in a separate location from the profiles, as I'm sure you
>> know.  The reason I suggested a separate BTRFS subvolume for
>> $HOME/.cache is that this will prevent the cache files for all
>> applications (for that user) from being included in the snapshots. We
>> take frequent snapshots and (afaik) it makes no sense to include cache
>> in backups or snapshots. The easiest way I know to exclude cache from
>> BTRFS snapshots is to put it on a separate subvolume. I assumed this
>> would make several things related to snapshots more efficient too.
>
> Yes, it will, and it will save space long-term as well since $HOME/.cache is
> usually the most frequently modified location in $HOME. In addition to not
> including this in the snapshots, it may also improve performance.  Each
> subvolume is it's own tree, with it's own locking, which means that you can
> generally improve parallel access performance by splitting the workload
> across multiple subvolumes.  Whether it will actually provide any real
> benefit in that respect is heavily dependent on the exact workload however,
> but it won't hurt performance.

I'm going to make this change now. What would be a good way to
implement this so that the change applies to the $HOME/.cache of each
user?

The simple way would be to create a new subvolume for each existing
user and mount it at $HOME/.cache in /etc/fstab, hard coding that
mount location for each user. I don't mind doing that as there are
only 4 users to consider. One minor concern is that it adds an
unexpected step to the process of creating a new user. Is there a
better way?
