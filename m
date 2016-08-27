Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34679 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbcH0HQx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Aug 2016 03:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <20160827005656.GA8439@vader.DHCP.thefacebook.com>
References: <cover.1468538030.git.osandov@fb.com> <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com>
 <20160718223104.GA6681@vader.DHCP.thefacebook.com> <2544227.upOtQjWuiQ@localhost.localdomain>
 <83e50f77-ae10-4c8d-4a03-3c9af298d9c7@fb.com> <20160818203327.GA7696@vader.DHCP.thefacebook.com>
 <CADxRZqwHPVTdiKQa89Y0gbBWS-UMWwYzqLSnBNRhx9U33iSdKw@mail.gmail.com> <20160827005656.GA8439@vader.DHCP.thefacebook.com>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Sat, 27 Aug 2016 10:16:25 +0300
Message-ID: <CADxRZqxUavad99jMQhftFzzpjnz4cC93m2jBwk=Fe5+H7wAdFA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 27, 2016 at 3:56 AM, Omar Sandoval <osandov@osandov.com> wrote:
> On Fri, Aug 26, 2016 at 02:06:29PM +0300, Anatoly Pugachev wrote:
>>
>> I can't load btrfs module with this patch applied to 4.8.0-rc3+ (git
>> v4.8-rc3-39-g61c0457)
>> on "modprobe btrfs" i'm getting the following in the logs and module
>> does not load:
>>
>> Btrfs loaded, crc32c=crc32c-generic, debug=on, assert=on
>> BTRFS: selftest: sectorsize: 8192  nodesize: 8192
>> BTRFS: selftest: Running btrfs free space cache tests
>> BTRFS: selftest: Running extent only tests
>> BTRFS: selftest: Running bitmap only tests
>> BTRFS: selftest: Running bitmap and extent tests
>> BTRFS: selftest: Running space stealing from bitmap to extent
>> BTRFS: selftest: Free space cache tests finished
>> BTRFS: selftest: Running extent buffer operation tests
>> BTRFS: selftest: Running btrfs_split_item tests
>> BTRFS: selftest: Running extent I/O tests
>> BTRFS: selftest: Running find delalloc tests
>> BTRFS: selftest: Running extent buffer bitmap tests
>> BTRFS: selftest: Setting straddling pages failed
>> BTRFS: selftest: Extent I/O tests finished
>
> Is this with the whole patchset + this patch? You still need the patch
> set for this to actually work, the extra patch is just some extra
> checks.

Omar,

sorry, I don't get what do you mean by the whole patchset ? I used git
kernel (git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git)
and applied patch from your mail from August 18,
https://www.spinics.net/lists/linux-btrfs/msg58023.html

Tell me what patches do I need or point to btrfs git repo with all
patches included and I'll test it.

Thanks.
