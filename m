Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:33358 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab2EaOeZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 10:34:25 -0400
Date: Thu, 31 May 2012 15:32:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] Revert "[PATCH] vfs: switch ->show_devname() to
 struct dentry *"
Message-ID: <20120531143234.GD11775@ZenIV.linux.org.uk>
References: <4FC74707.5030804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC74707.5030804@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2012 at 06:25:11PM +0800, Miao Xie wrote:
> This reverts commit d861c630e99febe5ce6055290085556c5b714b06
> 
> It is done to fix the wrong mount information of btrfs in /proc.
> Btrfs is an interesting filesystem that can be made by several disks, and
> we can remove any disk from the filesystem. But now if we remove the disk
> that is specified at mount, the mount information in /proc(such as mounts/
> mountinfo and so on) is not updated. And this wrong information will make
> us can not add that special disk back to the filesystem again. I will fix
> this problem by implement the show_devname() interface for btrfs, and in
> order to check the disk which is specified when doing mount is removed or not,
> I want pass vfsmount object into this function.

Keep wanting.  Patch NAKed.
