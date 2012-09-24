Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:40750 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab2IXVDy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 17:03:54 -0400
Date: Mon, 24 Sep 2012 23:03:49 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not async metadata csums if we have hardware
 crc32c
Message-ID: <20120924210349.GP14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348510264-5781-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348510264-5781-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 02:11:04PM -0400, Josef Bacik wrote:
> +#ifdef CONFIG_X86
> +	if (cpu_has_xmm4_2) {
> +		printk(KERN_ERR "doing it the fast way\n");
> +		ret = btree_csum_one_bio(bio);
> +		if (ret)
> +			return ret;
> +		return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 0);
> +	}
> +#endif

Could you please put the check into a separate helper and avoid the
#ifdef? This is a second candidate for a standalone utils.c where non-fs
support code could reside. Or you can call it hellpers.c .


david
