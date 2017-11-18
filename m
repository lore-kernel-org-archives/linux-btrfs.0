Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from internal.daemons-point.com ([83.236.132.110]:48794 "EHLO
        mail.daemons-point.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754055AbdKRJD5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 04:03:57 -0500
Subject: Re: Btrfs progs pre-release 4.14-rc1
To: Nick Terrell <terrelln@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20171114153335.5657-1-dsterba@suse.com>
 <66b53cc9-76bc-2864-1b00-cb4a459e0b4e@daemons-point.com>
 <520341F4-58FE-4A62-BC46-78FA1709A323@fb.com>
From: Uli Heller <uli.heller@daemons-point.com>
Message-ID: <90348c33-efe7-a6b7-ea6b-13082fbe2ffd@daemons-point.com>
Date: Sat, 18 Nov 2017 10:03:58 +0100
MIME-Version: 1.0
In-Reply-To: <520341F4-58FE-4A62-BC46-78FA1709A323@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 17.11.2017 um 21:08 schrieb Nick Terrell:
>> On Nov 17, 2017, at 8:48 AM, Uli Heller <uli.heller@daemons-point.com> wrote:
>>
>> I tried to compile these on ubuntu-14.04 running 4.4.0-98-generic
>> - I had to install libzstd-dev
>> - I had to disable the zstd tests
>>
>> Do you think this ends up in a working binary? Or am I doing something strange?
> You'll need to install libzstd-dev to compile with zstd enabled, since you
> need the libraries and headers. What version of libzstd do you have? You'll
> need a version >= 0.8.1 in order to read the compressed data.

I compiled and installed version 1.3.2. I didn't verify if this version 
is actually working OK.
The tests run during the build for quite some time and I didn't observe 
an error, so I assumed
it ought to be fine.

> On the zstd side, we're working on getting the version of zstd in Ubuntu
> 16.04 upgraded from 0.5.1 to a version >= 1.0.0 [1]. zstd-0.5.1 was
> released before the format stabilized, and can't read data produced by zstd
>> = 0.6.
> I would expect the zstd tests to fail if the zstd version is < 0.8.1.
> Otherwise, could you tell me which version of zstd you have, and I'll
> attempt to reproduce the issue.

OK, so the success of the zstd tests depend on the version of the 
library, not the version
of the kernel, right?

I can offer to send some output of the failing tests if it helps.

Thanks a lot + best regards, Uli
