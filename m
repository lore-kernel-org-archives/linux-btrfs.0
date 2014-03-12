Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbaCLQBD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Mar 2014 12:01:03 -0400
Date: Wed, 12 Mar 2014 17:01:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, sgw@linux.intel.com
Subject: Re: [PATCH] btrfs-progs: fix bug on mkfs with relative path specified
Message-ID: <20140312160101.GA6782@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1394533467-24967-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394533467-24967-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 11, 2014 at 06:24:27PM +0800, Gui Hecheng wrote:
> @@ -764,7 +765,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
>  	/* Add list for source directory */
>  	dir_entry = malloc(sizeof(struct directory_name_entry));
>  	dir_entry->dir_name = dir_name;
> -	dir_entry->path = strdup(dir_name);
> +	dir_entry->path = realpath(dir_name, real_path);

The fix is ok, but the return value of realpath() has to be checked.
