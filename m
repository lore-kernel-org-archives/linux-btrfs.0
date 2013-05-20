Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45043 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab3ETJWa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 05:22:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UeMIU-0004ZL-FW
	for linux-btrfs@vger.kernel.org; Mon, 20 May 2013 11:22:26 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 May 2013 11:22:26 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 20 May 2013 11:22:26 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs (general) raid for other filesystems?
Date: Mon, 20 May 2013 10:22:12 +0100
Message-ID: <kncpvv$18i$1@ger.gmane.org>
References: <knb28t$p9p$1@ger.gmane.org> <CAFvQSYQObGsKCf3iPtErfFvdQv6vqwc_KNAm5wt763ChrZWtUA@mail.gmail.com> <knb7di$8ee$1@ger.gmane.org> <C773E07F-F3BE-4C1A-8FAE-D72968F475B2@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <C773E07F-F3BE-4C1A-8FAE-D72968F475B2@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/05/13 20:34, Chris Murphy wrote:
> On May 19, 2013, at 12:59 PM, Martin <m_btrfs@ml1.co.uk> wrote:
>> 
>> btrfs-raid offers a greater variety and far greater flexibility of
>> raid options individually for filedata and metadata at the
>> filesystem level.
> 
> Well it really doesn't. The btrfs raid advantages leverage prior work
> that makes btrfs what it is.

Indeed, the "btrfs raid" as evolving looks to be tightly part of btrfs
itself, shaped by what is being done in btrfs...

And also there is the work going into how the 'raid' semantics
operate for data and the filesystem metadata.

Also tied into that is storage balancing and load (io bandwidth)
balancing with most recently developers looking how to move 'hot' data
onto preferred physical drives?


>> OK... So we make all of lvm, md-raid, and drbd all redundant!
> 
> No they are different things for different use cases. What you seem
> to be asking for is for a ZFS-like feature that allows other file
> systems to exist on ZFS, and thereby gaining some of the advantage of
> the underlying file system.

That's going a little too deep...


My thoughts are much more shallow. Can the raid and load balancing work
being done for btrfs be bundled up so as to permit that to also be used
instead as a filesystem layer that then utilises /any/ underlying
filesystem?

So, instead of btrfs style file-level raid and load balancing only on
devices which have been formatted with btrfs, the raid and load
balancing operates as a filsystem layer that coordinates storing files
on any motley collection of multiple whatever filesystem-on-device.

Obvious enough for raid1 to 'tee' a file out to multiple filesystems.

For the other raids, filenames would need to be munged to denote their
multiple parts (simply always append a 6 character index?). raid0 would
need a file to be split into parts and then those file parts
concatenated upon reading under the original filename. raid5/6 would
similarly need file splitting but also the data redundancy added.

For example, for paranoid redundancy and fast operation:


raid1 + load balance

 |
 V

btrfs on HDD1, ext4 on HDD2, NILFS on flash1, nfs to host2


Obviously, doing that loses any features (such as snapshots) not common
across all the group.


As for a use case? Would that be a good idea or not? :-)

One thought is that users could set up funky redundant operation across
networked devices using nfs.

Another thought is that we go to an awful lot of trouble to accommodate
extremely different storage technologies that are only ever going to
physically diverge further. For example, we have HDDs and SSDs. We also
have much cheaper flash with very limited wear levelling ideal for
'cold' data. Or even raw flash without all the proprietary firmware
obscurity... Hence dedicate a particular filesystem to each rather than
one monster for all?


The "raid + load balance" could be a well defined layer with no or few
special hooks into the lower layers.


All just a thought...

Regards,
Martin

