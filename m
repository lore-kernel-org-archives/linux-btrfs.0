From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: snapshot merging?
Date: Sun, 21 Sep 2008 14:22:38 +0200
Message-ID: <48D63C8E.2060802@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

At the beginning of August, Mikulas Patocka posted to linux-kernel 
mailing list about adding snapshot merging to LVM[1].

Basicaly, snapshot merging means that it is possible to turn a snapshot 
back into its origin.

Using LVM, however, means that you need to have free place outside of 
the filesystem (i.e., in physical volume) to make snapshots, which is 
not always possible on workstations and some servers.

Is something similar available, or planned, for btrfs? I didn't find 
anything similar on "btrfs design" page in the wiki.



[1] http://kerneltrap.org/Linux/LVM_Snapshot_Merging


-- 
Tomasz Chmielewski
http://wpkg.org
