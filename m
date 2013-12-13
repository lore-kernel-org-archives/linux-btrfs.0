Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab3LMBHx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 20:07:53 -0500
Date: Fri, 13 Dec 2013 02:07:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: subpagesize-blocksize: Allow mounting
 filesystems where sectorsize != PAGE_SIZE
Message-ID: <20131213010751.GV6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386805122-23972-1-git-send-email-sekharan@us.ibm.com>
 <1386805122-23972-8-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386805122-23972-8-git-send-email-sekharan@us.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 11, 2013 at 05:38:42PM -0600, Chandra Seetharaman wrote:
> This is the final patch of the series that allows filesystems with
> blocksize smaller than the PAGE_SIZE.

> -	if (sectorsize != PAGE_SIZE) {

You've implemented the sectorsize < PAGE_SIZE part (multiple extent
buffers per page), so the check should stay as:

	if (sectorsize > PAGE_SIZE) {

> -		printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
> -		       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
> -		goto fail_sb_buffer;
> -	}
> -
>  	mutex_lock(&fs_info->chunk_mutex);
>  	ret = btrfs_read_sys_array(tree_root);
>  	mutex_unlock(&fs_info->chunk_mutex);
