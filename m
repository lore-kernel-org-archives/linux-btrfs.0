Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965775Ab3DQWWA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 18:22:00 -0400
Date: Thu, 18 Apr 2013 00:21:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, wangshilong1991@gmail.com
Subject: Re: [PATCH] Btrfs: do not continue if out of memory happens
Message-ID: <20130417222157.GE16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <516BD5DE.70904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516BD5DE.70904@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 15, 2013 at 06:26:38PM +0800, Wang Shilong wrote:
> If out of memory happens, we should return -ENOMEM directly to the caller
> rather than continue the work.

Reviewed-by: David Sterba <dsterba@suse.cz>
