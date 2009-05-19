From: Josef Bacik <josef@redhat.com>
Subject: Re: extended acls..
Date: Tue, 19 May 2009 14:06:08 -0400
Message-ID: <20090519180608.GC7472@dhcp231-156.rdu.redhat.com>
References: <42ab06770905190950x5077edb0s3c55bd1c39ebeebe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sriram Ramkrishna <sriram.ramkrishna@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <42ab06770905190950x5077edb0s3c55bd1c39ebeebe@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 19, 2009 at 09:50:42AM -0700, Sriram Ramkrishna wrote:
> Howdy,
> 
> I'm curious if there is any plans to add extended acls ala AFS?  The
> reason I ask is that it seems in Linux we don't seem have moved off of
> POSIX style acls and I think there is definitely at least from my
> perspective that having a richer set of acl would be needed.  For
> instance, we would need acls to deal with controlled countries if we
> are sharing data with them etc.  It is a big shame that there is no
> RFC for extended ACLs.
> 
> Also, I would like to help out with development, I'm a newbie as far
> as kernel level hacking goes.  If there is a place I can go that I can
> start off small that would be lovely.
>

Extending ACLs beyond POSIX ACLs is a more generic topic that should probably be
discussed elsewhere, perhaps linux-fsdevel.  Its not going to do much good to
implement yet another extended ACL implementation in BTRFS if no other Linux fs
has the ability to use the same feature, so figuring out the details of
extending ACLs should be done before doing them in btrfs.  Thanks,

Josef 
