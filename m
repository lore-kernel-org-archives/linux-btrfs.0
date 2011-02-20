From: Maria =?ISO-8859-1?Q?Wikstr=F6m?= <maria@ponstudios.se>
Subject: bad tree block start
Date: Sun, 20 Feb 2011 20:24:49 +0100
Message-ID: <1298229889.13923.42.camel@mainframe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the computer froze for a few seconds then this appeared in the log:

btrfs bad tree block start 9407756905013237084 32178176

There was no other messages from btrfs. I can mount, unmount, read,
write and all the data seems to be there. What does it mean? My guess is
that there was some kind of corruption and it was corrected by the
raid1.

// Maria


