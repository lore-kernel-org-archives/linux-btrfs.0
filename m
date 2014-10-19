Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaJST4S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Oct 2014 15:56:18 -0400
Date: Sun, 19 Oct 2014 21:55:11 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs for stable (mostly 3.17)
Message-ID: <20141019195511.GB1191@kroah.com>
References: <54438BEC.4090708@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54438BEC.4090708@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 19, 2014 at 06:01:16AM -0400, Chris Mason wrote:
> Hi everyone,
> 
> I've pulled out some of the btrfs commits from the merge window that
> we'd like to see in stable.  The full list of sha's from Linus is below,
> you can see 4 of them are only needed on 3.17
> 
> 2fad4e83e12591eb3bd213875b9edc2d18e93383
> 0b4699dcb65c2cff793210b07f40b98c2d423a43 # v3.17
> 12b894cb288d57292b01cf158177b6d5c89a6272
> 78a017a2c92df9b571db0a55a016280f9019c65e
> 4d1a40c66bed0b3fa43b9da5fbd5cbe332e4eccf
> e6c4efd87ab04e5ead363f24e6ac35ed3506d401 # v3.17
> f6acfd50110b335c7af636cf1fc8e55319cae5fc
> 1d52c78afbbf80b58299e076a159617d6b42fe3c
> 75bfb9aff45e44625260f52a5fd581b92ace3e62
> bbe9051441effce51c9a533d2c56440df64db2d7
> 32be3a1ac6d09576c57063c6c350ca36eaebdbd3 # v3.17
> 42383020beb1cfb05f5d330cc311931bc4917a97
> d37973082b453ba6b89ec07eb7b84305895d35e1 # v3.17

I'm confused, the others not marked with a "# v3.17" need to go on older
kernels as well?

> I've made a git branch (stable-3.17) with all of these cherry picked out:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git stable-3.17
> 
> They all cherry pick cleanly, so the git tree is mostly for btrfs users
> who wanted a recent corruption fix.  Feel free to pull or feed the shas
> into your scripts.  The last one (d37973082b) was already tagged for
> stable, so you've probably got it already through the regular channels.
> It shouldn't need special ordering.

Ok, thanks, I'll just feed these sha1s to my scripts, it's easier that
way.

greg k-h
