From: David Sterba <dave@jikos.cz>
Subject: Re: Corrupt file in subvolume
Date: Mon, 10 Oct 2011 12:37:23 +0200
Message-ID: <20111010103723.GE17912@twin.jikos.cz>
References: <loom.20111010T040355-185@post.gmane.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: dima <dolenin@parallels.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20111010T040355-185@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Oct 10, 2011 at 02:14:26AM +0000, dima wrote:
> Somehow my subvolume with /home got corrupted. When I booted the machine this
> morning (after perfectly normal shutdown) it gave me a bunch of kernel errors.

That's very strange, if it was a pefrectly normal shutdown, I don't see
a way how could happen. External disk damage, bad RAM would seem a as
convenient excuse :)

> I found out that if I comment out my /home entry in fstab, it would
> boot ok. So the / is not corrupted. I then booted from the live CD and
> set "clear_cache" for /home instead of "inode_cache,space_cache"
> 
> /dev/disk/by-label/btrfs-root   /       btrfs  
> defaults,noatime,inode_cache,space_cache        0 0
> /dev/disk/by-label/btrfs-root   /var/lib/btrfs-root     btrfs  
> defaults,noatime,subvolid=0     0 0
> #/dev/disk/by-label/btrfs-root  /home   btrfs  
> defaults,noatime,subvol=__home-new,inode_cache,space_cache  0 0
> /dev/disk/by-label/btrfs-root  /home   btrfs  
> defaults,noatime,subvol=__home-new,clear_cache  0 0
> /var/lib/btrfs-root/boot        /boot   none    bind    0 0
> 
> Then I could mount the /home subvolume.
> 
> I also found the corrupted file
>    ? -????????? ? ?   ?        ?            ? 13.4.4.40.js

Chromium cache? Somebody recently reported a problem there. I wonder
what this browser does to the filesystem ... :)

> Whenever I try to access it I am getting Input/output error and the following
> error in the kernel.log
> 
> 
> Oct 10 10:38:03 yukikaze kernel: [34592.275080] parent transid verify failed on
> 105930436608 wanted 58565 found 134248
> Oct 10 10:38:03 yukikaze kernel: [34592.275161] BUG: scheduling while atomic:
> ls/2545/0x00000002

This bug is in most cases only a consequence of some btrfs BUG_ON,
please try to find it in your logs or reproduce the problem. The 'parent
transid verify' problem may cause a BUG_ON up in the caller stack.

> My question - is it possible to delete this rogue file somehow or repair it?
> I tried to delete the directory that contained it, but got the same Input/output
> error.

Fsck for the rescue! Or, you can try Josef's repair [1] proggy to retrieve
the data from the volume (AFAIK it should work around the parent transid
problem). If all other files are fine, you can rebuild the /home from
that.


david

[1] git://github.com/josefbacik/btrfs-progs.git
