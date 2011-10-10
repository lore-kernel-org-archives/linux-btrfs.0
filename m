From: Josef Bacik <josef@redhat.com>
Subject: Re: can't snapshot
Date: Mon, 10 Oct 2011 11:40:50 -0400
Message-ID: <4E931202.4030405@redhat.com>
References: <4E930BC2.4080405@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E930BC2.4080405@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2011 11:14 AM, Jim wrote:
> Good morning Btrfs list,
> I am trying to create a subvolume of a directory tree (approximately 1.1
> million subvolumes under nfs1).  The following error is thrown and
> without the wiki I don't know what argument is needed.  I am running
> kernel 3.1.0-rc4.
> 
> [root@btrfs ~]# btrfs sub snapshot /btrfs/nfs1/ /btrfs/snaps/
> Invalid arguments for subvolume snapshot
> [root@btrfs ~]# btrfs sub list /btrfs | head
> ID 256 top level 5 path nfs1
> ID 257 top level 5 path nfs2
> ID 258 top level 5 path nfs2/data
> ID 259 top level 5 path nfs1/data
> ID 260 top level 5 path nfs1/data/sites
> ID 261 top level 5 path nfs2/data/sites
> ID 262 top level 5 path nfs2/data/sites/0420
> ID 263 top level 5 path nfs2/data/sites/0421
> ID 264 top level 5 path nfs2/data/sites/0422
> ID 265 top level 5 path nfs2/data/sites/0423
> 

I think you have to do

btrfs sub snapshot /btrfs/nfs1 /btrfs/nfs1/snaps

Thanks,

Josef
