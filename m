Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3IROUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 10:20:41 -0400
Date: Wed, 18 Sep 2013 16:20:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Ross Kirk <ross.kirk@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop unused parameter from btrfs_item_nr
Message-ID: <20130918142038.GB6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379343489-20066-1-git-send-email-ross.kirk@gmail.com>
 <1379343489-20066-2-git-send-email-ross.kirk@gmail.com>
 <20130916155006.GU6810@twin.jikos.cz>
 <CAN_nJPi7K3VR7cw-RsoHYUiwV7QEGpF8J+HyLWHVUtpxMG+nfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAN_nJPi7K3VR7cw-RsoHYUiwV7QEGpF8J+HyLWHVUtpxMG+nfw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 18, 2013 at 01:28:32PM +0100, Ross Kirk wrote:
> >> Signed-off-by: Ross Kirk <ross.kirk@gmail.com>
> > Reviewed-by: David Sterba <dsterba@suse.cz>
> 
> Do I need to update anything following the Reviewed-by sign off? First
> time submitting a patch so still working things out :)

No you don't, it's up to the maintainer to pick the patch with the
reviewed-by tags.

> Also should a separate btrfs-progs patch be submitted, as the code is
> the same there too?

Yes please.


david
