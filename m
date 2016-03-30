Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbcC3Ruw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 13:50:52 -0400
Date: Wed, 30 Mar 2016 19:50:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fallback to vmalloc in btrfs_compare_tree
Message-ID: <20160330175016.GE27917@suse.cz>
Reply-To: dsterba@suse.cz
References: <1459346743-17191-1-git-send-email-dsterba@suse.com>
 <20160330171044.GB20816@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160330171044.GB20816@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 10:10:45AM -0700, Liu Bo wrote:
> On Wed, Mar 30, 2016 at 04:05:43PM +0200, David Sterba wrote:
> > The allocation of node could fail if the memory is too fragmented for a
> > given node size, practically observed with 64k.
> 
> It's not a critical path.  Why not use vmalloc directly?

We should try to avoid vmalloc if possible.
