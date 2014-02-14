Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59408 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaBNRaZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 12:30:25 -0500
Date: Fri, 14 Feb 2014 18:30:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs-progs: fix fsck leaks on error returns
Message-ID: <20140214173023.GZ16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1392261398-6197-4-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392261398-6197-4-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 13, 2014 at 11:16:38AM +0800, Gui Hecheng wrote:
> @@ -6460,6 +6460,7 @@ int cmd_check(int argc, char **argv)
>  	    !extent_buffer_uptodate(info->dev_root->node) ||
>  	    !extent_buffer_uptodate(info->chunk_root->node)) {
>  		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
> +		close_ctree(info->fs_root);
>  		return -EIO;

Can you please convert it to the 'goto + single return' pattern?

The other patches are ok, adding them to integration.
