From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous
	requests
Date: Sat, 22 May 2010 10:02:17 -0400
Message-ID: <20100522140217.GS32248@dhcp231-156.rdu.redhat.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com> <1274461422-18433-3-git-send-email-josef@redhat.com> <AANLkTikwPL8-WefVIMF1ldTZpWVHvS1Lbh4YB8MZ4eu0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@infradead.org, akpm@linux-foundation.org
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTikwPL8-WefVIMF1ldTZpWVHvS1Lbh4YB8MZ4eu0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 21, 2010 at 06:47:36PM -0700, Mike Fedyk wrote:
> On Fri, May 21, 2010 at 10:03 AM, Josef Bacik <josef@redhat.com> wrot=
e:
> > Btrfs cannot handle having logically non-contiguous requests submit=
ted. =A0For
> > example if you have
> >
> > Logical: =A0[0-4095][HOLE][8192-12287]
> > Physical: [0-4095] =A0 =A0 =A0[4096-8191]
> >
> > Normally the DIO code would put these into the same BIO's. =A0The p=
roblem is we
> > need to know exactly what offset is associated with what BIO so we =
can do our
> > checksumming and unlocking properly, so putting them in the same BI=
O doesn't
> > work. =A0So add another check where we submit the current BIO if th=
e physical
> > blocks are not contigous OR the logical blocks are not contiguous.
> >
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >
> > V1->V2
> > -Be more verbose in the in-code comment
> >
> > =A0fs/direct-io.c | =A0 20 ++++++++++++++++++--
> > =A01 files changed, 18 insertions(+), 2 deletions(-)
> >
>=20
> Btrfs has been pretty much self-contained (working well compiled
> against 2.6.32 for example).  Is there a way that this wouldn't just
> start silently breaking for people compiling the latest btrfs with
> dkms against older kernels?

Nope, you have to have these generic patches for DIO to work, so buildi=
ng btrfs
like this will stop working with earlier kernels.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
