Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36248 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbcGXBt3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 21:49:29 -0400
Received: by mail-oi0-f46.google.com with SMTP id w18so210919736oiw.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 18:49:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ+hVY27j5jOuAfTn4wPE_FV3AheR0+DLL1ui4m6OYCwQ@mail.gmail.com>
References: <6f4623c4-3e4c-7add-aa89-3857b0d48c61@friedels.name> <CAJCQCtQ+hVY27j5jOuAfTn4wPE_FV3AheR0+DLL1ui4m6OYCwQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 23 Jul 2016 19:49:28 -0600
Message-ID: <CAJCQCtSAMR8=QUW8DR5vriHOy-17cpfd94RoDiKZf8nGfKMQ6w@mail.gmail.com>
Subject: Re: Chances to recover with bad partition table?
Cc: Hendrik Friedel <hendrik@friedels.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jul 23, 2016 at 7:46 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Something like this:
> [root@f24s ~]# dd if=/dev/sda | hexdump -C | egrep '5f 42 48 52 66 53 5f'
> 00110040  5f 42 48 52 66 53 5f 4d  8d 4f 04 00 00 00 00 00  |_BHRfS_M.O......|

Ha so originally I was planning on putting in the dd portion a count
limit, like count=20480 for a 10MiB search from the start of the
drive. You could just do

# hexdump -C /dev/sda | egrep '5f 42 48 52 66 53 5f'

And then control-C to cancel it once the first super shows up.


-- 
Chris Murphy
