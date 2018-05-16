Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53930 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750924AbeEPPaV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 11:30:21 -0400
Date: Wed, 16 May 2018 17:27:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: Split btrfs_del_delalloc_inode into 2
 functions
Message-ID: <20180516152740.GE6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
 <1524820914-30864-3-git-send-email-nborisov@suse.com>
 <7f535049-9127-7acc-f49c-4fa0b2e50919@oracle.com>
 <841661a5-0380-7e93-3e0a-5926a8a921b8@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <841661a5-0380-7e93-3e0a-5926a8a921b8@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 11:39:56AM +0300, Nikolay Borisov wrote:
> On 11.05.2018 08:44, Anand Jain wrote:
> > On 04/27/2018 05:21 PM, Nikolay Borisov wrote:
> >> This is in preparation of fixing delalloc inodes leakage on transaction
> >> abort. Also export the new function.
> >>
> >> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > 
> >  nit: I think we are reserving function prefix __ for some special
> >  functions. I am not sure if the function name should prefix with __
> >  here.
> 
> Generally __ prefix is used for some internal function. In this case the
> gist of the function (with no locking) is behind the __ prefixed
> function, whereas the non __ version adds the necessary locking. I think
> this is a fairly well-established pattern in the kernel.

Yes, this is one of few patterns where __ is ok.
