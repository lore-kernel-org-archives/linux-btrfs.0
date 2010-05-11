From: Jay Sullivan <notfed@gmail.com>
Subject: rmdir SubVolume?
Date: Tue, 11 May 2010 11:51:09 -0400
Message-ID: <AANLkTin_5GBuC9IzSzoY6hw4brLApJd2FeYfNj6Mo5Jc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm just experimenting with btrfs (am currently using btrfs-tools
v0.19). I'm curious about deleting subvolume (and snapshot)
directories.   What exactly is the technical reason why we need a
special command "btrfsctl -D" to delete these?  What's the obstacle
preventing "rmdir" from being used on these?

-- 
Jay Sullivan
