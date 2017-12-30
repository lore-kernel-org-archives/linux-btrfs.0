Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:57268 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbdL3V3u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Dec 2017 16:29:50 -0500
Date: Sun, 31 Dec 2017 00:29:11 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V3] Btrfs: enchanse raid1/10 balance heuristic
Message-ID: <20171231002902.70599c8d@demfloro.ru>
In-Reply-To: <20171230203204.13151-1-nefelim4ag@gmail.com>
References: <20171230203204.13151-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 30 Dec 2017 23:32:04 +0300
Timofey Titovets <nefelim4ag@gmail.com> wrote:

> Currently btrfs raid1/10 balancer balance requests to mirrors,
> based on pid % num of mirrors.
> 
> Make logic understood:
>  - if one of underline devices are non rotational
>  - Queue leght to underline devices
> 
> By default try use pid % num_mirrors guessing, but:
>  - If one of mirrors are non rotational, repick optimal to it
>  - If underline mirror have less queue leght then optimal,
>    repick to that mirror
> 
> For avoid round-robin request balancing,
> lets round down queue leght:
>  - By 8 for rotational devs
>  - By 2 for all non rotational devs
> 
> Changes:
>   v1 -> v2:
>     - Use helper part_in_flight() from genhd.c
>       to get queue lenght
>     - Move guess code to guess_optimal()
>     - Change balancer logic, try use pid % mirror by default
>       Make balancing on spinning rust if one of underline devices
>       are overloaded
>   v2 -> v3:
>     - Fix arg for RAID10 - use sub_stripes, instead of num_stripes
> 
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>

Reviewed-by: Dmitrii Tcvetkov <demfloro@demfloro.ru>


