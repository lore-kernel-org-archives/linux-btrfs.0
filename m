Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54481 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750925AbdFSQfP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 12:35:15 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2D75AB9D
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 16:35:13 +0000 (UTC)
Date: Mon, 19 Jun 2017 18:34:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH v2 0/2] Ensure size values are rounded down
Message-ID: <20170619163408.GD21388@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1497613160-3074-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1497613160-3074-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 16, 2017 at 02:39:18PM +0300, Nikolay Borisov wrote:
> Hello, 
> 
> Here is a small series which fixes an issue that got reported internally to 
> Suse and which affects devices whose size is not multiple of sectorsize. More
> information can be found in the changelog for patch 2
> 
> The first patch in the series re-implements the btrfs_device_total_bytes
> getter/setters manually so that we can add a WARN_ON to catch future offenders. 
> I haven't implemented all 4 function that the macros do since we only ever use
> the getter and setter. 
> 
> The second patch ensures that all the values passed to the setter are rounded 
> down to a multiple of sectorsize. I also have an xfstest patch which passes
> after this series is applied. 
> 
> Changes since v1: 
>  * Moved some of the text from previous cover letter, into patch 2 to make 
>  explanation of the bug more coherent. 
>  * The first patch now only implements getter/setter while the 2nd patch 
>  adds the WARN_ON 
> 
> Nikolay Borisov (2):
>   btrfs: Manually implement device_total_bytes getter/setter
>   btrfs: Round down values which are written for total_bytes_size

Added to the queue, with the fixups.
