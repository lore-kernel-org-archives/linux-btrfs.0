Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43454 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaIQDyt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 23:54:49 -0400
Date: Wed, 17 Sep 2014 04:54:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Shea Levy <shea@shealevy.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Setting FS_USERNS_MOUNT in btrfs_fs_type.fs_flags
Message-ID: <20140917035448.GZ7996@ZenIV.linux.org.uk>
References: <20140917030500.GD6185@nixos.hsd1.nh.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140917030500.GD6185@nixos.hsd1.nh.comcast.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 16, 2014 at 11:05:00PM -0400, Shea Levy wrote:
> Hi all,
> 
> What work would be required to mark btrfs_fs_type with FS_USERNS_MOUNT
> so that btrfs images can be mounted by unprivileged users within a user
> namespace (along with something like [1])? I'd like to be able to create
> disk images without having to start a VM (and --rootdir isn't flexible
> enough because I want to make subvolumes).

Er...  Which is to say, you have an audit of btrfs code making sure that
it can cope with arbitrary image hand-crafted by potential attacker?
Because without that FS_USERNS_MOUNT could open one hell of security hole;
things like user being able to execute an arbitrary code in kernel mode,
etc.
