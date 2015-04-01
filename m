Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:36040 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbbDATsW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 15:48:22 -0400
Received: by iedm5 with SMTP id m5so52597305ied.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 12:48:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <551B951A.2030606@oracle.com>
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
	<550FCD9C.1000706@oracle.com>
	<CAGfcS_miW0=6A7a5PAQZcseCbS1KDpTPM7woKTosMjnAB3C3Cw@mail.gmail.com>
	<CAGfcS_nmUyBMZyrr_9pzvKxVFMJVfsmPb3DM83aaxCSUTj-2NA@mail.gmail.com>
	<551104B9.2010105@oracle.com>
	<CAGfcS_nc03H7ekvHBjZF7wEp2wFXuCXPA4Ar09mte4-+jOQKUA@mail.gmail.com>
	<551B951A.2030606@oracle.com>
Date: Wed, 1 Apr 2015 15:48:20 -0400
Message-ID: <CAGfcS_kYpMo-VNp8cSCbzihPsEDzxCnG_V3WrkgqYc6i6gOsTg@mail.gmail.com>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: "G. Richard Bellamy" <rbellamy@pteradigm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 2:50 AM, Anand Jain <Anand.Jain@oracle.com> wrote:
>
> Eric found something like this and has a fix with in the email.
> Sub: "I think "btrfs: fix leak of path in btrfs_find_item" broke stable
> trees ..."
>

I don't mind trying this patch if the maintainers recommend it.  I'm
still getting panics every few days and 3.18.10 won't mount my root
filesystem, so I've been running on 3.18.8.

--
Rich
