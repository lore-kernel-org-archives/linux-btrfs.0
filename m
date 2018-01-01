Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:44278 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbeAAAsR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Dec 2017 19:48:17 -0500
Received: by mail-it0-f51.google.com with SMTP id b5so35698548itc.3
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Dec 2017 16:48:17 -0800 (PST)
MIME-Version: 1.0
Reply-To: swestrup@gmail.com
From: Stirling Westrup <swestrup@gmail.com>
Date: Sun, 31 Dec 2017 19:48:15 -0500
Message-ID: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com>
Subject: A Big Thank You, and some Notes on Current Recovery Tools.
To: linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <n.borisov.lkml@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, I want to start this post with a HUGE THANK YOU THANK YOU THANK
YOU to Nikolay Borisov and most especially to Qu Wenruo!

Thanks to their tireless help in answering all my dumb questions I
have managed to get my BTRFS working again! As I speak I have the
full, non-degraded, quad of drives mounted and am updating my latest
backup of their contents.

I had a 4-drive setup with 2x4T and 2x2T drives and one of the 2T
drives failed, and with help I was able to make a 100% recovery of the
lost data. I do have some observations on what I went through though.
Take this as constructive criticism, or as a point for discussing
additions to the recovery tools:

1) I had a 2T drive die with exactly 3 hard-sector errors and those 3
errors exactly coincided with the 3 super-blocks on the drive. The
odds against this happening as random independent events is so
unlikely as to be mind-boggling. (Something like odds of 1 in 10^26)
So, I'm going to guess this wasn't random chance. Its possible that
something inside the drive's layers of firmware is to blame, but it
seems more likely to me that there must be some BTRFS process that
can, under some conditions, try to update all superblocks as quickly
as possible. I think it must be that a drive failure during this
window managed to corrupt all three superblocks. It may be better to
perform an update-readback-compare on each superblock before moving
onto the next, so as to avoid this particular failure in the future. I
doubt this would slow things down much as the superblocks must be
cached in memory anyway.

2) The recovery tools seem too dumb while thinking they are smarter
than they are. There should be some way to tell the various tools to
consider some subset of the drives in a system as worth considering.
Not knowing that a superblock was a single 4096-byte sector, I had
primed my recovery by copying a valid superblock from one drive to the
clone of my broken drive before starting the ddrescue of the failing
drive. I had hoped that I could piece together a valid superblock from
a good drive, and whatever I could recover from the failing one. In
the end this turned out to be a useful strategy, but meanwhile I had
two drives that both claimed to be drive 2 of 4, and no drive claiming
to be drive 1 of 4. The tools completely failed to deal with this case
and were consistently preferring to read the bogus drive 2 instead of
the real drive 2, and it wasn't until I deliberately patched over the
magic in the cloned drive that I could use the various recovery tools
without bizarre and spurious errors. I understand how this was never
an anticipated scenario for the recovery process, but if its happened
once, it could happen again. Just dealing with a failing drive and its
clone both available in one system could cause this.

3) There don't appear to be any tools designed for dumping a full
superblock in hex notation, or for patching a superblock in place.
Seeing as I was forced to use a hex editor to do exactly that, and
then go through hoops to generate a correct CSUM for the patched
block, I would certainly have preferred there to be some sort of
utility to do the patching for me.

4) Despite having lost all 3 superblocks on one drive in a 4-drive
setup (RAID0 Data with RAID1 Metadata), it was possible to derive all
missing information needed to rebuild the lost superblock from the
existing good drives. I don't know how often it can be done, or if it
was due to some peculiarity of the particular RAID configuration I was
using, or what. But seeing as this IS possible at least under some
circumstances, it would be useful to have some recovery tools that
knew what those circumstances were, and could make use of them.

5) Finally, I want to comment on the fact that each drive only stored
up to 3 superblocks. Knowing how important they are to system
integrity, I would have been happy to have had 5 or 10 such blocks, or
had each drive keep one copy of each superblock for each other drive.
At 4K per superblock, this would seem a trivial amount to store even
in a huge raid with 64 or 128 drives in it. Could there be some method
introduced for keeping far more redundant metainformation around? I
admit I'm unclear on what the optimal numbers of these things would
be. Certainly if I hadn't lost all 3 superblocks at once, I might have
thought that number adequate.

Anyway, I hope no one takes these criticisms the wrong way. I'm a huge
fan of BTRFS and its potential, and I know its still early days for
the code base, and it's yet to fully mature in its recovery and
diagnostic tools. I'm just hoping that these points can contribute in
some small way and give back some of the help I got in fixing my
system!



-- 
Stirling Westrup
Programmer, Entrepreneur.
https://www.linkedin.com/e/fpf/77228
http://www.linkedin.com/in/swestrup
http://technaut.livejournal.com
http://sourceforge.net/users/stirlingwestrup
