Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36811 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbH2DEl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 23:04:41 -0400
Date: Sat, 29 Aug 2015 06:04:16 +0000
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, jbacik@fb.com,
        clm@fb.com
Subject: Re: [PATCH] btrfs: trimming some start_transaction() code away
Message-ID: <20150829060416.GA996@gmail.com>
References: <20150827235345.GA1373@gmail.com>
 <20150828173856.GM11834@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150828173856.GM11834@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 07:38:56PM +0200, David Sterba wrote:
> On Thu, Aug 27, 2015 at 11:53:45PM +0000, Alexandru Moise wrote:
> > Just call kmem_cache_zalloc() instead of calling kmem_cache_alloc().
> > We're just initializing most fields to 0, false and NULL later on
> > _anyway_, so to make the code mode readable and potentially gain
> > a bit of performance (completely untested claim), we should fill our
> > btrfs_trans_handle with zeros on allocation then just initialize
> > those five remaining fields (not counting the list_heads) as normal.
> > 
> > Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
> 
> The performance gain is arguable but the generated code should be
> smaller, which counts.
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

Yeah, I ran a few iozone benchmarks on a Samsung 850 PRO SSD 
on 3 kernels, the latest archlinux kernel, my custom kernel which has:
CONFIG_BTRFS_ASSERT=y
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
with the patch, and my custom kernel without the patch.
I ran iozone 5 times on each kernel, There were huge differences
between my custom kernels and arch's kernel, but nothing conclusive
between my custom kernel with or without the patch. So it's safe
to say that it has not much of a visible effect on performance.

Thank you for your time!
