Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbcDDLax (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Apr 2016 07:30:53 -0400
Date: Mon, 4 Apr 2016 13:30:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com
Subject: Re: [PATCH] btrfs: fix typo in btrfs_statfs()
Message-ID: <20160404113013.GH9918@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1459764837-7088-1-git-send-email-luisbg@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459764837-7088-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 04, 2016 at 11:13:57AM +0100, Luis de Bethencourt wrote:
> Correct a typo in the chunk_mutex name.
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
> 
> Hi,
> 
> I noticed this typo while fixing bug 114281 [0]. If this type of fixes are
> not welcomed I could squash it into the patch for that bug.

> -	 * holding chunk_muext to avoid allocating new chunks, holding
> +	 * holding chunk_mutex to avoid allocating new chunks, holding

In this case it's a name of a mutex, so this makes sense eg. when one is
grepping for it. I'm not against fixing typos in comments in general,
it's usually better to fix several at once, eg. per file, see
bb7ab3b92e46da06b580c6f83abe7894dc449cca . If you find more, then please
send an updated patch, I'll queue this one into cleanups and can replace
it later.
