Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:59598 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab2HBO2L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 10:28:11 -0400
Message-ID: <501A8E7A.6070601@jan-o-sch.net>
Date: Thu, 02 Aug 2012 16:28:10 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <liub.liubo@gmail.com>
CC: Arne Jansen <sensille@gmx.net>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Behrens, Stefan" <sbehrens@strato-rz.de>
Subject: Re: [PATCH v2] Btrfs: remove superblock writing after fatal error
References: <1343821552-28726-1-git-send-email-sbehrens@giantdisaster.de> <50191AD3.9080401@gmail.com> <50192A11.3060109@jan-o-sch.net> <50192FCE.30006@gmail.com> <50193DDA.20504@giantdisaster.de> <501A56E3.3080401@giantdisaster.de> <501A583D.8030600@gmail.com> <501A61ED.3000908@gmx.net> <501A65B9.5060004@gmail.com> <501A6731.4000405@gmx.net> <501A6B0D.6050303@gmail.com> <501A84CA.10604@gmx.net>
In-Reply-To: <501A84CA.10604@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, August 02, 2012 at 15:46 (+0200), Arne Jansen wrote:
> On 02.08.2012 13:57, Liu Bo wrote:
>> Anyway, for now, our error flag has only been stored in memory, so what
>> about just keep it until we find a graceful way?
> 
> Yeah, we need this patch to restore consistency. We can define a fixed
> area on disk (e.g. behind the superblock) where we can write the flag
> to without risking the superblock.

At least we all agree that we need this patch, fine.

We don't yet agree that we need a place to store a "please consider fsck" flag.
Can I please get one concrete example in which situation we

a) do detect the user should really do a file system check AND
b) do not abort the transaction to clean the mess up?

(An example on how we could fail transaction cleanup is also accepted).

If such a situation doesn't exist, there's no need for this flag. The fact that
ext has such a flag doesn't convince me, probably because I know nothing about
ext. I can imagine that they can detect file system errors without the ability
to return to a potentially older consistent state.

Thanks,
-Jan
