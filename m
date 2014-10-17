Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46533 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaJQE0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 00:26:25 -0400
Received: by mail-pa0-f51.google.com with SMTP id lj1so61724pab.10
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Oct 2014 21:26:25 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Problems running Balance and checking integrity concurrently.
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <543FE8D4.2040804@giantdisaster.de>
Date: Fri, 17 Oct 2014 12:26:12 +0800
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <186E3C3A-40EC-462A-91AE-8586E7C2D137@gmail.com>
References: <5BE1151D-599F-4FD4-BD6B-AC707C72CEC4@gmail.com> <543FE8D4.2040804@giantdisaster.de>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Stefan Behrens,

Thanks very much for your attention!

More stress tests will be followed and will
give you feedbacks when finished.


> On Fri, 10 Oct 2014 21:35:02 +0800, Wang Shilong wrote:
>> Hello£¬
>> 
>> I have reproduced a problem with Btrfs integrity and balance using latest
>> btrfs kernel,it is very easy to reproduce:
>> 
>> With mount option ¡°check_int¡±, and run xfstests/btrfs/ tests, below test could definitely
>> reproduce problem:
>> 
>> ./check tests/btrfs/014
> 
> The following two patches fix the issue.
> 
> 

Best Regards,
Wang Shilong

