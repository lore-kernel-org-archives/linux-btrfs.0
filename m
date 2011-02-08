From: cwillu <cwillu@cwillu.com>
Subject: Re: no space left on device
Date: Tue, 8 Feb 2011 03:31:22 -0600
Message-ID: <AANLkTi=LpCrow+oY=d6OLFLeMR_m4Z7rNLv6Buy7pDL2@mail.gmail.com>
References: <AANLkTinH225vC8fRbA7zk_iOEmyADFZMBS6b7gx1tOxm@mail.gmail.com>
	<AANLkTi=Qp3US4TTxvXgwwU65kTx5fVYfq+q+EkEvZyTL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: C Anthony Risinger <anthony@extof.me>, linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Qp3US4TTxvXgwwU65kTx5fVYfq+q+EkEvZyTL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 8, 2011 at 3:00 AM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:
> On Feb 8, 2011 12:09 AM, "C Anthony Risinger" <anthony@extof.me> wrote:
>>
>> On Mon, Feb 7, 2011 at 3:21 PM, Leonidas Spyropoulos
>> <artafinde@gmail.com> wrote:
>> > Hey all,
>> >
>> > I run into no space left on device on a virtualbox
>> >
>> > After installing Debian 6 on a virtual machine
>> > I tried installing the KDE desktop
>> >
>> > The system HDD is 8Gb
>> > Both root (/) and /home are btrfs
>> > over LVM.
>> >
>> > While installing the packages I run into:
>> >
>> > no space left, need 4096, 4096 dealloc bytes, 1776283648 bytes_used, 0
>> > bytes_reserved,
>> > 0 bytes_pinned, 0 bytes_readonly, 0 may use 1776287744 total
>> >
>> > df shows only 74% used space on /
>> >
>> > kernel used: stock debian 6 2.6.32-5-686
>> >
>> > At the moment I cannot access it with normal boot, only recovery mode.
>> >
>> > I can provide whatever info you would like as long as you think of a
>> > way to load the normal system and not the recovery mode.
>>
>> IIRC .32 has all sorts of ENOSPC problems; I think this was seriously
>> tackled in kernels > .32... this kernel was only declared ready for
>> "early adopters", with an "expect issues" disclaimer.
>>
>> The btrfs-tools in squeeze is probably so old you may not even have
>> the `btrfs` binary, but I don't run debian so I'm not sure there...
>> not really a solution probably for you, but I wouldn't run that kernel
>> if using btrfs.
>>
>> C Anthony
>
> Hey all,
>
> Thanks for all the answers.
>
> The problem is that I cannot login to the system.only recovery mode works,
> and there btrfs command is not there as you imagined.
>
> I will try though ssh but I don't think it's installed by default and I
> cannot install it.
>
> So the next step is try from recovery console of debian live cd, which still
> has the really old tools...
>
> I think this is quite some serious issue but generally all debian's fault
> adopting a btrfs file system support on a 2.6.32 kernel and without
> btrfs-progs on some decent version.
>
> I'll update when possible.
> Please throw any other alternatives my way anyone.

I have to be blunt, blaming your problems on debian isn't terribly
classy.  The "oooo, shiny!" reflex is your fault, not debian's.

Download and install a prebuilt 2.6.35 or later kernel into your /boot
via a livecd or whatever, unpack and add the btrfs command to the
initramfs for that kernel, boot up into that initramfs with the kernel
option "break=premount", and fix the rootfs from the busybox prompt.

Alternatively, an ubuntu natty alpha livecd has a 2.6.38 kernel, and
you can install mostly up-to-date btrfs tools into that environment.
I'm sure debian has something similar available.

--Carey Underwood
