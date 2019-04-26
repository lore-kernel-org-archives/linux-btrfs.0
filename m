Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9EDC43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 07:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A849C206E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 07:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfDZHqc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:46:32 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38494 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZHqc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 03:46:32 -0400
Received: by mail-qt1-f193.google.com with SMTP id d13so3099026qth.5;
        Fri, 26 Apr 2019 00:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ai+vP/B94Ve42WDYthMy68WDqGtKeGDhz8vwsuWoKYY=;
        b=FG7fOj59wwyOPVaYrKZUOZkuiWAvC9akOixlTflJRlZBaD5Nk1Q5lt4sNCVKQ0Ymoj
         52Mw/cEb5bga48QDfZ25/IosOd7f4DVtReblKt78Tddb6JbvCOKlsnW4ZPHxwbqCcDWl
         AQM/p3uZiav0jkbogyOgR/4xxAbV+hxPuEvbksaoHrj3hkC5yYwUQGGxb0feSPNshzXf
         S+dmruYGKTPfi7MC8NPxeUYIYDBmFZwedMocX20dgkFMvHU+dhbQkTwmaEk2O8qXcQ6g
         uJAGfAJII+Qyt2ArmRK2SZ3h6YsW8oPqMVHZ/GGnoBbS0uiS7s2iVgur4G88lQugZgI8
         33hw==
X-Gm-Message-State: APjAAAVBrPBraidJkoagVa/Iqi808354m7O7uJIVMSDvP510mK1VadoD
        QO8l3m/Yer2pZRboxgbgjpAGH2eZtedEhQ8mJXg=
X-Google-Smtp-Source: APXvYqzr09tBTeb1FTaqfVBhYsMoMqeG81qMW2qxny43/8KyQQnSkk725v7OZs6m0g32Hp/ZRVlDu6HuZidDEo5Nyhc=
X-Received: by 2002:ac8:276b:: with SMTP id h40mr35193967qth.319.1556264790155;
 Fri, 26 Apr 2019 00:46:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190416202013.4034148-1-arnd@arndb.de> <20190416202701.127745-1-arnd@arndb.de>
 <20190425122153.450fc094@coco.lan> <20190425153534.GS2217@ZenIV.linux.org.uk>
 <CAK8P3a2HmiYQJ2FV2FgLiFsD8M9UKteC9Jetx7ja06PQVZWYfA@mail.gmail.com> <5511420228cb38d08a67c0f6a614b7671d7d23d4.camel@sipsolutions.net>
In-Reply-To: <5511420228cb38d08a67c0f6a614b7671d7d23d4.camel@sipsolutions.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 26 Apr 2019 09:46:13 +0200
Message-ID: <CAK8P3a3CzKLvpUiVV_k__kkaZ=wg2fqnFEzWYL9qNwBfxMKZ9w@mail.gmail.com>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to compat_ptr_ioctl
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 11:25 PM Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2019-04-25 at 17:55 +0200, Arnd Bergmann wrote:
> > On Thu, Apr 25, 2019 at 5:35 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > On Thu, Apr 25, 2019 at 12:21:53PM -0300, Mauro Carvalho Chehab wrote:
> > >
> > > > If I understand your patch description well, using compat_ptr_ioctl
> > > > only works if the driver is not for s390, right?
> > >
> > > No; s390 is where "oh, just set ->compat_ioctl same as ->unlocked_ioctl
> > > and be done with that; compat_ptr() is a no-op anyway" breaks.  IOW,
> > > s390 is the reason for having compat_ptr_ioctl() in the first place;
> > > that thing works on all biarch architectures, as long as all stuff
> > > handled by ->ioctl() takes pointer to arch-independent object as
> > > argument.  IOW,
> > >         argument ignored => OK
> > >         any arithmetical type => no go, compat_ptr() would bugger it
> > >         pointer to int => OK
> > >         pointer to string => OK
> > >         pointer to u64 => OK
> > >         pointer to struct {u64 addr; char s[11];} => OK
> >
> > To be extra pedantic, the 'struct {u64 addr; char s[11];} '
> > case is also broken on x86, because sizeof (obj) is smaller
> > on i386, even though the location of the members are
> > the same. i.e. you can copy_from_user() this
>
> Actually, you can't even do that because the struct might sit at the end
> of a page and then you'd erroneously fault in this case.
>
> We had this a while ago with struct ifreq, see commit 98406133dd and its
> parents.

Yes, you are right. Very rare to hit with real-life code, but easily
reproduced by intentionally hitting it and clearly a bug.

As the saying goes

  | the difference between "always works" and "almost always works"
  | is called data corruption

here the difference is an -EFAULT.

      Arnd
