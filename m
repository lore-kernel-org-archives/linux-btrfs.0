Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab3JXKRd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 06:17:33 -0400
Date: Thu, 24 Oct 2013 12:17:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] xfstests btrfs/020: test device replace on RO btrfs
Message-ID: <20131024101730.GD1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1382527446-16053-1-git-send-email-eguan@redhat.com>
 <1382546683-454-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382546683-454-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 24, 2013 at 12:44:43AM +0800, Eryu Guan wrote:
> +_cleanup()
> +{
> +	cd /

Using root as temporary directory?

> +	rm -f $tmp.*
> +	$UMOUNT_PROG $loop_mnt
> +	_destroy_loop_device $loop_dev1
> +	losetup -d $loop_dev2 >/dev/null 2>&1
> +	_destroy_loop_device $loop_dev3
> +	rm -rf $loop_mnt
> +	rm -f $fs_img1 $fs_img2 $fs_img3
> +}
