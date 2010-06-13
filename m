From: C Anthony Risinger <anthony@extof.me>
Subject: Re: default subvolume abilities/restrictions
Date: Sun, 13 Jun 2010 12:47:16 -0500
Message-ID: <AANLkTinQTEhdnKLF4UKnv1eAqNpgFTwKYynDfx02itHd@mail.gmail.com>
References: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost>
	<AANLkTinCbFQkWvehlmnmGrPdduWfWUjutgYADZAkSlCe@mail.gmail.com>
	<AANLkTikHScVP2MylD7EXVC-d-v0RloxVpv8P5SEgrXd6@mail.gmail.com>
	<AANLkTim0VvWP0CLIWCqHMUZX1dAHPOBWWcRoZYSRUgyn@mail.gmail.com>
	<20100613002252.GA12170@arch.davidb.org>
	<AANLkTilIw2LO7nA0yFx3A7aon03vPN5Et38pf3ZSTOQN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilIw2LO7nA0yFx3A7aon03vPN5Et38pf3ZSTOQN@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 12, 2010 at 8:06 PM, C Anthony Risinger <anthony@extof.me> =
wrote:
> On Sat, Jun 12, 2010 at 7:22 PM, David Brown <btrfs@davidb.org> wrote=
:
>> On Sat, Jun 12, 2010 at 06:06:23PM -0500, C Anthony Risinger wrote:
>>
>>>> # btrfs subvolume create new_root
>>>> # mv . new_root/old_root
>>
>>> can i at least get confirmation that the above is possible?
>>
>> I've had no problem with
>>
>> =A0# btrfs subvolume snapshot . new_root
>> =A0# mkdir old_root
>> =A0# mv * old_root
>> =A0# rm -rf old_root
>>
>> Make sure the 'mv' fails fo move new_root, and I'd look at the
>> new_root before removing everything.
>>
>> David
>
> heh, yeah i as i was writing the last email i realized that all i
> really wanted was to:
>
> # mv * new_root
>
> for some reason i was convinced that i must snapshot the old_root (.)
> to new_root... and then remove the erroneous stuff from old_root (.).
> thus a way to "parent" the default subvol (old_root/.) seemed a bette=
r
> solution...
>
> but alas, a snapshot isn't necessary. =A0i can create an empty subvol
> "new_root", and then "mv * new_root".
>
> i don't know how that escaped me :-), sorry for all the noise.
> however, there probably is a legitimate use case for wanting to
> replace the default subvolume, but this isn't it.
>
> C Anthony

ok i take it all back, i DO need this...

i rewrote my initramfs hook to do the following operations:

# btrfs subvolume create /new_root
# mv /* /new_root

instead of what i had:

# btrfs subvolume snapshot / /new_root

and it resulted in scarily COPYING my entire system... several gigs
worth... to the newly created subvolume, which took forever, and
grinded on my HD for awhile.  i don't know how long because i went to
bed.

this is why i need a way to "parent" the default subvolume.

a snapshot is nice and quick, but it leaves / full of erroneous
folders (dev/etc/usr/lib), an entire system, that will no longer be
used.  this space will in time become dead wasted space unless my
users manually "rm -rf" themselves.

so... any input on this?  how can i effectively, and efficiently, move
a users installation into a dedicated subvolume, when they have
already installed into the default subvolume?

i think the best way is what i originally suggested; make an empty
subvolume the new top-level subvol, and place the old top-level subvol
INTO it with a new name.

thoughts?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
