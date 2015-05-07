Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:34267 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbbEGEEe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 00:04:34 -0400
Received: by iedfl3 with SMTP id fl3so33938798ied.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 21:04:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20150505T131847-769@post.gmane.org>
References: <loom.20150505T131847-769@post.gmane.org>
From: Paul Harvey <csirac2@gmail.com>
Date: Thu, 7 May 2015 14:04:12 +1000
Message-ID: <CAB3_QuK_QhtC_Zyjaafa9oQEv_pV0uhmRibW=kRYy=n_cW=JHA@mail.gmail.com>
Subject: Re: btrfs send/receive for backup of subvolumes
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Disclaimer: I'm just a btrfs user, not an expert.

When dealing with a snapshot/subvolume, it should not matter how it
was created - once instantiated, the file contents should always be
the same. The resulting filesystem on the destination you've targeted
with "btrfs receive" should be usable in exactly in the same way as
the original regardless of whether it was created using an incremental
send or otherwise.

If you'd like some guarantee other than just blind faith that this is
the case, I've written a script [1] to help report sha512sums and PGP
signatures of directories. I wrote it to detect if the content of my
snapshots remain exactly (or at least mostly - see [2]) the same
regardless of what the eventual filesystem is (btrfs or not) and how
many send/receive transports had occurred.

You may find the full set of my scripts at [3] useful, the main script
can automatically snapshot all of your btrfs filesystems and each of
their subvolumes (or not, if you like). It does so by creating
snapshots under a '.snapshotz' directory in the root of each
subvolume, in the form of:
/path/to/subvol/.snapshotz/
YYYY-MM-DDTHHMMSS+hhmm (i.e. a valid
isodate). It also takes care of snapshot pruning, accumulating
measurement reports, and I've included some helper scripts to automate
transport of snapshots over ssh or between local filesystems.

Feel free to share any feedback you may have, but check the list of
bugs at [4] before you start using this code seriously.

[1] https://github.com/csirac2/snazzer/blob/master/doc/snazzer-measure.md
[2] https://bugzilla.kernel.org/show_bug.cgi?id=95201
[3] https://github.com/csirac2/snazzer
[4] https://github.com/csirac2/snazzer/issues
