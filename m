Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31572 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3ARBP2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 20:15:28 -0500
Date: Fri, 18 Jan 2013 09:12:59 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, zab@zabbo.net, cl@linux.com,
        penberg@kernel.org
Subject: Re: [PATCH V2] mm/slab: add a leak decoder callback
Message-ID: <20130118011258.GE6768@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1358305393-3507-1-git-send-email-bo.li.liu@oracle.com>
 <50F63BEE.8040506@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F63BEE.8040506@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 16, 2013 at 01:34:38PM +0800, Miao Xie wrote:
> On wed, 16 Jan 2013 11:03:13 +0800, Liu Bo wrote:
> > This adds a leak decoder callback so that slab destruction
> > can use to generate debugging output for the allocated objects.
> > 
> > Callers like btrfs are using their own leak tracking which will
> > manage allocated objects in a list(or something else), this does
> > indeed the same thing as what slab does.  So adding a callback
> > for leak tracking can avoid this as well as runtime overhead.
> 
> If the slab is merged with the other one, this patch can work well?

Yes and no, so I'll disable merging slab in the next version :)

thanks,
liubo
