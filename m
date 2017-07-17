Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56123 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751315AbdGQRM0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 13:12:26 -0400
Date: Mon, 17 Jul 2017 19:09:34 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: allow defrag compress to override NOCOMPRESS
 attribute
Message-ID: <20170717170934.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170713131844.706-1-dsterba@suse.com>
 <43b258b2-b808-5301-f832-44c4274aae38@oracle.com>
 <20170717164707.GO2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170717164707.GO2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 17, 2017 at 06:47:07PM +0200, David Sterba wrote:
> On Sat, Jul 15, 2017 at 12:52:34PM +0800, Anand Jain wrote:
> > On 07/13/2017 09:18 PM, David Sterba wrote:
> > > Currently, the BTRFS_INODE_NOCOMPRESS will prevent any compression on a
> > > given file, except when the mount is force-compress. As users have
> > > reported on IRC, this will also prevent compression when requested by
> > > defrag (btrfs fi defrag -c file).
> > >
> > > The nocompress flag is set automatically by filesystem when the ratios
> > > are bad and the user would have to manually drop the bit in order to
> > > make defrag -c work. This is not good from the usability perspective.
> > > 
> > > This patch will raise priority for the defrag -c over nocompress, ie.
> > > any file with NOCOMPRESS bit set will get defragmented. The bit will
> > > remain untouched.
> > > 
> > > Alternate option was to also drop the nocompress bit and keep the
> > > decision logic as is, but I think this is not the right solution.
> > 
> > 
> > Now the compression set through property will act same as
> > '-o compress-force'. Before this patch is was like '-o compress'.

Actually we'll need to split btrfs_inode::force_compress as defrag will
reset it to 0 at the end, which needs to be fixed so it does not
conflict with the properties.
