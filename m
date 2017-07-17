Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751301AbdGQQsW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 12:48:22 -0400
Date: Mon, 17 Jul 2017 18:47:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allow defrag compress to override NOCOMPRESS
 attribute
Message-ID: <20170717164707.GO2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170713131844.706-1-dsterba@suse.com>
 <43b258b2-b808-5301-f832-44c4274aae38@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43b258b2-b808-5301-f832-44c4274aae38@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 15, 2017 at 12:52:34PM +0800, Anand Jain wrote:
> On 07/13/2017 09:18 PM, David Sterba wrote:
> > Currently, the BTRFS_INODE_NOCOMPRESS will prevent any compression on a
> > given file, except when the mount is force-compress. As users have
> > reported on IRC, this will also prevent compression when requested by
> > defrag (btrfs fi defrag -c file).
> >
> > The nocompress flag is set automatically by filesystem when the ratios
> > are bad and the user would have to manually drop the bit in order to
> > make defrag -c work. This is not good from the usability perspective.
> > 
> > This patch will raise priority for the defrag -c over nocompress, ie.
> > any file with NOCOMPRESS bit set will get defragmented. The bit will
> > remain untouched.
> > 
> > Alternate option was to also drop the nocompress bit and keep the
> > decision logic as is, but I think this is not the right solution.
> 
> 
> Now the compression set through property will act same as
> '-o compress-force'. Before this patch is was like '-o compress'.

Right, I missed that. Yet I'm not sure, we actually might want this
semantics for the per-file compression option. The mount option
'compress' applies to the whole filesystem so the semantics "try to
compress and if it's not a gain, stop and mark the file nocompress".

The per-file compression option is user's intent to compress the file,
so the nocompress fallback logic goes against that.

> I am ok to fix that patch with a new patch.

Feel free to send the patch, although I think we don't want it, we still
can have a discussion. This should help to clarify the semantics of
compression behaviour further.
