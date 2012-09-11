Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:46554 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2IKKVR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 06:21:17 -0400
Date: Tue, 11 Sep 2012 13:21:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marios Titas <redneb8888@gmail.com>
Cc: Arne Jansen <sensille@gmx.net>,
        Andreas Philipp <philipp.andreas@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Cannot create subvolume with quota enabled
Message-ID: <20120911102102.GC19410@mwanda>
References: <504A4CBF.7000605@gmail.com>
 <504A6F67.3060506@gmx.net>
 <CAAdM646auV2U43HnoYG=32RipWU8hzaKa5RBNia+krCYWY6muA@mail.gmail.com>
 <504ED7EA.903@gmx.net>
 <CAAdM645dJhB8O0uXkCmDNWTnZ93rRN4r5nBgqyO9iSrdxUH4fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAdM645dJhB8O0uXkCmDNWTnZ93rRN4r5nBgqyO9iSrdxUH4fA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 11, 2012 at 04:35:26AM -0400, Marios Titas wrote:
> On Tue, Sep 11, 2012 at 2:19 AM, Arne Jansen <sensille@gmx.net> wrote:
> >
> > instead of applying my patch, could you please just revert
> >
> > commit 5986802c2fcc754040bb7ed95f30bb16c4a843b7
> > Author: Dan Carpenter <dan.carpenter@oracle.com>
> > Date:   Mon Jul 30 02:16:10 2012 -0600
> >
> >     Btrfs: fix some error codes in btrfs_qgroup_inherit()
> >
> > It introduces both faulty return codes.
> 
> Yes, reverting 5986802 and completely ignoring your earlier patch
> works.

Sorry for that.

Arne, you reviewed the patch when I sent it originally right?  You
were in the To: field and your btrfs_qgroup_inherit() code had just
hit linux-next the day before.

regards,
dan carpenter
