Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB35C4321B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC7072067D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556207627;
	bh=ho5TyauY3lJuFVAthLKFJ6Y7hIL31mARg19a8JCHiUk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=PX1LTxiGILCPnD9jknQEbkTNf/Qq2apXFFhQk9oftgGIGHRXSe08i5F6EGGLPs/iL
	 48q1JNwj9nCsAiwzGg+osdkIpYYqy4fPy5eRDI2A/f0IJAhFAa6Bs3XbAse8/XmKmV
	 QRUUopiU7M6IbJ12vIkg8UFRnNSxRxHdjHTdbBM8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbfDYPxW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:53:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:44084 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfDYPxV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 11:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=E3NXYmNospchyn56GjhuUUM3hrUac73tHVKaHCldfOk=; b=Bonx4HPMYcr3a2nktGqFVhvpkC
        Lm7Jv3Ti63Kv4EMBUFae5lI4ptDC5RAI5ElUhwvqH9DfP8HL3oLak9sqkNi1SrdMbInWhlezS4ZQv
        TaB3dxTt/lLAd7hovrVYa5w4+CCJd72lsXCzDbUllvhVuoJLaU1Hl5+LKJVzv+MI7D167ykTh2GZK
        d6OPs3hXZSnLAXf1R6CrpdOPA9x9rme1ywi76UowaMUx1f609U55StEwsjKOyqNJVxN4cMGncdYB6
        KnVvdda0AmWSEMwWetcrVOOCMdnwjzCP88m9Y10yNoScW0lTGYk+7ZUQxJpbglecBDUogb5ukJzjR
        1L7XLtaQ==;
Received: from [179.95.39.209] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJggS-0007pK-Bs; Thu, 25 Apr 2019 15:53:12 +0000
Date:   Thu, 25 Apr 2019 12:53:01 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgg@mellanox.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Sterba <dsterba@suse.com>,
        Darren Hart <dvhart@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        devel@driverdev.osuosl.org, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Sean Young <sean@mess.org>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to
 compat_ptr_ioctl
Message-ID: <20190425125301.5165cf15@coco.lan>
In-Reply-To: <20190425153534.GS2217@ZenIV.linux.org.uk>
References: <20190416202013.4034148-1-arnd@arndb.de>
        <20190416202701.127745-1-arnd@arndb.de>
        <20190425122153.450fc094@coco.lan>
        <20190425153534.GS2217@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Em Thu, 25 Apr 2019 16:35:34 +0100
Al Viro <viro@zeniv.linux.org.uk> escreveu:

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
> 	argument ignored => OK
> 	any arithmetical type => no go, compat_ptr() would bugger it
> 	pointer to int => OK

That's the case for all LIRC ioctls: they all use a pointer to u32
argument.

> 	pointer to string => OK
> 	pointer to u64 => OK
> 	pointer to struct {u64 addr; char s[11];} => OK
> 	pointer to long => needs explicit handler
> 	pointer to struct {void *addr; char s[11];} => needs explicit handler
> 	pointer to struct {int x; u64 y;} => needs explicit handler on amd64
> For "just use ->unlocked_ioctl for ->ioctl" we have
> 	argument ignored => OK
> 	any arithmetical type => OK
> 	any pointer => instant breakage on s390, in addtion to cases that break
> with compat_ptr_ioctl().
> 
> Probably some form of that ought to go into commit message for compat_ptr_ioctl()
> introduction...

Agreed.

Thanks,
Mauro
