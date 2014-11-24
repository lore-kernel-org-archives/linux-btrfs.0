Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:54430 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaKXD2l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Nov 2014 22:28:41 -0500
Message-ID: <1416799709.4998.13.camel@kernel.crashing.org>
Subject: Re: [GIT PULL] Btrfs deadlock fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Chris Mason <clm@fb.com>
Cc: torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Nov 2014 14:28:29 +1100
In-Reply-To: <1416788843.3019.2@mail.thefacebook.com>
References: <20141123151439.GA16816@ret.masoncoding.com>
	 <1416788595.4998.5.camel@kernel.crashing.org>
	 <1416788843.3019.2@mail.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2014-11-23 at 19:27 -0500, Chris Mason wrote:
> This should be from CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y.  I do test
> with this on here, but I'll look it over for ppc related fun.
> 
> The deadlock fix from this pull shouldn't be related.  Just to make 
> sure I read your email right, this stall isn't new with rc6 is it?

No, I observed it with -rc4 which is the first 3.18 I tried on this
specific machine. I can try to bisect but it will take a while, it
didn't happen afaik with 3.17

Cheers,
Ben.


