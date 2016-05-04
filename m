Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35967 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbcEDSHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 14:07:40 -0400
Received: by mail-oi0-f51.google.com with SMTP id x201so75083964oif.3
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 11:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f8233c24-e336-4d31-a4cb-f3b0f97d1305@linuxsystems.it>
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
	<pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
	<f8233c24-e336-4d31-a4cb-f3b0f97d1305@linuxsystems.it>
Date: Wed, 4 May 2016 12:07:39 -0600
Message-ID: <CAJCQCtQ5q_VUw0rCWWRZBFo=Lhx0ouYeuCDMxDLxcWKowUwbUw@mail.gmail.com>
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 4, 2016 at 7:52 AM, Niccolò Belli <darkbasic@linuxsystems.it> wrote:


> I tried to add rootflags=noatime,compress=lzo,discard,autodefrag to
> GRUB_CMDLINE_LINUX in /etc/default/grub as you suggested but my system
> didn't manage to boot, probably because grub automatically adds
> rootflags=subvol=@ and only a single rootflags can be taken into account. Do
> you have any suggestion?

Well, strictly speaking none of these options are necessary as
rootflags at boot time because ostensibly on most distros the file
system is read only until it reads fstab and then remounts rw with all
of your options. So it doesn't matter that some of them are missing.
If your distro immediately mounts btrfs rw (I think Ubuntu does?) then
it's a small problem for a small number of files that get touched
during startup. I don't think it's worth the hassle.

If you think it's worth the hassle, then you have to directly modify
the grub.cfg to include an expanded rootflags parameter. Right now
grub-mkconfig logic doesn't not include all options in fstab for
rootflags.

-- 
Chris Murphy
