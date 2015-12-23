Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:59934 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965814AbbLWXSe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 18:18:34 -0500
Date: Thu, 24 Dec 2015 10:17:03 +1100
From: Dave Chinner <david@fromorbit.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, fstests@vger.kernel.org,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas to do custom operation just after mount?
Message-ID: <20151223231703.GH26718@dastard>
References: <56721602.5050204@cn.fujitsu.com>
 <20151221001654.GM19802@dastard>
 <56776330.1090500@cn.fujitsu.com>
 <5677662F.2060806@cn.fujitsu.com>
 <56778B9E.8050900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56778B9E.8050900@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 21, 2015 at 01:18:22PM +0800, Anand Jain wrote:
> 
> 
> >BTW, any good idea for btrfs to do such operation like
> >enabling/disabling some minor features? Especially when it can be set on
> >individual file/dirs.
> >
> >Features like incoming write time deduplication, is designed to be
> >enabled/disabled for individual file/dirs, so it's not a quite good idea
> >to use mount option to do it.
> >
> >Although some feature, like btrfs quota(qgroup), should be implemented
> >by mount option though.
> >I don't understand why qgroup is enabled/disabled by ioctl. :(
> 
> 
> mount option won't persist across systems/computers unless
> remembered by human.

So record the mount option you want persistent in the filesystem at
mount time and don't turn it off until a "no-...." mount option is
provided at mount time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
