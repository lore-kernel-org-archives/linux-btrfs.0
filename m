From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Emergency - Can't Boot
Date: Sun, 31 Jul 2011 09:34:26 +0700
Message-ID: <CAG1y0scsFnWV+YcSzg=YAR82bLvce-UyK+LvEfeORhpYPWe8ew@mail.gmail.com>
References: <1312055511.4346.9.camel@hydra.darkmatter.org>
	<20110730204621.GA6989@carfax.org.uk>
	<201107301412.46941.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107301412.46941.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 31, 2011 at 4:12 AM,  <CACook@quantum-sci.com> wrote:
> On Saturday 30 July, 2011 13:46:21 Hugo Mills wrote:
>> On Sat, Jul 30, 2011 at 12:51:51PM -0700, . wrote:
>> > I just did my monthly dist-upgrade and rebooted, only to have it s=
tall
>> > at Control D. =A0It tried to automatically run fsck.btrfs and of c=
ourse it
>> > failed, and insists that I run it manually. =A0I can't. =A0I've re=
booted
>> > several times and can't get past Control D. =A0Don't know where it=
 keeps
>> > track of the number of reboots since last fsck.
>> >
>> > What do you do in a case like this?
>>
>> =A0 =A0[Just a note -- this seems to have been fixed in a conversati=
on on
>> IRC, by linking /bin/true to /bin/fsck.btrfs]
>
> Yes that fixed it.

IMHO a better fix is to just disable fsck on fstab for that fs. Somethi=
ng like

# <file system> <mount point>   <type>  <options>       <dump>  <pass>
LABEL=3DROOT  /               btrfs
subvolid=3D258,compress-force=3Dlzo,noatime        0       0

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
