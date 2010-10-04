From: "Jason J. W. Williams" <jasonjwwilliams@gmail.com>
Subject: MySQL on BTRFS Experiences
Date: Mon, 4 Oct 2010 12:17:21 -0600
Message-ID: <AANLkTi=7PDWuRb6J8cma-E7qGbFU=ounrzwZB681moZG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

My shop is a long time (~2006) ZFS user, considering moving off OpenSolaris
due to a number of non-technical issues. We use ZFS for all of our MySQL
databases. It's cheap/fast snapshots are critical to our backup strategy,
and we rely on the L2ARC and dedicated log device (i.e. NVRAM) features to
accelerate our pools with SSDs.

I've read through the archives for comments on stability, but they seem to
be generic "is it stable" questions. Is there anyone who is running a
critical MySQL operation on BTRFS that could comment on their experience
with it? "critical" to me means a 24x7 operation with 3-4 nines uptime
requirement.

Also, as BTRFS doesn't seem to have SSD acceleration features yet, is anyone
using BTRFS in combination with flashcache?

Anybody who's come to BTRFS from ZFS would be very helpful too.

Thank you in advance.

-J
