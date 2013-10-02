Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:13221 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752965Ab3JBTN2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Oct 2013 15:13:28 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is `btrfsck --repair` supposed to actually repair problems?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131002165324.GA21508@pyropus.ca>
Date: Wed, 2 Oct 2013 13:13:18 -0600
Cc: btrfs list <linux-btrfs@vger.kernel.org>
Message-Id: <DBA8B3F5-F070-48AC-8EF7-20CCCAD9C732@colorremedies.com>
References: <20131001211255.GA5946@pyropus.ca> <13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com> <20131001234655.GA7937@pyropus.ca> <441F4B12-E813-43E0-9933-79D1C3BF68C3@colorremedies.com> <20131002031355.GA11675@pyropus.ca> <DFC049CD-209E-49CB-91A3-05BB2F766BC8@colorremedies.com> <20131002165324.GA21508@pyropus.ca>
To: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 2, 2013, at 10:53 AM, Charles Cazabon <charlesc-lists-btrfs@pyropus.ca> wrote:

>> I'd wait until the raid is finished syncing.
> 
> Strictly speaking, this shouldn't be necessary.  mdadm arrays are fully usable
> from creation during the initial sync; the system tracks which bits have been
> initialized and which haven't.

I know but it's a 16TB array, do you really want to start over from scratch? No. And neither do most people. So this isn't a use case that's probably getting a ton of testing.


>> But now you tell us this? You didn't think it might be important to mention
>> that you've got a raid initially syncing, that you've formatted btrfs,
>> copied files over, and at some point you got a kerne lock up, and then once
>> restarted you ran a btrfsck?
> 
> Yes.  The array uses a write-intent bitmap, so the kernel lockup during the
> initial sync does not cause corruption; when the system is brought back up, it
> may re-initialize a portion that it had already initialized (i.e. it's not
> 100% efficient), but it doesn't result in corruption.

OK except there is corruption. We just don't know for sure if it's just files or if it's the file system. If you don't know already what caused it, it's not really correct to say what doesn't result in corruption.

Also the write-intent bitmap isn't configured by default, and you didn't previous say that it was. Is this an internal or external bitmap?


>> I would expect problems with any file system, with a system that locks up
>> while the raid is still syncing.
> 
> No, this doesn't cause any particular problems.  It's just like the normal
> case of a single-drive filesystem and the system crashing during a write.
> You just fsck to address any problems the interrupted write caused and recover
> the journal (if applicable).

If only hardware worked exactly per spec, and also didn't lie about committing data to disk rather than merely keeping it in cache, this may be true. But hardware lies, it has bugs. And the kernel isn't bug free either.


Chris Murphy