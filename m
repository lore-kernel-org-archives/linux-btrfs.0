Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbbLGPjR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 10:39:17 -0500
Date: Mon, 7 Dec 2015 16:37:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naota@elisp.net>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: [PATCH 2/3] btrfs-progs: properly reset nlink of multi-linked
 file
Message-ID: <20151207153717.GH4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449207447-1203-1-git-send-email-naota@elisp.net>
 <1449207447-1203-3-git-send-email-naota@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449207447-1203-3-git-send-email-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 04, 2015 at 02:37:26PM +0900, Naohiro Aota wrote:
> If a file is linked from more than one directory and only one
> of the links is corrupted, btrfs check dose not reset the nlink
> properly. Actually it can go into infinite loop to link the broken file
> into lost+found.
> 
> This patch fix two part of the code. The first one delay the freeing
> valid (no error, found inode ref, directory index, and directory
> item) backrefs. Freeing valid backrefs earier prevent reset_nlink() to
> add back all valid links.
> 
> The second fix is obvious: passing `ref_type' to btrfs_add_link() is just
> wrong. It should be `filetype' instead. The current code can break all valid
> file links.
> 
> Signed-off-by: Naohiro Aota <naota@elisp.net>

Applied, thanks.
