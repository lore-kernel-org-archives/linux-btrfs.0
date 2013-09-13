Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59541 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3IMRPe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 13:15:34 -0400
Date: Fri, 13 Sep 2013 10:15:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>, Zach Brown <zab@redhat.com>
Subject: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
Message-ID: <20130913171531.GB7009@roeck-us.net>
References: <20130913133314.GA20461@roeck-us.net>
 <CAMuHMdWoNo9U0DCRoXt8V2d1SiSxX5Sku9rNvg+9MiX++XjVRg@mail.gmail.com>
 <20130913163535.GA5681@roeck-us.net>
 <20130913170022.18785.82013@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130913170022.18785.82013@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 13, 2013 at 01:00:22PM -0400, Chris Mason wrote:
> Quoting Guenter Roeck (2013-09-13 12:35:35)
> > On Fri, Sep 13, 2013 at 03:52:43PM +0200, Geert Uytterhoeven wrote:
> > > On Fri, Sep 13, 2013 at 3:33 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > > > fs/btrfs/ioctl.c: In function 'btrfs_ioctl_file_extent_same':
> > > > fs/btrfs/ioctl.c:2802:3: error: implicit declaration of function '__put_user_unaligned' [-Werror=implicit-function-declaration]
> > > > cc1: some warnings being treated as errors
> > > > make[2]: *** [fs/btrfs/ioctl.o] Error 1
> > > > make[2]: *** Waiting for unfinished jobs....
> > > >
> > > > Seen with alpha:allmodconfig, arm:allmodconfig, m68k:allmodconfig, and
> > > > xtensa:allmodconfig.
> > > 
> > > Known issue, cfr. my early warning 10 days ago:
> > > 
> > > "Btrfs is the first user of __put_user_unaligned() outside the compat code,
> > > hence now all 32-bit architectures should make sure to implement this, too."
> > > 
> > > http://marc.info/?l=linux-arch&m=137820065929216&w=2
> > > 
> > > and today's thread https://lkml.org/lkml/2013/9/12/814
> > > 
> > 
> > It doesn't seem right that a patch breaks the build for several platforms, and
> > the problem is then blamed on the platform code instead of the code that is
> > introducing the problem.
> > 
> > Maybe we should add BROKEN to the btrfs dependencies for the affected platforms.
> > After all, it _is_ broken.
> 
> I'm happy to fix this with a bigger put of the info struct, just
> let me know the preferred arch-happy solution.
> 
Me not either. The only requirement I would have is that it should not break
a build. Of course, it would be even better if it would actually work ;-).

Guenter
