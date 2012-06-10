Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:37931 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab2FJUtI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Jun 2012 16:49:08 -0400
Message-ID: <4FD5083F.5010901@libero.it>
Date: Sun, 10 Jun 2012 22:49:03 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Samuel <chris@csamuel.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Removing btrfsctl, btrfs-vol, btrfs-show
References: <1339223060-6256-1-git-send-email-kreijack@inwind.it> <1339223060-6256-2-git-send-email-kreijack@inwind.it> <201206101846.41496.chris@csamuel.org>
In-Reply-To: <201206101846.41496.chris@csamuel.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/10/2012 10:46 AM, Chris Samuel wrote:
> On Saturday 09 June 2012 16:24:19 Goffredo Baroncelli wrote:
> 
>> This commit removes all the related code.
> 
> This doesn't seem to apply cleanly with patch 

Did you pass the "-p1" switch to the patch command ?

> (though git am
> seems to apply it OK) to the git repo master from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> 
> FYI patch complains thus:
> 
> patching file INSTALL
> patching file Makefile
> patching file btrfs-show.c
> patching file btrfs-vol.c
> patching file btrfsctl.c
> patching file Makefile
> Hunk #1 FAILED at 6.
> Hunk #2 FAILED at 17.
> 2 out of 2 hunks FAILED -- saving rejects to file Makefile.rej
> patching file btrfs-image.8.in
> Hunk #1 FAILED at 31.
> 1 out of 1 hunk FAILED -- saving rejects to file btrfs-image.8.in.rej
> The next patch would delete the file btrfs-show.8.in,
> which does not exist!  Assume -R? [n] 
> Apply anyway? [n] 
> Skipping patch.
> 1 out of 1 hunk ignored
> patching file btrfsck.8.in
> Hunk #1 FAILED at 14.
> 1 out of 1 hunk FAILED -- saving rejects to file btrfsck.8.in.rej
> The next patch would delete the file btrfsctl.8.in,
> which does not exist!  Assume -R? [n] 
> Apply anyway? [n] 
> Skipping patch.
> 1 out of 1 hunk ignored
> 
> 

