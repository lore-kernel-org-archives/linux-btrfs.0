Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbcBWSOG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 13:14:06 -0500
Date: Tue, 23 Feb 2016 19:13:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Hongxu Jia <hongxu.jia@windriver.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix symlink creation multiple times
Message-ID: <20160223181355.GP4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455848074-47741-1-git-send-email-hongxu.jia@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455848074-47741-1-git-send-email-hongxu.jia@windriver.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2016 at 09:14:34PM -0500, Hongxu Jia wrote:
> The rule to create symlink in Makefile caused parallel issue:
> $ make -j 40 DESTDIR=/image install BUILD_VERBOSE=1
> ...
>   1     [LN]     libbtrfs.so.0
>   2     [LN]     libbtrfs.so
>   3 ln -s -f libbtrfs.so.0.1 libbtrfs.so.0
>   4 ln -s -f libbtrfs.so.0.1 libbtrfs.so.0
>   5 ln -s -f libbtrfs.so.0.1 libbtrfs.so
>   6 ln -s -f libbtrfs.so.0.1 libbtrfs.so
> ...
> 
> It failed occasionally:
> ...
> |symlinkat: couldn't stat 'git/libbtrfs.so' even though symlink
> creation succeeded (No such file or directory).
> |ln: failed to create symbolic link 'libbtrfs.so': No such file or directory
> ...
> 
> Signed-off-by: Hongxu Jia <hongxu.jia@windriver.com>

Applied, thanks.
