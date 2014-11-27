Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30604 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753746AbaK0DET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 22:04:19 -0500
Message-ID: <1417057358.14696.7.camel@localhost.localdomain>
Subject: Re: [PATCH v4] btrfs-progs: fix page align issue for lzo compress
 in restore
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 27 Nov 2014 11:02:38 +0800
In-Reply-To: <20141014093234.GP22943@twin.jikos.cz>
References: <20140922134115.GP9715@twin.jikos.cz>
	 <1411461294-24093-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1929724.Hf7kupaGA7@fb07-iapwap2> <20141014093234.GP22943@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-10-14 at 11:32 +0200, David Sterba wrote:
> On Tue, Oct 14, 2014 at 10:06:16AM +0200, Marc Dietrich wrote:
> > This hasn't landed in an btrfs-progs branch I found. Any update?
> 
> I had it tagged for review and found something that needs fixing. The
> PAGE_CACHE_SIZE is hardcoded to 4k, this will break on filesystems with
> larger sectors (eg. the powerpc machines). I'll scheudule the patch post
> 3.17, with a fix.

Hi David，

I note that this patch is not yet in the latest integration, how's the
fix going?

-Gui

