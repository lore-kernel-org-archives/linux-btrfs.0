Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46801 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab3FEVMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Jun 2013 17:12:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UkL0b-0006pm-Kd
	for linux-btrfs@vger.kernel.org; Wed, 05 Jun 2013 23:12:41 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 23:12:41 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Jun 2013 23:12:41 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs raid1 on 16TB goes read-only after "btrfs: block rsv returned
 -28"
Date: Wed, 05 Jun 2013 22:12:31 +0100
Message-ID: <koo9jq$na8$1@ger.gmane.org>
References: <konjl0$r06$1@ger.gmane.org> <20130605150549.GP20133@carfax.org.uk> <konler$h9p$1@ger.gmane.org> <20130605154329.GQ20133@carfax.org.uk> <20130605162443.GE18160@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130605162443.GE18160@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/06/13 17:24, David Sterba wrote:
> On Wed, Jun 05, 2013 at 04:43:29PM +0100, Hugo Mills wrote:
>>    OK, so you've got plenty of space to allocate. There were some
>> issues in this area (block reserves and ENOSPC, and I think
>> specifically addressing the issue of ENOSPC when there's space
>> available to allocate) that were fixed between 3.8 and 3.9 (and
>> probably some between 3.9 and 3.10-rc as well), so upgrading your
>> kernel _may_ help here.
> 
> This is supposed to be fixed by
> https://patchwork-mail2.kernel.org/patch/2558911/
> 
> that went ti 3.10-rc with some followup patches, so it might not be
> enough as a standalone fix.
> 
> Unless you really need 'inode_cache', remove it from the mount options.

Thanks for that. Remounting without the inode_cache option looks to be
allowing rsync to continue. (No sync loop needed.)


For a 16TB raid1 on kernel 3.8.13, any good mount options to try?

For that size of storage and with many hard links, is there any
advantage formatting with leaf/node size greater than the default 4kBytes?


Thanks,
Martin

