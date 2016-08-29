Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56896 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755123AbcH2Ru1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 13:50:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1beQhU-0002pO-FF
        for linux-btrfs@vger.kernel.org; Mon, 29 Aug 2016 19:50:24 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs send extremely slow (almost stuck)
Date: Mon, 29 Aug 2016 19:50:18 +0200
Message-ID: <20160829195018.7a87a1fd@jupiter.sol.kaishome.de>
References: <c7cb948d-5831-7b97-937e-c21c5335e76c@googlemail.com>
        <CA+X5Wn6BPhSR4Zsjp9xOgOap=GXKE2bCcgFtbpouMJ2y+++Qwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 28 Aug 2016 17:41:22 -0400
schrieb james harvey <jamespharvey20@gmail.com>:

> On Sun, Aug 28, 2016 at 12:15 PM, Oliver Freyermuth
> <o.freyermuth@googlemail.com> wrote:
> > For me, this means I have to stay with rsync backups, which are
> > sadly incomplete since special FS attrs like "C" for nocow are not
> > backed up.  
> 
> Should be able to make a script that creates a textfile with lsattr
> for every file.  Then either just leave that file as part of the
> backup in case it's needed some day, or making a corresponding script
> on the backup machine to restore those.

The problem with this idea is that chattr +C will only work on empty
files, so it needs to be applied in the "middle", read: upon creating
the file and before filling it with content.

It would be possible to let a script first create empty files according
to this list and then use "rsync --no-whole-file --inplace" so it will
build upon the empty files instead of its usual behavior to create
files temporarily and then rename them into place. I'd recommend to use
these options anyways if writing to btrfs snapshots to take advantage
of shared extents. Apparently rsync cannot handle sparse files in this
mode (tho there should be a patch to make this possible by using the
hole-punching feature of newer kernels but it makes the rsync protocol
incompatible to unpatched versions AFAIR).

I think borgbackup suffers from the same problem. While in latest
version it seems to support attrs, it does apply them after filling the
files with contents (as most programs do, also attributes like mtime,
owner etc are applied after closing the written file, for obvious
reasons). This simply doesn't work for +C on btrfs.

-- 
Regards,
Kai

Replies to list-only preferred.

