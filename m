Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:53573 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932280AbdKBP73 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 11:59:29 -0400
Received: by mail-wm0-f51.google.com with SMTP id r196so23562wmf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 08:59:28 -0700 (PDT)
Message-ID: <1509638366.1662.142.camel@gmail.com>
Subject: Re: Several questions regarding btrfs
From: ST <smntov@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Thu, 02 Nov 2017 17:59:26 +0200
In-Reply-To: <173c1ba3-1a05-1a27-7bee-22141200cbf8@gmail.com>
References: <1509467017.1662.37.camel@gmail.com>
         <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
         <1509480384.1662.84.camel@gmail.com>
         <ea097624-d485-9423-387f-3c9427508883@gmail.com>
         <1509545153.1662.105.camel@gmail.com>
         <7e8d6430-01e0-ba8e-5822-510ba1daef9f@gmail.com>
         <1509613781.1662.115.camel@gmail.com>
         <173c1ba3-1a05-1a27-7bee-22141200cbf8@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >> There's one other caveat though, only root can use the qgroup ioctls,
> >> which means that only root can check quotas.
> > 
> > Only root can check quotas?! That is really strange. How users are
> > supposed to know they are about to be out of space?... Is this by design
> > so and will remain like that or it's just because this feature was not
> > finished yet?
> > 
> I have no idea if it's intended to be that way, but quite a few things 
> in BTRFS are root-only that debatably should not be.  I think the quota 
> ioctls fall under the same category as the tree search ioctl, they 
> access data that's technically privileged and can let you see things 
> beyond the mount point they're run on.

Could somebody among developers please elaborate on this issue - is
checking quota going always to be done by root? If so - btrfs might be a
no-go for our use case...

Thank you!

