Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45499 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751198AbcKGKVG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 05:21:06 -0500
Date: Mon, 7 Nov 2016 11:21:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 2/4] btrfs-progs: introduce new send-dump object
Message-ID: <20161107102103.GL12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161103040734.8098-1-quwenruo@cn.fujitsu.com>
 <20161103040734.8098-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161103040734.8098-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 03, 2016 at 12:07:32PM +0800, Qu Wenruo wrote:
> +/*
> + * Disable format zero length warning since we use zero length format
> + * for unified function parameters.
> + */
> +#pragma GCC diagnostic ignored "-Wformat-zero-length"

No such tricks should be necessary, NULL instead of "" works.
