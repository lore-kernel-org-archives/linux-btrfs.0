Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53927 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753512AbaICPCO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 11:02:14 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49500 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XPC4Z-002TSW-3W
	for linux-btrfs@vger.kernel.org; Wed, 03 Sep 2014 09:02:11 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CANg_oxziMWqfWZsykPSx+LcYzXJEfbopw0RyNR78WXWkSno3sg@mail.gmail.com>
Date: Wed, 3 Sep 2014 09:02:08 -0600
Message-Id: <CA3FC378-5E28-4C42-AEDC-3CE448929E7F@colorremedies.com>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com> <540498AF.6030109@fb.com> <CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com> <pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net> <CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com> <pan$1b676$93919c37$3c0fae08$71129a93@cox.net> <CANg_oxxiAJbchugA2puD7PE3qgd_iQ+Lwpzs416YPBUBCKVOag@mail.gmail.com> <54062424.9040508@fb.com> <CANg_oxy5p8mxeHtjGjVRvvntE9JY_yXxRFRDjbSny=XGa1ZGfg@mail.gmail.com> <CANg_oxzq3CAbj8iL1zK-_KFxSX7h2Z__9Yj1v-19EPwd-ijr=g@mail.gmail.com> <CANg_oxxn-4LXnG5t_wgX=ZvkLHc2tT8+TY-WEsn2awUTBsHSfA@mail.gmail.com> <54070B5F.20100@fb.com> <CANg_oxziMWqfWZsykPSx+LcYzXJEfbopw0RyNR78WXWkSno3sg@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 3, 2014, at 8:11 AM, john terragon <jterragon@gmail.com> wrote:

> It's a usb2 device but doesn't it seem kind of slow?

Not atypical, I have one that's the same, and another that's ~21MB/s, both are USB 2. 

[Certain older Apple Mac firmware boot faster with the slow stick than the fast one, and it turns out the block size matters. Block size 512 bytes is insanely slow (as in 100KB/s) on the "fast" stick, whereas a block size of even 32k puts it to 20+MB/s. So I think the older firmware must be initially asking for 512 byte blocks, once the kernel takes over the performance is very good.]

Chris Murphy

