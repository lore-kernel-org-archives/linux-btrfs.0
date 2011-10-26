From: Sage Weil <sage@newdream.net>
Subject: Re: ceph on btrfs [was Re: ceph on non-btrfs file systems]
Date: Wed, 26 Oct 2011 09:32:09 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1110260929140.18909@cobra.newdream.net>
References: <CAO47_-9L7SdQwhJ27B6yzrqG8xvj+CeZHeSutgeCixcv7kUidg@mail.gmail.com>
 <Pine.LNX.4.64.1110252221510.6574@cobra.newdream.net>
 <CAO47_--RTCNYP1s6O-jjjd_spT2=RrDJjBegd1S3YKz=on2YnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="557981400-300933238-1319646729=:18909"
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christian Brunner <chb@muc.de>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <CAO47_--RTCNYP1s6O-jjjd_spT2=RrDJjBegd1S3YKz=on2YnQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--557981400-300933238-1319646729=:18909
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 26 Oct 2011, Christian Brunner wrote:
> 2011/10/26 Sage Weil <sage@newdream.net>:
> > On Wed, 26 Oct 2011, Christian Brunner wrote:
> >> >> > Christian, have you tweaked those settings in your ceph.conf? =A0=
It would be
> >> >> > something like 'journal dio =3D false'. =A0If not, can you verify=
 that
> >> >> > directio shows true when the journal is initialized from your osd=
 log?
> >> >> > E.g.,
> >> >> >
> >> >> > =A02011-10-21 15:21:02.026789 7ff7e5c54720 journal _open dev/osd0=
=2Ejournal fd 14: 104857600 bytes, block size 4096 bytes, directio =3D 1
> >> >> >
> >> >> > If directio =3D 1 for you, something else funky is causing those
> >> >> > blkdev_fsync's...
> >> >>
> >> >> I've looked it up in the logs - directio is 1:
> >> >>
> >> >> Oct 25 17:20:16 os00 osd.000[1696]: 7f0016841740 journal _open
> >> >> /dev/vg01/lv_osd_journal_0 fd 15: 17179869184 bytes, block size 409=
6
> >> >> bytes, directio =3D 1
> >> >
> >> > Do you mind capturing an strace? =A0I'd like to see where that blkde=
v_fsync
> >> > is coming from.
> >>
> >> Here is an strace. I can see a lot of sync_file_range operations.
> >
> > Yeah, these all look like the flusher thread, and shouldn't be hitting
> > blkdev_fsync. =A0Can you confirm that with
> >
> > =A0 =A0 =A0 =A0filestore flusher =3D false
> > =A0 =A0 =A0 =A0filestore sync flush =3D false
> >
> > you get no sync_file_range at all? =A0I wonder if this is also perf lyi=
ng
> > about the call chain.
>=20
> Yes, setting this makes the sync_file_range calls go away.

Okay.  That means either sync_file_range on a regular btrfs file is=20
triggering blkdev_fsync somewhere in btrfs, there is an extremely sneaky=20
bug that is mixing up file descriptors, or latencytop is lying.  I'm=20
guessing the latter, given the other weirdness Josef and Chris were=20
seeing.  :)

> Is it safe to use these settings with "filestore btrfs snap =3D 0"?

Yeah.  They're purely a performance thing to push as much dirty data to=20
disk as quickly as possible to minimize the snapshot create latency. =20
You'll notice the write throughput tends to tank when them off.

sage
--557981400-300933238-1319646729=:18909--
