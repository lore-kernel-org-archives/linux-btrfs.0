Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38053 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab2EVVaw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 May 2012 17:30:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SWwfI-0004Bg-L8
	for linux-btrfs@vger.kernel.org; Tue, 22 May 2012 23:30:48 +0200
Received: from cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com ([217.137.143.235])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 23:30:48 +0200
Received: from m_btrfs by cpc4-stap10-2-0-cust490.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2012 23:30:48 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: SSD format/mount parameters questions
Date: Tue, 22 May 2012 22:30:34 +0100
Message-ID: <jph0hq$r2r$1@dough.gmane.org>
References: <jp32u7$vlc$1@dough.gmane.org> <20120518070251.GA32766@panda> (sfid-20120518_121930_821794_9A426EAB) <201205191936.36655.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <201205191936.36655.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/05/12 18:36, Martin Steigerwald wrote:
> Am Freitag, 18. Mai 2012 schrieb Sander:
>> Martin wrote (ao):
>>> Are there any format/mount parameters that should be set for using
>>> btrfs on SSDs (other than the "ssd" mount option)?
>>
>> If possible, format the whole device, do not partition the ssd. This
>> will guarantee proper allignment.
> 
> Current partitioning tools align at 1 MiB unless otherwise specified.
> 
> And then thats only the alignment of the start of the filesystem.
> 
> Not the granularity that the filesystem itself uses to align its writes.
> 
> And then its not clear to me what effect proper alignment will actually 
> have given the intelligent nature of SSD firmwares.

That's what I'm trying to untangle rather than just trusting to "magic".
I'm also not so convinced about the "SSD firmwares" being quite so
"intelligent"...


So far, the only clear indications are that a number of SSDs have a
performance 'sweet spot' when you use 16kByte blocks for data transfer.

Practicalities for the SSD internal structure strongly suggest that they
work in chunks of data greater than 4kBytes.

4kByte operation is a strong driver for SSD manufacturers, but what
compromises do they make to accommodate that?


And for btrfs:

Extents are aligned to "sector size" boundaries (4kBytes default).

And there is a comment that setting larger sector sizes increases the
CPU overhead in btrfs due to the larger memory moves needed for making
inserts into the trees.

If the SSD is going to do a read-modify-write on anything smaller than
16kBytes in any case, might btrfs just as well use that chunk size to
good advantage in the first place?

So, what is most significant?


Also:

btrfs has a big advantage of using checksumming and COW. However, ext4
is more mature, similarly uses extents, and also allows specifying a
large "delayed allocation" time to merge multiple writes if you're happy
your system is safely on a UPS...


I'm not too worried about this for MLC SSDs, but it is something that is
of concern for the yet shorter modify-erase count lifespan of TLC SSDs.


Regards,
Martin

