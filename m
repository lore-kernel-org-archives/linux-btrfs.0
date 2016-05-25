Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:52698 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbcEYLAM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 07:00:12 -0400
Subject: Re: Copy on write of unmodified data
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
 <20160525092958.GH16712@carfax.org.uk>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <dc2b10c2-24b4-0686-f382-c53cfce7a9df@zytor.com>
Date: Wed, 25 May 2016 04:00:00 -0700
MIME-Version: 1.0
In-Reply-To: <20160525092958.GH16712@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/25/16 02:29, Hugo Mills wrote:
> On Wed, May 25, 2016 at 01:58:15AM -0700, H. Peter Anvin wrote:
>> Hi,
>>
>> I'm looking at using a btrfs with snapshots to implement a generational
>> backup capacity.  However, doing it the naïve way would have the side
>> effect that for a file that has been partially modified, after
>> snapshotting the file would be written with *mostly* the same data.  How
>> does btrfs' COW algorithm deal with that?  If necessary I might want to
>> write some smarter user space utilities for this.
> 
>    Sounds like it might be a job for one of the dedup tools
> (deupremove, bedup), or, if you're writing your own, the safe
> deduplication ioctl which underlies those tools.
> 

I guess I would prefer if data wasn't first duplicated and then
deduplicated if possible.  It sounds like I ought to write a "smart
copy-overwrite" tool for this.

	-hpa



