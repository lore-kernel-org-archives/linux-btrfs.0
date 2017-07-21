Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51921 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751996AbdGURg5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 13:36:57 -0400
Date: Fri, 21 Jul 2017 19:35:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: separate defrag and property compression
Message-ID: <20170721173540.GN2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1500317040.git.dsterba@suse.com>
 <9dc75da8c4a2cfc0cddec3c9ccf95f5d28a89084.1500317040.git.dsterba@suse.com>
 <c5ce5317-a1d2-f4b3-1615-76812c8874f8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c5ce5317-a1d2-f4b3-1615-76812c8874f8@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 06:49:19PM +0800, Anand Jain wrote:
> 
> 
> On 07/18/2017 02:46 AM, David Sterba wrote:
> > Add new value for compression to distinguish between defrag and
> > property. Previously, a single variable was used and this caused clashes
> > when the per-file 'compression' was set and a defrag -c was called.
> 
>   How about..
>     deprecate property compression
>     introduce property compress (inline with -o compress) [1]
>     introduce property compress-force (inline with -o compress-force) [2]

IIRC compress-force has been added as a bandaid when 'compress' bails
out of compression too soon (due to the trivial check and that just one
incompressible chunk can set tne NOCOMPRESS bit). So compress-force now
compresses everthing even if it's not worth.

What we need is better behaviour of 'compress', and that's where the
heuristics should help. It will try to guess if the data are
compressible in advance, so we hopefully don't reach the point where the
incompressible chunk will flip the NOCOMPRESS bit.

I don't want to spread the compress-force logic further, rather improve
the heuristic and possibly track a long-term stats about the file and
the data compressibility. So everybody can use 'compress' and expect
sane behaviour, and this would apply to the per-file property and
defrag.

> inode_need_compress will look something like this..
> -----
> static inline int inode_need_compress(struct inode *inode)
> {
>          struct btrfs_root *root = BTRFS_I(inode)->root;
> 
>          /* force compress */
>          if (btrfs_test_opt(root->fs_info, FORCE_COMPRESS) ||
> 		            BTRFS_I(inode)->force_compress) [2]
>                  return 1;
> 
>          /* bad compression ratios */
>          if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS)
>                  return 0;
> 
>          if (btrfs_test_opt(root->fs_info, COMPRESS) ||
>              BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS ||
>              BTRFS_I(inode)->compress) [1]
>                  return 1;
> 
>          return 0;
> }
> -----
> 
>   defrag -c will in turn set the compress property.
> 
>   introduce defrag --compress-force|-C to in turn set the compress-force
>   property.

This would be a good enhancement to the defrag interface to
check/manipulate the properties, but this does not affect the kernel
behaviour.
