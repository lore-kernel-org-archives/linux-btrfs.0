Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:53645 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754291Ab3JBQx5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Oct 2013 12:53:57 -0400
Date: Wed, 2 Oct 2013 10:53:24 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Is `btrfsck --repair` supposed to actually repair problems?
Message-ID: <20131002165324.GA21508@pyropus.ca>
References: <20131001211255.GA5946@pyropus.ca>
	<13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com>
	<20131001234655.GA7937@pyropus.ca>
	<441F4B12-E813-43E0-9933-79D1C3BF68C3@colorremedies.com>
	<20131002031355.GA11675@pyropus.ca>
	<DFC049CD-209E-49CB-91A3-05BB2F766BC8@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <DFC049CD-209E-49CB-91A3-05BB2F766BC8@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> wrote:
> On Oct 1, 2013, at 9:13 PM, Charles Cazabon wrote:
> > 
> > Ah, I'm not looking to repair the files -- I can recopy the files easily
> > enough, and rsync will pick up any files whose contents have been corrupted.
> 
> If you run a scrub, dmesg should contain the path for affected files which
> you can then delete. If it's just a checksum problem with files, the file
> system doesn't need fixing.

Okay, I'll do that.

> I'd wait until the raid is finished syncing.

Strictly speaking, this shouldn't be necessary.  mdadm arrays are fully usable
from creation during the initial sync; the system tracks which bits have been
initialized and which haven't.

> > It's a brand new array.  The initial sync is actually still going on
> > (about half complete; it'll take several days to initialize an array this
> > size on this hardware).
> 
> OK maybe someone else can comment if this is expected to work, maybe on
> linux-raid even.

https://raid.wiki.kernel.org/index.php/Initial_Array_Creation talks about the
initial (re)sync.  It explicitly states:

  This can take quite a time and the array is not fully resilient whilst this
  is happening (it is however fully useable). 

> But now you tell us this? You didn't think it might be important to mention
> that you've got a raid initially syncing, that you've formatted btrfs,
> copied files over, and at some point you got a kerne lock up, and then once
> restarted you ran a btrfsck?

Yes.  The array uses a write-intent bitmap, so the kernel lockup during the
initial sync does not cause corruption; when the system is brought back up, it
may re-initialize a portion that it had already initialized (i.e. it's not
100% efficient), but it doesn't result in corruption.

> I would expect problems with any file system, with a system that locks up
> while the raid is still syncing.

No, this doesn't cause any particular problems.  It's just like the normal
case of a single-drive filesystem and the system crashing during a write.
You just fsck to address any problems the interrupted write caused and recover
the journal (if applicable).

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
