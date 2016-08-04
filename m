Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36689 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322AbcHDWY3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Aug 2016 18:24:29 -0400
Received: by mail-qk0-f171.google.com with SMTP id v123so114640209qkh.3
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Aug 2016 15:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
 <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com> <CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
 <CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com> <CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
From: Martin <rc6encrypted@gmail.com>
Date: Fri, 5 Aug 2016 00:19:10 +0200
Message-ID: <CAGQ70YfvcujVWs-Hr-jLS5DED3ti5XK=fVhx6M8K7c85UVYDhA@mail.gmail.com>
Subject: Re: How to stress test raid6 on 122 disk array
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Excellent. Thanks.

In order to automate it, would it be ok if I dd some zeroes directly
to the devices to corrupt them, or do need to physically take the
disks out while running?

The smallest disk of the 122 is 500GB. Is it possible to have btrfs
see each disk as only e.g. 10GB? That way I can corrupt and resilver
more disks over a month.








On 4 August 2016 at 23:12, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Aug 4, 2016 at 2:51 PM, Martin <rc6encrypted@gmail.com> wrote:
>> Thanks for the benchmark tools and tips on where the issues might be.
>>
>> Is Fedora 24 rawhide preferred over ArchLinux?
>
> I'm not sure what Arch does any differently to their kernels from
> kernel.org kernels. But bugzilla.kernel.org offers a Mainline and
> Fedora drop down for identifying the kernel source tree.
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
>
> And then whatever Austin says.
>
>
>
> --
> Chris Murphy
