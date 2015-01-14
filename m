Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbbANAQI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:16:08 -0500
Date: Wed, 14 Jan 2015 01:16:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Mason <clm@fb.com>, Miao Xie <miaox@cn.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: avoid build warning on 32-bit
Message-ID: <20150114001606.GQ3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4264141.3m7C7LgF5c@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4264141.3m7C7LgF5c@wuerfel>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 13, 2015 at 03:09:03PM +0100, Arnd Bergmann wrote:
> A recent change introduced a type cast from a private 64-bit
> value to a pointer, which works fine on 64-bit architectures,
> but not on 32-bit ones, where it produces a harmless compiler
> warning:
> 
> fs/btrfs/extent_io.c: In function 'btrfs_free_io_failure_record':
> fs/btrfs/extent_io.c:2193:13: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> 
> This adds an intermediate cast to 'unsigned long', which tells
> the compiler to ignore the type mismatch.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: f612496bca664 ("Btrfs: cleanup the read failure record after write
> 			or when the inode is freeing")

Already reported, but not merged

https://patchwork.kernel.org/patch/5541281/
