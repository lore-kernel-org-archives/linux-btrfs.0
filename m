From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Synching a Backup Server
Date: Mon, 10 Jan 2011 09:22:49 +0700
Message-ID: <AANLkTi=AmNOhK9+WdwoRTHi7HrFhOmGT8wV9N77yVH+s@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<201101061342.23991.CACook@quantum-sci.com>
	<AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
	<201101071720.08298.hka@qbs.com.pl>
	<4D29A033.7000803@chandlerfamily.org.uk>
	<AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
	<4D29D508.6080006@chandlerfamily.org.uk>
	<AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
	<20110109183030.GA29572@carfax.org.uk>
	<4D2A2128.2060508@chandlerfamily.org.uk>
	<20110109220101.GB29572@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110109220101.GB29572@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 10, 2011 at 5:01 AM, Hugo Mills <hugo-lkml@carfax.org.uk> w=
rote:
> =A0 There is a root subvolume namespace (subvolid=3D0), which may con=
tain
> files, directories, and other subvolumes. This root subvolume is what
> you see when you mount a newly-created btrfs filesystem.

Is there a detailed explanation in the wiki about subvolid=3D0? What
does "top level 5" in the output of "btrfs subvolume list" mean (I
thought "5" was subvolid for root subvolume)?

# btrfs subvolume list /
ID 256 top level 5 path maverick-base
ID 257 top level 5 path kernel-2.6.37

>
> =A0 The default subvolume is simply what you get when you mount the
> filesystem without a subvol or subvolid parameter to mount. Initially=
,
> the default subvolume is set to be the root subvolume. If another
> subvolume is set to be the default, then the root subvolume can only
> be mounted with the subvolid=3D0 mount option.

=2E.. and mounting with either subvolid=3D5 and subvolid=3D0 gives the =
same
result in my case.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
