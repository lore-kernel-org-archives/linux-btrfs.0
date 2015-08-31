Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbbHaPXI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 11:23:08 -0400
Date: Mon, 31 Aug 2015 17:22:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs-progs: Simplify memory allocation for
 enumerate_dead_subvols
Message-ID: <20150831152228.GZ11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e7e430d22bb78d6ab8b28a514685cda221bfe379.1440597812.git.zhaolei@cn.fujitsu.com>
 <a35e7055905a4407f144f7515b058be66125f7ac.1440597812.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a35e7055905a4407f144f7515b058be66125f7ac.1440597812.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 10:03:37PM +0800, Zhao Lei wrote:
> No need prepare memory for enumerate_dead_subvols() in caller, and pass
> additional argument for allocated length.
> 
> Just do every thing inside enumerate_dead_subvols(), it will not
> increase malloc count, but make code simple.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
