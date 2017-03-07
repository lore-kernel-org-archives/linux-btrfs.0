Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49291 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932739AbdCGQDz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 11:03:55 -0500
Date: Tue, 7 Mar 2017 16:48:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: add file item tracepoint
Message-ID: <20170307154824.GV4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1488595287-3247-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1488595287-3247-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 03, 2017 at 06:41:27PM -0800, Liu Bo wrote:
> +	TP_printk_btrfs(
> +		"root %llu(%s) ino %llu sz 0x%llx disk_isz 0x%llx "
> +		"file extent range [0x%llx 0x%llx] "
> +		"(num_bytes 0x%llx ram_bytes 0x%llx disk_bytenr 0x%llx "
> +		"disk_num_bytes 0x%llx extent_offset 0x%llx type (%s) "
> +		"compression %u",

> +	TP_printk_btrfs(
> +		"root %llu(%s) ino %llu sz 0x%llx disk_isz 0x%llx "
> +		"file extent range [0x%llx 0x%llx] "
> +		"extent_type (%s) compression %u",

Please update the message formats according to
https://btrfs.wiki.kernel.org/index.php/Development_notes#Tracepoints
