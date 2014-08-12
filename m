Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53460 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750763AbaHLDFB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 23:05:01 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:53655 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XH2OR-0017qu-Ny
	for linux-btrfs@vger.kernel.org; Mon, 11 Aug 2014 21:05:00 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Ideas for a feature implementation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53E97B8A.4010304@gmail.com>
Date: Mon, 11 Aug 2014 21:04:58 -0600
Message-Id: <022B4C95-B240-4562-A3D6-7BE7C650FA53@colorremedies.com>
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com> <53E83035.8010603@gmail.com> <678801E6-E1C8-42B5-8D50-C59B68549EC4@colorremedies.com> <53E97B8A.4010304@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 11, 2014, at 8:27 PM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 08/11/2014 04:27 PM, Chris Murphy wrote:
>> 
>> On Aug 10, 2014, at 8:53 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>> 
>>> 
>>> Another thing that isn't listed there, that I would personally
>>> love to see is support for secure file deletion.  To be truly
>>> secure though, this would need to hook into the COW logic so that
>>> files marked for secure deletion can't be reflinked (maybe make
>>> the automatically NOCOW instead, and don't allow snapshots?), and
>>> when they get written to, the blocks that get COW'ed have the old
>>> block overwritten.
>> 
>> If the file is reflinked or snapshot, then it can it be secure
>> deleted? Because what does it mean to secure delete a file when
>> there's a completely independent file pointing to the same physical
>> blocks? What if someone else owns that independent file? Does the
>> reflink copy get rm'd as well? Or does the file remain, but its
>> blocks are zero'd/corrupted?
> The semantics that I would expect would be that the extents can't be
> reflinked, and when snapshotted the whole file gets COW'ed, and then
> inherits the secure deletion flag, possibly with another flag saying
> that the user can't disable the secure deletion flag.

Ahh OK I was thinking of a secure delete command (or an option to rm that indicates secure delete). You're suggesting one or more flags that makes for secure file handling, not just delete, affecting: a.) copied b.) moved, c.) snapshot/reflinked, d.) deleted.  So if deleted, a regular rm would "see" the xattr and do a secure delete; and the xattr would inhibit or limit the others.

While a reflink or normal copy could be inhibited, the snapshot case seems more difficult because it just creates a new tree. It's not scanning the tree for files/folders with xattr, which would have to be done to go retroactively remove the file set with the secure delete flag - could be really slow. And what if the snapshot is made read-only?

Strictly secure delete, e.g. rm -s, would be more straightforward than a flag affecting other filesystem operations.

>> For SSDs, whether it's an overwrite or an FITRIM ioctl it's an open
>> question when the data is actually irretrievable. It may be
>> seconds, but could be much longer (hours?) so I'm not sure if it's
>> useful. On HDD's using SMR it's not necessarily a given an
>> overwrite will work there either.
> By secure deletion, I don't mean make the data absolutely
> unrecoverable by any means, I mean make it functionally impractical
> for someone without low-level access to and/or extensive knowledge of
> the hardware to recover the data; that is, more secure than simply
> unlinking the file, but obviously less than (for example) the
> application of thermite to the disk platters.  I'm talking the rough
> equivalent of wiping the data from RAM.
> 
> Anyone who is truly security minded should be using whole disk
> encryption anyway, but even then you have the data accessible from the
> running OS.

Seems straightforward for any file system already supporting discard. This even has a useful application for thinly provisioned storage and large files where you'd want the underlying logical layer to free up extents sooner than later - even if you didn't care about the security aspect.

But for that matter, on SSDs right now you can rm the file and then fstrim the file system to get the same effect.

Chris Murphy