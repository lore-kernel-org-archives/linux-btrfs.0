Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56958 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964842Ab2I1V0X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 17:26:23 -0400
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Fri, 28 Sep 2012 17:26:21 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q8SLQI0C118948
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 17:26:18 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q8SLQHB9015160
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Sep 2012 18:26:18 -0300
Message-ID: <506615F8.90202@linux.vnet.ibm.com>
Date: Fri, 28 Sep 2012 14:26:16 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        kreijack@inwind.it, kreijack@libero.it,
        =?ISO-8859-1?Q?S=E9bastien_Mau?= =?ISO-8859-1?Q?ry?=
	<sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr> <5064B96B.7060502@libero.it> <5064BEEB.1090707@libero.it> <20120928091759.6d096016@natsu> <5065D3D7.8080101@inwind.it> <20120929000223.4827d375@natsu> <20120928202026.GG6136@carfax.org.uk>
In-Reply-To: <20120928202026.GG6136@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/28/2012 01:20 PM, Hugo Mills wrote:

> On Sat, Sep 29, 2012 at 12:02:23AM +0600, Roman Mamedov wrote:
>> On Fri, 28 Sep 2012 18:44:07 +0200
>> Goffredo Baroncelli<kreijack@inwind.it>  wrote:
>>
>>> This means that the ration of space physically allocated on the disk and
>>> the space available is 7GB/10GB = 0.7 . So on 135GB of disk, only 94GB
>>> are available.
>> You assume metadata allocation will always grow linearly with data, which is
>> not true. So in my opinion it is not a good estimate.
>     No, but it's the best model we have right now. (And probably about
> the best model we will have, without knowledge of the future
> intentions of the user). Without inlining file data, the metadata is
> dominated by checksums, which is a linear relationship (approx
> 1000:1). With inlining file data, metadata is probably dominated by
> inline data; assuming the ratio of small-to-large files on the FS
> remains unchanged in future, a linear relationship also applies. For
> general usage, I'm happy to assume that the current ratio of data to
> metadata will remain largely unchanged over the lifetime of the FS.
Since there really isn't a simple answer to how much free-space,
why not have the command print an upper and lower estimate and let
the user figure out how to interpret the numbers? This would inform
the user that there is some guesswork inherent in the estimation and
also provide an educated user with more exact numbers. Something
containing information such as:

   Total:                        135.00 GiB
   Allocated:                    10.51 GiB
   Unallocated:                  124.49 GiB
   Free_Upper_Est:               130.00 GiB
   Free_Lower_Est:               62.45 GiB



The main idea is that an informed user would know that the
upper-estimation would be for only writing, say, new data, while
the lower-estimation would be for writing everything in, say, a
RAID-1 subvolume. An uninformed user would (hopefully) realize
that he needs to read the Wiki's FAQ.

>     ... and I've always found those hard to deal with in scripts. :)
>
>     (But they do have "plumbing" options, to use the git terminology,
> so I'd be happy with having a parsable output option).
>
>     Hugo.
>
In 'df'/'du', -h is used for human-readable output while no options
is for easily parsable output.

Basically, I think that the bikeshed should be green. ;)

-Wade

