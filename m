Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58839 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030701AbeCANkd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Mar 2018 08:40:33 -0500
Date: Thu, 1 Mar 2018 14:38:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: dev-replace: skip prealloc extents when copy
 nocow pages
Message-ID: <20180301133811.GA4817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180228011058.23906-1-bo.li.liu@oracle.com>
 <CAL3q7H5zgigVQdOmQedB8NZ12f1h-hoFjeed6nwz50qPqRpeMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5zgigVQdOmQedB8NZ12f1h-hoFjeed6nwz50qPqRpeMQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 01, 2018 at 12:52:11PM +0000, Filipe Manana wrote:
> On Wed, Feb 28, 2018 at 1:10 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > It doens't make sense to process prealloc extents as pages will be
> > filled with zero when reading prealloc extents.
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Makes sense.

Added to next, thanks.
