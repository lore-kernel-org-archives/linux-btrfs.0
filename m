Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:31561 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755608AbdCGT1A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 14:27:00 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v27GoolK009582
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 16:50:51 GMT
Date: Tue, 7 Mar 2017 08:49:42 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add file item tracepoint
Message-ID: <20170307164942.GA13162@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1488595287-3247-1-git-send-email-bo.li.liu@oracle.com>
 <20170307154824.GV4662@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307154824.GV4662@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 04:48:24PM +0100, David Sterba wrote:
> On Fri, Mar 03, 2017 at 06:41:27PM -0800, Liu Bo wrote:
> > +	TP_printk_btrfs(
> > +		"root %llu(%s) ino %llu sz 0x%llx disk_isz 0x%llx "
> > +		"file extent range [0x%llx 0x%llx] "
> > +		"(num_bytes 0x%llx ram_bytes 0x%llx disk_bytenr 0x%llx "
> > +		"disk_num_bytes 0x%llx extent_offset 0x%llx type (%s) "
> > +		"compression %u",
> 
> > +	TP_printk_btrfs(
> > +		"root %llu(%s) ino %llu sz 0x%llx disk_isz 0x%llx "
> > +		"file extent range [0x%llx 0x%llx] "
> > +		"extent_type (%s) compression %u",
> 
> Please update the message formats according to
> https://btrfs.wiki.kernel.org/index.php/Development_notes#Tracepoints

I feel like for size and offset, if using '%llu' rather than '%llx', it
is not easy to tell whether the size/offset is aligned to 4K or not.

Thanks,

-liubo
