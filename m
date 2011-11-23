From: cwillu <cwillu@cwillu.com>
Subject: Re: Announcing btrfs-gui
Date: Wed, 23 Nov 2011 11:39:02 -0600
Message-ID: <CAE5mzvgbYyvU4tNnzr3sWcY=QGTTqceW4X=uLiswy-eM4F9rHg@mail.gmail.com>
References: <20110601232058.GA22619@carfax.org.uk>
	<4EBDBCD9.8060009@vangasse.eu>
	<20111123123333.GE28749@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	Amedee Van Gasse <amedee@vangasse.eu>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111123123333.GE28749@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2011 at 6:33 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Nov 12, 2011 at 01:24:57AM +0100, Amedee Van Gasse wrote:
>> On 02-06-11 01:20, Hugo Mills wrote:
>> > =C2=A0 =C2=A0Unless the traffic gets too high-volume, or unless so=
meone
>> >important objects, I'm going to suggest that bug reports should go =
to
>> >this list for now (cc'd me, if you like). Note that this isn't an
>> >"offical" btrfs project -- it's just something I knocked together o=
n
>> >my own.
>>
>>
>> I seem to have stumbled upon a bug.
>> During install, Ubuntu gives the user the option to use btrfs as the
>> root filesystem. It automatically creates two subvolumes, @ (for /)
>> and @home (for /home, only if no other partition is used for /home),
>> like this:
>>
>> mount | grep btrfs
>> /dev/sda6 on / type btrfs (rw,subvol=3D@)
>> /dev/sda6 on /home type btrfs (rw,subvol=3D@home)
>> /dev/sda6 on
>> /tmp/btrfs-gui-kl6zx1/12624/eba4f1e9-5b55-4e14-abb8-5a3cf3625c56
>> type btrfs (rw,subvolid=3D0)
>>
>> When gtrfs-gui scans for filesystems, it gives the error
>> Root helper exception: b'@' is not JSON serializable
> [snip]
>
> =C2=A0 Mmm... That could be fun. :)
>
> =C2=A0 Thanks for the bug report. I hope I'll have time to look into =
this
> next week.

Looks like a unicode screwup; python 3 doesn't do implicit unicode
conversions anymore, so passing a bytestring to the json module isn't
supported.  The solution will be something along the lines of
"subvol.decode('ascii')" (or possibly utf-8 if you're willing to
silently break on the admittedly obscure case of a non-ascii subvolume
name in an installation using an encoding other than utf-8).
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
