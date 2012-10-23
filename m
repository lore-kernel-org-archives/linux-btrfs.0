Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:50429 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933444Ab2JWU2O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 16:28:14 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5086E9D6.4070201@inwind.it>
Date: Tue, 23 Oct 2012 14:28:11 -0600
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, kreijack@inwind.it
Message-Id: <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 23, 2012, at 1:02 PM, Goffredo Baroncelli <kreijack@inwind.it> wrote:

> On 2012-10-23 20:17, Chris Murphy wrote:
>> 
>> btrfs-progs-0.20.rc1.20121017git91d9eec-1.fc18.x86_64
> 
> Definitely this version contains my patch.
> 
> Are you able to reproduce this bug (the missing device warning)?

Yes. 100%. It's there hours later.

> If so,
> please could you be so kindly to test the Stefan's tool [*] to dump the
> super-blocks of the involved disks ?

I would but haven't the first clue what to do with this:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg19572.html

This happens even with no data, so I can dd the entire missing device into a sparse file: dd to img, cp --sparse, tar with -Sj. The 80GB /dev/sdb becomes 2.5K. It's here now:
https://dl.dropbox.com/u/3253801/devsdb_image_sparse.img.tar.bz2

And by the time I've done all that, the "*** Some devices missing" message is still present with 'btrfs fi show'

Or since it's a VM that I don't care about at all, I can give you login info.

Chris Murphy