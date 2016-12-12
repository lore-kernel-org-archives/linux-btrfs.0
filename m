Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52595 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750712AbcLLNi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 08:38:29 -0500
Date: Mon, 12 Dec 2016 14:38:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Pan Bian <bianpan2016@163.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: fix improper return value
Message-ID: <20161212133820.GQ12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480827113-3928-1-git-send-email-bianpan2016@163.com>
 <20161204195707.GA21783@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161204195707.GA21783@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 04, 2016 at 11:57:07AM -0800, Omar Sandoval wrote:
> On Sun, Dec 04, 2016 at 12:51:53PM +0800, Pan Bian wrote:
> > In function btrfs_uuid_tree_iterate(), errno is assigned to variable ret
> > on errors. However, it directly returns 0. It may be better to return
> > ret. This patch also removes the warning, because the caller already
> > prints a warning.
> > 
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188731
> 
> Looks good.
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>

Added to 4.10 queue.
