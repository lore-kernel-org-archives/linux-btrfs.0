Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27607 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753348AbdHUNmx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:42:53 -0400
Date: Mon, 21 Aug 2017 16:42:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs: Use common error handling code in
 update_ref_path()
Message-ID: <20170821134215.4wpttdh5siuax5b3@mwanda>
References: <1e8e1da2-a9e3-9dc7-6ffe-6c32f8464337@users.sourceforge.net>
 <7083c299-4803-68c8-ae57-c0e74f5d9229@users.sourceforge.net>
 <dcd64dfb-944a-2a81-b4a2-8d7ce71d811b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dcd64dfb-944a-2a81-b4a2-8d7ce71d811b@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 09:08:04AM -0400, Jeff Mahoney wrote:
> On 8/21/17 8:41 AM, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Mon, 21 Aug 2017 13:34:29 +0200
> > 
> > Add a jump target so that a bit of exception handling can be better reused
> > in this function.
> > 
> > This issue was detected by using the Coccinelle software.
> 
> Adding a jump label in the middle of a conditional for "common" error
> handling makes the code more difficult to understand.
> 

I have said that a bunch of times.  It's like bashing my face into the
keyboard for all the good it does.  On the other hand, some people
accept these oddly placed labels...  No one else writes code like this
so far as I know.

regards,
dan carpenter

