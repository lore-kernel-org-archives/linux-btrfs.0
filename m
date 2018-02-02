Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34678 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753292AbeBBTql (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 14:46:41 -0500
MIME-Version: 1.0
In-Reply-To: <1515404705-490-3-git-send-email-nborisov@suse.com>
References: <1515404705-490-1-git-send-email-nborisov@suse.com> <1515404705-490-3-git-send-email-nborisov@suse.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 2 Feb 2018 21:46:40 +0200
Message-ID: <CAHp75VeXC=ig=P1xeFDQTvMn+FP2oGWN2SgbOmTZQj+C-K6EWg@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: Remove custom crc32c init code
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 8, 2018 at 11:45 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> The custom crc32 init code was introduced in
> 14a958e678cd ("Btrfs: fix btrfs boot when compiled as built-in") to
> enable using btrfs as a built-in. However, later as pointed out by
> 60efa5eb2e88 ("Btrfs: use late_initcall instead of module_init") this
> wasn't enough and finally btrfs was switched to late_initcall which
> comes after the generic crc32c implementation is initiliased. The
> latter commit superseeded the former. Now that we don't have to
> maintain our own code let's just remove it and switch to using the
> generic implementation.

>  fs/btrfs/hash.c            | 54 ----------------------------------------------
>  fs/btrfs/hash.h            | 43 ------------------------------------

IIRC Adding -D to git format-patch will make it shorter and nicer.
But please, double check that git am actually detects removals.

-- 
With Best Regards,
Andy Shevchenko
