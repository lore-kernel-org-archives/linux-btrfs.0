Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB37AC43218
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 412C520891
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfDYPzn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:55:43 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43713 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfDYPzn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 11:55:43 -0400
Received: by mail-qt1-f195.google.com with SMTP id g4so604936qtq.10;
        Thu, 25 Apr 2019 08:55:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zkwopJCM5aWIxk1QBblXCx0FKSBr5++vETUbB1hTeEs=;
        b=NlFeIDqca1cphh1upv/cDvlCmoF3HGt9HAeTxX4mddA/iM+S/tVwkvKF/kGj0UjUS6
         NrEz4HIfUbW0toeWqqgP6WykwBwrZXLqbB6Gf6WXQRQex61VKLGV4z7FqIf5z6epxlDA
         Zv6YT0xVBX4JXNVzfiLQkRVgx7ZxCgZCcx6YGw7ZiQNKvWVoE2MZjdk29nY9hWl10OxW
         yAE81CZ2r95sOz6SCvFgjobX+lYYBFMn6RP5xtON6VBegCcJl0BWI//Epf0VQR/m3M1i
         fO+vLQD6vYsIVNmtqkDsRUoT1LVLB77F/7RpXaY1QsscJYaj8m55g74xVtdoLQi4J+CB
         +Qlg==
X-Gm-Message-State: APjAAAUUJhjzP/nzNWGRi13/QF447CE8eBjeq7u2Iw7AolrPIWsq/zVY
        yehVaa+rTyWhqJhrPiIN5UwhzSnp3AGTpY3tt3w=
X-Google-Smtp-Source: APXvYqwupzbYTiLjLfqIarqoXDi4frJzR/cv4HqO21AQp9/xhogJt2aa2zuSHYZLMoMxRTXJvQmzyoVA0Y0H4v8cQsw=
X-Received: by 2002:a0c:d2fa:: with SMTP id x55mr32105048qvh.161.1556207741117;
 Thu, 25 Apr 2019 08:55:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190416202013.4034148-1-arnd@arndb.de> <20190416202701.127745-1-arnd@arndb.de>
 <20190425122153.450fc094@coco.lan> <20190425153534.GS2217@ZenIV.linux.org.uk>
In-Reply-To: <20190425153534.GS2217@ZenIV.linux.org.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 25 Apr 2019 17:55:23 +0200
Message-ID: <CAK8P3a2HmiYQJ2FV2FgLiFsD8M9UKteC9Jetx7ja06PQVZWYfA@mail.gmail.com>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to compat_ptr_ioctl
To:     Al Viro <viro@zeniv.linux.org.uk>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 5:35 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Thu, Apr 25, 2019 at 12:21:53PM -0300, Mauro Carvalho Chehab wrote:
>
> > If I understand your patch description well, using compat_ptr_ioctl
> > only works if the driver is not for s390, right?
>
> No; s390 is where "oh, just set ->compat_ioctl same as ->unlocked_ioctl
> and be done with that; compat_ptr() is a no-op anyway" breaks.  IOW,
> s390 is the reason for having compat_ptr_ioctl() in the first place;
> that thing works on all biarch architectures, as long as all stuff
> handled by ->ioctl() takes pointer to arch-independent object as
> argument.  IOW,
>         argument ignored => OK
>         any arithmetical type => no go, compat_ptr() would bugger it
>         pointer to int => OK
>         pointer to string => OK
>         pointer to u64 => OK
>         pointer to struct {u64 addr; char s[11];} => OK

To be extra pedantic, the 'struct {u64 addr; char s[11];} '
case is also broken on x86, because sizeof (obj) is smaller
on i386, even though the location of the members are
the same. i.e. you can copy_from_user() this, but not
copy_to_user(), which overwrites 4 bytes after the end of
the 20-byte user structure.

       Arnd
