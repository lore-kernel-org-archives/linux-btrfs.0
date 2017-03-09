Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41559 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753499AbdCIShx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Mar 2017 13:37:53 -0500
Date: Thu, 9 Mar 2017 10:36:32 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add file item tracepoint
Message-ID: <20170309183632.GD28780@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1488595287-3247-1-git-send-email-bo.li.liu@oracle.com>
 <20170307154824.GV4662@twin.jikos.cz>
 <20170307164942.GA13162@localhost.localdomain>
 <20170309125222.GD14605@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170309125222.GD14605@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 09, 2017 at 01:52:22PM +0100, David Sterba wrote:
> On Tue, Mar 07, 2017 at 08:49:42AM -0800, Liu Bo wrote:
> > On Tue, Mar 07, 2017 at 04:48:24PM +0100, David Sterba wrote:
> > > On Fri, Mar 03, 2017 at 06:41:27PM -0800, Liu Bo wrote:
> > > > +	TP_printk_btrfs(
> > > > +		"root %llu(%s) ino %llu sz 0x%llx disk_isz 0x%llx "
> > > > +		"file extent range [0x%llx 0x%llx] "
> > > > +		"(num_bytes 0x%llx ram_bytes 0x%llx disk_bytenr 0x%llx "
> > > > +		"disk_num_bytes 0x%llx extent_offset 0x%llx type (%s) "
> > > > +		"compression %u",
> > > 
> > > > +	TP_printk_btrfs(
> > > > +		"root %llu(%s) ino %llu sz 0x%llx disk_isz 0x%llx "
> > > > +		"file extent range [0x%llx 0x%llx] "
> > > > +		"extent_type (%s) compression %u",
> > > 
> > > Please update the message formats according to
> > > https://btrfs.wiki.kernel.org/index.php/Development_notes#Tracepoints
> > 
> > I feel like for size and offset, if using '%llu' rather than '%llx', it
> > is not easy to tell whether the size/offset is aligned to 4K or not.
> 
> I think we'll have to do some conversion either way, and I don't see
> %llx used anywhere in our thacepoints.
> 
> If the alignment is useful for certain values, we can extend the format
> to signify that, for example: "start=4097!".

OK, I'll update this patch to comply with the wiki so you can take it,
and then make a new patch to convert %llu to %llx to see if any
objections.

Thanks,

-liubo
