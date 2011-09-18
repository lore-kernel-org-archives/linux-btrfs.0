From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Sun, 18 Sep 2011 10:55:49 -0400
Message-ID: <1316357705-sup-2667@shiny>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com> <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca> <20110918014608.GA16198@alboin.amr.corp.intel.com> <4E759DE5.3020907@oracle.com> <4E75AEFD.105@gmail.com> <8444301C-856F-44FA-94A3-D3583DFA0FFB@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jeff liu <jeff.liu@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <8444301C-856F-44FA-94A3-D3583DFA0FFB@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Jeff liu's message of 2011-09-18 06:33:38 -0400:
>=20
> =E5=9C=A8 2011-9-18=EF=BC=8C=E4=B8=8B=E5=8D=884:42=EF=BC=8C Marco Sto=
rnelli =E5=86=99=E9=81=93=EF=BC=9A
>=20
> > Il 18/09/2011 09:29, Jeff Liu ha scritto:
> >> Hi Andreas and Andi,
> >>=20
> >> Thanks for your comments.
> >>=20
> >> On 09/18/2011 09:46 AM, Andi Kleen wrote:
> >>=20
> >>>>> with an additional improvement if the offset is larger or equal=
 to the
> >>>>> file size, return -ENXIO in directly:
> >>>>>=20
> >>>>>                if (offset>=3D inode->i_size) {
> >>>>>                        mutex_unlock(&inode->i_mutex);
> >>>>>                        return -ENXIO;
> >>>>>                }
> >>>>=20
> >>>> Except that is wrong, because it would then be impossible to wri=
te sparse files.
> >>=20
> >> Per my tryout, except that, if the offset>=3D source file size, ca=
ll
> >> lseek(fd, offset, SEEK_DATA/SEEK_HOLE) against Btrfs will always r=
eturn
> >> the total file size rather than -ENXIO.  however, our desired resu=
lt it
> >> -ENXIO in this case, Am I right?
> >>=20
> >=20
> > Yes, ENXIO should be the operation result.
>=20
> Thanks for your kind confirmation.

Thanks everyone, I've put Jeff's last version of this in my queue.

-chris
