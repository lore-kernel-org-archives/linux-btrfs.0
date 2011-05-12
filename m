From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: BTRFS deduplication
Date: Thu, 12 May 2011 07:52:20 +0200
Message-ID: <1305179540.3106.8.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi again list,

I've seen in a message dating back to january that offline deduplication
has been implemented in BTRFS, but I can't find it in my btrfs-tools
0.19+20100601-3ubuntu2

Has it reached release, or not yet ? How could I give it a try ?

I've seen a discussion about whether deduplication should be made
offline or online ; my usage case it to backup a number of laptops
having all about the same software and many files in common, to a single
backup server using rsync, I would be very much interested in online
deduplication - because I don't have "n" times the storage space, that
offline dedup might temporarily need, and because performance isn't
crucial for this application, as backups can be done overnight...

Thanks in advance :-)

