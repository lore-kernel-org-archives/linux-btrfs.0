From: C Anthony Risinger <anthony@extof.me>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 12:52:38 -0600
Message-ID: <AANLkTimPx+u-bJH+beEP4kr6Bb3qJh1EryriHxeLDsj_@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<201012011933.40169.kreijack@libero.it>
	<20101201183656.GD7021@localhost.localdomain>
	<AANLkTi=2z9RwiiD+ohhqB-WDf9uFXYoko3VhjOjmiY=5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Goffredo Baroncelli <kreijack@libero.it>, ssorce@redhat.com,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2z9RwiiD+ohhqB-WDf9uFXYoko3VhjOjmiY=5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 12:48 PM, C Anthony Risinger <anthony@extof.me> =
wrote:
> On Wed, Dec 1, 2010 at 12:36 PM, Josef Bacik <josef@redhat.com> wrote=
:
>> On Wed, Dec 01, 2010 at 07:33:39PM +0100, Goffredo Baroncelli wrote:
>>
>>> Another point that I want like to discuss is how manage the "pivoti=
ng" between
>>> the subvolumes. One of the most beautiful feature of btrfs is the s=
napshot
>>> capability. In fact it is possible to make a snapshot of the root o=
f the
>>> filesystem and to mount it in a subsequent reboot.
>>> But is very complicated to manage the pivoting of a snapshot of a r=
oot
>>> filesystem, because I cannot delete the "old root" due to the fact =
that the
>>> "new root" is placed in the "old root".
>>>
>>> A possible solution is not to put the root of the filesystem (where=
 are placed
>>> /usr, /etc....) in the root of the btrfs filesystem; but it should =
be accepted
>>> from the beginning the idea that the root of a filesystem should be=
 placed in
>>> a subvolume which int turn is placed in the root of a btrfs filesys=
tem...
>>>
>>> I am open to other opinions.
>>>
>>
>> Agreed, one of the things that Chris and I have discussed is the pos=
siblity of
>> just having dangling roots, since really the directories are just an=
 easy way to
>> get to the subvolumes. =A0This would let you delete the original vol=
ume and use
>> the snapshot from then on out. =A0Something to do in the future for =
sure.
>
> i would really like to see a solution to this particular issue. =A0i =
may
> be missing something, but the dangling subvol roots doesn't seem to
> address the management of the root volume itself.
>
> for example... most people will install their whole system into the
> real root (id=3D5), but this renders the system unmanageable, because
> there is no way to ever empty it without manually issuing an `rm -rf`=
=2E
>
> i'm having a really hard time controlling this with the initramfs hoo=
k
> i provide for archlinux users. =A0the hook requires a specific struct=
ure
> "underneath" what the user perceives as /, but i can only accomplish
> this for new installs -- for existing installs i can setup the proper
> "subroot" structure, and snapshot their current root... but i cannot
> remove the stagnant files in the real root (id=3D5) that well never,
> ever be accessed again.
>
> ... or does dangling roots address this?

i forgot to mention, but a quick 'n dirty solution would be to simply
not enable users to do this by accident.  mkfs.btrfs could create a
new subvol, then mark it as default... this way the user has to
manually mount with id=3D0, or remark 0 as the default.

effectively, users would be unknowingly be installing into a
subvolume, rather then the top-level root (apologies if my terminology
is incorrect).

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
