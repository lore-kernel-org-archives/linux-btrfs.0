Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33722 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757879AbcILMlM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:41:12 -0400
Received: by mail-oi0-f48.google.com with SMTP id y2so310713050oie.0
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 05:41:11 -0700 (PDT)
Subject: Re: Small fs
To: Martin Steigerwald <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
 <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
 <1771908.LWBdy5fQ5X@merkaba>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <3e8e686c-9c42-a1e1-a0ac-9eb27208360d@gmail.com>
Date: Mon, 12 Sep 2016 08:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <1771908.LWBdy5fQ5X@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-11 15:21, Martin Steigerwald wrote:
> Am Sonntag, 11. September 2016, 21:56:07 CEST schrieb Imran Geriskovan:
>> On 9/11/16, Duncan <1i5t5.duncan@cox.net> wrote:
>>> Martin Steigerwald posted on Sun, 11 Sep 2016 17:32:44 +0200 as excerpted:
>>>>> What is the smallest recommended fs size for btrfs?
>>>>> Can we say size should be in multiples of 64MB?
>>>>
>>>> Do you want to know the smalled *recommended* or the smallest *possible*
>>>> size?
>>
>> In fact both.
>> I'm reconsidering my options for /boot
>
> Well my stance on boot still is: Ext4. Done.
>
> :)
>
> It just does not bother me. It practically makes no difference at all. It has
> no visible effect on my user experience and I never saw the need to snapshot /
> boot.
FWIW, I use BTRFS for /boot, but it's not for snapshotting or even the 
COW, it's for DUP mode and the error recovery it provides.  Most people 
don't think about this if it hasn't happened to them, but if you get a 
bad read from /boot when loading the kernel or initrd, it can 
essentially nuke your whole system.  I run BTRFS for /boot in DUP mode 
with mixed-bg (because I only use 512MB for boot) to mitigate the chance 
that a failed read has any impact, and ensure that if it does, it will 
refuse to boot instead of booting with a corrupted kernel or initrd.
>
> But another approach in case you want to use BTRFS for /boot is to use a
> subvolume. Thats IMHO the SLES 12 default setup. They basically create
> subvolumes for /boot, /var, /var/lib/mysql – you name it. Big advantage: You
> have one big FS and do not need to plan space for partitions or LVs.
> Disadvantage: If it breaks, it breaks.
>
> That said, I think at a new installation I may do this for /boot. Just put it
> inside a subvolume.
>
> From my experiences at work with customer systems and even some systems I
> setup myself, I often do not use little partitions anymore. I did so for a
> CentOS 7 training VM, just 2 GiB XFS for /var. Guess what happened? Last
> update was too long ago, so… yum tried to download a ton of packages and then
> complained it has not enough space in /var. Luckily I used LVM, so I enlarged
> partition LVM resides on, enlarged PV and then enlarged /var. There may be
> valid reasons to split things up, and I am quite comfortable with splitting /
> boot out, cause its, well, plannable easily enough. And it may make sense to
> split /var or /var/log out. But on BTRFS I would likely use subvolumes. Only
> thing I may separate would be /home to make it easier on a re-installation of
> the OS to keep it around. That said, I never ever reinstalled the Debian on
> this ThinkPad T520 since I initially installed it. And on previous laptops I
> even copied the Debian on the older laptop onto the newer laptop. With the
> T520 I reinstalled, cause I wanted to switch to 64 bit cleanly.
>
Yeah, small partitions make sense in some cases, but in a lot of places 
they're typically used, there are perfectly legitimate reasons to 
suddenly need multiple gigabytes of extra space for a short period of 
time.  In my case, the only partition that I have split out that's less 
than a few GB is /boot, but I usually split out /usr/src and 
/usr/portage, because I need them to be fast, and run /tmp and /var/tmp 
on tmpfs (so technically split out).  I personally see little value in 
splitting out /home on a single user system unless you're multi-booting 
or planning to switch distros at some point (or are running a distro 
that needs special handling to do release upgrades).

