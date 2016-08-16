Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36176 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbcHPTj7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 15:39:59 -0400
Received: by mail-oi0-f51.google.com with SMTP id f189so112677954oig.3
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Aug 2016 12:39:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <em5669168d-5565-4286-9e94-0d18f614ee57@laptophendrik>
References: <em5669168d-5565-4286-9e94-0d18f614ee57@laptophendrik>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 16 Aug 2016 13:39:54 -0600
Message-ID: <CAJCQCtRmcHCKGRUSFfDhCs8iy5nTvW2HTQnWsDF1N7f_s03G1Q@mail.gmail.com>
Subject: Re: Debian Jessie: How to set rootflags=degraded
To: Hendrik Friedel <hendrik@friedels.name>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 16, 2016 at 1:31 PM, Hendrik Friedel <hendrik@friedels.name> wrote:
> Hello,
>
> I am using a raid1 under debian Jessie, because I need to decrease the
> likelyhood of unavailability of the system.
> Unfortunately I found, that when removing one of the drives, the system will
> not boot up. Instead initramfs will show up and tell me that the root volume
> could not be mounted.
>
> I read here:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31265.html
> that adding rootflags=degraded.
>
> Furthermore I see that this is not yet default -at least in Ubuntu-
> https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1229456?comments=all
>
> But that it should work by modifying /etc/grub.d/10_linux:
> https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1229456/comments/3
> GRUB_CMDLINE_LINUX="rootflags=subvol=${rootsubvol},degraded
> ${GRUB_CMDLINE_LINUX}"
>
> when doing that and running grub-mkconfig and update-grub, I still get no
> entry with with "degraded" in /etc/grub.cfg.

Well it belongs in /boot/grub2/grub.cfg so maybe you're looking at a
stale file? Otherwise I'm not sure why it wouldn't include degraded.

>
> Can someone tell me, how to achieve this? I've been seaching for very long
> now and I am surprised, that I don't find any answer.


The additional issue is that there's a udev rule (check the archives)
that prevents the volume from being considered ready unless all
devices are found. So even with degraded, out of the box this won't
boot on systemd systems at least, because the mount attempt never
happens. Just be aware that booting degraded unattended really isn't a
great idea because Btrfs doesn't have any concept right now of faulty
devices, so it's likely to cause more problems than it solves. If for
any reason one of the drives becomes available slightly later than the
other, using degraded by default can cause an otherwise healthy volume
to be mounted degraded, SILENTLY. And if this happens to alternate
devices where both devices get separately modified while degraded,
it'll corrupt the entire file system. So you're really better off
choosing another solution until Btrfs matures with this use case in
mind.

-- 
Chris Murphy
