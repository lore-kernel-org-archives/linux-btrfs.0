From: Francis Galiegue <fgaliegue@gmail.com>
Subject: Re: system crash at mounting of btrfs
Date: Wed, 13 Oct 2010 08:00:48 +0200
Message-ID: <AANLkTi=mNogcnL2qZ_v+WBYt3Voy=YWSdPwdd9_9Wb7p@mail.gmail.com>
References: <loom.20101007T155351-932@post.gmane.org>
	<20101008171635.GS4804@think>
	<loom.20101009T073143-310@post.gmane.org>
	<loom.20101009T150327-437@post.gmane.org>
	<20101011235525.GK22691@think>
	<loom.20101012T083638-169@post.gmane.org>
	<20101013004915.GM22691@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101013004915.GM22691@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 13, 2010 at 02:49, Chris Mason <chris.mason@oracle.com> wro=
te:
[...]
>
> I've got a utility that will wipe the log and get you mountable again=
=2E
> The intel drive should definitely support barriers, are you doing
> anything with LVM or raid or dm-crypt on top of it?
>

Not Intel related and I don't use dm-crypt, but I use btrfs on three
machines over RAID 1 (MD) + LVM, all with SATA disks (and I've learned
the lesson: write caching disabled on all drives). Are there ill
effects to such setups?


--=20
=46rancis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (St=C3=A9phane Faroult, in "Th=
e
Art of SQL", ISBN 0-596-00894-5)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
