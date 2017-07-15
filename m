Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-sy3aus01on0066.outbound.protection.outlook.com ([104.47.117.66]:62144
        "EHLO AUS01-SY3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751061AbdGOGpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jul 2017 02:45:41 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH] btrfs: allow defrag compress to override NOCOMPRESS
 attribute
Date: Sat, 15 Jul 2017 06:45:38 +0000
Message-ID: <MEXPR01MB21686EDDDB16DB80C3F780FF9EA20@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <20170713131844.706-1-dsterba@suse.com>
 <43b258b2-b808-5301-f832-44c4274aae38@oracle.com>
In-Reply-To: <43b258b2-b808-5301-f832-44c4274aae38@oracle.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Anand Jain
> Sent: Saturday, 15 July 2017 2:53 PM
> To: David Sterba <dsterba@suse.com>; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs: allow defrag compress to override NOCOMPRESS
> attribute
> 
> 
> On 07/13/2017 09:18 PM, David Sterba wrote:
> > Currently, the BTRFS_INODE_NOCOMPRESS will prevent any compression
> on
> > a given file, except when the mount is force-compress. As users have
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
> Now the compression set through property will act same as '-o compress-
> force'. Before this patch is was like '-o compress'.
> I am ok to fix that patch with a new patch.

While we are at it, would it be possible to add an option to remove compression? Ie. btrfs fi defrag -c none file
Currently this doesn't seem to exist.

Thanks,
Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
