From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: abysmal performance
Date: Sat, 30 Apr 2011 17:16:53 -0500
Message-ID: <BANLkTims8NH-2V_ytOSfVWkAGtEDmGdT7A@mail.gmail.com>
References: <1304088305-sup-3784@localhost>
	<1304089239-sup-5110@think>
	<BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
	<1304195921-sup-9266@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: John Wyzer <john.wyzer@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304195921-sup-9266@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 30, 2011 at 3:40 PM, John Wyzer <john.wyzer@gmx.de> wrote:
>> If you just want to see your fragmentation you can use the 'filefrag'
>> program from e2fsprogs:
>>
>> # for file in $(find <PATH/TO/BTRFS/VOL/> -type f); do filefrag
>> ${file}; done | sort -n -k 2 | less
>
>
> Hmm.
> Tried it and it gives me about 500000 lines of
>
> FIBMAP: Invalid argument
>
> and then:
>
> large_file: 1 extent found
>
> Is that the way it is supposed to work?
> Just asking because this was part of a vmware disk image. Both the virtual
> machine and the rest of the host system are almost unusable once the VM ist
> started (even more unusable than without vmware :-D )

No.  It sounds like the filefrag command is getting confused in the
virtual environment.
