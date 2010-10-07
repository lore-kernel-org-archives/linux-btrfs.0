From: Francis Galiegue <fgaliegue@gmail.com>
Subject: Can you please define "snapshot" and "subvolume"?
Date: Thu, 7 Oct 2010 13:39:41 +0200
Message-ID: <AANLkTimBsVGS=eJvpdf2Sq_Dg76zQRgy=E+3089zQ9D4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have difficulties grabbing these two concepts.

As far as I can tell, a snapshot is an instant, synchronized,
photography of the filesystem at a given point in time; a subvolume is
a "subroot" to a btrfs filesystem.

While I fully understand (and use) the purpose of snapshots, I don't
quite fathom the use case for subvolumes, apart from btrfs-convert...
Why has btrfs grown such a feature in the first place? Can someone
give me a use case for them?

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
