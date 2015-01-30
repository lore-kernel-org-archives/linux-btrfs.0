Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51566 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbbA3COt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 21:14:49 -0500
Date: Fri, 30 Jan 2015 02:14:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Miao Xie <miaoxie@huawei.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH RESEND v4 6/8] vfs: Add get_vfsmount_sb() function to get
 vfsmount from a given sb.
Message-ID: <20150130021445.GH29656@ZenIV.linux.org.uk>
References: <1422498281-20493-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422498281-20493-7-git-send-email-quwenruo@cn.fujitsu.com>
 <54CAD5DC.2060603@huawei.com>
 <54CAE1E3.1040406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54CAE1E3.1040406@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 09:44:03AM +0800, Qu Wenruo wrote:

> This shouldn't happen. If someone is ro, the whole fs should be ro, right?

Wrong.  Individual vfsmounts over an r/w superblock might very well be r/o.
As for that trylock...  What for?  It invites transient failures for no
good reason.  Removal of sysfs entry will block while write(2) to that sucker
is in progress, so btrfs shutdown will block at that point in ctree_close().
It won't go away under you.

Now, you might want to move those sysfs entry removals to the very beginning
of btrfs_kill_super(), but that's a different story - you need only to make
sure that they are removed not later than the destruction of the data
structures they need (IOW, the current location might very well be OK - I
hadn't checked the details).

As for "it won't go r/o under us" - sb_want_write() will do that just fine.
