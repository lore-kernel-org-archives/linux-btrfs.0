Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53737 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbcGDRwx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 13:52:53 -0400
Date: Mon, 4 Jul 2016 19:53:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Salah Triki <salah.triki@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: btrfs: Replace -ENOENT by -ERANGE in btrfs_get_acl()
Message-ID: <20160704175316.GN13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1467520810-11027-1-git-send-email-salah.triki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467520810-11027-1-git-send-email-salah.triki@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 03, 2016 at 05:40:10AM +0100, Salah Triki wrote:
> size contains the value returned by posix_acl_from_xattr(), which
> returns -ERANGE, -ENODATA, zero, or an integer greater than zero. So
> replace -ENOENT by -ERANGE.
> 
> Signed-off-by: Salah Triki <salah.triki@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
