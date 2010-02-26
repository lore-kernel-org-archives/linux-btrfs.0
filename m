From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 16:10:50 -0500
Message-ID: <20100226211050.GN12841@think>
References: <20100225004004.GK25641@think>
 <20100225140420.4EBA940954@viridian.itc.virginia.edu>
 <69e11d1f1002251028s3df20904yb9e90be36c883bbe@mail.gmail.com>
 <20100226161332.GA12841@think>
 <20100226161523.GB12841@think>
 <69e11d1f1002261157x1b305776w96f6bfcef4b8ae2f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Gustavo Alves <gjalves@gjalves.com.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <69e11d1f1002261157x1b305776w96f6bfcef4b8ae2f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 04:57:27PM -0300, Gustavo Alves wrote:
> In my case, kernel 2.6.32-0.51.rc7.git2.fc13.i686.PAE and BTRFS under=
 LVM2.
>=20

Did you also have power-off based reboots?  Depending on the
configuration LVM (anything other than a single drive) won't send barri=
ers to
the device.

-chris

> ----
> Gustavo Junior Alves
> Specchio Solu=E7=F5es em TI
>=20
>=20
> On Fri, Feb 26, 2010 at 1:15 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
> > On Fri, Feb 26, 2010 at 11:13:32AM -0500, Chris Mason wrote:
> >> On Thu, Feb 25, 2010 at 03:28:19PM -0300, Gustavo Alves wrote:
> >> > I've got the same error before in a similar situation (24 partit=
ions,
> >> > only two with problems). Unfortunally I erased all data after th=
is
> >> > error. Strange that all I've done was shutdown and poweron the
> >> > machine.
> >>
> >> Basically it looks like the tree of data checksums isn't right. =A0=
Which
> >> kernels were you running when you had these problems?
> >
> > Sorry, I mixed up this corruption with one farther down. =A0The sam=
e
> > question stands though, this error generally means that IO either d=
idn't
> > happen or happened in the wrong place.
> >
> > So, the more details you can give about your config the easier it w=
ill
> > be to nail it down.
> >
> > -chris
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
