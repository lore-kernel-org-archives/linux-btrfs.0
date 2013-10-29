Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:44075 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab3J2DYK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Oct 2013 23:24:10 -0400
Received: by mail-pa0-f42.google.com with SMTP id kp14so6285099pab.15
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Oct 2013 20:24:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9c53ka-otf.ln1@hurikhan77.spdns.de>
References: <9c53ka-otf.ln1@hurikhan77.spdns.de>
Date: Mon, 28 Oct 2013 23:24:10 -0400
Message-ID: <CALJXSJr0sjzFwCT=w1WdDX+-CWS-CjDhYBArVpvTeUNBM88Mdw@mail.gmail.com>
Subject: Re: memory leak in <=3.11.6
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 28, 2013 at 6:34 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
>
> If I close all my desktop programs, my system stays at +12 GB RAM usage
> while after a fresh boot it has 12+ GB free (of 16 GB). Cache stays low at 2
> GB while after a few minutes uptime cache is about 5 GB.

I probably have the same problem over here, after about 2 weeks of
random read/write it seems my memory and swap get almost full and even
after killing all process and getting in single user mode, memory
won't free up.  Would you happen to have quota enabled too? Kernel is
3.11.4
