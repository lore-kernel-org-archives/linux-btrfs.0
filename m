From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs/git question.
Date: Tue, 29 Nov 2011 10:22:06 -0500
Message-ID: <20111129152206.GL24338@shiny>
References: <af6c5f5cb5a1778a8d811e8293dfdd73@www.jots.org>
 <4ED43C30.50502@cfl.rr.com>
 <CAG1y0scuoKwH_MbQPGQKr5sYAXP_kB=j6FOMHgm2=EzPwAVL=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: "Ken D'Ambrosio" <ken@jots.org>, linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0scuoKwH_MbQPGQKr5sYAXP_kB=j6FOMHgm2=EzPwAVL=Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 09:33:37AM +0700, Fajar A. Nugraha wrote:
> On Tue, Nov 29, 2011 at 8:58 AM, Phillip Susi <psusi@cfl.rr.com> wrot=
e:
> > On 11/28/2011 12:53 PM, Ken D'Ambrosio wrote:
> >> Seems I've picked up a wireless regression, and randomly drop my W=
iFi
> >> connection with more recent kernels. =A0While I'd love to try to t=
rack down the
> >> issue, the sporadic nature makes it difficult. =A0But I don't want=
 to revert to a
> >> flat-out old kernel because of all the btrfs modifications. =A0Is =
it possible
> >> using git to add *just* btrfs patches to an older kernel?
> >
> > Sure: use git rebase to apply the patches to the older kernel.
>=20
> ... or use 3.1.2, and get ONLY fs/btrfs from Chris' for-linus tree,
> compile it out-of-tree, and use it to replace the original btrfs.ko.

If you're on a 3.1 kernel, you can pull my for-linus directly on top of
it with git pull.  I always keep a btrfs tree against the previous
kernel so that people can use the latest btrfs goodness without having
to use an rc kernel.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
