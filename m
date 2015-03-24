Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:37045 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbbCXKkW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 06:40:22 -0400
Received: by igcxg11 with SMTP id xg11so420116igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2015 03:40:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <551104B9.2010105@oracle.com>
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
	<550FCD9C.1000706@oracle.com>
	<CAGfcS_miW0=6A7a5PAQZcseCbS1KDpTPM7woKTosMjnAB3C3Cw@mail.gmail.com>
	<CAGfcS_nmUyBMZyrr_9pzvKxVFMJVfsmPb3DM83aaxCSUTj-2NA@mail.gmail.com>
	<551104B9.2010105@oracle.com>
Date: Tue, 24 Mar 2015 06:40:21 -0400
Message-ID: <CAGfcS_nc03H7ekvHBjZF7wEp2wFXuCXPA4Ar09mte4-+jOQKUA@mail.gmail.com>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: "G. Richard Bellamy" <rbellamy@pteradigm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 24, 2015 at 2:31 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
> Do you have this fix ..
>
>  [PATCH] Btrfs: release path before starting transaction in can_nocow_extent
>
> could you try ?.

I believe I already have this patch.  3.18.9 contains this:

commit bdeeab62a611f1f7cd48fd285ce568e8dcd0455a
Merge: 797afdf 1bda19e
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Oct 18 16:46:21 2013 -0700

    Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs

    Pull btrfs fix from Chris Mason:
     "Sage hit a deadlock with ceph on btrfs, and Josef tracked it down to a
      regression in our initial rc1 pull.  When doing nocow writes we were
      sometimes starting a transaction with locks held"

    * 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs:
      Btrfs: release path before starting transaction in can_nocow_extent
