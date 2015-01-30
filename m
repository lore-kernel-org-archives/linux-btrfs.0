Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54696 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762698AbbA3RaD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 12:30:03 -0500
Date: Fri, 30 Jan 2015 18:30:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, miaoxie@huawei.com
Subject: Re: [PATCH RFC v3 1/5] Revert "btrfs: add support for processing
 pending changes" related commits
Message-ID: <20150130173001.GP3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422005505-9472-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422005505-9472-2-git-send-email-quwenruo@cn.fujitsu.com>
 <20150123145735.GN13289@twin.jikos.cz>
 <54C58C5C.30701@cn.fujitsu.com>
 <54C5D91E.7050502@cn.fujitsu.com>
 <20150128132513.GE3641@twin.jikos.cz>
 <54C989A0.1080307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54C989A0.1080307@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 29, 2015 at 09:15:12AM +0800, Qu Wenruo wrote:
> > Are we sure that there's no possible deadlock when we eg. change the
> > label via sysfs in the middle of a balance that removes some of the
> > files? Or other combination of operations. Can we guarantee that this
> > will be ok in the long term and not introduced accidentally?
> For me, I didn't see the difference between VFS staff and sysfs/kernfs 
> staff.
> They both have their own locking things which is out of the control of 
> btrfs.

VFS is a close neighbor in the layering, syscalls come through it,
affects filesystem state very often and API changes propagate to all the
filesystems.

Sysfs provides us some API but in a very limited scope compared to VFS.

> But we are still using VFS staffs, right? If we want to use sysfs 
> interfaces to do things like change label,
> then it's our responsibility to ensure things works fine.

I absolutelly agree with that and that's why I'm trying to minimize the
potential traps when the subsystems become interconnected too closely,
eg.  depending on internal locks.

> If not we 
> should either modify btrfs or sysfs to
> do it, just like what we were doing with VFS staffs.

This means changing innternal workings of the two, this seems unlikely
as we're mere users for them. Though we can bring new requests for API
or some such, we can't easily affect their internal logic just because
it's easy for us to throw a transaction commit somewhere and stop
caring.

> To ensure the cooperation works fine, we just need extra testcases, much 
> like what we were doing.
> 
> So IMHO, I didn't really see the difference between VFS and sysfs staffs 
> (except sysfs is not so wided adapted).
> We just needs to do all the old style work, modify btrfs or sysfs or 
> both and, and add tons of test case.

And I see a big difference, if nothing else, sysfs is user of VFS layer.
