Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaAOOT1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 09:19:27 -0500
Date: Wed, 15 Jan 2014 15:19:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, wangshilong1991@gmail.com
Subject: Re: [PATCH 1/2 v2] xfstests: make btrfs/001.out in line with subvol
 delete output
Message-ID: <20140115141926.GB6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
 <1389669828-2222-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389669828-2222-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 14, 2014 at 11:23:48AM +0800, Anand Jain wrote:
> --- a/common/filter
> +++ b/common/filter
> @@ -313,5 +313,9 @@ _filter_ro_mount() {
>  	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
>  }
>  
> +_filter_transcation_commit_default() {
> +	sed -e "/Transaction commit: none (default)/d"
> +}

This IMO belongs to filters.btrfs

> +
>  # make sure this script returns success
>  /bin/true
