Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:58142 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbcEITXL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 May 2016 15:23:11 -0400
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>,
        linux-btrfs@vger.kernel.org
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
Cc: Clemens Eisserer <linuxhippy@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5730E39B.7000403@bouton.name>
Date: Mon, 9 May 2016 21:23:07 +0200
MIME-Version: 1.0
In-Reply-To: <52f0c710-d695-443d-b6d5-266e3db634f8@linuxsystems.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 09/05/2016 16:53, Niccolò Belli a écrit :
> On domenica 8 maggio 2016 20:27:55 CEST, Patrik Lundquist wrote:
>> Are you using any power management tweaks?
>
> Yes, as stated in my very first post I use TLP with
> SATA_LINKPWR_ON_BAT=max_performance, but I managed to reproduce the
> bug even without TLP. Also in the past week I've alwyas been on AC.
>
> On lunedì 9 maggio 2016 13:52:16 CEST, Austin S. Hemmelgarn wrote:
>> Memtest doesn't replicate typical usage patterns very well.  My usual
>> testing for RAM involves not just memtest, but also booting into a
>> LiveCD (usually SystemRescueCD), pulling down a copy of the kernel
>> source, and then running as many concurrent kernel builds as cores,
>> each with as many make jobs as cores (so if you've got a quad core
>> CPU (or a dual core with hyperthreading), it would be running 4
>> builds with -j4 passed to make).  GCC seems to have memory usage
>> patterns that reliably trigger memory errors that aren't caught by
>> memtest, so this generally gives good results.
>
> Building kernel with 4 concurrent threads is not an issue for my
> system, in fact I do compile a lot and I never had any issue.

Note : I once had a server which would pass memtest86 and repeated
kernel compilations maxing out the CPU threads but couldn't at the same
time reliably compile a kernel and copy large amounts of data.
I think I lost my little automated test suite (I should definitely look
for it again or code it from scratch) but what I did on new servers
since that time was :

1/ create a file larger than the system's RAM (this makes sure you will
read and write all data from disk and not only caches and might catch
controller hardware problems too) with dd if=/dev/urandom (several
gigabytes of random data exercise many different patterns, far more than
what memtest86 would test), compute its md5 checksum
2/ launch a subprocess repeatedly compiling the kernel with more jobs
than available CPU threads and stopping as soon as the make exit code
was != 0.
3/ launch another subprocess repeatedly copying the random file to
another location and exiting when the md5 checksum didn't match the source.

Let it run as a burn-in test for as long as you can afford (from
experience after 24 hours if it's still running the probability that the
test will find a problem becomes negligible).
If one of the subprocess stopped by itself your hardware is not stable.

This actually caught a few unstable systems before it could go into
production for me.

Lionel
