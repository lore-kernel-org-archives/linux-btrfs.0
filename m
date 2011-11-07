From: Arne Jansen <sensille@gmx.net>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Mon, 07 Nov 2011 10:37:16 +0100
Message-ID: <4EB7A6CC.5030502@gmx.net>
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06.11.2011 20:29, Andrea Gelmini wrote:
> 2011/11/6 Chris Mason <chris.mason@oracle.com>:
> 
> Hi Chris,
>    and thanks a lot for your work.
> 
>> Arne Jansen and Jan Schmidt have improved the scrubber and provided
>> utilities to walk btrfs' many backrefs.  The scrubber is much faster
>> thanks to extensive btree readahead and instead of just telling you a
>> specific block is bad, it tells you which btree or which file was
>> impacted by that bad block.
> 
>    Using your for-linus branch, on latest Linus' git tree, with latest
> git tools,
>    I've got this:
> 
> root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /dev/md126
> ERROR: scrubbing /dev/md126 failed for device id 1 (Cannot allocate memory)
> scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
> 	scrub started at Sun Nov  6 20:23:46 2011 and was aborted after 0 seconds
> 	total bytes scrubbed: 0.00 with 0 errors
> root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /home/
> ERROR: scrubbing /home/ failed for device id 1 (Cannot allocate memory)
> scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
> 	scrub started at Sun Nov  6 20:25:01 2011 and was aborted after 0 seconds
> 	total bytes scrubbed: 0.00 with 0 errors

On what platform are you running this? Can you please try this after
a fresh boot? Maybe there's an allocation that can't be served with
a badly fragmented memory.

Thanks,
Arne

> 
> Thanks a lot for your time,
> Andrea
>>
