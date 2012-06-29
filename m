Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62306 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2F2Fgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 01:36:38 -0400
Received: by vcbf11 with SMTP id f11so2068981vcb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2012 22:36:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120627134857.GC2819@localhost.localdomain>
References: <CACCfv7qEa-hVmNEB6DMy9khGfjcyPuLk27M1ue4VMDwgv9++FQ@mail.gmail.com>
	<20120627134857.GC2819@localhost.localdomain>
Date: Fri, 29 Jun 2012 15:06:38 +0930
Message-ID: <CACCfv7oOU3-S5iNJqCd084-WK5WE=gBdwkOhd1tqF0udN7pw7Q@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:1887 after hard shutdown.
From: Jordan Windsor <jordanw2@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 11:18 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Tue, Jun 26, 2012 at 09:46:44PM -0600, Jordan Windsor wrote:
>> Hello,
>> My computer locked up and I had to press the reset button.
>> Ever since then I can't mount the btrfs filesystem, here's the output:
>>
>
> Already fixed, go to the newest kernel you can get ahold of, 3.5-rc4 is the
> newest I think?  Thanks,
>
> Josef

Hello,
I get the same problem with linux-mainline from AUR (latest), When I
try mounting with "-o clear_cache" the process hangs and I can't c-Z
or c-C it also I can't kill it in another terminal either.
Thanks.
