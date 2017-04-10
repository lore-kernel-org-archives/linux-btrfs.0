Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36167 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbdDJLbu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 07:31:50 -0400
Received: by mail-io0-f175.google.com with SMTP id l7so91028728ioe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 04:31:50 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id i89sm6281026ioo.52.2017.04.10.04.31.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Apr 2017 04:31:48 -0700 (PDT)
Subject: Re: Volume appears full but TB's of space available
To: linux-btrfs@vger.kernel.org
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
 <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
 <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
 <CAJCQCtRyia+r7Qdwwzwoyw+aoxvav86d2HHyKpQkDD6guHp3iA@mail.gmail.com>
 <CAD4AmV68i-nUqzYMxc-QHuDAx8P=K4Jr4JrZdW=vFFyC0PK1+A@mail.gmail.com>
 <d531fd79-c08a-0ba1-ae51-5503bc56b121@gmail.com>
 <pan$2e792$2cb39d1$9f52bd61$285d9133@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <97a26215-464f-290b-c242-ffeff567da3b@gmail.com>
Date: Mon, 10 Apr 2017 07:31:44 -0400
MIME-Version: 1.0
In-Reply-To: <pan$2e792$2cb39d1$9f52bd61$285d9133@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-08 01:12, Duncan wrote:
> Austin S. Hemmelgarn posted on Fri, 07 Apr 2017 07:41:22 -0400 as
> excerpted:
>
>> 2. Results from 'btrfs scrub'.  This is somewhat tricky because scrub is
>> either asynchronous or blocks for a _long_ time.  The simplest option
>> I've found is to fire off an asynchronous scrub to run during down-time,
>> and then schedule recurring checks with 'btrfs scrub status'.  On the
>> plus side, 'btrfs scrub status' already returns non-zero if the scrub
>> found errors.
>
> This is (one place) where my "keep it small enough to be in-practice-
> manageable" comes in.
>
> I always run my scrubs with -B (don't background, always, because I've
> scripted it), and they normally come back within a minute. =:^)
>
> But that's because I'm running multiple btrfs pair-device raid1 on a pair
> of partitioned SSDs, with each independent btrfs built on a partition
> from each ssd, with all partitions under 50 GiB.  So scrubs takes less
> than a minute to run (on the under 1 GiB /var/log, it returns effectively
> immediately, as soon as I hit enter on the command), but that's not
> entirely surprising at the sizes of the ssd-based btrfs' I am running.
>
> When scrubs (and balances, and checks) come back in a minute or so, it
> makes maintenance /so/ much less of a hassle. =:^)
>
> And the generally single-purpose and relatively small size of each
> filesystem means I can, for instance, keep / (with all the system libs,
> bins, manpages, and the installed-package database, among other things)
> mounted read-only by default, and keep the updates partition (gentoo so
> that's the gentoo and overlay trees, the sources and binpkg cache, ccache
> cache, etc) and (large non-ssd/non-btrfs) media partitions unmounted by
> default.
>
> Which in turn means when something /does/ go wrong, as long as it wasn't
> a physical device, there's much less data at risk, because most of it was
> probably either unmounted, or mounted read-only.
>
> Which in turn means I don't have to worry about scrub/check or other
> repair on those filesystems at all, only the ones that were actually
> mounted writable.  And as mentioned, those scrub and check fast enough
> that I can literally wait at the terminal for command completion. =:^)
>
> Of course my setup's what most would call partitioned to the extreme, but
> it does have its advantages, and it works well for me, which after all is
> the important thing for /my/ setup.
Eh, maybe most people who never dealt with disks with capacities on the 
order of triple-digit _megabytes_.  TBH, most of my systems look pretty 
similar, although I split at places that most people think are odd until 
I explain the reasoning (like /var/cache or the RRD storage for 
collectd).  With the exception of the backing storage for the storage 
micro-cluster I have on my home network and the VM storage, all my 
filesystems are 32GB or less (and usually some multiple of 8G), although 
I'm not lucky enough to have a good enough system to run maintenance 
that fast (although part of that might be that I don't heavily 
over-provision space in most of the filesystems, but instead leave a 
reasonable amount of slack-space at the LVM level, so if a filesystem 
gets wedged, I just temporarily resize the LV it's on so I can fix it).
>
> But the more generic point remains, if you setup multi-TB filesystems
> that take days or weeks for a maintenance command to complete, running
> those maintenance commands isn't going to be something done as often as
> one arguably should, and rebuilding from a filesystem or device failure
> is going to take far longer than one would like, as well.  We've seen the
> reports here.  If that's what you're doing, strongly consider breaking
> your filesystems down to something rather more manageable, say a couple
> TiB each.  Broken along natural usage lines, it can save a lot on the
> caffeine and headache pills when something does go wrong.
>
> Unless of course like one poster here, you're handling double-digit-TB
> super-collider data files.  Those tend to be a bit difficult to store on
> sub-double-digit-TB filesystems.  =:^)  But that's the other extreme from
> what I've done here, and he actually has a good /reason/ for /his/
> double-digit- or even triple-digit-TB filesystems.  There's not much to
> be done about his use-case, and indeed, AFAIK he decided btrfs simply
> isn't stable and mature enough for that use-case yet, tho I believe he's
> using it for some other, more minor and less gargantuan use-cases.
Even aside from that, there are cases where you essentially need large 
filesystems.  One good example is NAS usage.  In that case, it's a lot 
simpler to provision one filesystem and then share out subsets of it 
than it is to provision one for each share.  Clustering is another good 
example (the micro-cluster I mentioned above being a good example of 
this, by just using one filesystem for each back-end system, I end up 
saving a very large amount of resources without compromising performance 
(although, the 200GB back-end filesystems are nowhere near the multi-TB 
filesystems that are usually the issue).
