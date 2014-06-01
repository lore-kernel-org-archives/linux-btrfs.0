Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64052 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaFAPys (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jun 2014 11:54:48 -0400
Received: by mail-ob0-f170.google.com with SMTP id uy5so3602725obc.15
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 08:54:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140601020750.0283af6c@ws>
References: <20140601020750.0283af6c@ws>
From: Shaun Reich <sreich@kde.org>
Date: Sun, 1 Jun 2014 11:54:06 -0400
Message-ID: <CADVynFBKtAKUACDsmy2fmtBonkoscWSXD-WDr6RAcmxizE+5yQ@mail.gmail.com>
Subject: Re: superblock corruption, cannot obtain data
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Cc: Shaun Reich <sreich@kde.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> How do you know it's a bad superblock?  While I'm not a dev just a list
> regular, show-super looks reasonable from here, and find-root does find
> what appears to be a good root.  From here the problem seems to be a bad
> ctree (of several), not a bad superblock.

yes i think you're right. i think that was just the initial thinking of #btrfs


>
> First thing to try is mounting with nospace_cache.  If that works, try
> mounting with clear_cache and letting it work for a bit to rebuild.

nope, same error.

>
> If that doesn't work, it may simply be the log tree.  btrfs-zero-log is
> used to fix that, but before you try that, read this entry in the FAQ
> and follow the instructions for making a filesystem image to turn in to
> the devs to help them fix such problems, and consider making a backup
> of the damaged filesystem using dd/ddrescue, since the warning about
> making it possibly more difficult to recover if this is NOT the problem
> applies:

tried this, btrfs-image complains about roughly the same error,
btrfs-zero-log said the following: http://bpaste.net/show/328495


> Another thing to try is mounting recovery,ro.  A number of people have
> reported that would work when simple recovery wouldn't, because when
> it was writable btrfs would immediately try to fix the problem and
> immediately fail.

nope, same error.

here's what happens when i run fsck http://cwillu.com:8080/74.84.235.22/3

"Critical roots corrupted, unable to fsck the FS" sounds like
especially good news ;p


--
Shaun Reich,
KDE Software Developer (kde.org)
