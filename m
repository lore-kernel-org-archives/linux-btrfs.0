Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:51083 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3ITEuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 00:50:00 -0400
Received: by mail-pa0-f53.google.com with SMTP id lb1so251997pab.40
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Sep 2013 21:50:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5236E1FF.4080900@mur.at>
References: <5236E1FF.4080900@mur.at>
Date: Fri, 20 Sep 2013 00:49:59 -0400
Message-ID: <CALJXSJpPeUTCnKQWph1gr3GYuvLLqGtRfJTi3Dq42o=96BxXnw@mail.gmail.com>
Subject: Re: rootfs crash
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: =?UTF-8?Q?Jogi_Hofm=C3=BCller?= <jogi@mur.at>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 16, 2013 at 6:48 AM, Jogi Hofmüller <jogi@mur.at> wrote:
>  After btrfs-zero-log the device
> was still not mountable.  Mount attempts fail with i/o erros now.
...
> All this is happening on an Asus Zen book  UX32V with two 128GB SSDs.


Did you make sure you aren't working with a dead SSD? That would make
everything much more complicated than it should be. I also had a
Zenbook from Asus with SSD with Btrfs, and it died 2 months ago. It
couldn't handle Btrfs for more than 6 months. Either those SSDs are
weak or Btrfs really is an SSD killer even though it is a COW FS.

Maybe using ddrescue first to get it off the defective media would
give you a chance to recover more data.
