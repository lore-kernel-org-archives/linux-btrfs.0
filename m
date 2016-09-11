Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:45393 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756197AbcIKTWC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 15:22:02 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Small fs
Date: Sun, 11 Sep 2016 21:21:58 +0200
Message-ID: <1771908.LWBdy5fQ5X@merkaba>
In-Reply-To: <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com> <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net> <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 11. September 2016, 21:56:07 CEST schrieb Imran Geriskovan:
> On 9/11/16, Duncan <1i5t5.duncan@cox.net> wrote:
> > Martin Steigerwald posted on Sun, 11 Sep 2016 17:32:44 +0200 as excerpted:
> >>> What is the smallest recommended fs size for btrfs?
> >>> Can we say size should be in multiples of 64MB?
> >> 
> >> Do you want to know the smalled *recommended* or the smallest *possible*
> >> size?
> 
> In fact both.
> I'm reconsidering my options for /boot

Well my stance on boot still is: Ext4. Done.

:)

It just does not bother me. It practically makes no difference at all. It has 
no visible effect on my user experience and I never saw the need to snapshot /
boot.

But another approach in case you want to use BTRFS for /boot is to use a 
subvolume. Thats IMHO the SLES 12 default setup. They basically create 
subvolumes for /boot, /var, /var/lib/mysql – you name it. Big advantage: You 
have one big FS and do not need to plan space for partitions or LVs. 
Disadvantage: If it breaks, it breaks.

That said, I think at a new installation I may do this for /boot. Just put it 
inside a subvolume.

>From my experiences at work with customer systems and even some systems I 
setup myself, I often do not use little partitions anymore. I did so for a 
CentOS 7 training VM, just 2 GiB XFS for /var. Guess what happened? Last 
update was too long ago, so… yum tried to download a ton of packages and then 
complained it has not enough space in /var. Luckily I used LVM, so I enlarged 
partition LVM resides on, enlarged PV and then enlarged /var. There may be 
valid reasons to split things up, and I am quite comfortable with splitting /
boot out, cause its, well, plannable easily enough. And it may make sense to 
split /var or /var/log out. But on BTRFS I would likely use subvolumes. Only 
thing I may separate would be /home to make it easier on a re-installation of 
the OS to keep it around. That said, I never ever reinstalled the Debian on 
this ThinkPad T520 since I initially installed it. And on previous laptops I 
even copied the Debian on the older laptop onto the newer laptop. With the 
T520 I reinstalled, cause I wanted to switch to 64 bit cleanly.

-- 
Martin
