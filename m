Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51936 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739AbbA3GP4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 01:15:56 -0500
Date: Fri, 30 Jan 2015 06:15:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miao Xie <miaoxie@huawei.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to get
 vfsmount from a given sb.
Message-ID: <20150130061550.GJ29656@ZenIV.linux.org.uk>
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com>
 <54CAD5DC.2060603@huawei.com>
 <54CAE1E3.1040406@cn.fujitsu.com>
 <20150130021445.GH29656@ZenIV.linux.org.uk>
 <54CB0520.2070008@huawei.com>
 <20150130043714.GI29656@ZenIV.linux.org.uk>
 <54CB17F1.2070902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54CB17F1.2070902@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 01:34:41PM +0800, Miao Xie wrote:
> > 	First of all, ->s_umount is not a mutex; it's rwsem.  So you mean
> > down_read_trylock().  As for the transient failures - grep for down_write
> > on it...  E.g. have somebody call mount() from the same device.  We call
> > sget(), which finds existing superblock and calls grab_super().  Sure,
> > that ->s_umount will be released shortly, but in the meanwhile your trylock
> > will fail...
> 
> I know it, so I suggested to return -EBUSY in the previous mail.
> I think it is acceptable method, mount/umount operations are not so many
> after all.

Er...  What for, when there's a trivial variant that doesn't suffer those
spurious -EBUSY?  Seriously, just move sysfs removals up to make sure
that any possible fs shutdown won't progress past those during sysfs IO and
use sb_want_write/sb_dont_write to make sure it'll stay r/w for the duration.
What's the problem?
