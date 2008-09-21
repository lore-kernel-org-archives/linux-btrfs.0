From: Zheng Yan <zheng.yan@oracle.com>
Subject: Re: snapshot merging?
Date: Sun, 21 Sep 2008 23:00:14 +0800
Message-ID: <48D6617E.1010908@oracle.com>
References: <48D63C8E.2060802@wpkg.org> <48D657DB.7050601@oracle.com> <48D65ACD.7030907@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48D65ACD.7030907@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski wrote:
> Zheng Yan schrieb:
>> Tomasz Chmielewski wrote:
>>> At the beginning of August, Mikulas Patocka posted to linux-kernel
>>> mailing list about adding snapshot merging to LVM[1].
>>>
>>> Basicaly, snapshot merging means that it is possible to turn a snapshot
>>> back into its origin.
>>>
>>> Using LVM, however, means that you need to have free place outside of
>>> the filesystem (i.e., in physical volume) to make snapshots, which is
>>> not always possible on workstations and some servers.
>>>
>>> Is something similar available, or planned, for btrfs? I didn't find
>>> anything similar on "btrfs design" page in the wiki.
>>>
>> Writeable snapshot has been available in btrfs for a long time.
> 
> Writeable snapshots and snapshot merging are two different things.
> 
> 
>>> [1] http://kerneltrap.org/Linux/LVM_Snapshot_Merging
>>>
>> Writeable snapshot means you can mount/modify snapshots as you like.
>> In other words, btrfs does snapshot merging automatically.
> 
> With LVM, you can also modify snapshots as you like, but it doesn't mean
> LVM supports snapshot merging right now (that is, you have to apply the
> patches described on the page above to have "snapshot merging" feature).
> 
> 
> Maybe let me show you an example:
> 
> 0) you have your "original" root filesystem
> 1) you make a snapshot of your rootfs
> 2) you upgrade your distribution (version 1.0 -> version 2.0-alpha)
> 3) you realise that some of the things don't work as expected - you mark
> that your snapshot should be turned into an original
> 4) you reboot (as your rootfs is mounted, you have to) and from now on
> your snapshot turns into the original from point 0.
> 

You can mount the snapshot created in step 1 as your rootfs.
(by changing rootfs mount option in the boot parameter)

Yan Zheng



