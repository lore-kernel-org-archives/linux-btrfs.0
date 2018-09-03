Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6279 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727243AbeICHXO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 03:23:14 -0400
Subject: Re: bug: btrfs-progs scrub -R flag doesn't show per device stats
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQv6RyGsK69451xu3pA_2pVPLkektT9rCVAtDL6VXwgGQ@mail.gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <5c0adacf-2b76-05b0-d5ca-eef5d4a8b428@cn.fujitsu.com>
Date: Mon, 3 Sep 2018 11:11:52 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQv6RyGsK69451xu3pA_2pVPLkektT9rCVAtDL6VXwgGQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/01/2018 02:43 AM, Chris Murphy wrote:
> btrfs-progs v4.17.1
> 
> man btrfs-scrub:
> 
>             -R
>                 print raw statistics per-device instead of a summary
> 
> 
> However, on a two device Btrfs volume, -R does not show per device
> statistics. See screenshot:
> 
> https://drive.google.com/open?id=1xmt_NHGlNJPc8I0F4_OZxgGe9b3quCnD
> 
> Additionally, the description of -d and -R doesn't help me distinquish
> between the two. -R says "instead of a summary" so that suggests -d
> will summarize but isn't explicitly stated.
> 
The description of '-R' is incorrect, it shoudle be 'raw print mode, 
print full data instead of summary'.
The option '-d' do print separate statistics for each device indded,
not the '-R'.

A patch has been sent(forgot to CC you).

Thanks,
Su
> 
> 
