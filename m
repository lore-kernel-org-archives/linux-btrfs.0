Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36611 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbcEMVyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 17:54:01 -0400
Received: by mail-oi0-f68.google.com with SMTP id i2so19757551oib.3
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 14:54:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <218bfc1b-a136-45cf-b5d0-8d4c5937efbf@linuxsystems.it>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
	<CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
	<c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
	<20160505174854.GA1012@vader.dhcp.thefacebook.com>
	<585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
	<2cd5aca36f853f3c9cf1d46c2f133aa3@linuxsystems.it>
	<CAFvQSYTQ1yZqPYyv0dmd+JuHRWfKm-RtZLdbKXQeHiWMthnyLw@mail.gmail.com>
	<f1dd07efb34a0a110f62566979530944@linuxsystems.it>
	<799cf552-4612-56c5-b44d-59458119e2b0@gmail.com>
	<52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
	<20160509162940.GC15597@hungrycats.org>
	<c5fa6a35-f6bd-4546-8297-7f6225696157@linuxsystems.it>
	<a3a4e412-221d-c12b-284b-af53e4738211@gmail.com>
	<ef2e08cf-587c-4569-9600-9ad7bc45aab2@linuxsystems.it>
	<994b4fa5-c7ef-27e1-2fc2-386ab62a16c0@gmail.com>
	<218bfc1b-a136-45cf-b5d0-8d4c5937efbf@linuxsystems.it>
Date: Fri, 13 May 2016 15:54:00 -0600
Message-ID: <CAJCQCtSkg6p0+ez8_Wo8EWuM91V_td82JHU9bWng_e20fiVvaw@mail.gmail.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Clemens Eisserer <linuxhippy@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Duncan <1i5t5.duncan@cox.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2016 at 6:10 AM, Niccolò Belli
<darkbasic@linuxsystems.it> wrote:
> On venerdì 13 maggio 2016 13:35:01 CEST, Austin S. Hemmelgarn wrote:
>>
>> The fact that you're getting an OOPS involving core kernel threads
>> (kswapd) is a pretty good indication that either there's a bug elsewhere in
>> the kernel, or that something is wrong with your hardware.  it's really
>> difficult to be certain if you don't have a reliable test case though.
>
>
> Talking about reliable test cases, I forgot to say that I definitely found
> an interesting one. It doesn't lead to OOPS but perhaps something even more
> interesting. While running countless stress tests I tried running some games
> to stress the system in different ways. I chosed openmw (an open source
> engine for Morrowind) and I played it for a while on my second external
> monitor (while I watched at some monitoring tools on my first monitor). I
> noticed that after playing a while I *always* lose internet connection (I
> use an USB3 Gigabit Ethernet adapter). This isn't the only thing which
> happens: even if the game keeps running flawlessly and the system *seems* to
> work fine (I can drag windows, open the terminal...) lots of commands simply
> stall (for example mounting a partition, unmounting it, rebooting...). I can
> reliably reproduce it, it ALWAYS happens.

Well there are a bunch of kernel debug options. If your kernel has
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB=y at compile time you can boot with boot parameter
slub_debug=1 to enable it and maybe there'll be something more
revealing about the problems you're having. More aggressive is
CONFIG_DEBUG_PAGEALLOC=y but it'll slow things down quite noticeably.

And then there's some Btrfs debug options for compile time, and are
enabled with mount options. But I think the problem you're having
isn't specific to Btrfs or someone else would have run into it.




-- 
Chris Murphy
