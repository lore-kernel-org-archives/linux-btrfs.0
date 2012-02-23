From: "Matthias G. Eckermann" <mge@suse.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 23 Feb 2012 15:09:43 +0100
Message-ID: <20120223140943.GA18618@suse.com>
References: <4E4B2452.9070407@oracle.com> <1483419.CO5JBoDgFX@bursa22> <4F462ADE.4040507@oracle.com> <CAG1y0sddAf4zdvj82Xx-H0_YH8ssyzmtOJ1-+sUVnRUJM4+gTw@mail.gmail.com>
Reply-To: "Matthias G. Eckermann" <mge@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Hubert Kario <hka@qbs.com.pl>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: "Fajar A. Nugraha" <list@fajar.net>,
	Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sddAf4zdvj82Xx-H0_YH8ssyzmtOJ1-+sUVnRUJM4+gTw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

On 2012-02-23 T 19:13 +0700 Fajar A. Nugraha wrote:
> On Thu, Feb 23, 2012 at 7:02 PM, Anand Jain wrote:
>=20
> > and what you will notice is autosnap snapshots =C2=A0are named
> > using uuid.
> >
> > =C2=A0Main reason to drop time-stamp based names is that,
> > =C2=A0 =C2=A0- test (clicking on Take-snapshot button) which took m=
ore
> > =C2=A0than one snapshot per second was failing.
> > =C2=A0 =C2=A0- a more descriptive creation time is available using =
a =C2=A0
> > command line option as in the example below.
> > =C2=A0-----
> > =C2=A0# btrfs su list -t tag=3D@minute,parent=3D/btrfs/sv1 /btrfs
> > =C2=A0/btrfs/.autosnap/6c0dabfa-5ddb-11e1-a8c1-0800271feb99 Thu Feb=
 23 13:01:18 2012 /btrfs/sv1 @minute
> > =C2=A0/btrfs/.autosnap/5669613e-5ddd-11e1-a644-0800271feb99 Thu Feb=
 23 13:15:01 2012 /btrfs/sv1 @minute
> > =C2=A0-----
> > =C2=A0As of now code for time-stamp as autosnap snapshot name is
> > =C2=A0commented out, if more people wanted it to be a time-stamp
> > =C2=A0based names, I don't mind having that way. Please do let me
> > know.
>=20
> For me the main bonus point of having timestamp in names in
> the abiility to sort it by creation date by simply using "ls".
> As for the more-than-one-click-per-second problem, in my
> script I simply let it fail and return informative-enough
> error message.
>=20
> A workaround would be adding nanosecond timestamp, or put the
> UUID AFTER the time stamp, e.g:
> /btrfs/.autosnap/@minute_20120223_131501_123456_5669613e-5ddd-11e1-a6=
44-0800271feb99

I wonder, if this is not mixing several aspects / requirements:
1. unique snapshot numbering
2. storing the time stamp of a snapshot
3. human visible order of snapshots

Thus we have chosen a different solution in our "snapper"
approach (as announced here in Aug 2011):
- the snapshot number is a simple integer
  -> human visible order of snapshots
- all metadata is stored in an XML file associated to
  this snapshot
- this requires that the btrfs snapshot itself is
  in a subdirectory of the snapshot-numbered directory.

Example:

----------------------------< snip >----------------------------

2012-02-23 15:02 (0) ~
naxos root (5)  # tree -x /.snapshots/6/
/.snapshots/6/
|-- filelist-5.txt
|-- info.xml
`-- snapshot

2012-02-23 15:02 (0) ~
naxos root (5)  # cat /.snapshots/6/info.xml
<?xml version=3D"1.0"?>
<snapshot>
  <type>post</type>
  <num>6</num>
  <date>2012-02-23 11:32:59</date>
  <pre_num>5</pre_num>
  <cleanup>number</cleanup>
</snapshot>

----------------------------< snap >----------------------------

With introducing a store for meta information, the requirements
listed above (1-3) can be fulfilled.

Shouldn't the autosnap implementation include a similar
option and/or functionality? Or does it already?

=46eel free to copy what snapper does:)

so long -
	MgE

P.S.: For those interested in the details: snapshots 5 and 6 are
a pre-post-pair, which enclose the real action: a timezone
change.  "filelist-5.txt" contains the file which differ between
5 and 6 for faster access from the management layer.

--=20
Matthias G. Eckermann     Senior Product Manager   SUSE=C2=AE Linux Ent=
erprise
Phone: +49 30 44315731    Mobile: +49 179 2949448        Twitter: mge15=
12
SUSE LINUX Products GmbH  Maxfeldstra=C3=9Fe 5          90409 N=C3=BCrn=
berg Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer, HRB 16746 (AG N=C3=
=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
