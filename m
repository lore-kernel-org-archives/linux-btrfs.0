From: Wout Mertens <wmertens@cisco.com>
Subject: Re: Interesting problem with write data.
Date: Thu, 18 Nov 2010 11:36:34 +0100
Message-ID: <70DF2C9D-0157-4FCB-B1AF-8A84E017249C@cisco.com>
References: <AANLkTinTtvN6T6Ykjs6-UzHi3XYgimM92Pa5wSPrF3sZ@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Magicloud Magiclouds <magicloud.magiclouds@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinTtvN6T6Ykjs6-UzHi3XYgimM92Pa5wSPrF3sZ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I think test 2 actually makes dd allocate 1GB of memory and then write it to disk. So if you don't have 1GB free you may be testing your swap.

Also, what kernel/btrfs version are you using? In what situations are you experiencing slowness?

Wout.

On Nov 18, 2010, at 7:19 , Magicloud Magiclouds wrote:

> Hi,
>  Recently, I made a btrfs to use. And I met slowness problem. Trying
> to diag it. I found this:
> 1. dd if=/dev/zero of=test count=1024 bs=1MB
> This is fast, at about 25MB/s, and reasonable iowait.
> 2. dd if=/dev/zero of=test count=1 bs=1GB
> This is pretty slow, at about 1.5MB/s, and 90%+ iowait, constantly.
>  May I know why it works like this? Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

