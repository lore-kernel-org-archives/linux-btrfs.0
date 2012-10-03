Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56263 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2JCKsr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 06:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <506C14BA.70006@oberhumer.com>
References: <5033A78E.3080703@oberhumer.com>
	<506C14BA.70006@oberhumer.com>
Date: Wed, 3 Oct 2012 12:48:46 +0200
Message-ID: <CAFLxGvw3OqOb0UVhjtwC+CD+wtubH-O1FM7=fYFT8ztWPVPd6w@mail.gmail.com>
Subject: Re: [GIT PULL v2] Update LZO compression
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Johannes Stezenbach <js@sig21.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CC'in akpm.

On Wed, Oct 3, 2012 at 12:34 PM, Markus F.X.J. Oberhumer
<markus@oberhumer.com> wrote:
> Hi all,
>
> is there some official maintainer who feels responsible for
> pushing the LZO update to Linus?
>
> Otherwise I also could issue a pull-request on github, but somehow I
> don't think that this is the preferred workflow.
>
> Cheers,
> Markus
>
> On 2012-08-21 17:21, Markus F.X.J. Oberhumer wrote:
>> Hi all,
>>
>> as suggested on the mailing list I have converted the updated LZO
>> code into git, so please pull my "lzo-update" branch from
>>
>>   git://github.com/markus-oberhumer/linux.git lzo-update
>>
>> You can browse the branch at
>>
>>   https://github.com/markus-oberhumer/linux/compare/lzo-update
>>
>> I'd ask some official kernel maintainer for review and to push this into
>> linux-next so that it will hopefully land in the 3.7 release.
>>
>> Share and enjoy,
>> Markus
>>
>> Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>
>>
>>
>> [ Changes in v2: Optimize code for CPUs with inefficient unaligned
>>   access => significant speed increase on ARM ]
>>
>>
>> On 2012-07-16 20:30, Markus F.X.J. Oberhumer wrote:
>>> Hi all,
>>>
>>> I finally have prepared a small package that updates the LZO version
>>> in the Linux kernel. Please get it from:
>>>
>>> http://www.oberhumer.com/opensource/lzo/download/Testing/linux-kernel-lzo-20120716.tar.gz
>>>
>>> As stated in the README this version is significantly faster (typically more
>>> than 2 times faster!) than the current version, has been thoroughly tested on
>>> x86_64/i386/powerpc platforms and is intended to get included into the
>>> official Linux 3.6 or 3.7 release.
>>>
>>> I encourage all compression users to test and benchmark this new version,
>>> and I also would ask some official LZO maintainer to convert the updated
>>> source files into a GIT commit and possibly push it to Linus or linux-next.
>>>
>>> Share and enjoy,
>>> Markus
>>>
>>> Signed-off-by: Markus F.X.J. Oberhumer" <markus@oberhumer.com>
>
> --
> Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/



-- 
Thanks,
//richard
