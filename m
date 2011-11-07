From: Arne Jansen <sensille@gmx.net>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Mon, 07 Nov 2011 10:57:48 +0100
Message-ID: <4EB7AB9C.8010402@gmx.net>
References: <20111106183851.GA4339@shiny>	<CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>	<4EB7A6CC.5030502@gmx.net> <20111107154936.7c60be38@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111107154936.7c60be38@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On 07.11.2011 10:49, Roman Mamedov wrote:
> On Mon, 07 Nov 2011 10:37:16 +0100
> Arne Jansen <sensille@gmx.net> wrote:
> 
>>>    I've got this:
>>>
>>> root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /dev/md126
>>> ERROR: scrubbing /dev/md126 failed for device id 1 (Cannot allocate memory)
>>> scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
>>> 	scrub started at Sun Nov  6 20:23:46 2011 and was aborted after 0 seconds
>>> 	total bytes scrubbed: 0.00 with 0 errors
>>> root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /home/
>>> ERROR: scrubbing /home/ failed for device id 1 (Cannot allocate memory)
>>> scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
>>> 	scrub started at Sun Nov  6 20:25:01 2011 and was aborted after 0 seconds
>>> 	total bytes scrubbed: 0.00 with 0 errors
>>
>> On what platform are you running this? Can you please try this after
>> a fresh boot? Maybe there's an allocation that can't be served with
>> a badly fragmented memory.
> 
> If so, shouldn't there also be a corresponding dmesg warning about "Unable to allocate....", which would confirm or rule this out?
> So before following the "did you try turning it off and on again" advice (and throwing away useful debug info), I'd suggest checking/saving dmesg first.
> 

You're right of course. The advice was not meant as a fix, but as a
means to gather more information.
