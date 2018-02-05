Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbeBEXBd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Feb 2018 18:01:33 -0500
Date: Mon, 5 Feb 2018 23:59:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH 0/2] Remove custom crc32c init code from btrfs
Message-ID: <20180205225918.GL18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515404705-490-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515404705-490-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 08, 2018 at 11:45:03AM +0200, Nikolay Borisov wrote:
> So here is a small 2 patch set which removes btrfs' manual initialisation of 
> the lower level crc32c module. Explanation why is ok can be found in Patch 2/2.
> 
> Patch 1/2 just adds a function to the generic crc32c header which allows 
> querying the actual crc32c implementaiton used (i.e. software or hw-accelerated)
> to retain current btrfs behavior. This is mainly used for debugging purposes 
> and is independent. 
> 
> Nikolay Borisov (2):
>   libcrc32c: Add crc32c_impl function
>   btrfs: Remove custom crc32c init code

As we got ack from Herbert, I'm going to add the patches to my for-next.
