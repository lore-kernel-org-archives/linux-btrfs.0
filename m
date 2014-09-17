Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:40400 "EHLO
	homiemail-a46.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756068AbaIQUbh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 16:31:37 -0400
Date: Wed, 17 Sep 2014 16:31:35 -0400
From: Shea Levy <shea@shealevy.com>
To: Zach Brown <zab@zabbo.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Setting FS_USERNS_MOUNT in btrfs_fs_type.fs_flags
Message-ID: <20140917203135.GC2068@nixos>
References: <20140917030500.GD6185@nixos.hsd1.nh.comcast.net>
 <20140917035448.GZ7996@ZenIV.linux.org.uk>
 <20140917161214.GC20887@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140917161214.GC20887@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 17, 2014 at 09:12:14AM -0700, Zach Brown wrote:
> On Wed, Sep 17, 2014 at 04:54:48AM +0100, Al Viro wrote:
> > On Tue, Sep 16, 2014 at 11:05:00PM -0400, Shea Levy wrote:
> > > Hi all,
> > > 
> > > What work would be required to mark btrfs_fs_type with FS_USERNS_MOUNT
> > > so that btrfs images can be mounted by unprivileged users within a user
> > > namespace (along with something like [1])? I'd like to be able to create
> > > disk images without having to start a VM (and --rootdir isn't flexible
> > > enough because I want to make subvolumes).
> > 
> > Er...  Which is to say, you have an audit of btrfs code making sure that
> > it can cope with arbitrary image hand-crafted by potential attacker?
> 
> It definitely can't cope. The easiest places to find bugs are the
> hundreds of BUG_ON() sites, many can be triggered by on-disk structures.
> The sheer volume of those makes me trust that you could find much worse
> if you did a thorough audit.
> 
> - z
> (fun related fact: distros automount btrfs images)

OK, so it seems like the answer to my question is "a helluva lot". Guess
I won't count on seeing it any time soon :)

Thanks,
Shea
