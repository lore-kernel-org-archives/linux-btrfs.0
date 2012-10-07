Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57720 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2JGOoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 10:44:21 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
Date: Sun, 7 Oct 2012 16:44:19 +0200
Cc: =?utf-8?q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>,
        Alex <alex@bpmit.com>
References: <50714AC8.4010100@petaramesh.org> <loom.20121007T141248-114@post.gmane.org> <50718151.8090506@petaramesh.org> (sfid-20121007_163445_311645_DBA4D8EF)
In-Reply-To: <50718151.8090506@petaramesh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210071644.19815.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Oktober 2012 schrieb Swâmi Petaramesh:
> Hi again ;-)
> 
> Le 07/10/2012 14:33, Alex a écrit :
> > 1. Convert to a 16k or 32k leafsize.
> 
> How should I do this ? Can I do this on a live FS, and isn't this going
> to double my on-disk used space (I have active snapshots...)

I think you need to backup, reformat and restore from backup for now.

> > 2. defragment (each non-trivial file) every now and again
> 
> I believed that the "autodefrag" mount option was supposed to avoid the
> need for manual defrags...?

In theory yes. But AFAIR it is currently limited to certain usecases.

> Plus, with respect to snapshots, isn't this going to increase a lot my
> used disk space ?

I don´t think so, but I will leave this to a developer to answer.

> > 3. Note that btrfs in kernel 3.6 (vs 3.5) does appear to be quite a
> > bit quicker.
> 
> I'm not sure that "a bit" quicker will be enough, when I see my BTRFS
> is currently about 8x slower than what ext4 user to...

How did you measure this? Is this just the boot times you mentioned in the 
original article?

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
