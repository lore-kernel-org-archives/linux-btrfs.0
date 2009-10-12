From: jim owens <jowens@hp.com>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 12:16:39 -0400
Message-ID: <4AD35667.3020103@hp.com>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>	<4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru> <87my3y3r8u.fsf@faran.nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: =?UTF-8?B?UMOkciBBbmRlcnNzb24=?= <paran@lysator.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87my3y3r8u.fsf@faran.nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

P=C3=A4r Andersson wrote:
> I just ran into the max hard link per directory limit, and remembered
> this thread. I get EMLINK when trying to create more than 311 (not 27=
2)
> links in a directory, so at least the BUG() is fixed.
>=20
> What is the reason for the limit, and is there any chance of increasi=
ng
> it to something more reasonable as Mikhail suggested?
>=20
> For comparison I tried to create 200k hardlinks to the the same file =
in
> the same directory on btrfs, ext4, reiserfs and xfs:

what real-world application uses and needs this many hard links?

jim
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
