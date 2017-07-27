Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:40945 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751497AbdG0VCd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 17:02:33 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dapvI-0000j6-4S
        for linux-btrfs@vger.kernel.org; Thu, 27 Jul 2017 23:02:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 2/2] btrfs-progs: Use named constants for common sizes
Date: Thu, 27 Jul 2017 21:02:12 +0000 (UTC)
Message-ID: <pan$9b8a8$c35443cf$d85bd4b7$f5299060@cox.net>
References: <1501143420-28062-1-git-send-email-nborisov@suse.com>
        <1501143420-28062-2-git-send-email-nborisov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolay Borisov posted on Thu, 27 Jul 2017 11:17:00 +0300 as excerpted:

> diff --git a/convert/main.c b/convert/main.c
> index c56382e915fd..49ab829b5641 100644
> --- a/convert/main.c
> +++ b/convert/main.c

> @@ -1586,7 +1586,7 @@ next:
>   * |   RSV 1   |  | Old  |   |    RSV 2  | | Old  | |   RSV 3   |
>   * |   0~1M    |  | Fs   |   | SB2 + 64K | | Fs   | | SB3 + 64K |
>   *
> - * On the other hande, the converted fs image in btrfs is a completely 
> + * On the other hande, the converted fs image in btrfs is a completely
>   * valid old fs.
>   *
>   * |<-----------------Converted fs image in btrfs-------------------->|

If you're going to kill the line-terminating space, you might as well
do the spell-correct in the same line:

s/hande/hand/

(Or avoid the noise of doing either.  I'm not sure which the devs prefer.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

