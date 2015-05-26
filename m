Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33138 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbbEZMfA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 08:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <20150523000905.GA16230@ret.masoncoding.com>
References: <20150523000905.GA16230@ret.masoncoding.com>
Date: Tue, 26 May 2015 08:33:23 -0400
Message-ID: <CA+5PVA7yA-q3V_KHp-zL+4G_bO9Fp4i0jH_UXdez0r+4D4KqYQ@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 22, 2015 at 9:14 PM, Chris Mason <clm@fb.com> wrote:
> Hi Linus,
>
> My for-linus-4.1 branch has three more fixes:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-4.1
>
> I fixed up a regression from 4.0 where conversion between different raid
> levels would sometimes bail out without converting.
>
> Filipe tracked down a race where it was possible to double allocate
> chunks on the drive.
>
> Mark has a fix for fiemap.  All three will get bundled off for stable as
> well.
>
> Chris Mason (1) commits (+18/-0):
>     Btrfs: fix regression in raid level conversion

Shouldn't this be CC'd to stable since it fixes a broken commit in 4.0?

josh
