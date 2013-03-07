Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55878 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab3CGXL3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 18:11:29 -0500
Date: Fri, 8 Mar 2013 00:11:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add a incompatible format change for smaller
 metadata extent refs
Message-ID: <20130307231126.GB29541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362684477-19402-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362684477-19402-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 07, 2013 at 02:27:57PM -0500, Josef Bacik wrote:
> +	/*
> +	 * If we don't have skinny metadata, don't bother doing anything
> +	 * different
> +	 */
> +	if (metadata &&
> +	    !btrfs_fs_incompat(root->fs_info,
> +			       BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)) {

Trimming the BTRFS_FEATURE_INCOMPAT_ prefix would make the lines
shorter, ie. wrapping the check into a macro similar to the mount
options

#define btrfs_fs_incompat(i, f) (__btrfs_fs_incompat((i),	\
	BTRFS_FEATURE_INCOMPAT_ ## f))

david
