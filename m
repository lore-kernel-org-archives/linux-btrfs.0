Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753133AbcJMOaM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 10:30:12 -0400
Date: Thu, 13 Oct 2016 16:29:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2] btrfs-progs: fsck-test: Add image for quota verify
 stack overflow
Message-ID: <20161013142958.GX11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161007072300.3367-1-quwenruo@cn.fujitsu.com>
 <20161007072300.3367-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161007072300.3367-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2016 at 03:23:00PM +0800, Qu Wenruo wrote:
> +for img in $(find . \( -iname '*.img' -o	\
> +			-iname '*.img.xz' -o 	\
> +			-iname '*.raw' -o 	\
> +			-iname '*.raw.xz' \) | sort)
> +do
> +	image=$(extract_image $img)
> +	run_check $TOP/btrfs check "$image"
> +	rm -f "$image"
> +done

There's a helper that enumerates images and calls 'check_image' on each,
so you should redefine 'check_image' if you don't want to do the default
actions (check, repair and check). Fixed in devel.
