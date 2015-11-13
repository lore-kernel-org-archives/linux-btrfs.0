Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651AbbKMRvQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 12:51:16 -0500
Date: Fri, 13 Nov 2015 18:49:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: mkfs: Enable -d dup for single device
Message-ID: <20151113174938.GT6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b2688434550d5dd940594e9a61ab0660f69cbb26.1447423853.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b2688434550d5dd940594e9a61ab0660f69cbb26.1447423853.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 13, 2015 at 10:11:37PM +0800, Zhao Lei wrote:
> Current code don't support dup profile in single device, except it
> is in mixed mode, because following reason:
> 1: In some ssd with deduplication function, it have no effect.
> 2: For a physical device, it the entire disk broken, -d dup can
>    not help.
> 3: Half performance comparing with single profile.
> 4: We have a workaround: Create multi-partition in single device,
>    and btefs will treat them as multi device.
> 
> Instead of refuse -d dup, we have a better choise:
> Give user a chance to select, and output a warning to notice above
> problem.
> 
> Test:
[...]

Thanks.

> +	warning_on(!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP) && ssd,
> +		   "DUP have no effect if your SSD have deduplication function");

This seems too specific, I suggest to say something generic that
duplicate does not necessrily be stored twice and point to the manual
page where we can be detailed as needed.

Patch will be added to devel branch soon.
