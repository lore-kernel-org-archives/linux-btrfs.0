Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:55065 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGYEvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 00:51:53 -0400
Message-ID: <53D1E260.6080708@skagestad.org>
Date: Fri, 25 Jul 2014 06:51:44 +0200
From: =?UTF-8?B?VG9yYmrDuHJu?= <lists@skagestad.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
References: <1502954.OtX3SzjMKZ@merkaba> <53C52AE4.6010803@fb.com> <1984661.CMGGdWA6Ux@merkaba> <1809953.ithLVmijbn@merkaba> <53D11F2B.1070008@fb.com>
In-Reply-To: <53D11F2B.1070008@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2014 04:58 PM, Chris Mason wrote:
> <snip>
> Liu Bo has a promising patch:
>
> https://patchwork.kernel.org/patch/4618421/
>
> Please give it a shot.  There's a second deadlock reading the free space
> cache, I'm still working on that one too.
>
> -chris
I (as expected, my hang was with free space cache) still get hangs with 
this applied on top of 3.16-rc6.
Looking forward to the free space cache patch.

I have not been able to trigger the same hang as I had with 3.15 on any 
of the 3.16-rc6 kernels so far.

--
Torbjørn

