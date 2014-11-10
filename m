Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14757 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbaKJBfk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Nov 2014 20:35:40 -0500
Date: Mon, 10 Nov 2014 12:35:34 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] btrfs: regression test for btrfs extent merge
Message-ID: <20141110013534.GM28565@dastard>
References: <1413423740-7022-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20141016081307.GZ13912@dhcp-13-216.nay.redhat.com>
 <543F8286.4060200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <543F8286.4060200@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 16, 2014 at 04:32:06PM +0800, Qu Wenruo wrote:
> -------- Original Message --------
> Subject: Re: [PATCH] btrfs: regression test for btrfs extent merge
> From: Eryu Guan <eguan@redhat.com>
> >>+
> >>+tmp=`mktemp -d`
> >I'm a bit concerned about this. Some functions in common/rc use
> >$tmp.some_sufix as temp file. If $tmp defined as a dir here, I'm not
> >sure if it will cause any trouble.
> It seems that most tests uses /tmp/$$ as tmp, only some exception
> like btrfs/077 uses mktemp -d.
> So I'd better use the old /tmp/$$ method.

Can you please send a patch to fix btrfs/077 as well?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
