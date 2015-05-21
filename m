Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284AbbEUOpd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 May 2015 10:45:33 -0400
Date: Thu, 21 May 2015 16:45:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: remove unused inode argument from
 uncompress_inline()
Message-ID: <20150521144531.GR23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1432046805-6668-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1432046805-6668-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 19, 2015 at 11:46:45PM +0900, Byongho Lee wrote:
> The inode argument is never used from the beginning, so remove it.
> 
> Change since v1:
> - Add missing Signed-off-by line.

This ^^^ belongs ...
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

> ---

... here. The text below --- will not be part of the commit changelog,
and is meant to be read by other people.

>  fs/btrfs/inode.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
