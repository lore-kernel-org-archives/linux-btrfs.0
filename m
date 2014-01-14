Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35359 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751719AbaANV1p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:27:45 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:55122 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W3BWP-000PBx-Va
	for linux-btrfs@vger.kernel.org; Tue, 14 Jan 2014 14:27:42 -0700
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140114210617.GK7221@carfax.org.uk>
Date: Tue, 14 Jan 2014 14:27:40 -0700
Message-Id: <AF3AF222-D59D-4209-BC7A-91D6EB58EC50@colorremedies.com>
References: <201401100106.s0A16CNd016476@atl4mhib27.myregisteredsite.com> <52CF4D5D.2010709@chinilu.com> <486C0640-409D-4636-858C-84A679C0AF4E@colorremedies.com> <52D59E28.7010200@chinilu.com> <20140115030021.0b001eeb@natsu> <20140114210617.GK7221@carfax.org.uk>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 14, 2014, at 2:06 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Wed, Jan 15, 2014 at 03:00:21AM +0600, Roman Mamedov wrote:
>> That said, do not fall into a false sense of security relying on proprietary,
>> barely if ever updated after the device has been shipped, and often very
>> peculiar-behaving SMART routines inside the black-box HDD firmware as your
>> most important data safeguard.
>> 
>> Of course SMART must be checked and monitored, but don't delude yourself into
>> thinking it will always warn you of anything going wrong well in advance of
>> failure, or even at all.
> 
>   The famous paper from Google a few years back suggested that SMART
> was a useful predictor of failure in something like 20% of failures.

https://static.googleusercontent.com/media/research.google.com/en/us/archive/disk_failures.pdf


"Out of all failed drives, over 56% of them have no count in any of the four strong SMART signals,"

and

"even when we add all remaining SMART parameters (except temperature) we still ﬁnd that over 36% of all failed drives had zero
counts on all variables."

For those that do report counts, they still weren't able to come up with a good predictor of failures based on any combination of the current attributes.

So there's a really good chance the drive will fail without warning. This study doesn't report on the accuracy of the health self-assessment, i.e. the PASS/FAIL state for the drive.


Chris Murphy