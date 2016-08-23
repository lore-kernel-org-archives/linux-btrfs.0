Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755385AbcHWMNn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 08:13:43 -0400
Date: Tue, 23 Aug 2016 13:41:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix em leak in find_first_block_group
Message-ID: <20160823114110.GJ16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1471548606-1433-1-git-send-email-jbacik@fb.com>
 <20160819173153.GA6679@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160819173153.GA6679@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2016 at 10:31:53AM -0700, Omar Sandoval wrote:
> On Thu, Aug 18, 2016 at 03:30:06PM -0400, Josef Bacik wrote:
> > We need to call free_extent_map() on the em we look up.Btrfs: fix em leak in
> > find_first_block_group
> 
> Something weird happened with your patch here ^^^

Fixed.
