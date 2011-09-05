From: David Sterba <dsterba@suse.cz>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Mon, 5 Sep 2011 15:51:29 +0200
Message-ID: <20110905135129.GI11678@ds.suse.cz>
References: <4E64A0C5.2060409@cyberphoria.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F6rn?= Kalkbrenner <terminar@cyberphoria.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64A0C5.2060409@cyberphoria.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Sep 05, 2011 at 12:13:25PM +0200, Bj=F6rn Kalkbrenner wrote:
> Then i tried to
> "mount -o subvolumeid=3D256 /dev/mapper/root /home" (id of home subvo=
l)
> and the content of my home is back...

this is a known limitation and a fix is pending in Josef's development
tree

http://git.kernel.org/?p=3Dlinux/kernel/git/josef/btrfs-work.git;a=3Dco=
mmit;h=3D4fbb149dfc7454d0f233fa8e5b9167f3645c8fcc


"Btrfs: fix how we mount subvol=3D<whatever>

 We've only been able to mount with subvol=3D<whatever> where whatever =
was
 a subvol within whatever root we had as the default.  This allows us t=
o
 mount -o subvol=3Dpath/to/subvol/you/want relative from the normal
 fs_tree root.  Thanks,"

currently, the /home subvolume is searched inside the volume set by
'set-default'. When you change it to an alternative root snapshot, the
'/home' subvolume lookup fails as you've seen.

The patch changes it so that the subvolumes are always looked up to the
original default root subvolume (I don't know of a better name, interna=
l
id 5 or alse selectable by subvolid=3D0).


david

>=20
>=20
> My questions are:
>=20
> 1. where is the "original" root from today morning before i did
> set-default? Lost?
>=20
> 2. why can't i do "mount -o subvolume=3Dhome /dev/mapper/root /home"
> anymore? To be more exact, i can, but why is it empty and why is it
> working when i enter the subvolume id?
>=20
> 3. I am now using the snapshot /snapshots/20110902 but what is
> /snapshots/20110902 now and why is it still listed? It's empty?
>=20
> 4. can i now delete the snapshots/20110902 or will that drop my curre=
nt
> active working root?
>=20
> 5. can i rename snapshots, e.g. the snapshots/20110902 or "home" to
> "home-20110905"?
>=20
> 6. is my btrfs filesystem broken now and should i recreate the whole
> thing or is it safe to use it?
>=20
> Bye
> Bj=F6rn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
