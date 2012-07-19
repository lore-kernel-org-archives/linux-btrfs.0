Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11082 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab2GSBlO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 21:41:14 -0400
Message-ID: <50075C3D.10700@cn.fujitsu.com>
Date: Thu, 19 Jul 2012 09:00:45 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Long btrfs hangs during suspend to RAM / BTRFS warning (device
References: <20120626193637.GA27856@merlins.org> <20120626193637.GA27856@merlins.org> <20120627013818.GA3556@merlins.org> <20120627052012.GA32533@merlins.org> <20120629123624.GS7472@merlins.org> <20120702195820.GA10655@merlins.org> <4FF3DB87.5090405@cn.fujitsu.com> <20120704151556.GD6807@merlins.org> <4FF595D8.6040509@cn.fujitsu.com> <20120705143417.GB21630@merlins.org> <20120718180110.GC16899@merlins.org>
In-Reply-To: <20120718180110.GC16899@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/19/2012 02:01 AM, Marc MERLIN wrote:

> 
> Just to put a lid (maybe) on that thread, I now think that it's very
> possible my btrfs hangs when the drive was almost full (10GB remaining
> though) were due to my Crucial RealSSD C300, which has just mostly died
> yesterday after (I think) the firmware got too many problems trying to remap
> blocks (garbage collection) since I wasn't using TRIM.
> (yes, I had the latest 007 firmware on the SSD).
> 
> I don't know that the SSD caused the corruption I saw in some files and that
> went away when I dropped the latest btrfs snapshot, but at this point I'm
> pretty sure that the SSD went into emergency garbage collection mode when
> its space was running low, and in turn was causing btrfs to hang.
> 
> Sorry for the most likely false alarm (except for snapshot corruption which
> is likely btrfs related).
> 
> I'll post another message about no TRIM with dmcrypt and possible ensuing
> SSD problems.
> 
> Marc


Hi Marc,

It's ok, any user report is WELCOME. :)

thanks,
liubo
