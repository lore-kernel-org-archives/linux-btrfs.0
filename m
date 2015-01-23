Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbbAWQ7v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 11:59:51 -0500
Date: Fri, 23 Jan 2015 17:59:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaoxie@huawei.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Don't call btrfs_start_transaction() on frozen fs
 to avoid deadlock.
Message-ID: <20150123165949.GR13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150120171344.GH13289@twin.jikos.cz>
 <54BEF99D.7090104@cn.fujitsu.com>
 <1421802329.27917.8@mail.thefacebook.com>
 <54BEFC56.3000403@cn.fujitsu.com>
 <1421802656.27917.9@mail.thefacebook.com>
 <54BF189C.4070201@huawei.com>
 <54BF19DD.8060600@cn.fujitsu.com>
 <54BF1C5B.509@huawei.com>
 <54BF22BE.3080606@cn.fujitsu.com>
 <54BF4F62.3010805@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54BF4F62.3010805@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2015 at 03:04:02PM +0800, Miao Xie wrote:
> > Pending changes are *not* only mount options. Feature change and label change
> > are also pending changes if using sysfs.
> 
> My miss, I don't notice feature and label change by sysfs.
> 
> But the implementation of feature and label change by sysfs is wrong, we can
> not change them without write permission.

Label change does not happen if the fs is readonly. If the filesystem is
RW and label is changed through sysfs, then remount to RO will sync the
filesystem and the new label will be saved.

The sysfs features write handler is missing that protection though, I'll
send a patch.

> > For freeze, it's not the same problem since the fs will be unfreeze sooner or
> > later and transaction will be initiated.
> 
> You can not assume the operations of the users, they might freeze the fs and
> then shutdown the machine.

The semantics of freezing should make the on-device image consistent,
but still keep some changes in memory.

> >>> For example, if we change the features/label through sysfs, and then umount
> >>> the fs,
> >> It is different from pending change.
> > No, now features/label changing using sysfs both use pending changes to do the
> > commit.
> > See BTRFS_PENDING_COMMIT bit.
> > So freeze -> change features/label -> sync will still cause the deadlock in the
> > same way,
> > and you can try it yourself.
> 
> As I said above, the implementation of sysfs feature and label change is wrong,
> it is better to separate them from the pending mount option change, make the
> sysfs feature and label change be done in the context of transaction after
> getting the write permission. If so, we needn't do anything special when sync
> the fs.

That would mean to drop the write support of sysfs files that change
global filesystem state (label and features right now). This would leave
only the ioctl way to do that. I'd like to keep the sysfs write support
though for ease of use from scripts and languages not ioctl-friendly.
