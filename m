Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:37183 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab3JRT6t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 15:58:49 -0400
Received: by mail-qa0-f54.google.com with SMTP id j15so1017800qaq.13
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 12:58:48 -0700 (PDT)
Message-ID: <1382126306.29286.129.camel@hp-a6734f>
Subject: Re: dmesg filled with btrfs messages
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Chester <somethingsome2000@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Fri, 18 Oct 2013 15:58:26 -0400
In-Reply-To: <CAAE6i0ibfsMT5ynHMVm_uxNze6bapeL4kmhVba5Tf-em2_V2nQ@mail.gmail.com>
References: <CAAE6i0ibfsMT5ynHMVm_uxNze6bapeL4kmhVba5Tf-em2_V2nQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2013-10-17 at 15:54 -0500, Chester wrote:
> ---------- Forwarded message ----------
> From: Chester <somethingsome2000@gmail.com>
> Date: Thu, Oct 17, 2013 at 3:51 PM
> Subject: dmesg filled with btrfs messages
> To: linux-btrfs <linux-btrfs@vger.kernel.org>
> 
> 
> It's what looks like the same message repeated over and over again.
> Here's my dmesg: Pasted below is an excerpt. The full netconsole log
> is on pastebin http://pastebin.com/4dQGCL9U

> [    0.000000] Linux version 3.11.0 (root@NaviLaptop) (gcc version
> 4.6.4 (Funtoo 4.6.4-r2) ) #1 SMP Thu Oct 17 08:33:08 CDT 2013

Unfortunately, the 3.11.0 kernel shipped with some outstanding bugs in
btrfs; the fixes were merged into the 3.12-rc kernels and the stable
kernel 3.11.5 or later.

Please upgrade your kernel to 3.11.5 or later!

-- 
Calvin Walton <calvin.walton@kepstin.ca>

