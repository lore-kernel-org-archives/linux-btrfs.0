From: Zheng Yan <zheng.yan@oracle.com>
Subject: Re: snapshot merging?
Date: Sun, 21 Sep 2008 22:19:07 +0800
Message-ID: <48D657DB.7050601@oracle.com>
References: <48D63C8E.2060802@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48D63C8E.2060802@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski wrote:
> At the beginning of August, Mikulas Patocka posted to linux-kernel
> mailing list about adding snapshot merging to LVM[1].
> 
> Basicaly, snapshot merging means that it is possible to turn a snapshot
> back into its origin.
> 
> Using LVM, however, means that you need to have free place outside of
> the filesystem (i.e., in physical volume) to make snapshots, which is
> not always possible on workstations and some servers.
> 
> Is something similar available, or planned, for btrfs? I didn't find
> anything similar on "btrfs design" page in the wiki.
> 
Writeable snapshot has been available in btrfs for a long time.

> 
> [1] http://kerneltrap.org/Linux/LVM_Snapshot_Merging
> 
Writeable snapshot means you can mount/modify snapshots as you like.
In other words, btrfs does snapshot merging automatically.


Yan Zheng
