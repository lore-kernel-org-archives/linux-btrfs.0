From: Mat <jackdachef@gmail.com>
Subject: [mount] commit intervall for metadata and btrfs - is it planned ?
Date: Wed, 10 Feb 2010 18:15:26 +0000 (UTC)
Message-ID: <loom.20100210T190536-373@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

First off: you guys are doing amazing work !

btrfs "Better-FS" gets more and more stable, fast and space-efficient than
all/most of the other filesystems :)


It being able to survive compiling of openoffice, chromium webbrowser and other
stressful stuff is a testament to its ever growing maturity 


Now on to my question:

Since I'm using btrfs on more and more test-partitions on my system and also am
into energy saving:

is the following mount-option which exists for reiserfs, ext2-4 and reiser4
(tmgr.atom_max_age) also planned to be implemented for btrfs ?

       commit=nrsec
              Sync all data and metadata  every  nrsec  seconds.  The  default
              value is 5 seconds. Zero means default.

(in this case ext3)

if yes, when will it be added ?


Many thanks in advance

Mat

