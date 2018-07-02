Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56279 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752596AbeGBOBg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 10:01:36 -0400
MIME-Version: 1.0
Message-ID: <trinity-d938775a-abc7-4647-9ffc-0d69a56e37e7-1530540086745@3c-app-mailcom-bs10>
From: "Su Yue" <Damenly_Su@gmx.com>
To: "Nikolay Borisov" <nborisov@suse.com>
Cc: "Su Yue" <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] btrfs-progs: lowmem: delay before lowmem repair
Content-Type: text/plain; charset=UTF-8
Date: Mon, 2 Jul 2018 16:01:26 +0200
In-Reply-To: <93c08062-8368-616f-f8c6-5ff8616aad08@suse.com>
References: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
 <93c08062-8368-616f-f8c6-5ff8616aad08@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Sent: Monday, July 02, 2018 at 5:43 PM
> From: "Nikolay Borisov" <nborisov@suse.com>
> To: "Su Yue" <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH RFC 0/3] btrfs-progs: lowmem: delay before lowmem repair
>
> 
> 
> On  2.07.2018 12:28, Su Yue wrote:
> > Since lowmem repair is dangerous, it should remind user more obviously.
> > The patchset add 10 seconds delay like btrfs balance and add am option
> > '--force-repair-lowmem' to skip the delay.
> 
> IMO this is the wrong way to approach a dangerous option. If it's so
> dangerous it needs to be written in the documentation explicitly this is
> so. If someone wants to use lowmem then they should explicitly set
> --mode lowmem. So I'm inclined to NACK this patch.
> 
OK. After some considerations, I thinks the patchset is indeed appropriate.
Droping it is fine.

Thanks,
Su
> > 
> > ---
> > I don't whether it's a good idea to add delay and the option only for
> > lowmem repair is acceptable, so make it RFC.
> > 
> > Su Yue (3):
> >   btrfs-progs: lowmem: delay before lowmem repair starts
> >   btrfs-progs: lowmem: force to start without delay with option
> >     '--force-repair-lowmem'
> >   btrfs-progs: tests: append '--force-repair-lowmem' if lowmem repair is
> >     enabled
> > 
> >  check/main.c       | 43 ++++++++++++++++++++++++++++++++++++-------
> >  tests/common.local |  1 +
> >  2 files changed, 37 insertions(+), 7 deletions(-)
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
