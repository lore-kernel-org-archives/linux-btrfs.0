From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: filesystem seeding ... BUGs on .38, .39, loopback, real devices,
 tmp branch ... everything
Date: Thu, 2 Jun 2011 11:19:53 -0500
Message-ID: <BANLkTi=t7f47VMw1CLRG67T9MariQg9q0g@mail.gmail.com>
References: <BANLkTikZyg0gyUZH5pQ9d=P4brsTUA9PCg@mail.gmail.com> <1307014855.13841.10.camel@quintos.origo>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Geoff Ritter <geoff.ritter@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307014855.13841.10.camel@quintos.origo>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 2, 2011 at 6:40 AM, Geoff Ritter <geoff.ritter@gmail.com> w=
rote:
> On Thu, 2011-06-02 at 04:20 -0500, C Anthony Risinger wrote:
>>
>> i tried with loop devices at first, then "real" devices -- this is a=
ll
>> under KVM/QEMU, and with FSs that are/will be smaller than 1G.
>
> I have tried the seed option as well. =C2=A0I was able to successfull=
y mount
> the read write partition after setting up the seed. =C2=A0However, bo=
th had
> to be independent partitions on a real device.
>
> During testing, both .38 and .39rc could NOT create a seed if one or
> both partitions were encrypted. =C2=A0I believe encrypted partitions =
also
> work with a loop device for the unlocked version you write too. =C2=A0=
The
> response I got after a few days is as follows:
>
>> Chris Mason chris.mason@oracle.com
>> cwillu <cwillu@cwillu.com>
>> date =C2=A0Thu, May 5, 2011 at 4:42 PM
>> Ok, looks like I busted the seed support
>> when I fixed up some of the chunk
>> allocations. =C2=A0I'll reproduce this and
>> work out a fix.
>
> I just assumed it would take a while to fix so I haven't tried again
> since. =C2=A0If the root of the problem appears to be loop devices, y=
ou might
> want to report that. =C2=A0Err I guess you did. =C2=A0To me, this doe=
sn't explain
> why it wouldn't work in a Virtual Machine. =C2=A0I would have thought=
 the VM
> would treat it as a real device.

yeah ... i wasn't sure if this was the same exact problem you had or
what, i can't find much info at all about anyone using seed support.

i tried loop devices on my real machine too (.38), and because of
continuous oops/locks i moved to a VM so i didn't hose my system.
however, when i tried with "real" devices in the VM, these were not
loopbacks, they were just regular raw files used as backing for QEMU
(though i don't know if it internally uses loopback) ... they were
exposed as virtio devices /dev/vdb and /dev/vdc.  i got the exact same
results using those devices, using btrfs-vol instead of btrfs, and a
whole slew of other trial and error that all led to the same issue.

the 10 lines or so i provided earlier reproduces consistently for me
=2E.. in the end, it *seemed* to work, but still :-)

what i REALLY want though, is simply more information on how seeding
works and should be used ... the wiki et al seem to imply that i can
reuse the seed device for MULTIPLE filesystems ... how can i do this?
i tried adding the device to an existing array but i couldnt see any
files ... can anyone shed some light on this feature?

thanks much,

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
