From: Sage Weil <sage@newdream.net>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Tue, 25 Oct 2011 15:27:03 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1110251526360.32603@cobra.newdream.net>
References: <Pine.LNX.4.64.1110231739380.25255@cobra.newdream.net>
 <CAO47_-9jp===DT=scpe=U8BnPnUCAVz7xUWVCC9AMVmx67CdaA@mail.gmail.com>
 <Pine.LNX.4.64.1110240941500.15349@cobra.newdream.net>
 <20111024195147.GB31264@dhcp231-156.rdu.redhat.com>
 <CAO47_-_=1uLV34WAAHFhv6z7fDmtY8L-+HUzfu=WcHNatbvxJQ@mail.gmail.com>
 <20111025122320.GA3703@dhcp231-156.rdu.redhat.com>
 <Pine.LNX.4.64.1110250932140.20108@cobra.newdream.net>
 <CAO47_-9O0KzhGn_yskGYFMf8PH8APHg5BPbq98KFAU2RaYQYtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-1943522348-1319581623=:32603"
Cc: Josef Bacik <josef@redhat.com>, ceph-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_-9O0KzhGn_yskGYFMf8PH8APHg5BPbq98KFAU2RaYQYtw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-1943522348-1319581623=:32603
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 25 Oct 2011, Christian Brunner wrote:
> 2011/10/25 Sage Weil <sage@newdream.net>:
> > On Tue, 25 Oct 2011, Josef Bacik wrote:
> >> At this point it seems like the biggest problem with latency in ceph-o=
sd
> >> is not related to btrfs, the latency seems to all be from the fact tha=
t
> >> ceph-osd is fsyncing a block dev for whatever reason.
> >
> > There is one place where we sync_file_range() on the journal block devi=
ce,
> > but that should only happen if directio is disabled (it's on by default=
).
> >
> > Christian, have you tweaked those settings in your ceph.conf? =A0It wou=
ld be
> > something like 'journal dio =3D false'. =A0If not, can you verify that
> > directio shows true when the journal is initialized from your osd log?
> > E.g.,
> >
> > =A02011-10-21 15:21:02.026789 7ff7e5c54720 journal _open dev/osd0.journ=
al fd 14: 104857600 bytes, block size 4096 bytes, directio =3D 1
> >
> > If directio =3D 1 for you, something else funky is causing those
> > blkdev_fsync's...
>=20
> I've looked it up in the logs - directio is 1:
>=20
> Oct 25 17:20:16 os00 osd.000[1696]: 7f0016841740 journal _open
> /dev/vg01/lv_osd_journal_0 fd 15: 17179869184 bytes, block size 4096
> bytes, directio =3D 1

Do you mind capturing an strace?  I'd like to see where that blkdev_fsync=
=20
is coming from.

thanks!
sage
--557981400-1943522348-1319581623=:32603--
