Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758301Ab3ANW1u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 17:27:50 -0500
Date: Mon, 14 Jan 2013 14:27:49 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        ablock84@googlemail.com, Arvin Schnell <aschnell@suse.de>
Subject: Re: [PATCH 2/3] btrfs-progs: libify some parts of btrfs-progs
Message-ID: <20130114222749.GS12558@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de> <1357681304-2978-3-git-send-email-mfasheh@suse.de> <50EFDBDD.1040104@oracle.com> <20130111230058.GN12558@wotan.suse.de> <50F37E8D.3070107@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F37E8D.3070107@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 14, 2013 at 11:42:05AM +0800, Anand Jain wrote:
>  Its bit strange, the steps given before can reproduce
>  the problem still on my older workspace. However when
>  I try with the fresh clone, it can reproduce the issue
>  (4 times, consistently) only with the following (new)
>  steps..
>
> -----------------
> # git clone 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>
> # cd btrfs-progs/
> # make version; make install

Ok, I was able to fix this by adding the libs target to the various other
targets.

A series of patches with all the fixes (build and whitespace) and Arvin's
patch can be found at:

https://github.com/markfasheh/btrfs-progs-patches/tree/no-data-and-libify

If nothing else comes up, I will send them out tommorrow. Thanks again to
you all for looking at this.
	--Mark

--
Mark Fasheh
