Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FD8C43218
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 21:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CBA0206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 21:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387979AbfDYV1O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 17:27:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40516 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfDYV1N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 17:27:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJlsJ-0000g8-4C; Thu, 25 Apr 2019 23:25:47 +0200
Message-ID: <5511420228cb38d08a67c0f6a614b7671d7d23d4.camel@sipsolutions.net>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to
 compat_ptr_ioctl
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>
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
Date:   Thu, 25 Apr 2019 23:25:43 +0200
In-Reply-To: <CAK8P3a2HmiYQJ2FV2FgLiFsD8M9UKteC9Jetx7ja06PQVZWYfA@mail.gmail.com> (sfid-20190425_175600_668610_93FA972E)
References: <20190416202013.4034148-1-arnd@arndb.de>
         <20190416202701.127745-1-arnd@arndb.de> <20190425122153.450fc094@coco.lan>
         <20190425153534.GS2217@ZenIV.linux.org.uk>
         <CAK8P3a2HmiYQJ2FV2FgLiFsD8M9UKteC9Jetx7ja06PQVZWYfA@mail.gmail.com>
         (sfid-20190425_175600_668610_93FA972E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 2019-04-25 at 17:55 +0200, Arnd Bergmann wrote:
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
> the same. i.e. you can copy_from_user() this

Actually, you can't even do that because the struct might sit at the end
of a page and then you'd erroneously fault in this case.

We had this a while ago with struct ifreq, see commit 98406133dd and its
parents.

johannes

