Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCADC4321A
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C9F4205ED
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 15:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfDYPc0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:32:26 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44074 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387593AbfDYPcZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 11:32:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id s10so504701qtc.11;
        Thu, 25 Apr 2019 08:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vnOK55Hhpegmo/fnJEz+TCVV+Rtg/rYKGc4878e+cQM=;
        b=UKuOoUy+U/DhO1lrIpJzV4Ph/CephrAcf/jKCSeUIeDvoHjzvpEnXC65Ukf9h1Ml3O
         /s3B+ucBFA/SCZiwvcG8m44SU5vaLq+cSoUpr+v97MybACPI8xSw+tBqbMtGey3O/dwh
         7k6dvRZqNSLErq6sAvUOfdrbS3QsRH/LAtzQL7ZCp3VEV4Xa+tJDCKHFqhG4eUmFBOoA
         TdH5uTW+6TRa6B8E0jLoEj97uvssKvZFAGT30Y1GHSjPupev46xs0A2EzYdpKp1K0Cnc
         ECJ5zIKvJo3lKjWIAoD4lKDuRognkIEVFH3Eb+w7nBaxIUaAv8axd6sFg84VH9IhHe+7
         WZ5Q==
X-Gm-Message-State: APjAAAWLh3mra7FsjsrItm2wXSJLHGYq1pNo9wSfDkOc4Mfvr6JR7F6K
        S2gD/7PIlEI9SIS02upAVCHeANw0CRkAyRlXWeA=
X-Google-Smtp-Source: APXvYqwxk/2uu8237YdCHmRUJfKvMCqEAFuyKk69MJnoHNCwVO4ijAI41YQVvxcBEABnP8bt18E+q4gxBK6hSfckd+U=
X-Received: by 2002:ac8:2924:: with SMTP id y33mr30625898qty.212.1556206343098;
 Thu, 25 Apr 2019 08:32:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190416202013.4034148-1-arnd@arndb.de> <20190416202701.127745-1-arnd@arndb.de>
 <20190425122153.450fc094@coco.lan>
In-Reply-To: <20190425122153.450fc094@coco.lan>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 25 Apr 2019 17:32:05 +0200
Message-ID: <CAK8P3a1qCQJEkne3uAw-Ep-taNU9t5Y2ZmgoiCGmOz1BSwmzEw@mail.gmail.com>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to compat_ptr_ioctl
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
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

On Thu, Apr 25, 2019 at 5:22 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> Em Tue, 16 Apr 2019 22:25:33 +0200 Arnd Bergmann <arnd@arndb.de> escreveu:
>
> If I understand your patch description well, using compat_ptr_ioctl
> only works if the driver is not for s390, right?

No, the purpose of compat_ptr_ioctl() is to make sure it works
everywhere including s390.

Even on s390 it tends to work most of the time, but for correctness
the upper bit of a 32-bit pointer needs to be cleared, as
compat_ptr_ioctl does, in case some application passes a pointer
with that bit set. [IIRC, in the instruction pointer, the high bit is set, in
data references it is ignored but usually cleared, but it may be left
on for IP-relative address generation]

       Arnd
