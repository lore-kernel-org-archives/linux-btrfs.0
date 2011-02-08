From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: no space left on device
Date: Tue, 8 Feb 2011 10:08:01 +0000
Message-ID: <AANLkTikirGVnZi6ePSN=sDco=p1BpRih3qEx+Hnhwvh6@mail.gmail.com>
References: <AANLkTinH225vC8fRbA7zk_iOEmyADFZMBS6b7gx1tOxm@mail.gmail.com>
	<AANLkTi=Qp3US4TTxvXgwwU65kTx5fVYfq+q+EkEvZyTL@mail.gmail.com>
	<AANLkTi=LpCrow+oY=d6OLFLeMR_m4Z7rNLv6Buy7pDL2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: C Anthony Risinger <anthony@extof.me>, linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=LpCrow+oY=d6OLFLeMR_m4Z7rNLv6Buy7pDL2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 8 February 2011 09:31, cwillu <cwillu@cwillu.com> wrote:
> On Tue, Feb 8, 2011 at 3:00 AM, Leonidas Spyropoulos
> <artafinde@gmail.com> wrote:
>> On Feb 8, 2011 12:09 AM, "C Anthony Risinger" <anthony@extof.me> wro=
te:
>>>
>>> On Mon, Feb 7, 2011 at 3:21 PM, Leonidas Spyropoulos
>>> <artafinde@gmail.com> wrote:
>>> > Hey all,
>>> >
>>> > I run into no space left on device on a virtualbox
>>> >
>>> > After installing Debian 6 on a virtual machine
>>> > I tried installing the KDE desktop
>>> >
>>> > The system HDD is 8Gb
>>> > Both root (/) and /home are btrfs
>>> > over LVM.
>>> >
>>> > While installing the packages I run into:
>>> >
>>> > no space left, need 4096, 4096 dealloc bytes, 1776283648 bytes_us=
ed, 0
>>> > bytes_reserved,
>>> > 0 bytes_pinned, 0 bytes_readonly, 0 may use 1776287744 total
>>> >
>>> > df shows only 74% used space on /
>>> >
>>> > kernel used: stock debian 6 2.6.32-5-686
>>> >
>>> > At the moment I cannot access it with normal boot, only recovery =
mode.
>>> >
>>> > I can provide whatever info you would like as long as you think o=
f a
>>> > way to load the normal system and not the recovery mode.
>>>
>>> IIRC .32 has all sorts of ENOSPC problems; I think this was serious=
ly
>>> tackled in kernels > .32... this kernel was only declared ready for
>>> "early adopters", with an "expect issues" disclaimer.
>>>
>>> The btrfs-tools in squeeze is probably so old you may not even have
>>> the `btrfs` binary, but I don't run debian so I'm not sure there...
>>> not really a solution probably for you, but I wouldn't run that ker=
nel
>>> if using btrfs.
>>>
>>> C Anthony
>>
>> Hey all,
>>
>> Thanks for all the answers.
>>
>> The problem is that I cannot login to the system.only recovery mode =
works,
>> and there btrfs command is not there as you imagined.
>>
>> I will try though ssh but I don't think it's installed by default an=
d I
>> cannot install it.
>>
>> So the next step is try from recovery console of debian live cd, whi=
ch still
>> has the really old tools...
>>
>> I think this is quite some serious issue but generally all debian's =
fault
>> adopting a btrfs file system support on a 2.6.32 kernel and without
>> btrfs-progs on some decent version.
>>
>> I'll update when possible.
>> Please throw any other alternatives my way anyone.
>
> I have to be blunt, blaming your problems on debian isn't terribly
> classy. =A0The "oooo, shiny!" reflex is your fault, not debian's.

Well you are right it is my problem and yeah I wanted to test the "new
shiny" Debian 6 with
officially btrfs supported.

=46or the moment I apt-get clean to get some space since my / was
updating the KDE (so it had a lot of cache files there)
Reserved something like 300Mb and then vlextend the /

But the next step is to update kernel and btrfs-progs from git.

Thanks for answers

>
> Download and install a prebuilt 2.6.35 or later kernel into your /boo=
t
> via a livecd or whatever, unpack and add the btrfs command to the
> initramfs for that kernel, boot up into that initramfs with the kerne=
l
> option "break=3Dpremount", and fix the rootfs from the busybox prompt=
=2E

The above seems unknown to me. Could you elaborate a bit please?

>
> Alternatively, an ubuntu natty alpha livecd has a 2.6.38 kernel, and
> you can install mostly up-to-date btrfs tools into that environment.
> I'm sure debian has something similar available.

I was wondering how to fix this without liveCD.

>
> --Carey Underwood
>

--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
