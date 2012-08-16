Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39373 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab2HPPWD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 11:22:03 -0400
Message-ID: <502D100D.2030609@pobox.com>
Date: Thu, 16 Aug 2012 11:21:49 -0400
From: Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
CC: Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
References: <50299142.2030504@oberhumer.com> <20120814123937.GA14756@sig21.net> <502B8FE3.7080501@oberhumer.com> <20120815144539.GA8300@sig21.net> <502C92C3.7090701@oberhumer.com>
In-Reply-To: <502C92C3.7090701@oberhumer.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/16/2012 02:27 AM, Markus F.X.J. Oberhumer wrote:
> On 2012-08-15 16:45, Johannes Stezenbach wrote:
>> On Wed, Aug 15, 2012 at 02:02:43PM +0200, Markus F.X.J. Oberhumer wrote:
>>> On 2012-08-14 14:39, Johannes Stezenbach wrote:
>>>> On Tue, Aug 14, 2012 at 01:44:02AM +0200, Markus F.X.J. Oberhumer wrote:
>>>>> On 2012-07-16 20:30, Markus F.X.J. Oberhumer wrote:
>>>>>>
>>>>>> As stated in the README this version is significantly faster (typically more
>>>>>> than 2 times faster!) than the current version, has been thoroughly tested on
>>>>>> x86_64/i386/powerpc platforms and is intended to get included into the
>>>>>> official Linux 3.6 or 3.7 release.
>>>>>>
>>>>>> I encourage all compression users to test and benchmark this new version,
>>>>>> and I also would ask some official LZO maintainer to convert the updated
>>>>>> source files into a GIT commit and possibly push it to Linus or linux-next.
>>>>
>>>> Sorry for not reporting earlier, but I didn't have time to do real
>>>> benchmarks, just a quick test on ARM926EJ-S using barebox,
>>>> and found in the new version decompression is slower:
>>>> http://lists.infradead.org/pipermail/barebox/2012-July/008268.html
>>>
>>> I can only guess, but maybe your ARM cpu does not have an efficient
>>> implementation of {get,put}_unaligned().
>>
>> Yes, ARMv5 cannot do unaligned access.  ARMv6+ could, but
>> I think the Linux kernel normally traps it for debug,
>> all ARM seem to use generic {get,put}_unaligned() implementation
>> which use byte access and shift.
>
> Hmm - I could imagine that we're wasting a lot of possible speed gain
> by not exploiting that feature on ARMv6+.

Or you could just realize that unaligned accesses are slow in the best 
case, and are simply not supported on some processors.

If you think a little bit, I bet you could come up with a solution that 
operates at cacheline-aligned granularity, something that would be _even 
faster_ than simply fixing the code to do aligned accesses.

	Jeff




