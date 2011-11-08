From: Chris Mason <chris.mason@oracle.com>
Subject: Re: corrupted btrfs after suspend2ram uncorrectable with scrub
Date: Tue, 8 Nov 2011 12:20:43 -0500
Message-ID: <20111108172043.GH4954@shiny>
References: <CANkykrA7uxc51rFTbTXar8v_3vE2Gn9LKYrApOfvqWNf5B_adw@mail.gmail.com>
 <orzkgfwlom.fsf@livre.localdomain>
 <CANkykrBn0Ed6B25UzRkvs6cKebTvhpqOW79F1UEc_2uMumqCQA@mail.gmail.com>
 <CANkykrCfvFH_fg+5vJVkoWgcPuFp6euzVxZPTRDf=U+qrYUipA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-btrfs@vger.kernel.org
To: Gustavo Sverzut Barbieri <barbieri@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANkykrCfvFH_fg+5vJVkoWgcPuFp6euzVxZPTRDf=U+qrYUipA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2011 at 03:08:41PM -0200, Gustavo Sverzut Barbieri wrot=
e:
> On Tue, Nov 1, 2011 at 9:20 PM, Gustavo Sverzut Barbieri
> <barbieri@gmail.com> wrote:
> > On Tue, Nov 1, 2011 at 7:57 PM, Alexandre Oliva <oliva@lsd.ic.unica=
mp.br> wrote:
> >> Hi, Gustavo,
> >>
> >> On Nov =A01, 2011, Gustavo Sverzut Barbieri <barbieri@gmail.com> w=
rote:
> >>
> >>> =A0 btrfs csum failed ino 2957021 extent 85041815552 csum 6673106=
79
> >>> wanted 0 mirror 0
> >>
> >>> Is there any way to recover it? =A0:-S
> >>
> >> Did you try mounting without data checksums?
> >
> > Just tried to mount with -o nodatasum, no luck. Is that enough?
>=20
> Ideas? Should I give up and consider data lost? :-(

We actually check the crcs even when mounted with nodatasum.  Can you
give the restore tool a shot from my current btrfs-progs git repo?  If
it can read it we can find a way to get the files off.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
