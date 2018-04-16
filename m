Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752934AbeDPTyc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 15:54:32 -0400
Date: Mon, 16 Apr 2018 21:52:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/15] Review uuid_mutex usage
Message-ID: <20180416195200.GA21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180412022938.8257-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2018 at 10:29:23AM +0800, Anand Jain wrote:
> uuid_mutex lock is not a per-fs lock but a global lock. The main aim of
> this patch-set is to critically review the usage of this lock, and delete
> the unnecessary once. By doing this we improve the concurrency of
> device operations across multiple btrfs filesystems is in the system.
> 
> patch 1: Was sent before, I am including it here, as its about uuid_mutex.
> 
> patch 2-9: Are cleanup and or preparatory patches.
> 
> patch 10-14: Drops the uuid_mutex and makes sure there is enough lock,
> as discussed in the patch change log.
> 
> patch 15: A generic cleanup patch around functions in the same context.
> 
> These patches are on top of
>   https://github.com/kdave/btrfs-devel.git remove-volume-mutex
> And it will be a good idea to go along with the kill-volume-mutex patches.
> 
> This is tested with xfstests and there are no _new_ regression. And I am
> trying to understand the old regressions, and notice that they are
> inconsistent.

The series looks good to me, I don't see any obvious breakage when the
uuid mutex is being removed, most of the device list consistency is
guarded by the device_list_mutex.

It indeed looks like uuid_mutex is overused and I've noticed that the
lock description in volumes.c is not entirely correct as it says that
eg. the device count and count of rw devices is proteced by that lock.

This would be good to update too, so it matches the code.

I'll add the branch to for-next to expose it to more testing.
