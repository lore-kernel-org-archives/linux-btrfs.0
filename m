From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs problems and fedora 14
Date: Fri, 26 Nov 2010 11:47:19 -0600
Message-ID: <AANLkTim1tppydrcBdcGvNyXDGviz2_HOzOY2_OrSsqWM@mail.gmail.com>
References: <1290467983.24502.66.camel@main-wireless>
	<AANLkTinuQU46BCL6WLM4hEc+ocXsbOGHoF3ppGbTOc8y@mail.gmail.com>
	<AANLkTimkdtmjeO1Hzq5y1nL_ERNiJS1S0xn6Vu2_yyj=@mail.gmail.com>
	<1290583953.2235.28.camel@main-wireless>
	<AANLkTimhA5z8xB_t9bGCC4=jzezPhHTPzBPy=0PW9Kpg@mail.gmail.com>
	<1290764456.4380.20.camel@main-wireless>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: C Anthony Risinger <anthony@extof.me>,
	Hugo Mills <hugo-lkml@carfax.org.uk>,
	Wenyi Liu <qingshenlwy@gmail.com>, linux-btrfs@vger.kernel.org
To: david grant <dg@david-grant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290764456.4380.20.camel@main-wireless>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 26, 2010 at 3:40 AM, david grant <dg@david-grant.com> wrote=
:
> I am totally anal about having backups of a current operating systems
> and using those for testing I thought tat the best way to do this wit=
h
> btrfs was to rsync the file system to another partition but exclude a=
ll
> snapshots. This worked very well as long as I mounted only the root f=
ile
> system of the copy but what I did was add snapshots to the copy and a=
t
> some point (probably at the start) the btree system was corrupted but=
 I
> only saw this on backtracking and checking all messages. Also, I didn=
't
> want to boot from a snapshot of my working operating system for fear =
I
> could screw things up and have to re-install from scratch. =A0In orde=
r to
> try again, I deleted all snapshots from the original system, did an
> rsync and checked the copy. I then made a snapshot of the copy via yu=
m,
> used rootflags and it worked!!
>
> So, cwillu, after your scolding of me and your (perfectly reasonable)
> questioning of my understanding, I did get it together for booting.
>
> BUT I am still left with the problem that caused it for me: how do I
> backup (clone?) a btrfs file system with snapshots to another btrfs
> partition (apart from using dd).

I use rsync myself, and explicitly list the subvolumes and mirrors I
want copied, which sounds pretty much like what you were doing.  The
corruption you saw definitely wasn't supposed to happen, but depending
on which kernel's you've used and (to a lessor extent) whether a few
particular kernel options are set, isn't too surprising.  Things
_have_ been pretty stable for me for the last little while, basically
since 2.6.35+btrfs_git, and I use snapshots quite a bit.

What I use in a nutshell is:

mountpoint "${BACKUP_TO}/${TODAY}" || {
        btrfs subvolume snapshot "${BACKUP_TO}/${YESTERDAY}"
"${BACKUP_TO}/${TODAY}" || exit 1
}
btrfs subvolume snapshot / /backup-snap && {
        rsync -vaxR --inplace --delete --ignore-errors /backup-snap/./
${BACKUP_TO}/${TODAY}/
        btrfs subvolume delete /backup-snap
}

This will give you incremental backups while avoiding the worst of the
duplication.  I haven't verified that rsync actually does anything
useful COW-wise at the file level, but that's the idea behind the
--inplace option (without it, rsync writes to a copy, and replaces the
original, which COW can't help with).

This is a still a little ways from actually making new snapshots to
fully reproduce the existing filesystem, but I'm not certain that's
what you were after.

> I just hope I don't get scolded again and told I am not up to it.

In point of fact, I said that you _were_ up to it (you were), and that
you'd have it running in no time (you did) once you understood things
better (you do).  I win?  (I always win)  =3DD

[Also, please post your replies under the quoted original, not on top.
 Easier to follow the thread that way.]
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
