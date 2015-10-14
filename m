Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11656 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbbJNClS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 22:41:18 -0400
Date: Tue, 13 Oct 2015 22:41:10 -0400
From: Chris Mason <clm@fb.com>
To: Mark Fasheh <mfasheh@suse.de>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: fix use after free iterating extrefs
Message-ID: <20151014024110.GF4890@ret.masoncoding.com>
References: <20151013180648.GC4890@ret.masoncoding.com>
 <20151013191755.GG1044@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20151013191755.GG1044@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2015 at 12:17:55PM -0700, Mark Fasheh wrote:
> On Tue, Oct 13, 2015 at 02:06:48PM -0400, Chris Mason wrote:
> > The code for btrfs inode-resolve has never worked properly for
> > files with enough hard links to trigger extrefs.  It was trying to
> > get the leaf out of a path after freeing the path:
> > 
> > 	btrfs_release_path(path);
> > 	leaf = path->nodes[0];
> > 	item_size = btrfs_item_size_nr(leaf, slot);
> > 
> > The fix here is to use the extent buffer we cloned just a little higher
> > up to avoid deadlocks caused by using the leaf in the path.
> > 
> > Signed-off-by: Chris Mason <clm@fb.com>
> > cc: stable@vger.kernel.org # v3.7+
> > cc: Mark Fasheh <mfasheh@suse.de>
> Reviewed-by: Mark Fasheh <mfasheh@suse.de>

Thanks Mark and Filipe, I've tested this and queued it up.

-chris
