From: Josef Bacik <josef@redhat.com>
Subject: Re: BTRFS deduplication
Date: Thu, 12 May 2011 11:41:35 -0400
Message-ID: <20110512154135.GC19041@dhcp231-156.rdu.redhat.com>
References: <1305179540.3106.8.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305179540.3106.8.camel@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2011 at 07:52:20AM +0200, Sw=E2mi Petaramesh wrote:
> Hi again list,
>=20
> I've seen in a message dating back to january that offline deduplicat=
ion
> has been implemented in BTRFS, but I can't find it in my btrfs-tools
> 0.19+20100601-3ubuntu2
>=20
> Has it reached release, or not yet ? How could I give it a try ?
>=20
> I've seen a discussion about whether deduplication should be made
> offline or online ; my usage case it to backup a number of laptops
> having all about the same software and many files in common, to a sin=
gle
> backup server using rsync, I would be very much interested in online
> deduplication - because I don't have "n" times the storage space, tha=
t
> offline dedup might temporarily need, and because performance isn't
> crucial for this application, as backups can be done overnight...
>=20
> Thanks in advance :-)
>=20

So the btrfs-progs patch only exists on the mailing list and the kernel=
 patch is
sitting in my git tree.  This was more of a weekend project and less of=
 a
serious attempt at an actual solution.  It could be cleaned up and actu=
ally
used, but I'm not at all interested in doing that :).  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
