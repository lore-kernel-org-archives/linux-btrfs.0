Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35121 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbeHSLsV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Aug 2018 07:48:21 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: waxhead@dirtcellar.net
Cc: Adam Hunt <voxadam@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: lazytime mount =?UTF-8?B?b3B0aW9u4oCUbm8=?= support in Btrfs
Date: Sun, 19 Aug 2018 10:37:35 +0200
Message-ID: <2641568.fxl50hTsRH@merkaba>
In-Reply-To: <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
References: <ompef3$sim$1@blaine.gmane.org> <a9037e77-5ea6-fadd-23a1-6cd1f2770220@dirtcellar.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

waxhead - 18.08.18, 22:45:
> Adam Hunt wrote:
> > Back in 2014 Ted Tso introduced the lazytime mount option for ext4
> > and shortly thereafter a more generic VFS implementation which was
> > then merged into mainline. His early patches included support for
> > Btrfs but those changes were removed prior to the feature being
> > merged. His> 
> > changelog includes the following note about the removal:
> >    - Per Christoph's suggestion, drop support for btrfs and xfs for
> >    now,
> >    
> >      issues with how btrfs and xfs handle dirty inode tracking.  We
> >      can add btrfs and xfs support back later or at the end of this
> >      series if we want to revisit this decision.
> > 
> > My reading of the current mainline shows that Btrfs still lacks any
> > support for lazytime. Has any thought been given to adding support
> > for lazytime to Btrfs?
[…]
> Is there any new regarding this?

I´d like to know whether there is any news about this as well.

If I understand it correctly this could even help BTRFS performance a 
lot cause it is COW´ing metadata.

Thanks,
-- 
Martin
