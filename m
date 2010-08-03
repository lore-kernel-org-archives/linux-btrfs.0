From: birger <birger@birger.sh>
Subject: birgers RFE #2
Date: Tue, 03 Aug 2010 14:44:41 +0200
Message-ID: <1280839481.31210.10.camel@sch30110.bergens-tidende.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I understand that there is resistance to adding dependencies to the
tools package, so how about a contrib package for contributed tools?

I have a neat snapshot script for my laptop that I wouldn't mind
sharing. Works mostly like the NetApp snapshots. Set up a cron job with
a prefix for the snapshot name and the number of snapshots to keep. It's
very easy to set up for schemes like 24 hourly snapshots, 7 daily and 4
weekly.

The only dependency as far as I remember now is bash.

I would also be willing to try setting up a btrfs-to-btrfs incremental
snapshot system given that my RFE #3 also gets done. :-)

-- 
birger


