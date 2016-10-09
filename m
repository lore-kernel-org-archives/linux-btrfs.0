Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54689 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751066AbcJIUkG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 9 Oct 2016 16:40:06 -0400
Date: Sun, 9 Oct 2016 22:40:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: David Sterba <dsterba@suse.com>, BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: Btrfs progs pre-release 4.8.1-rc1
Message-ID: <20161009204004.GH11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161007122651.5125-1-dsterba@suse.com>
 <CAKgsxVQsy4E0HVUPK3jYum75GyMvuui_sAVOkzDeAAL8f1zUtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKgsxVQsy4E0HVUPK3jYum75GyMvuui_sAVOkzDeAAL8f1zUtQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2016 at 12:57:58PM -0700, Justin Maggard wrote:
> This is falling over on my 32-bit ARM platform.  Using stock Debian
> Jessie armel or armhf, it builds now, but the send ioctl is unhappy:
> 
> # btrfs send -p /data/test/.snapshots/1/snapshot/
> /data/test/.snapshots/2/snapshot/ > /dev/null
> At subvol /data/test/.snapshots/2/snapshot/
> ERROR: send ioctl failed with -25: Inappropriate ioctl for device
> 
> If I remove the packed attribute from the btrfs_ioctl_send_args struct
> and change the BUILD_ASSERT to expect a 72-byte structure, it all
> starts working again.  I'm using a 4.1 kernel built with the standard
> armhf toolchain from Wheezy (gcc 4.7.2).

Thanks for the report, I think I'll drop the additional changes and
release just the build fixes. We'd need to validate that all ioctls
really work on the target build architecture. The potential explanation
for the problem you found is that 32bit arm has 4 byte pointers but
needs 8 byte alignment.
