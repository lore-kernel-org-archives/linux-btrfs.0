Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [193.170.194.20] ([193.170.194.20]:41925 "EHLO mail.servus.at"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753347Ab2HPG1y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 02:27:54 -0400
Message-ID: <502C92C3.7090701@oberhumer.com>
Date: Thu, 16 Aug 2012 08:27:15 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
References: <50299142.2030504@oberhumer.com> <20120814123937.GA14756@sig21.net> <502B8FE3.7080501@oberhumer.com> <20120815144539.GA8300@sig21.net>
In-Reply-To: <20120815144539.GA8300@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-08-15 16:45, Johannes Stezenbach wrote:
> On Wed, Aug 15, 2012 at 02:02:43PM +0200, Markus F.X.J. Oberhumer wrote:
>> On 2012-08-14 14:39, Johannes Stezenbach wrote:
>>> On Tue, Aug 14, 2012 at 01:44:02AM +0200, Markus F.X.J. Oberhumer wrote:
>>>> On 2012-07-16 20:30, Markus F.X.J. Oberhumer wrote:
>>>>>
>>>>> As stated in the README this version is significantly faster (typically more
>>>>> than 2 times faster!) than the current version, has been thoroughly tested on
>>>>> x86_64/i386/powerpc platforms and is intended to get included into the
>>>>> official Linux 3.6 or 3.7 release.
>>>>>
>>>>> I encourage all compression users to test and benchmark this new version,
>>>>> and I also would ask some official LZO maintainer to convert the updated
>>>>> source files into a GIT commit and possibly push it to Linus or linux-next.
>>>
>>> Sorry for not reporting earlier, but I didn't have time to do real
>>> benchmarks, just a quick test on ARM926EJ-S using barebox,
>>> and found in the new version decompression is slower:
>>> http://lists.infradead.org/pipermail/barebox/2012-July/008268.html
>>
>> I can only guess, but maybe your ARM cpu does not have an efficient
>> implementation of {get,put}_unaligned().
> 
> Yes, ARMv5 cannot do unaligned access.  ARMv6+ could, but
> I think the Linux kernel normally traps it for debug,
> all ARM seem to use generic {get,put}_unaligned() implementation
> which use byte access and shift.

Hmm - I could imagine that we're wasting a lot of possible speed gain
by not exploiting that feature on ARMv6+.

>> Could you please try the following patch and test if you can see
>> any significant speed difference?
> 
> It isn't.  I made the attached quick hack userspace code
> using ARM kernel headers and barebox unlzop code.
> (new == your new code, old == linux-3.5 git, test == new + your suggested change)
> (sorry I had no time to clean it up)

My suggested COPY4 replacement probably has a lot of load stalls - maybe some
ARM expert could have a look and suggest a more efficient implementation.

In any case, I still would like to see the new code in linux-next because
of the huge improvements on other modern CPUs.

Cheers,
Markus

> 
> I compressed a Linux Image with lzop (lzop <arch/arm/boot/Image >lzoimage)
> and timed uncompression:
> 
> # time ./unlzopold <lzoimage >/dev/null
> real    0m 0.29s
> user    0m 0.19s
> sys     0m 0.10s
> # time ./unlzopold <lzoimage >/dev/null
> real    0m 0.29s
> user    0m 0.20s
> sys     0m 0.09s
> # time ./unlzopnew <lzoimage >/dev/null
> real    0m 0.41s
> user    0m 0.30s
> sys     0m 0.10s
> # time ./unlzopnew <lzoimage >/dev/null
> real    0m 0.40s
> user    0m 0.30s
> sys     0m 0.10s
> # time ./unlzopnew <lzoimage >/dev/null
> real    0m 0.40s
> user    0m 0.29s
> sys     0m 0.11s
> # time ./unlzoptest <lzoimage >/dev/null
> real    0m 0.39s
> user    0m 0.28s
> sys     0m 0.11s
> # time ./unlzoptest <lzoimage >/dev/null
> real    0m 0.39s
> user    0m 0.27s
> sys     0m 0.11s
> # time ./unlzoptest <lzoimage >/dev/null
> real    0m 0.39s
> user    0m 0.27s
> sys     0m 0.11s
> 
> FWIW I also checked the sha1sum to confirm the Image uncompressed OK.
> 
> 
> Johannes

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
