Return-Path: <SRS0=TOkC=MG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207B3C004D3
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Sep 2018 21:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5ED8208D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Sep 2018 21:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5ED8208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbeIYDV2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Sep 2018 23:21:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43232 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbeIYDV2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 23:21:28 -0400
Received: by mail-qt1-f196.google.com with SMTP id l16-v6so10634574qtq.10;
        Mon, 24 Sep 2018 14:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R2zzxBgg/8NvVC9r2LVRNtyuv4apxgAqKmjDoDkBQsY=;
        b=m3oub87+2L5CaG6KqUGUFCNFQAh+IrATvLMlnDkH5vH3Cq3ScmDIWXq/nCE970LGWH
         PSozLPvte5ls1QAfav8sFFjdOkRHD8ETgMrOxXm9lxM8TCX2Cpy2N4PIEyU5dEFVUl7Z
         5MQ6uK9dmLueOOIRL6FgijpzVWANeUpJe0nRoZysKC5Q/jm4hLDXzxCV8s9bFtfCymkc
         wtzz8LkVOTUkRBAA+c0b1N+QO4xGgUIq32hFTndEJCjEMqU+Pmo2Ue0VdLi6gDjIGf5U
         o+fkdsGnOw6GQGj/fZiFzYzOGS7rVs3a3SJP9OXr+3QtTux8JbMBlNv7m/qzj3qcfoXa
         +fLw==
X-Gm-Message-State: ABuFfognNM3UYjrlcnxl0oD2qAXRuTecXojnyT2GEkkkR1Zw9An6Z+Db
        WJOgaKTl4FB6msszpMtnfQm9eFHHDwFX59WcSL4=
X-Google-Smtp-Source: ACcGV600+tboLwtxr6q8SyQHIWnW+YzCxl/7gTIqTN76ybjiM0uW8wcQwahSSBcAthjiW96c6jblRT0dWwUCS6IUl9k=
X-Received: by 2002:aed:3f08:: with SMTP id p8-v6mr545436qtf.185.1537823837231;
 Mon, 24 Sep 2018 14:17:17 -0700 (PDT)
MIME-Version: 1.0
References: <20180912150142.157913-1-arnd@arndb.de> <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath> <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath> <20180918175952.GJ11367@ziepe.ca>
 <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com> <20180924203505.GC6008@ziepe.ca>
In-Reply-To: <20180924203505.GC6008@ziepe.ca>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 24 Sep 2018 23:17:01 +0200
Message-ID:
 <CAK8P3a1Bh9NnncbcT0X4fKWC7B0FnqYyEMUwB6MvmzaNO7VhFQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to generic_compat_ioctl_ptrarg
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Darren Hart <dvhart@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qat-linux@intel.com,
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
        linux-fbdev@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
Message-ID: <20180924211701.Ux_MGiajIraIOb9d8kYMqqxyfIN6A-RWozs0HpVW3tY@z>

On Mon, Sep 24, 2018 at 10:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Mon, Sep 24, 2018 at 10:18:52PM +0200, Arnd Bergmann wrote:
> > On Tue, Sep 18, 2018 at 7:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> > > > On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > > > > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> > We already do this inside of some subsystems, notably drivers/media/,
> > and it simplifies the implementation of the ioctl handler function
> > significantly. We obviously cannot do this in general, both because of
> > traditional drivers that have 16-bit command codes (drivers/tty and others)
> > and also because of drivers that by accident defined the commands
> > incorrectly and use the wrong type or the wrong direction in the
> > definition.
>
> That could work well, but the first idea could be done globally and
> mechanically, while this would require very careful per-driver
> investigation.
>
> Particularly if the core code has worse performance.. ie due to
> kmalloc calls or something.
>
> I think it would make more sense to start by having the core do the
> case to __user and then add another entry point to have the core do
> the copy_from_user, and so on.

Having six separate callback pointers to implement a single
system call seems a bit excessive though.

        Arnd
