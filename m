Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:33065 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdBWMeN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 07:34:13 -0500
Received: by mail-it0-f54.google.com with SMTP id d9so3362071itc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Feb 2017 04:34:13 -0800 (PST)
Subject: Re: Downgrading kernel 4.9 to 4.4 with space_cache=v2 enabled?
To: Christian Theune <ct@flyingcircus.io>, linux-btrfs@vger.kernel.org
References: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <029c96aa-9c1e-f12c-8b63-4e4485428c67@gmail.com>
Date: Thu, 23 Feb 2017 07:34:06 -0500
MIME-Version: 1.0
In-Reply-To: <BB064A3C-6F5C-4490-80A6-F42BEFAA945A@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-23 05:51, Christian Theune wrote:
> Hi,
>
> not sure whether it’s possible, but we tried space_cache=v2 and obviously after working fine in staging it broke in production. Or rather: we upgraded from 4.4 to 4.9 and enabled the space_cache. Our production volume is around 50TiB usable (underlying HW Raid 6).
>
> The machine crashes silently every 15 hours or so and takes _ages_ to reboot. It current is stuck trying to mount the local filesystems and I guess btrfs is doing something, but I don’t have shell access yet.
>
> I’m wondering whether we can downgrade by booting back into 4.4 or will this break things even further? (We’ve had some unpleasant surprises with FS’ in the last months, so I thought I’d rather ask.)
If it has a v2 free space cache and was mounted on a kernel newer than 
(I think) 4.8, it almost certainly won't mount on a 4.4 kernel.  The 
free-space-tree code got added in 4.5, and there was an incompatible 
filesystem flag added more recently to mark filesystems which are 
unaffected by a bug in the original implementation.  That flag gets set 
automatically on kernels that include the code to fix the bug's effects 
on the FS, which IIRC includes 4.9 kernels.

That said, if you can get it to mount at all on the 4.9 kernel, you can 
probably convert it back by mounting with -o clear_cache,space_cache=v1. 
  I'm saying probably in this case because it may be more than just the 
v2 space cache that's messed up, and if there's other corruption in the 
FS, you'll still see issues.  If it's just the free space cache though, 
adding those two options to the mount options (and removing 
space_cache=v2) should let it mount much more quickly, and you should 
see some above-average disk activity for a while, but afterwards you 
should be able to mount it on the 4.4 kernel again.

