Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55300 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031121Ab3HIVfw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 17:35:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V7uLf-0002IZ-Kj
	for linux-btrfs@vger.kernel.org; Fri, 09 Aug 2013 23:35:51 +0200
Received: from dyndsl-080-228-178-103.ewe-ip-backbone.de ([80.228.178.103])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Aug 2013 23:35:51 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-178-103.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Aug 2013 23:35:51 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Why does btrfs benchmark so badly in this case?
Date: Fri, 09 Aug 2013 23:35:33 +0200
Message-ID: <8u3gda-evs.ln1@hurikhan77.spdns.de>
References: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com> <20130808194015.GH16712@localhost.localdomain> <CAJBj3vfrHPDhM579JZDhUQgmyd2PnUtrgwYX0718tOrK8MzNCA@mail.gmail.com> <20130808203855.GI16712@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik@fusionio.com> schrieb:

>> So I guess the reason that ZFS does well with that workload is that
>> ZFS is using smaller blocks, maybe just 512B ?
> 
> Yeah I'm not sure what ZFS does, but if you are writing over a block and
> the size/offset isn't aligned then you'd see similar issues with ZFS since
> it would
> have to read+modify+write.  It is likely that ZFS just is using a smaller
> blocksize.

>From what I remember, ZFS uses dynamic block sizes. However, block size can 
be forced and thus tuned for workloads that require it:

http://www.joyent.com/blog/bruning-questions-zfs-record-size

Maybe that's the reason...

It would be interesting to see how the benchmarks performed with forced 
block size.

Regards,
Kai

