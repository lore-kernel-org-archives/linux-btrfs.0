Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35869 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbcJGT6q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Oct 2016 15:58:46 -0400
Received: by mail-qk0-f170.google.com with SMTP id o68so52342809qkf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Oct 2016 12:57:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161007122651.5125-1-dsterba@suse.com>
References: <20161007122651.5125-1-dsterba@suse.com>
From: Justin Maggard <jmaggard10@gmail.com>
Date: Fri, 7 Oct 2016 12:57:58 -0700
Message-ID: <CAKgsxVQsy4E0HVUPK3jYum75GyMvuui_sAVOkzDeAAL8f1zUtQ@mail.gmail.com>
Subject: Re: Btrfs progs pre-release 4.8.1-rc1
To: David Sterba <dsterba@suse.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On Fri, Oct 7, 2016 at 5:26 AM, David Sterba <dsterba@suse.com> wrote:
> Hi,
>
> another pre-release, just in case.  I did a lot of build tests [1] and
> automated a few things so the build failures should not happen again.
>
> ETA for the release is on Sunday (2016-10-09).  Please test and report any new
> problems.
>
> Changes since 4.8:
> - 32bit build works

This is falling over on my 32-bit ARM platform.  Using stock Debian
Jessie armel or armhf, it builds now, but the send ioctl is unhappy:

# btrfs send -p /data/test/.snapshots/1/snapshot/
/data/test/.snapshots/2/snapshot/ > /dev/null
At subvol /data/test/.snapshots/2/snapshot/
ERROR: send ioctl failed with -25: Inappropriate ioctl for device

If I remove the packed attribute from the btrfs_ioctl_send_args struct
and change the BUILD_ASSERT to expect a 72-byte structure, it all
starts working again.  I'm using a 4.1 kernel built with the standard
armhf toolchain from Wheezy (gcc 4.7.2).

-Justin
