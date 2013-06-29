Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58769 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3F2OEM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 10:04:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Usvl4-0006lf-JN
	for linux-btrfs@vger.kernel.org; Sat, 29 Jun 2013 16:04:10 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 16:04:10 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 16:04:10 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: raid1 inefficient unbalanced filesystem reads
Date: Sat, 29 Jun 2013 15:04:00 +0100
Message-ID: <kqmpga$pum$1@ger.gmane.org>
References: <kqk4sc$t5d$1@ger.gmane.org> <20130628170410.GX4288@localhost.localdomain> <kqki3l$nmr$1@ger.gmane.org> <201306291941.32127.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <201306291941.32127.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29/06/13 10:41, Russell Coker wrote:
> On Sat, 29 Jun 2013, Martin wrote:
>> Mmmm... I'm not sure trying to balance historical read/write counts is
>> the way to go... What happens for the use case of an SSD paired up with
>> a HDD? (For example an SSD and a similarly sized Raptor or enterprise
>> SCSI?...) Or even just JBODs of a mishmash of different speeds?
>>
>> Rather than trying to balance io counts, can a realtime utilisation
>> check be made and go for the least busy?
> 
> It would also be nice to be able to tune this.  For example I've got a RAID-1 
> array that's mounted noatime, hardly ever written, and accessed via NFS on 
> 100baseT.  It would be nice if one disk could be spun down for most of the 
> time and save 7W of system power.  Something like the --write-mostly option of 
> mdadm would be good here.

For that case, a "--read-mostly" would be more apt ;-)

Hence, add a check to preferentially use last disk used if all are idle?


> Also it should be possible for a RAID-1 array to allow faster reads for a 
> single process reading a single file if the file in question is fragmented.

That sounds good but complicated to gather and sort the fragments into
groups per disk... Or is something like that already done by the block
device elevator for HDDs?

Also, is head seek optimisation turned off for SSD accesses?


(This is sounding like a lot more than just swapping:

"current->pid % map->num_stripes"

to a

"psuedorandomhash( current->pid ) % map->num_stripes"

... ;-) )


Are there any readily accessible present state for such as disk activity
or queue length or access latency available for the btrfs process to read?

I suspect a good first guess to cover many conditions would be to
'simply' choose whichever device is powered up and has the lowest
current latency, or if idle has the lowest historical latency...


Regards,
Martin

