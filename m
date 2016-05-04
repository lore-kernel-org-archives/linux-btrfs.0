Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37907 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbcEDS4w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 14:56:52 -0400
Received: by mail-ig0-f175.google.com with SMTP id m9so56534381ige.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 11:56:52 -0700 (PDT)
Subject: Re: /etc/fstab rootfs options vs grub2 rootflags cmdline
To: Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>
References: <79249c4d-eab0-43fa-a6ae-b670699891dc@linuxsystems.it>
 <pan$7b1b$2e968d2f$7ddc7045$1ba7386@cox.net>
 <f8233c24-e336-4d31-a4cb-f3b0f97d1305@linuxsystems.it>
 <CAJCQCtQ5q_VUw0rCWWRZBFo=Lhx0ouYeuCDMxDLxcWKowUwbUw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <09be130c-b0db-8419-fb8c-53a7e2d8e8e5@gmail.com>
Date: Wed, 4 May 2016 14:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ5q_VUw0rCWWRZBFo=Lhx0ouYeuCDMxDLxcWKowUwbUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-04 14:07, Chris Murphy wrote:
> On Wed, May 4, 2016 at 7:52 AM, Niccolò Belli <darkbasic@linuxsystems.it> wrote:
>
>
>> I tried to add rootflags=noatime,compress=lzo,discard,autodefrag to
>> GRUB_CMDLINE_LINUX in /etc/default/grub as you suggested but my system
>> didn't manage to boot, probably because grub automatically adds
>> rootflags=subvol=@ and only a single rootflags can be taken into account. Do
>> you have any suggestion?
>
> Well, strictly speaking none of these options are necessary as
> rootflags at boot time because ostensibly on most distros the file
> system is read only until it reads fstab and then remounts rw with all
> of your options. So it doesn't matter that some of them are missing.
> If your distro immediately mounts btrfs rw (I think Ubuntu does?) then
> it's a small problem for a small number of files that get touched
> during startup. I don't think it's worth the hassle.
For what it's worth:
1. This only applies on systems using an initramfs.  IF you're using 
systemd, you're using an initramfs, but it's still worth remembering.
2. Some options can't be set in rootflags (the lazytime mount option for 
example, as well as some of the FS specific ones).
3. Some options can't be changed during a remount from ro to rw (mostly 
FS specific ones, I don't know of any right now for BTRFS that can't be 
changed though.
