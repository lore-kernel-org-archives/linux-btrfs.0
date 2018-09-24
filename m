Return-Path: <SRS0=TOkC=MG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD10CECE568
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Sep 2018 20:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 816BA2087A
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Sep 2018 20:19:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 816BA2087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbeIYCXH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Sep 2018 22:23:07 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37611 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbeIYCXH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 22:23:07 -0400
Received: by mail-qt1-f196.google.com with SMTP id n6-v6so10943050qtl.4;
        Mon, 24 Sep 2018 13:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OsYidU1hlYJ+klx90AxIRQwB+6wMrrJr/JJ5pU6q0MY=;
        b=Bq/5Ah6K21QrKgRd+sjq/p5dJ91R2dGXcpqxjIP6Bg+7vpN08kjY+Dt47M4ZWLQpy7
         jWD2Xl247Vp9nhJwHCKu4MLoc/EaiAJKxWCbQTyBPprQ3k0pW3+ANb0vjgsMD/Z997c3
         TTQErOEhXe37g034dqRyqZnxjDcbV1O5xAvhemXC0trlHhq8VTSBTaXu/lCeZNMzLdwF
         f7arq0xyFJiacUrcyltM3Jq9mrkP0ImHO0BXL5vt10A1ggljVrqJJhAOH/MD2YwFTJg3
         /+K/bIdKv6ZCGQxQGe3C/o10WAVA0/aUOVl11Oud2OwxwgE+VuN73daPLfyknval13lO
         Gsfw==
X-Gm-Message-State: ABuFfohThuABX9vh8S5yordOs4kPicfzJH7PP/gcS6K9DccXXnG2e6nk
        a05V5KLBS8tfiTJs1N6C94upuBmoFFwCm9LwbLQ=
X-Google-Smtp-Source: ACcGV60Ps3U5LLCo0RjeCpaPr9VTAwVS7tqdLJYGXjikqVVB7pTkjFqFcc8hPBx92H8kqqx7rZwu+cIOb887IRHt2U8=
X-Received: by 2002:a0c:a8cc:: with SMTP id h12-v6mr393998qvc.161.1537820349291;
 Mon, 24 Sep 2018 13:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <20180912150142.157913-1-arnd@arndb.de> <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath> <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath> <20180918175952.GJ11367@ziepe.ca>
In-Reply-To: <20180918175952.GJ11367@ziepe.ca>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 24 Sep 2018 22:18:52 +0200
Message-ID:
 <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com>
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
Message-ID: <20180924201852.vNVQq8o09G6ofGY7xP2y0wWQpDNCyzlUbIRv7Mx9tUo@z>

On Tue, Sep 18, 2018 at 7:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> > On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> > >
> > > > Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
> > > >
> > > > As for a longer term solution, would it be possible to init fops in such
> > > > a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
> > > > so we don't have to duplicate this boilerplate for every ioctl fops
> > > > structure?
> > >
> > >     Bad idea, that...  Because several years down the road somebody will add
> > > an ioctl that takes an unsigned int for argument.  Without so much as looking
> > > at your magical mystery macro being used to initialize file_operations.
> >
> > Fair, being explicit in the declaration as it is currently may be
> > preferable then.
>
> It would be much cleaner and safer if you could arrange things to add
> something like this to struct file_operations:
>
>   long (*ptr_ioctl) (struct file *, unsigned int, void __user *);
>
> Where the core code automatically converts the unsigned long to the
> void __user * as appropriate.
>
> Then it just works right always and the compiler will help address
> Al's concern down the road.

I think if we wanted to do this with a new file operation, the best
way would be to do the copy_from_user()/copy_to_user() in the caller
as well.

We already do this inside of some subsystems, notably drivers/media/,
and it simplifies the implementation of the ioctl handler function
significantly. We obviously cannot do this in general, both because of
traditional drivers that have 16-bit command codes (drivers/tty and others)
and also because of drivers that by accident defined the commands
incorrectly and use the wrong type or the wrong direction in the
definition.

       Arnd
