Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:39340 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030213Ab2JXTNB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 15:13:01 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device [SOLVED]
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50882E38.4000408@gmail.com>
Date: Wed, 24 Oct 2012 13:13:01 -0600
Message-Id: <D0E7C142-9FAE-4233-BA2E-BB1EB341FD93@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it> <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com> <5087174A.2060405@inwind.it> <1BE15E02-3DBE-42AB-8900-D82C11BCD1B7@colorremedies.com> <50882E38.4000408@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 24, 2012, at 12:06 PM, Goffredo Baroncelli <kreijack@gmail.com> wrote:
>> 
> 
> I was able to reproduce it:
> 
> - I filled the filesystem until I got "No space left on device".

I didn't even need to get that far.


> So it seems that I spread all the data to the other disk, filling up the
> smaller ones. So it stuck to "No space left on device".
> 
> Now I rebalanced with -dconvert=single, as suggested by Hugo, then I was
> able to remove the disk:
> 
> Label: 'test2'  uuid: 11d0f1a8-2770-4ff2-8df5-f772f1056edc
> 	Total devices 3 FS bytes used 7.63GB
> 	devid    4 size 12.00GB used 9.48GB path /dev/vdf
> 	devid    3 size 3.00GB used 492.94MB path /dev/vdd
> 	devid    2 size 3.00GB used 64.00MB path /dev/vdc

It's an interesting solution, but difficult for a larger file system. Or at least, could be very time consuming.

Aside from the "no space left" problem, the 'device delete' behavior itself has kindof a high penalty: a successful 'device delete' on a five disk raid10 (one was added in advance of the delete), all disks are significantly written to, not merely a reconstruction of the replaced disk. It means a lot of writing to do disk removals in the face of an impending disk failure.


Chris Murphy

