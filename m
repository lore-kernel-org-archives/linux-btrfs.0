From: Brian Sullivan <bexamous@gmail.com>
Subject: ls & flush-btrfs-1 sit at 100% sys
Date: Wed, 17 Nov 2010 21:03:02 -0800
Message-ID: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had been running 2.6.32 for a many months without any issues.  Btrfs
on top of a raid6 md array.  Filesystem is at  9/11TB used.

I updated to 2.6.34 for a week or so and had no problem.
Updated to 2.6.36 for a few days and no problems.
Update to 2.6.37 and now I cannot read from array.

So I boot up to 2.6.37...
I can run btrfsck and it finds no problems.
I can mount the fs, no problem.
I can run df, no problem.
I can cd to the fs, no problem... even a few folders down, as long as
I can remember exact path because...
Soon as I do 'ls' anywhere it gets stuck.

Is doesn't return, I check top and both ls and flush-btrfs-1 are
sitting at ~50% sys usage each.

I let the system sit in this state all day today while I was at work
(~9 hours) and ls never returned.  Even while in this state however,
df still is working.  I can still cd to directories (as long as I
recall their exact path).

Not sure what is going on here.
