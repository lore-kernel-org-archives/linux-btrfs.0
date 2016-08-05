Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:35951 "EHLO
	mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbcHELjk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 07:39:40 -0400
Received: by mail-it0-f42.google.com with SMTP id x130so19627577ite.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Aug 2016 04:39:40 -0700 (PDT)
Subject: Re: How to stress test raid6 on 122 disk array
To: Chris Murphy <lists@colorremedies.com>, Martin <rc6encrypted@gmail.com>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com>
 <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
 <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
 <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a119738d-942b-4dca-265e-5f9db15e2893@gmail.com>
Date: Fri, 5 Aug 2016 07:39:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-04 17:12, Chris Murphy wrote:
> On Thu, Aug 4, 2016 at 2:51 PM, Martin <rc6encrypted@gmail.com> wrote:
>> Thanks for the benchmark tools and tips on where the issues might be.
>>
>> Is Fedora 24 rawhide preferred over ArchLinux?
>
> I'm not sure what Arch does any differently to their kernels from
> kernel.org kernels. But bugzilla.kernel.org offers a Mainline and
> Fedora drop down for identifying the kernel source tree.
IIRC, they're pretty close to mainline kernels.  I don't think they have 
any patches in the filesystem or block layer code at least, but I may be 
wrong, it's been a long time since I looked at an Arch kernel.
>
>>
>> If I want to compile a mainline kernel. Are there anything I need to tune?
>
> Fedora kernels do not have these options set.
>
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> # CONFIG_BTRFS_DEBUG is not set
> # CONFIG_BTRFS_ASSERT is not set
>
> The sanity and integrity tests are both compile time and mount time
> options, i.e. it has to be compiled enabled for the mount option to do
> anything. I can't recall any thread where a developer asked a user to
> set any of these options for testing though.
FWIW, I actually have the integrity checking code built in on most 
kernels I build.  I don't often use it, but it has near zero overhead 
when not enabled, and it's helped me track down lower-level storage 
configuration issues on occasion.
>
>
>> When I do the tests, how do I log the info you would like to see, if I
>> find a bug?
>
> bugzilla.kernel.org for tracking, and then reference the URL for the
> bug with a summary in an email to list is how I usually do it. The
> main thing is going to be the exact reproduce steps. It's also better,
> I think, to have complete dmesg (or journalctl -k) attached to the bug
> report because not all problems are directly related to Btrfs, they
> can have contributing factors elsewhere. And various MTAs, or more
> commonly MUAs, have a tendancy to wrap such wide text as found in
> kernel or journald messages.
Aside from kernel messages, the other general stuff you want to have is:
1. Kernel version and userspace tools version (`uname -a` and `btrfs 
--version`)
2. Any underlying storage configuration if it's not just plain a SSD/HDD 
or partitions (for example, usage of dm-crypt, LVM, mdadm, and similar 
things).
3. Output from `btrfs filesystem show` (this can be trimmed to the 
filesystem that's having the issue).
4. If you can still mount the filesystem, `btrfs filesystem df` output 
can be helpful.
5. If you can't mount the filesystem, output from `btrfs check` run 
without any options will usually be asked for.

