Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39111 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaKXG6T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 01:58:19 -0500
Received: by mail-lb0-f174.google.com with SMTP id w7so6816800lbi.5
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Nov 2014 22:58:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cba79e6d37aee8454d5f9672fe2c6545@cs.wisc.edu>
References: <cba79e6d37aee8454d5f9672fe2c6545@cs.wisc.edu>
Date: Mon, 24 Nov 2014 12:28:17 +0530
Message-ID: <CALJfu6OJ=2U5ouWNmj4YwRFoN=C0_hBd8QyxGY=+m48h=-tRfA@mail.gmail.com>
Subject: Re: Help with Btrfs TracePoints and FTrace
From: Rohan Puri <rohan.puri15@gmail.com>
To: ygovind <ygovind@cs.wisc.edu>
Cc: Btrfs Developer List <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 7:03 AM, ygovind <ygovind@cs.wisc.edu> wrote:
> Hi - I have taken minor project on Btrfs file system as my independent study
> and trying to understand data/metadata allocation algorithm used in Btrfs
> file system. I would like to know how can I use Btrfs Tracepoints and Ftrace
> to debug. I was trying to find documents on web but wasn't able to find any
> document which can guide me through step by step process on using Btrfs
> Tracepoints or Ftrace on Btrfs.
>
> All the study so far is happening on a laptop with virtual box Ubuntu. I
> have downloaded latest kernel and trying to understand the flow by putting
> printk statements and compiling that module. In this setup - if you can
> guide me through the process of setting up tracepoints or Ftrace - that will
> really help me. Also, if you have any other suggestions on understanding
> allocation algorithms for data/metadata - I am open to learn.
>
> Best Regards,
> Yash
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Yash,

Go through the design documents available online. btrfs makes use of
COW B-tree. You can get some papers related to this. For tracing, you
can also make use of systemtap.

- Rohan
