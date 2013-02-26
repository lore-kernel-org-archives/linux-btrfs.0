Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab3BZUX6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 15:23:58 -0500
Message-ID: <512D19DA.7030008@redhat.com>
Date: Tue, 26 Feb 2013 14:23:54 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
References: <511D2D2B.8040804@redhat.com> <5124EDAB.5020003@giantdisaster.de>
In-Reply-To: <5124EDAB.5020003@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/20/13 9:37 AM, Stefan Behrens wrote:

...

> This means that it is now required to change all occurrences of
> "mkfs.btrfs" to "mkfs.btrfs -f" everywhere. Can't we first establish a
> time period of 100 years where the -f option is tolerated and ignored,
> and then in 2113 we require that the users add the -f option?
> 
> (Just had to do this string replacement everywhere, and had to add -f to
> xfstest's _scratch_mkfs in common.rc as well). Sigh.

I'll send a patch today to make xfstests handle both variants cleanly,
I should have done that earlier, sorry.

-Eric

