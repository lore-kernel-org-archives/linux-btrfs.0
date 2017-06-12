Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34685 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754872AbdFLPj4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 11:39:56 -0400
Date: Mon, 12 Jun 2017 17:38:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: btrfs_ioctl_search_key documentation
Message-ID: <20170612153846.GP25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
 <20170605222032.9207-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170605222032.9207-1-hans.van.kranenburg@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 12:20:32AM +0200, Hans van Kranenburg wrote:
> A programmer who is trying to implement calling the btrfs SEARCH
> or SEARCH_V2 ioctl will probably soon end up reading this struct
> definition.
> 
> Properly document the input fields to prevent common misconceptions:
>  1. The search space is linear, not 3 dimensional. The invidual min/max
>  values for objectid, type and offset cannot be used to filter the
>  result, they only define the endpoints of an interval.
>  2. The transaction id (a.k.a. generation) filter applies only on
>  transaction id of the last COW operation on a whole metadata page, not
>  on individual items.
> 
> Ad 1. The first misunderstanding was helped by the previous misleading
> comments on min/max type and offset:
>   "keys returned will be >= min and <= max".
> 
> Ad 2. For example, running btrfs balance will happily cause rewriting of
> metadata pages that contain a filesystem tree of a read only subvolume,
> causing transids to be increased.
> 
> Also, improve descriptions of tree_id and nr_items and add in/out
> annotations.
> 
> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>

Looks good to me, thanks. I've realigned the comments so they don't
overflow 80 columns and aligned the /* in */ hints.

> Most interesting changes since v1:
>  - mention the special tree_id input value 0
>  - rewrite the part about min_key and max_key, trying to be more concise

I find the description instructive enough so the expanded expression to
describe the whole range is not IMHO needed.
