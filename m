From: Arne Jansen <sensille@gmx.net>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Fri, 16 Mar 2012 16:37:50 +0100
Message-ID: <4F635E4E.80802@gmx.net>
References: <201112171833.34720.Martin@lichtvoll.de> <201203151832.19703.Martin@lichtvoll.de> <20120315174245.GV19217@shiny> (sfid-20120315_185259_074357_E09C1265) <201203161605.47792.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201203161605.47792.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 16.03.2012 16:05, Martin Steigerwald wrote:

>> has an important fix for scrub on 32 bit that should solve this.
> 
> So finally - the machine did make-kpkg over night and complained about
> missing Documentation lguest, then I switched off lots from distro default
> config and just did the usual make stuff - I was able to scrub both
> partitions on that ThinkPad T23:
> 
> deepdance:~> btrfs scrub status /
> scrub status for 2bf5b1dc-1d89-4f0d-a561-1a5551a27275
>         scrub started at Fri Mar 16 11:56:12 2012 and finished after 741 seconds
>         total bytes scrubbed: 9.62GB with 0 errors
> 
> deepdance:~> btrfs scrub status /home
> scrub status for a600de65-e1ab-4cbf-b150-bbaeaf9fa98d
>         scrub started at Fri Mar 16 12:00:31 2012 and finished after 1708 seconds
>         total bytes scrubbed: 36.63GB with 0 errors
> 
> Thanks a lot for fixing this. 
> 
> Tested-by: Martin Steigerwald <martin@lichtvoll.de>
> 
> Arne, if you want me to test your two patches to readahead as well, please
> tell me. Now since only a few files need to be recompiled it would be
> quite easy to test them

As Chris's patch already solves your problem, I think we're
fine. The two patches are more important for future users of
readahead. As I had them sitting in the queue there was a
small hope they might help your problem ;)

Thanks,
Arne

> 
> Next challenge is the slow performance at times. This morning as I booted
> into the new kernel afterwards on tty it took at least 15 seconds of
> heavy disk activity with hearable lots of seeks to just open a screen.
> But thats something for a different thread.
> 
> Thanks,

