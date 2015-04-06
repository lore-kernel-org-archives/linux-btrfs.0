Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36060 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbbDFSYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 14:24:52 -0400
Received: by wizk4 with SMTP id k4so38961761wiz.1
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 11:24:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6qZ4OmxGdmUimqGAHR67Tt2ty41ZmNsFNX5NXSEibQSA@mail.gmail.com>
References: <CAKgsxVRfn8v3ubrwonm-UXgBRg7Mz=90_DSOwzpeyVTTP-JQ8g@mail.gmail.com>
	<CAL3q7H6qZ4OmxGdmUimqGAHR67Tt2ty41ZmNsFNX5NXSEibQSA@mail.gmail.com>
Date: Mon, 6 Apr 2015 11:24:50 -0700
Message-ID: <CAKgsxVSTYjH8SDgLRgQys5-GF3DqqRd0W-f=925NZ2GoyU5BbA@mail.gmail.com>
Subject: Re: Btrfs ENOSPC issue
From: Justin Maggard <jmaggard10@gmail.com>
To: fdmanana@gmail.com
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 4, 2015 at 4:33 AM, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Sat, Apr 4, 2015 at 12:36 AM, Justin Maggard <jmaggard10@gmail.com> wrote:
>> Hi,
>>
>> We're hitting a consistently reproducible ENOSPC condition with a
>> simple test case:
>>
>> # truncate -s 1T btrfs.fs
>> # mkfs.btrfs btrfs.fs
>> # mount btrfs.fs /mnt/
>> # fallocate -l 1021G /mnt/fallocate
>> # btrfs fi sync /mnt/
>> # dd if=/dev/zero of=/mnt/dd bs=1G
>> # btrfs fi sync /mnt/
>> # rm /mnt/fallocate
>> # btrfs fi sync /mnt/
>> # fallocate -l 20G /mnt/fallocate
>> fallocate: /mnt/fallocate: fallocate failed: No space left on device
>>
>> I continue to get ENOSPC even after unmount / mount.
>>
>> Here we have 1022GB free as reported by df, yet we can't allocate
>> 20GB.  I tried the integration-4.1 tree, which had the same results.
>> I also added Zhao Lei's ENOSPC most recent patchset from today, but it
>> didn't seem to help.
>
> Have you tried too the following patch (not in any release nor rc)?
>
> https://patchwork.kernel.org/patch/5800231/
>

No, I hadn't; thanks for the pointer!  That patch does indeed make my
test case work.

-Justin
