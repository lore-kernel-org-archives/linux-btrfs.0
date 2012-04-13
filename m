From: cwillu <cwillu@cwillu.com>
Subject: Re: Wiki update request: source repo page Was: [PATCH] Btrfs: use
 i_version instead of our own sequence
Date: Fri, 13 Apr 2012 14:03:38 -0600
Message-ID: <CAE5mzvhym10Y9-Z8zLKrQYhvBR6FhUHigk-xs_OWNiQJWFG4PQ@mail.gmail.com>
References: <1333986794-6525-1-git-send-email-josef@redhat.com>
	<CALLzPKY0ViBnaH8PVOmxad+oPpbWiYOz24+Lc8CWNuzKbyHHng@mail.gmail.com>
	<20120412133107.GC1924@localhost.localdomain>
	<pan.2012.04.12.21.41.17@cox.net>
	<20120412215546.GB4856@carfax.org.uk>
	<pan.2012.04.12.22.56.00@cox.net>
	<20120413131632.GG4856@carfax.org.uk>
	<pan.2012.04.13.18.48.48@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.04.13.18.48.48@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 13, 2012 at 12:48 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Hugo Mills posted on Fri, 13 Apr 2012 14:16:32 +0100 as excerpted:
>
>> On Thu, Apr 12, 2012 at 10:56:00PM +0000, Duncan wrote:
>>> Hugo Mills posted on Thu, 12 Apr 2012 22:55:46 +0100 as excerpted:
>>> > The general advice is -- use a single-device root filesystem, or =
an
>>> > initramfs. These are simple, supported, and will generally get go=
od
>>> > help. Any other configuration will cause you to be told to use an
>>> > initramfs. So far, I've not heard any concrete reason why one
>>> > shouldn't be used except "ooh, I don't understand them, and they'=
re
>>> > scary!".
>>>
>>> FWIW, device names appear to be reasonably stable, here. =C2=A0Stab=
le enough
>>> that I currently have this built into the kernel as part of my kern=
el
>>> command line:
>>
>> That's all well and good for you, but my point is that in the
>> general case, device names are *not* stable, and the kernel does *no=
t*
>> claim to guarantee this. If you assume that they are stable, and you=
r
>> system breaks as a result, then you get to keep both pieces. Your
>> choice, but your risk as well. The recommendation for a stable relia=
ble
>> system is to run btrfs dev scan before mounting a btrfs filesystem.
>
> BTW, I don't believe I've thanked you for the replies, yet. =C2=A0Tha=
nks, and
> I don't disagree with the rest.
>
> I guess I generally agree here, too... with /generally/ stressed. =C2=
=A0But
> the wiki should cover more than the default, "general" case.
>
> Meanwhile [kernel command line] ...
>
>>> md=3D3,/dev/sda6,/dev/sdb6,/dev/sdc6,/dev/sdd6 root=3D/dev/md3p1
>
>> So you're doing the same thing as btrfs's "device=3D" mount option.
>
> Same general thing, yes.
>
>> Again, if this works, all well and good, but it'll break if devices =
move
>> around, requiring the manual step. If you want to avoid that and hav=
e it
>> all Just Work, use an initrd (for both MD and btrfs).
>
> Obviously, for systems where it all moves around at every boot, this
> isn't going to be a very useful alternative, I'll agree. =C2=A0But th=
at's not
> the case on a lot of hardware.
>
> And the trouble with "just works" isn't when it does INDEED "just wor=
k",
> but when it doesn't. =C2=A0In that case, the admin needs to be comfor=
table
> enough with the system and his understanding of it to get things back
> into operational condition. =C2=A0The more layers of unnecessary comp=
lexity
> (like a shouldn't be necessary initr*) there are, the more difficult =
that
> "grok the system well enough to be reasonably confident in one's abil=
ity
> to restore it" status is to achieve, and the higher the risk of failu=
re,
> should the admin's disaster recovery skills actually be needed.

The fact is that you _don't_ know that your device names aren't going
to change one day, any more than a generation of developers who only
worked with ext3 knew that "fsync is expensive and all you really need
is the atomic guarantee of mv".

[snip]

> Stick to a distro's packages?
>
> How are people only running distro packages supposed to run the patch=
es
> they're asked to test on the list, talk the distro package maintainer
> into including possibly one-shot debugging patches into a new general
> rollout?

On debian derivatives at least, creating a distro packaged kernel from
a git checkout is a single, fairly short, command.  And the logic to
create the initramfs is separate from that, triggered when a kernel is
installed (and which works even if you just installed a kernel by
copying the bzimage to /boot).  I'd be surprised if it was much
different on any other distro.

Everyone needs to start somewhere, but it's not unreasonable to expect
an admin to understand how their distro does things, and where to find
answers when they don't know, and to verify that their knowledge is
correct.  The middle of a disaster recovery should not be the first
time you've tried a recovery.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
