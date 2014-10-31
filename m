Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48204 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaJaVEN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 17:04:13 -0400
Received: by mail-wg0-f49.google.com with SMTP id x13so7337710wgg.36
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Oct 2014 14:04:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0e571e9dd17e1e98b7b5e4573f5144e3@cs.wisc.edu>
References: <0e571e9dd17e1e98b7b5e4573f5144e3@cs.wisc.edu>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 1 Nov 2014 00:03:31 +0300
Message-ID: <CAGqmi77xYx=_oRZSDcDwq_N211fFWRR6k-oED07JRZY+genmFQ@mail.gmail.com>
Subject: Re: Compile BtrFS as kernel module
To: Nishant Agrawal <nragrawal@cs.wisc.edu>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-10-31 22:23 GMT+03:00 Nishant Agrawal <nragrawal@cs.wisc.edu>:
> Hi,
>
> I want to compile btrfs as kernel module with special debug prints. Can
> anyone help me with the instructions to do that?
>
> I tried to do online search but I couldn't find anything.
>
> Regards,
> Nishant
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hm.. http://www.cyberciti.biz/tips/compiling-linux-kernel-module.html

You must can compile and configure vanilla kernel first and only after
you can do experiments with kernel development.
As i know btrfs have special fields in kernel config for debugging.

-- 
Have a nice day,
Timofey.
