Return-Path: <SRS0=TOkC=MG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBAEECE568
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Sep 2018 20:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 393DA2098A
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Sep 2018 20:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="X3UT+glc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 393DA2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbeIYCjI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Sep 2018 22:39:08 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46764 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbeIYCjG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 22:39:06 -0400
Received: by mail-io1-f66.google.com with SMTP id y12-v6so18685712ioj.13
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2018 13:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zGovwL34m3Q5BD9+4dJtUpU8TqZLav+XmYRhRA5U/9M=;
        b=X3UT+glcIJb5oLsdvNnVZeUDurKxQTpOAFdYnLr3OlV0sBpTq6a94MZoGR8IvcacWi
         sci5aWT713EV2DJQpkH/xCNeB3usHjcNQyi+ol5GSysPgkHuvYymR4EL6vRQxms5pQMk
         YRWBxRwX5/6pied75MvOCaYrhRewsOfmKEs+aZtfv+VLzRjXTB/AECC/RfXaG9RfZ4Ce
         bikpGFk0O6hKxe5Qz4a3h61PGSMngFNyukLb54m3abzgr+7nH70mKxhGwvwbp+3WZiEr
         VHzMDU9Zh5s2NRqfk5zVX6Aou5/uZPDgAkxDy2/UXnASmwKA8nFZjPeBXGauj+Vp67DV
         eXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zGovwL34m3Q5BD9+4dJtUpU8TqZLav+XmYRhRA5U/9M=;
        b=tiAIYOkU6DA5Ett8j8AxMlVrhuU1Br173I4yi02OSDBpc60O6AzJsFU0tXKU6FJhy5
         8z6hdo8pmDBD2oIPaGbAInbXx83i1vFgHfZjvTtSNSU6KvWy+y6UJqRR4FksM6hJqb+N
         I8yycNnoU8EjZKQls2rDO3eZhh9es7qWd776xFSV2QU4t47XfL28gJDKbc1LRaX6/ilL
         6EgYSGxrinrDHa9gwFCcFEsqsVga+5j8V73LVUzNZReVS4sC0mvo4d1cMnXzaVPFfqio
         mMlCgS5Uv27ZoccqR+w0WnWz3j+3nNWgcv/+K0G96BQbTCg40lxtx0ibzHoM700Igbjv
         ZxjA==
X-Gm-Message-State: ABuFfoja7CN8T5UxvZygd9PCE4HOzQNfhl3oqYFyKbFMGeVuE4EKYC5a
        A8fOBqNkEDFnUFv1R3Sb9WTdGA==
X-Google-Smtp-Source: ACcGV61ECXbxJxiwQwEyDEDcELQXpE4eIuuZ37a3ZaLiDV+6S+ztWuUYuJIdSoXN7kaQSj+n3ut79A==
X-Received: by 2002:a6b:5903:: with SMTP id n3-v6mr519122iob.176.1537821306779;
        Mon, 24 Sep 2018 13:35:06 -0700 (PDT)
Received: from ziepe.ca (S010614cc2056d97f.ed.shawcable.net. [174.3.196.123])
        by smtp.gmail.com with ESMTPSA id y25-v6sm5740417ita.3.2018.09.24.13.35.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Sep 2018 13:35:06 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1g4XZR-00080t-5a; Mon, 24 Sep 2018 14:35:05 -0600
Date:   Mon, 24 Sep 2018 14:35:05 -0600
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Arnd Bergmann <arnd@arndb.de>
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
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180924203505.GC6008@ziepe.ca>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath>
 <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath>
 <20180918175952.GJ11367@ziepe.ca>
 <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org
Message-ID: <20180924203505.JuavytarQlPihQpFTowPnOzNdtCLH0SedxU1buWPIiU@z>

On Mon, Sep 24, 2018 at 10:18:52PM +0200, Arnd Bergmann wrote:
> On Tue, Sep 18, 2018 at 7:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> > > On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > > > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> > > >
> > > > > Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
> > > > >
> > > > > As for a longer term solution, would it be possible to init fops in such
> > > > > a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
> > > > > so we don't have to duplicate this boilerplate for every ioctl fops
> > > > > structure?
> > > >
> > > >     Bad idea, that...  Because several years down the road somebody will add
> > > > an ioctl that takes an unsigned int for argument.  Without so much as looking
> > > > at your magical mystery macro being used to initialize file_operations.
> > >
> > > Fair, being explicit in the declaration as it is currently may be
> > > preferable then.
> >
> > It would be much cleaner and safer if you could arrange things to add
> > something like this to struct file_operations:
> >
> >   long (*ptr_ioctl) (struct file *, unsigned int, void __user *);
> >
> > Where the core code automatically converts the unsigned long to the
> > void __user * as appropriate.
> >
> > Then it just works right always and the compiler will help address
> > Al's concern down the road.
> 
> I think if we wanted to do this with a new file operation, the best
> way would be to do the copy_from_user()/copy_to_user() in the caller
> as well.
>
> We already do this inside of some subsystems, notably drivers/media/,
> and it simplifies the implementation of the ioctl handler function
> significantly. We obviously cannot do this in general, both because of
> traditional drivers that have 16-bit command codes (drivers/tty and others)
> and also because of drivers that by accident defined the commands
> incorrectly and use the wrong type or the wrong direction in the
> definition.

That could work well, but the first idea could be done globally and
mechanically, while this would require very careful per-driver
investigation. 

Particularly if the core code has worse performance.. ie due to
kmalloc calls or something.

I think it would make more sense to start by having the core do the
case to __user and then add another entry point to have the core do
the copy_from_user, and so on.

Jason
