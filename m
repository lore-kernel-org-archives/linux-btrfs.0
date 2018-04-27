Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39695 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758392AbeD0PrD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 11:47:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F24BAAE79
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 15:47:00 +0000 (UTC)
Date: Fri, 27 Apr 2018 17:44:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: qgroup, don't try to insert status item after
 ENOMEM in rescan worker
Message-ID: <20180427154425.GB21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426192351.473-1-jeffm@suse.com>
 <20180426192351.473-3-jeffm@suse.com>
 <471d8f08-ee33-80c7-67be-d35d5df6f166@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <471d8f08-ee33-80c7-67be-d35d5df6f166@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2018 at 11:39:50PM +0300, Nikolay Borisov wrote:
> On 26.04.2018 22:23, jeffm@suse.com wrote:
> > From: Jeff Mahoney <jeffm@suse.com>
> > 
> > If we fail to allocate memory for a path, don't bother trying to
> > insert the qgroup status item.  We haven't done anything yet and it'll
> > fail also.  Just print an error and be done with it.
> > 
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> 
> nit: So the code is correct however, having the out label there is
> really ugly. What about on path alloc failure just have the print in the
> if branch do goto done?

Yeah, I don't like jumping to the inner blocks either. I saw this in the
qgroup code so we should clean it up and not add new instances.

In this case, only the path allocation failure jumps to the out label,
so printing the message and then jump to done makes sense to me.
However, the message would have to be duplicated in the end, and I don't
see a better way without further restructuring the code.
