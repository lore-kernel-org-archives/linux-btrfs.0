From: Tom Cameron <tomc603@gmail.com>
Subject: Balance RAID10 with odd device count
Date: Mon, 20 Feb 2012 19:35:18 -0500
Message-ID: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com>
Reply-To: tom@drdabbles.us
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had a 4 drive RAID10 btrfs setup that I added a fifth drive to with
the "btrfs device add" command. Once the device was added, I used the
balance command to distribute the data through the drives. This
resulted in an infinite run of the btrfs tool with data moving back
and forth across the drives over and over again. When using the "btrfs
filesystem show" command, I could see the same pattern repeated in the
byte counts on each of the drives.

It would probably add more complexity to the code, but adding a check
for loops like this may be handy. While a 5-drive RAID10 array is a
weird configuration (I'm waiting for a case with 6 bays), it _should_
be possible with filesystems like BTRFS. In my head, the distribution
of data would be uneven across drives, but the duplicate and stripe
count should be even at the end. I'd imagine it to look something like
this:

D1: A1 B1 C1 D1
D2: A1 B1 C1    E1
D3: A2 B2    D1 E1
D4: A2    C2 D2 E2
D5:    B2 C2 D2 E2

This is obviously over simplified, but the general idea is the same. I
haven't looked into the way the "RAID"ing of objects works in BTRFS
yet, but because it's a filesystem and not a block-based system it
should be smart enough to care only about the duplication and striping
of data, and not the actual block-level or extent-level balancing.
Thoughts?

Thanks in advance!
Tom
