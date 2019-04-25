Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE85C43219
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D48472081C
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfDYPfs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:35:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47236 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfDYPfr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 11:35:47 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hJgPO-0002EI-Tp; Thu, 25 Apr 2019 15:35:35 +0000
Date:   Thu, 25 Apr 2019 16:35:34 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
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
Message-ID: <20190425153534.GS2217@ZenIV.linux.org.uk>
References: <20190416202013.4034148-1-arnd@arndb.de>
 <20190416202701.127745-1-arnd@arndb.de>
 <20190425122153.450fc094@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425122153.450fc094@coco.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 12:21:53PM -0300, Mauro Carvalho Chehab wrote:

> If I understand your patch description well, using compat_ptr_ioctl
> only works if the driver is not for s390, right?

No; s390 is where "oh, just set ->compat_ioctl same as ->unlocked_ioctl
and be done with that; compat_ptr() is a no-op anyway" breaks.  IOW,
s390 is the reason for having compat_ptr_ioctl() in the first place;
that thing works on all biarch architectures, as long as all stuff
handled by ->ioctl() takes pointer to arch-independent object as
argument.  IOW,
	argument ignored => OK
	any arithmetical type => no go, compat_ptr() would bugger it
	pointer to int => OK
	pointer to string => OK
	pointer to u64 => OK
	pointer to struct {u64 addr; char s[11];} => OK
	pointer to long => needs explicit handler
	pointer to struct {void *addr; char s[11];} => needs explicit handler
	pointer to struct {int x; u64 y;} => needs explicit handler on amd64
For "just use ->unlocked_ioctl for ->ioctl" we have
	argument ignored => OK
	any arithmetical type => OK
	any pointer => instant breakage on s390, in addtion to cases that break
with compat_ptr_ioctl().

Probably some form of that ought to go into commit message for compat_ptr_ioctl()
introduction...
