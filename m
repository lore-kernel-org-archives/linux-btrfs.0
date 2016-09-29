Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:37935 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932557AbcI2KDU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 06:03:20 -0400
Date: Thu, 29 Sep 2016 12:03:11 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: space_info 4 has 18446742286429913088 free, is not full
Message-ID: <20160929100311.GA6357@angband.pl>
References: <1c94f3b1-b238-6668-7976-c0594f170dfe@profihost.ag>
 <57EBAAF5.10509@cn.fujitsu.com>
 <4f91af54-78ae-5c08-3daa-8a0c16210e5f@profihost.ag>
 <57EBB329.9060009@cn.fujitsu.com>
 <3e429001-020a-748b-c0c5-85b4091599a1@profihost.ag>
 <57ECBAE7.5030807@cn.fujitsu.com>
 <0e556b63-7c85-1e97-00b0-91bfca44e82c@profihost.ag>
 <57ECBF0D.3050609@cn.fujitsu.com>
 <85f85ca6-95c0-1394-9b09-93dcc00c2319@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <85f85ca6-95c0-1394-9b09-93dcc00c2319@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 29, 2016 at 09:27:01AM +0200, Stefan Priebe - Profihost AG wrote:
> Am 29.09.2016 um 09:13 schrieb Wang Xiaoguang:
> >>> I found that compress sometime report ENOSPC error even in 4.8-rc8,
> >>> currently
> >> I cannot confirm that as i do not have anough space to test this without
> >> compression ;-( But yes i've compression enabled.
> > I might not get you, my poor english :)
> > You mean that you only get ENOSPC error when compression is enabled?
> > 
> > And when compression is not enabled, you do not get ENOSPC error?
> 
> I can't tell you. I cannot test with compression not enabled. I do not
> have anough free space on this disk.

Disabling compression doesn't immediately require any space -- it affects
only newly written data.  What you already have remains in the old
compression setting, unless you defrag everything (a side effect of
defragging is switching existing extents to the new compression mode).

-- 
A MAP07 (Dead Simple) raspberry tincture recipe: 0.5l 95% alcohol, 1kg
raspberries, 0.4kg sugar; put into a big jar for 1 month.  Filter out and
throw away the fruits (can dump them into a cake, etc), let the drink age
at least 3-6 months.
