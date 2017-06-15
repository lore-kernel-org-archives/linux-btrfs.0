Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750814AbdFOQ3E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 12:29:04 -0400
Date: Thu, 15 Jun 2017 18:27:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3 v2.1] btrfs: write_dev_flush does not return ENOMEM
 anymore
Message-ID: <20170615162758.GE25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1497344741-1135-1-git-send-email-anand.jain@oracle.com>
 <1497346349-1194-1-git-send-email-anand.jain@oracle.com>
 <20170613152328.GY25451@twin.jikos.cz>
 <873d0302-a3ea-4017-9487-889d0f88a469@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <873d0302-a3ea-4017-9487-889d0f88a469@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 14, 2017 at 05:01:11PM +0800, Anand Jain wrote:
> > I have a prototype for the
> > preallocated flush bio but was waiting until these cleanups are in
> > before snding it.
> 
>   oh. sorry for the delay if any. -ENOMEM was only purpose I had/have
>   in mind for peralloc, but looks like there is another purpose which
>   I am not aware of.

The bio preallocation is a slight optimization, we don't have to
allocate and free the bio all the time.

> > I've noticed that threre are two more "if (!device->bdev)" checks under
> > the device lock in write_all_supers, that might be worth removing.
> 
> > However, a NULL bdev and device->missing are related and I think there
> > are some dark corners in dev replace where the invariant can be
> > temporarily broken.
> 
>   Ok. Thanks for the hints. Trying to dig.
> 
> > Given that we probably don't have great testing
> > coverage of devices with the flush capabilities,
> 
>   Any hints on what type of test coverage ?

Devices used for normal testing, any sort of test basically, that do not
have the flush capabilities will never exercise the in write_dev_flush.
So any reference counts or failures will not get covered.
