From: Tobias <tracer@robotech.de>
Subject: Extreme slowdown
Date: Thu, 15 Dec 2011 19:49:08 +0100
Message-ID: <4EEA4124.20907@robotech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all!

My BTRFS-FS ist getting really slow. Reading is ok, writing is slow and 
deleting is horrible slow.

There are many files and many links on the FS.

# btrfs filesystem df /srv/storage
Data: total=3.09TB, used=3.07TB
System, DUP: total=8.00MB, used=496.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=154.88GB, used=70.56GB
Metadata: total=8.00MB, used=0.00

Maybe it's because there is so much Metadata and it needs so many seeks 
on the discs when deleting?

I'd like to delete some of the old Files but its so horrible slow that i 
think its maybe faster to copy all needed Data to a different Disc, 
killing the FS and move the Files back...

The machine is a QuadCore with 8GB RAM. Kernel is "3.1+for-linus".

Any hints how i could speed it up?

Tobias
