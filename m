Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbbGXMJz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jul 2015 08:09:55 -0400
Date: Fri, 24 Jul 2015 14:09:46 +0200
From: David Sterba <dsterba@suse.com>
To: Omar Sandoval <osandov@fb.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] btrfs: add replace missing and replace RAID 5/6 to
 profile configs
Message-ID: <20150724120946.GT6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <cover.1437683940.git.osandov@fb.com>
 <6d332e954da29e8418689cb49294a68da2fa5376.1437683940.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6d332e954da29e8418689cb49294a68da2fa5376.1437683940.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 23, 2015 at 01:51:50PM -0700, Omar Sandoval wrote:
> +			# We can't do replace with these profiles because they
> +			# imply only one device ($SCRATCH_DEV), and we need to
> +			# keep $SCRATCH_DEV around for _scratch_mount
> +			# and _check_scratch_fs.
> +			local unsupported=(
> +				"single"
> +				"dup"

DUP does imply single device, but why does 'single' ?
