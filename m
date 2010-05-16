From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Mounting raid without a btrfsctl scan
Date: Sun, 16 May 2010 21:38:31 +0200
Message-ID: <AANLkTims-SmMYx_oR3PN1RhV7qcqm0Mym8uSqFJowQAW@mail.gmail.com>
References: <4BEE817A.7060604@gmx.com>
	 <20100516000257.GB651@mother.pipebreaker.pl>
	 <AANLkTinRVuk_uJBLsBD0ANdKkEHs-9zz4Tor_0xi7oCI@mail.gmail.com>
	 <201005162044.23272.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: kreijack@libero.it, linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005162044.23272.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Resending because I forgot to add linux-btrfs... AGAIN!

On 16 May 2010 20:44, Goffredo Baroncelli <kreijack@gmail.com> wrote:
> On Sunday 16 May 2010, Sebastian 'gonX' Jensen wrote:
>> On 16 May 2010 02:02, Tomasz Torcz <tomek@pipebreaker.pl> wrote:
>
> [...]
>> I don't know if I mentioned it before, but my system
>> spends at least 6 seconds in the initramfs before passing control over
>> to my distributions initscripts. Part of it is obviously because of
>> btrfs having to spend approximately 3 seconds probing for devices (I
>> have a decent amount of devices).
>
>
>> However, btrfs does not have that
>> many functions yet. Would it be possible to at least have partial
>> functionality kernel side, so that an initramfs is not required for
>> mounting RAID devices?
>
> I think that the good question is: why a kernel probing should be faster than
> a user space probing ?

It's unlikely that it is (it's also harder to code, probably), but
having to initialize the entire ramfs (3 seconds on my reasonably fast
desktop computer) before being able to scan for devices with btrfs is
something that could probably be avoided. A luxury, if you will.

> I think that some reasons of the time required by the btrfsctl scan in user
> space are:
> 1) a scan performed via 'btrfsctl -a' scans every block device (cdrom and
> floppy included). I suggest to perform a scan via udev (see my previous post);
> that should be reduce the boot time.

I agree, and I think this is a good idea. This could also be
implemented if kernel-side probing is to be implemented.
If UDev scanning isn't feasible yet, or just a luxury, would it at
least not be possible to select what partitions/drives to probe, to
save time? This seems (from my limited programming perspective) fairly
easy to implement.

> 2) the actual initramfs tools pay attention to wait that _all_ devices
> appeared. This requires a bit of time which is not related to the "user space"
> scan.
>
> Comments ?
>
> G.Baroncelli
>

- Sebastian J.

[...]
