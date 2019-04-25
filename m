Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B5DC43218
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 16:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C875F206BF
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 16:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbfDYQms (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:42:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48282 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfDYQmq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 12:42:46 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hJhSF-0003K2-7F; Thu, 25 Apr 2019 16:42:35 +0000
Date:   Thu, 25 Apr 2019 17:42:35 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Sterba <dsterba@suse.com>,
        Darren Hart <dvhart@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        driverdevel <devel@driverdev.osuosl.org>, qat-linux@intel.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-iio@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-pci <linux-pci@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-remoteproc@vger.kernel.org,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, Sean Young <sean@mess.org>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to
 compat_ptr_ioctl
Message-ID: <20190425164235.GT2217@ZenIV.linux.org.uk>
References: <20190416202013.4034148-1-arnd@arndb.de>
 <20190416202701.127745-1-arnd@arndb.de>
 <20190425122153.450fc094@coco.lan>
 <20190425153534.GS2217@ZenIV.linux.org.uk>
 <CAK8P3a2HmiYQJ2FV2FgLiFsD8M9UKteC9Jetx7ja06PQVZWYfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2HmiYQJ2FV2FgLiFsD8M9UKteC9Jetx7ja06PQVZWYfA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 05:55:23PM +0200, Arnd Bergmann wrote:
> On Thu, Apr 25, 2019 at 5:35 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Thu, Apr 25, 2019 at 12:21:53PM -0300, Mauro Carvalho Chehab wrote:
> >
> > > If I understand your patch description well, using compat_ptr_ioctl
> > > only works if the driver is not for s390, right?
> >
> > No; s390 is where "oh, just set ->compat_ioctl same as ->unlocked_ioctl
> > and be done with that; compat_ptr() is a no-op anyway" breaks.  IOW,
> > s390 is the reason for having compat_ptr_ioctl() in the first place;
> > that thing works on all biarch architectures, as long as all stuff
> > handled by ->ioctl() takes pointer to arch-independent object as
> > argument.  IOW,
> >         argument ignored => OK
> >         any arithmetical type => no go, compat_ptr() would bugger it
> >         pointer to int => OK
> >         pointer to string => OK
> >         pointer to u64 => OK
> >         pointer to struct {u64 addr; char s[11];} => OK
> 
> To be extra pedantic, the 'struct {u64 addr; char s[11];} '
> case is also broken on x86, because sizeof (obj) is smaller
> on i386, even though the location of the members are
> the same. i.e. you can copy_from_user() this, but not
> copy_to_user(), which overwrites 4 bytes after the end of
> the 20-byte user structure.

D'oh!  FWIW, it might be worth putting into Documentation/ somewhere;
basically, what is and what isn't biarch-neutral.

Or arch-neutral, for that matter - it's very close.  The only real
exception, IIRC, is an extra twist on m68k, where int behaves
like x86 long long - its alignment is only half its size, so
sizeof(struct {char c; int x;}) is 6, not 8 as everywhere
else.  Irrelevant for biarch, thankfully (until somebody gets insane
enough to implement 64bit coldfire, kernel port for it *and* biarch
support for m68k binaries on that thing, that is)...
