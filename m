Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751088AbdCGUXm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 15:23:42 -0500
Date: Tue, 7 Mar 2017 18:36:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] btrfs: No need to check !(flags & MS_RDONLY) twice
Message-ID: <20170307173642.GY4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170304183250.32295-1-rgoldwyn@suse.de>
 <20170306174151.GA16893@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170306174151.GA16893@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 06, 2017 at 09:41:51AM -0800, Omar Sandoval wrote:
> On Sat, Mar 04, 2017 at 12:32:50PM -0600, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > Code cleanup.
> > The code block is for !(*flags & MS_RDONLY). We don't need
> > to check it again.
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>

Added to queue, thanks.
