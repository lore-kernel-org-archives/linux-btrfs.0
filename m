From: Josef Bacik <josef@redhat.com>
Subject: Re: BTRFS Linux kernel BUG
Date: Thu, 12 May 2011 11:40:13 -0400
Message-ID: <20110512154013.GB19041@dhcp231-156.rdu.redhat.com>
References: <1305211122.3072.3.camel@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305211122.3072.3.camel@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2011 at 04:38:42PM +0200, Sw=E2mi Petaramesh wrote:
> (Not sure if this list allows attachments, as the message I sent
> doesn't seem to have been dispatched. I resend without the attachment=
,
> available anyway at the URL below:)
>=20
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/781694
>=20
>=20
> On a BTRFS machine, the working Gnome session suddenly disappeared,
> replaced with a text screen displaying an ugly "kernel BUG" related t=
o
> BTRFS (see attached picture).
>=20
> I would have expected the system to be hanged, but no, pressing a key
> brought me back to my Gnome session, where I could shut the system do=
wn
> gracefully...
>=20

Did you happen to get dmesg from that?  It seems that you got disk erro=
rs while
writing out the supers, which points to a hardware problem, but having =
the full
dmesg would be good to say for sure.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
