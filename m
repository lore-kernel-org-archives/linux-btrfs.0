Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58868 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbaGCNoc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 09:44:32 -0400
Date: Thu, 3 Jul 2014 06:44:21 -0700
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Message-ID: <20140703134421.GS26932@merlins.org>
References: <20140702204152.GI20961@merlins.org>
 <20140703081318.GB20612@localhost.localdomain>
 <53B5125F.4070707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B5125F.4070707@cn.fujitsu.com>
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch. Hopefully this will make it to the next 3.15.x
kernel.

I also went back to 3.14 anyway since the 'blocked for 120 seconds' look
like another instance of deadlocks we've been discussing here.

But just curious:

> >>[160562.925463] parent transid verify failed on 2776298520576 wanted 41015 found 18120

What should I be doing about this?
Does it mean that I do have some kind of corruption/damage on my
filesystem?

Also, is it possible to have all these messages state which devid they
occurred on? I don't even know which device I should be worrying about
right now, and although I'm running scrub now, my understanding is that
scrub doesn't actually look at FS structures and is likely to miss this
anyway.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
