From: Yee-Ting Li <yee379@gmail.com>
Subject: show data and metadata raid settings
Date: Sat, 10 Jul 2010 22:29:08 -0700
Message-ID: <FBD4FCC6-CEB3-464D-A48C-5F57F5A4D9A6@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
To: The development of BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-show can list the disks in a btrfs array, but is there a way i can determine the raid settings on an array? i /though/ i had created a raid1 data and metadata array, but when i copy data into it, each file doesn't appear to occupy double the amount of space on the array as i expected from reading the various threads on the mailing list.

is there a way i can move an existing array between different raid types (within reason of disk space etc)? when's the eta for raid5?

on ubuntu 10.4.