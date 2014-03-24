Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exchange-west-ht02.tripadvisor.com ([192.170.138.102]:16745
	"EHLO exchange-west.tripadvisor.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751084AbaCXE4i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 00:56:38 -0400
From: "Benjamin O'Connor" <boconnor@tripadvisor.com>
To: Marc MERLIN <marc@merlins.org>
CC: Hugo Mills <hugo@carfax.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Any use for mkfs.btrfs -d raid5 -m raid1 ?
Date: Mon, 24 Mar 2014 04:50:16 +0000
Message-ID: <AB4CCD7B-7343-4BCD-A7EA-4F5540F084F6@tripadvisor.com>
References: <20140323224435.GC18293@merlins.org>
 <20140323225229.GJ25400@carfax.org.uk> <20140323231156.GD18293@merlins.org>
In-Reply-To: <20140323231156.GD18293@merlins.org>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While raid1 metadata with raid5 data would seem to be a non-useful configuration, I've taken to using raid10 metadata with raid0 data (and if I'm right, my logic could probably be extended to claim that r10 metadata would be a good choice with r5 data).

In theory this would preserve some copy of the metadata in the case of a pair of blown drives in r5, or in the case of any blown drive in r0.  

I have not done any testing, but my assumption in setting it up this way would be that even though my data is r0 and losing a drive would obviously send that particular data into the weeds, since there is still a good metadata structure I'd be able to recover data that lay elsewhere on the BTRFS.

My setup here, BTW, is 10x 28TB LUNs. (250+TB btrfs filesystem)  BTRFS Raid0 for data, Raid10 for metadata.  This is just log archive data, so total data redundancy isn't much of an issue.  Obviously if one of my 28TB LUNs pooped the bed, I'd lose all of the data there, but presumably since the metadata is redundant across other LUNs, I'd still be able to rescue a decent amount of the remaining data.  

Now that I've written this entire email out, I'm thinking I should probably actually test the implication of a total LUN loss though, because otherwise I'm just wasting space mirroring the striped metadata (not that it really matters that much though, storage is cheap). 

-ben

On Mar 23, 2014, at 7:11 PM, Marc MERLIN <marc@merlins.org> wrote:

> On Sun, Mar 23, 2014 at 10:52:29PM +0000, Hugo Mills wrote:
>> On Sun, Mar 23, 2014 at 03:44:35PM -0700, Marc MERLIN wrote:
>>> If I lose 2 drives on a raid5, -m raid1 should ensure I haven't lost my
>>> metadate.
>>> From there, would I indeed have small files that would be stored entirely on
>>> some of the drives that didn't go missing, and therefore I could recover
>>> some data with 2 missing drives?
>> 
>>   btrfs's RAID-1 is two copies only, so you may well have lost some
>> of your metadata. n-copies RAID-1 is coming Real Soon Now™ (Chris has
>> it on his todo list, along with fixing all the parity RAID stuff).
> 
> Oh, right, I forgot about that. Then I'm not coming up with many good
> reasons why raid1 metadata with raid5 data would be useful.
> Actually raid5 metadata should be faster since it's striped on more drives.
> 
> I'll update the doc I just posted, thanks.
> 
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                      .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  

----------
Benjamin O'Connor
TechOps Systems Administrator
TripAdvisor Media Group

boconnor@tripadvisor.com
c. 617-312-9072
----------




