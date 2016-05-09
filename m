Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36287 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbcEISWK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 May 2016 14:22:10 -0400
Received: by mail-io0-f172.google.com with SMTP id u185so210036221iod.3
        for <linux-btrfs@vger.kernel.org>; Mon, 09 May 2016 11:22:09 -0700 (PDT)
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram
 and disk are ok. it still mounts, but I cannot repair
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>
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
Cc: linux-btrfs@vger.kernel.org, Clemens Eisserer <linuxhippy@gmail.com>,
        Patrik Lundquist <patrik.lundquist@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4aa3dda7-70d6-5dcf-2fa7-4f2b509e4a1e@gmail.com>
Date: Mon, 9 May 2016 14:21:57 -0400
MIME-Version: 1.0
In-Reply-To: <20160509162940.GC15597@hungrycats.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-09 12:29, Zygo Blaxell wrote:
> On Mon, May 09, 2016 at 04:53:13PM +0200, Niccolò Belli wrote:
>> While trying to find a common denominator for my issue I did lots of backups
>> of /dev/mapper/cryptroot and I restored them into /dev/mapper/cryptroot
>> dozens of times (triggering a 150GB+ random data write every time), without
>> any issue (after restoring the backup I alwyas check the parition with btrfs
>> check). So disk doesn't seem to be the culprit.
>
> Did you also check the data matches the backup?  btrfs check will only
> look at the metadata, which is 0.1% of what you've copied.  From what
> you've written, there should be a lot of errors in the data too.  If you
> have incorrect data but btrfs scrub finds no incorrect checksums, then
> your storage layer is probably fine and we have to look at CPU, host RAM,
> and software as possible culprits.
This is a good point.
>
> The logs you've posted so far indicate that bad metadata (e.g. negative
> item lengths, nonsense transids in metadata references but sane transids
> in the referred pages) is getting into otherwise valid and well-formed
> btrfs metadata pages.  Since these pages are protected by checksums,
> the corruption can't be originating in the storage layer--if it was, the
> pages should be rejected as they are read from disk, before btrfs even
> looks at them, and the insane transid should be the "found" one not the
> "expected" one.  That suggests there is either RAM corruption happening
> _after_ the data is read from disk (i.e. while the pages are cached in
> RAM), or a severe software bug in the kernel you're running.
>
> Try different kernel versions (e.g. 4.4.9 or 4.1.23) in case whoever
> maintains your kernel had a bad day and merged a patch they should
> not have.
>
> Try a minimal configuration with as few drivers as possible loaded,
> especially GPU drivers and anything from the staging subdirectory--when
> these drivers have bugs, they ruin everything.
>
> Try memtest86+ which has a few more/different tests than memtest86.
> I have encountered RAM modules that pass memtest86 but fail memtest86+
> and vice versa.
>
> Try memtester, a memory tester that runs as a Linux process, so it can
> detect corruption caused when device drivers spray data randomly into RAM,
> or when the CPU thermal controls are influenced by Linux (an overheating
> CPU-to-RAM bridge can really ruin your day, and some of the dumber laptop
> designs rely on the OS for thermal management).
>
> Try running more than one memory testing process, in case there is a bug
> in your hardware that affects interactions between multiple cores (memtest
> is single-threaded).  You can run memtest86 inside a kvm (e.g. kvm
> -m 3072 -kernel /boot/memtest86.bin) to detect these kinds of issues.
>
> Kernel compiles are a bad way to test RAM.  I've successfully built
> kernels on hosts with known RAM failures.  The kernels don't always work
> properly, but it's quite rare to see a build fail outright.
My original suggestion that prompted that part of the comment was to run 
a bunch of concurrent kernel builds (I only use kernel builds myself 
because it's a big project with essentially zero build dependencies, if 
I had the patience and space (and a LiveCD with the right tools and 
packages installed), I'd probably be using something like LibreOffice or 
Chromium instead), each run with as many jobs as CPU's (so on a 
quad-core system, run a dozen or so concurrently with make -j4).  I 
don't use this as my sole test (I also use multiple other tools), but I 
find that this does a particularly good job of exercising things that 
memtest doesn't, and I don't just make sure the build's succeed, but 
also that the compiled kernel images all match, because if there's bad 
RAM, the resultant images will often be different in some way (and I had 
forgotten to mention this bit).

This practice evolved out of the fact that the only bad RAM I've ever 
dealt with either completely failed to POST (which can have all kinds of 
interesting symptoms if it's just one module, some MB's refuse to boot, 
some report the error, others just disable the module and act like 
nothing happened), or passed all the memory testing tools I threw at it 
(memtest86, memtest86+, memtester, concurrent memtest86 invocations from 
Xen domains, inventive acrobatics with tmpfs and FIO, etc), but failed 
under heavy concurrent random access, which can be reliably produced by 
running a bunch of big software builds at the same time with the CPU 
insanely over-committed.  I could probably produce a similar workload 
with tmpfs and FIO, but it's a lot quicker and easier to remember how to 
do a kernel build than it is to remember the complex incantations needed 
to get FIO to do anything interesting.
