Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35140 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbbLKCc7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Dec 2015 21:32:59 -0500
Received: by mail-ig0-f169.google.com with SMTP id su19so29850874igc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Dec 2015 18:32:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5669FE64.2090308@anonym.com>
References: <1448340960.14125.51.camel@scientia.net>
	<pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
	<1448400350.21291.88.camel@scientia.net>
	<pan$3a1c9$86b20059$6602684a$c91a5eb4@cox.net>
	<1449635882.20578.2.camel@scientia.net>
	<pan$eafa8$b5da4379$31bc32b1$5bc4c9a0@cox.net>
	<1449782004.7032.19.camel@scientia.net>
	<5669FE64.2090308@anonym.com>
Date: Thu, 10 Dec 2015 19:32:58 -0700
Message-ID: <CAJCQCtR+8V5Kp6kYD3SsOpBQWi8_hc=m-FoumSkb5b4cQf0MBQ@mail.gmail.com>
Subject: Re: subvols, ro- and bind mounts - how?
From: Chris Murphy <lists@colorremedies.com>
To: "S.J." <sorry@anonym.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 3:36 PM, S.J. <sorry@anonym.com> wrote:

> Quote:
>
> " Most mount options apply to the whole filesystem, and only the options for
> the first subvolume
> to be mounted will take effect. This is due to lack of implementation and
> may change in the future. "
>
> from https://btrfs.wiki.kernel.org/index.php/Mount_options in a red box on
> the top.

That seems due for a revision because I do rw, ro, rw, rw, ro mounts
in sequence and they stick fine. In fact they stick with the same
subvolume.

[root@f23m ]# mount /dev/sda7 /mnt/1 -o subvol=home
[root@f23m ]# mount /dev/sda7 /mnt/2 -o subvol=home,ro
[root@f23m ]# mount /dev/sda7 /mnt/3 -o subvol=home
[root@f23m ]# mount
[...snip...]
/dev/sda7 on /mnt/1 type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=258,subvol=/home)
/dev/sda7 on /mnt/2 type btrfs
(ro,relatime,seclabel,ssd,space_cache,subvolid=258,subvol=/home)
/dev/sda7 on /mnt/3 type btrfs
(rw,relatime,seclabel,ssd,space_cache,subvolid=258,subvol=/home)

And Project Atomic, a.k.a. ostree and rpm-ostree etc., depend on
mounting different parts of the same fs volume to different mounts
points with different read and read/write settings (bind mounts), and
that works too. http://projectatomic.io/


-- 
Chris Murphy
