Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oln040092069033.outbound.protection.outlook.com ([40.92.69.33]:39328
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750752AbdLWL4V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 06:56:21 -0500
From: Alberto Bursi <alberto.bursi@outlook.it>
To: James Courtier-Dutton <james.dutton@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs balance problems
Date: Sat, 23 Dec 2017 11:56:19 +0000
Message-ID: <VI1PR08MB03368FD615EFAF0C3BB6195B92030@VI1PR08MB0336.eurprd08.prod.outlook.com>
References: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
In-Reply-To: <CAAMvbhEL4gw29ttxN9xbey3YFwUpmeYht2_m4rPFn9F3fn1rqQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/23/2017 12:19 PM, James Courtier-Dutton wrote:
> Hi,
>
> During a btrfs balance, the process hogs all CPU.
> Or, to be exact, any other program that wishes to use the SSD during a
> btrfs balance is blocked for long periods. Long periods being more
> than 5 seconds.
> Is there any way to multiplex SSD access while btrfs balance is
> operating, so that other applications can still access the SSD with
> relatively low latency?
>
> My guess is that btrfs is doing a transaction with a large number of
> SSD blocks at a time, and thus blocking other applications.
>
> This makes for atrocious user interactivity as well as applications
> failing because they cannot access the disk in a relatively low latent
> manner.
> For, example, this is causing a High Definition network CCTV
> application to fail.
>
> What I would really like, is for some way to limit SSD bandwidths to
> applications.
> For example the CCTV app always gets the bandwidth it needs, and all
> other applications can still access the SSD, but are rate limited.
> This would fix my particular problem.
> We have rate limiting for network applications, why not disk access also?
>
> Kind Regards
>
> James
>

On most I/O intensive programs in Linux you can use "ionice" tool to 
change the disk access priority of a process. [1]
This allows me to run I/O intensive background scripts in servers 
without the users noticing slowdowns or lagging, of course this means 
the process doing heavy I/O will run more slowly or get outright paused 
if higher-priority processes need a lot of access to the disk.

It works on btrfs balance too, see (commandline example) [2].

If you don't start the process with ionice as in [2], you can always 
change the priority later if you get the get the process ID. I use iotop 
[3], which also supports commandline arguments to integrate its output 
in scripts.

For btrfs scrub it seems to be possible to specify the ionice options 
directly, while btrfs balance does not seem to have them (would be nice 
to add them imho). [4]

For the sake of completeness, there is also "nice" tool for CPU usage 
priority (also used in my scripts on servers to keep the scripts from 
hogging the CPU for what is just a background process, and seen in [2] 
commandline too). [5]

1. http://man7.org/linux/man-pages/man1/ionice.1.html
2. 
https://unix.stackexchange.com/questions/390480/nice-and-ionice-which-one-should-come-first
3. http://man7.org/linux/man-pages/man8/iotop.8.html
4. https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-scrub
5. http://man7.org/linux/man-pages/man1/nice.1.html

-Alberto
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
