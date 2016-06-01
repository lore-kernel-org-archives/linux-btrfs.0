Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbcFAO5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 10:57:21 -0400
Date: Wed, 1 Jun 2016 16:56:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, noah.massey@gmail.com, dsterba@suse.cz,
        ahferroin7@gmail.com, hugo@carfax.org.uk
Subject: Re: [PATCH v2 1/2] btrfs-progs: utils: Introduce new pseudo random
 API
Message-ID: <20160601145641.GD29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1464231411-13261-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464231411-13261-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 10:56:50AM +0800, Qu Wenruo wrote:
> David has reported some quite chaos usage of pseudo random numbers.
> Like using static srand seed, or even calling rand() without setting
> seed correctly.
> 
> The new pseudo random API will initialize the random seed on its first
> calling and use uniformly distributed pseudo random number generator as
> backend.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---

Patches applied, with minor adjustments (renamed a few things). Thanks.
