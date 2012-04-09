From: David Sterba <dave@jikos.cz>
Subject: Re: Large metadata mount messages lost after reboot
Date: Tue, 10 Apr 2012 00:15:24 +0200
Message-ID: <20120409221524.GA11041@twin.jikos.cz>
References: <CADxhoDTqCuvtiAUd5a4AAZsLBQ=7i-mvf8X0FeZB1CyBJXpdyg@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Calvin Morrow <calvin.morrow@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADxhoDTqCuvtiAUd5a4AAZsLBQ=7i-mvf8X0FeZB1CyBJXpdyg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2012 at 04:06:56PM -0600, Calvin Morrow wrote:
> After a reboot however, the "flagging fs with big metadata feature"
> message no longer appears on subsequent mounts.

        /*
         * flag our filesystem as having big metadata blocks if
         * they are bigger than the page size
         */
        if (btrfs_super_leafsize(disk_super) > PAGE_CACHE_SIZE) {
                if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
                        printk(KERN_INFO "btrfs flagging fs with big metadata feature\n");
                features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
        }

translation: it will print the message only the first time it's mounted and the
flag is not already stored on disk.

> Is this expected behavior?

Yes it is.

> Is there a way I can dump filesystem
> information to determine what leaf and node size the filesystem thinks
> it has?

# mkfs.btrfs -n 32k -l 32k image

WARNING! - Btrfs v0.19-152-g1957076 IS STAB^WEXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on image
        nodesize 32768 leafsize 32768 sectorsize 4096 size 300.00GB
Btrfs v0.19-152-g1957076

# file image
image: BTRFS Filesystem sectorsize 4096, nodesize 32768, leafsize 32768)

and it does it by looking to the first superblock:

/usr/share/misc/magic:
# BTRFS
0x10040         string          _BHRfS_M        BTRFS Filesystem
>0x1012b        string          >\0             (label "%s",
>0x10090        lelong          x               sectorsize %d,
>0x10094        lelong          x               nodesize %d,
>0x10098        lelong          x               leafsize %d)


david
