Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17042 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753110AbdHUNOt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:14:49 -0400
Date: Mon, 21 Aug 2017 16:14:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: Use common error handling code in
 __btrfs_free_extent()
Message-ID: <20170821131416.kaq6xst5lpqmsd77@mwanda>
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <5c87a777-0772-456c-d094-9ca3f819a182@users.sourceforge.net>
 <5a10445b-763a-29a3-aa34-32e5381fdade@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5a10445b-763a-29a3-aa34-32e5381fdade@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 09:07:47AM -0400, Jeff Mahoney wrote:
> On 8/21/17 8:38 AM, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Mon, 21 Aug 2017 10:03:00 +0200
> > 
> > Add a jump target so that a bit of exception handling can be better reused
> > at the end of this function.
> > 
> > This issue was detected by using the Coccinelle software.
> 
> btrfs_abort_transaction dumps __FILE__:__LINE__ in the log so this patch
> makes the code more difficult to debug.
> 

I was just reviewing this and I missed that issue.  These patches are
just exhausting...

regards,
dan carpenter

