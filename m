Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbbKZOrl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 09:47:41 -0500
Date: Thu, 26 Nov 2015 15:45:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Support convert to -d dup for btrfs-convert
Message-ID: <20151126144555.GT31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <a00388267bcd7b1f90f45259338901ba1cfffb0b.1447925171.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a00388267bcd7b1f90f45259338901ba1cfffb0b.1447925171.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 19, 2015 at 05:26:22PM +0800, Zhao Lei wrote:
> Since we will add support for -d dup for non-mixed filesystem,
> kernel need to support converting to this raid-type.
> 
> This patch remove limitation of above case.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
