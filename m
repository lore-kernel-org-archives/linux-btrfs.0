Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751291AbdGQRXy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jul 2017 13:23:54 -0400
Date: Mon, 17 Jul 2017 19:06:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Paul Jones <paul@pauljones.id.au>
Cc: Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: allow defrag compress to override NOCOMPRESS
 attribute
Message-ID: <20170717170629.GP2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170713131844.706-1-dsterba@suse.com>
 <43b258b2-b808-5301-f832-44c4274aae38@oracle.com>
 <MEXPR01MB21686EDDDB16DB80C3F780FF9EA20@MEXPR01MB2168.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <MEXPR01MB21686EDDDB16DB80C3F780FF9EA20@MEXPR01MB2168.ausprd01.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 15, 2017 at 06:45:38AM +0000, Paul Jones wrote:
> > Now the compression set through property will act same as '-o compress-
> > force'. Before this patch is was like '-o compress'.
> > I am ok to fix that patch with a new patch.
> 
> While we are at it, would it be possible to add an option to remove
> compression? Ie. btrfs fi defrag -c none file Currently this doesn't
> seem to exist.

Short answer: yes. As we're going to touch the ioctl and commandline
interface for zstd anyway.
