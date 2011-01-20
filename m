From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs, broken design?
Date: Thu, 20 Jan 2011 16:20:30 -0500
Message-ID: <1295558324-sup-1046@think>
References: <EC13E050-AA91-4DCA-B171-9CA55D537DB7@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?utf-8?q?Beno=C3=AEt_Thi=C3=A9bault?= <benoit.thiebault@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <EC13E050-AA91-4DCA-B171-9CA55D537DB7@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Beno=C3=AEt Thi=C3=A9bault's message of 2011-01-20 16:06:=
21 -0500:
> Hi everyone,
>=20
> I am very interested in the features provided by btrfs.
>=20
> I know it is still under active development and thus do not consider =
using it yet "in production", but the Wikipedia page describing btrfs c=
ontains a very frightening sentence:
> "Edward Shiskin, one of the Reiser4 developers now working for Redhat=
, got asked in Q2/2010 to look more detailled into Btrfs and judged tha=
t it has a broken design. This design may lead in some cases to out of =
space problems."
>=20
> I have read the linked mail exchange in the mailing list but it is ve=
ry technical and I am not quite sure I understood everything. Could you=
 please tell me if the problem has been fixed since?

There was a bug fixed as part of that discussion, and I think I also
better described the way the tree balancing works to Edward.

>=20
> Is there a planned date for the final release of btrfs?

A final release?  We'll keep improving things for a long time.  The
biggest missing feature today is btrfsck, which I'm working on full tim=
e
right now.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
