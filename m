Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:47247 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbaIQQMP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 12:12:15 -0400
Date: Wed, 17 Sep 2014 09:12:14 -0700
From: Zach Brown <zab@zabbo.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Shea Levy <shea@shealevy.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Setting FS_USERNS_MOUNT in btrfs_fs_type.fs_flags
Message-ID: <20140917161214.GC20887@lenny.home.zabbo.net>
References: <20140917030500.GD6185@nixos.hsd1.nh.comcast.net>
 <20140917035448.GZ7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140917035448.GZ7996@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 17, 2014 at 04:54:48AM +0100, Al Viro wrote:
> On Tue, Sep 16, 2014 at 11:05:00PM -0400, Shea Levy wrote:
> > Hi all,
> > 
> > What work would be required to mark btrfs_fs_type with FS_USERNS_MOUNT
> > so that btrfs images can be mounted by unprivileged users within a user
> > namespace (along with something like [1])? I'd like to be able to create
> > disk images without having to start a VM (and --rootdir isn't flexible
> > enough because I want to make subvolumes).
> 
> Er...  Which is to say, you have an audit of btrfs code making sure that
> it can cope with arbitrary image hand-crafted by potential attacker?

It definitely can't cope. The easiest places to find bugs are the
hundreds of BUG_ON() sites, many can be triggered by on-disk structures.
The sheer volume of those makes me trust that you could find much worse
if you did a thorough audit.

- z
(fun related fact: distros automount btrfs images)
