From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: =?utf-8?Q?=E2=80=9Cbio?= too =?utf-8?Q?big=E2=80=9D?=
 regression and silent data corruption in 3.0
Date: Mon, 08 Aug 2011 23:53:43 -0300
Message-ID: <orty9r5m88.fsf@livre.localdomain>
References: <orwreobtuf.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orwreobtuf.fsf@livre.localdomain> (Alexandre Oliva's message of
	"Sun, 07 Aug 2011 22:00:24 -0300")
List-ID: <linux-btrfs.vger.kernel.org>

On Aug  7, 2011, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:

> 2. Removing a partition from the filesystem (say, the external disk)
> didn't relocate =E2=80=9Csingle=E2=80=9D block groups as such to othe=
r disks, as
> expected.

/me reads some code and resets expectations about RAID0 in btrfs ;-)

update_block_group_flags is what does this.  It doesn't care what was
chosen when the filesystem was created, it just forces RAID0 if more
than 1 disk remains:

		/* turn single device chunks into raid0 */
		return stripped | BTRFS_BLOCK_GROUP_RAID0;

Is this really intended?  Given my current understanding that RAID0
doesn't mean striping over all disks, but only over two disks, I guess =
I
might even be interested in it, but...  I still think the user's choice
should be honored, but I don't see where the choice is stored (if it is
at all).


> I wonder, why can't btrfs mark at least mounted partitions as busy, i=
n
> much the same way that swap, md and various filesystems do, to avoid
> such accidental reuses?

Heh.  And *unmark* them when they're removed, too...  As in, it won't
let me create a new filesystem in a partition that was just removed fro=
m
a filesystem, if that was the partition listed in /etc/mtab.

--=20
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
=46ree Software Evangelist      Red Hat Brazil Compiler Engineer
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
