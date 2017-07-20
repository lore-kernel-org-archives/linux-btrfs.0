Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44905 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965118AbdGTK4M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 06:56:12 -0400
Subject: Re: [PATCH 4/4] btrfs: allow defrag compress to override NOCOMPRESS
 attribute
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1500317040.git.dsterba@suse.com>
 <afb29965ae24123bf6b5aa4d9390f42292a1796c.1500317040.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <7a9f4ff0-d413-faf8-5c5a-725889235fc6@oracle.com>
Date: Thu, 20 Jul 2017 19:02:56 +0800
MIME-Version: 1.0
In-Reply-To: <afb29965ae24123bf6b5aa4d9390f42292a1796c.1500317040.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/18/2017 02:46 AM, David Sterba wrote:
> Currently, the BTRFS_INODE_NOCOMPRESS will prevent any compression on a
> given file, except when the mount is force-compress. As users have
> reported on IRC, this will also prevent compression when requested by
> defrag (btrfs fi defrag -c file).

  There is a hidden workaround... even with the existing
  inode_need_compression().

  BTRFS_INODE_NOCOMPRESS gets reset [1] so ..

    (btrfs prop set /btrfs/sv1 compression "")
    btrfs prop set /btrfs/sv1 compression lzo
    A normal defrag or with -c will try to compress again.

----------------
static int prop_compression_apply(struct inode *inode,
                                   const char *value,
                                   size_t len)
{
         int type;

         if (len == 0) {
                 BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
                 BTRFS_I(inode)->flags &= ~BTRFS_INODE_COMPRESS;
                 BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;

                 return 0;
         }

         if (!strncmp("lzo", value, len))
                 type = BTRFS_COMPRESS_LZO;
         else if (!strncmp("zlib", value, len))
                 type = BTRFS_COMPRESS_ZLIB;
         else
                 return -EINVAL;

         BTRFS_I(inode)->flags &= ~BTRFS_INODE_NOCOMPRESS;   <---- [1]
         BTRFS_I(inode)->flags |= BTRFS_INODE_COMPRESS;
         BTRFS_I(inode)->force_compress = type;

         return 0;
}
---------------

  So what's missing is btrfs prop set /btrfs/sv1 compress-force
  and rest cleanup as discussed in the other email.

Thanks, Anand


