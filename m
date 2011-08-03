From: Erik Jensen <eriksjunk@rkjnsn.net>
Subject: Honest timeline for btrfsck
Date: Tue, 2 Aug 2011 23:57:24 -0700
Message-ID: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The lack of any information on when btrfsck might be ready is a real
headache to those deciding what to do with a corrupted file system.

I am currently sitting on a btrfs array of 10 disks that has been
reporting "parent transid verify failed" since last November. While
the data on the drive is by no means irreplaceable, it would take a
fair amount of effort. At the time I was told that a btrfsck would
almost certainly be released by the end of the year. In January, it
was "finally almost ready", and toward the end of May it was going to
be released in "a couple of days
(hopefully)".

Had I known back in November 9 months would go by with no such tool, I
would have certainly wiped the array and started over, as it was
certainly not worth the wait. So here I am, several assurances of
imminent release later, still wondering whether it would be better to
wait or cut my losses.

I understand that everyone is working hard, and I deeply appreciate
the effort being put into this filesystem. I'm not looking for an
exact date, just a rough order of magnitude on which to base
decisions.

Thank you very much.

--Erik Jensen
