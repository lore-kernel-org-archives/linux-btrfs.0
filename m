From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Replacing the top-level root
Date: Wed, 27 Oct 2010 11:52:44 -0500
Message-ID: <AANLkTik2NEt9B6A8aHn5WSyFb6qLfL7pR4Eohw3FAbhK@mail.gmail.com>
References: <AANLkTiktaR6ipbH-i=kTdRvHqBdTAAcYYsdVamogifm1@mail.gmail.com>
	<20101027055311.GA8550@davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: David Brown <btrfs@davidb.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101027055311.GA8550@davidb.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 27, 2010 at 12:53 AM, David Brown <btrfs@davidb.org> wrote:
> On Mon, Oct 25, 2010 at 03:20:58PM -0500, C Anthony Risinger wrote:
>
>> For example, right now extlinux support booting btrfs, but _only_ fr=
om
>> the top-level root. =A0if i just had a way to "swap" the top-level r=
oot
>> with a different subvol, i could overcome several problems i have wi=
th
>> users all at once:
>>
>> ) users install their system to the top-level root, which means it i=
s
>> no longer manageable by snapshot scripts [currently]
>> ) if the top-level root could be swapped, extlinux could then boot m=
y
>> snapshot? (i'm probably wrong here)
>
> I don't think this is a solution to the extlinux problem, but I've
> moved roots into new subvolumes, basically something like this.
>
> Root is mounted as /, I've also mounted the volume on /mounted in thi=
s
> example.
>
> =A0# btrfs subvolume snapshot /mounted /mounted/newrootname
>
> Now reboot, adding the subvol option to use the newrootname.
> Go into /mounted and make sure files touced there don't show up in '/=
'
> (we really are mounting the submount).
>
> Then just use rm -rf to remove everything that isn't a subvol. =A0I
> don't know of an easy way to do that, and be careful.

yeah, this is precisely what i do currently...

the problem is i have to tell the user to do this themselves, as there
isn't a way to safely accomplish it automatically.  i expect this will
become a more common problem, esp. for those trying to integrate
advanced btrfs handlers into their distro; like myself.  basically, i
have ultimate control over all subvols, except top-level, and i want
to why/how to address this.

imo, if there really is not a proper solution to this issue because of
some technical reason, i think mkfs.btrfs should automatically create
a subvol, and mark it default... because from the feedback i'm getting
or lack thereof, the top-level subvol is dangerous because it's not
manageable.

this should be done immediately imo, but at the very least, once
grub2/extlinux support booting from subvols.

thoughts?

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
