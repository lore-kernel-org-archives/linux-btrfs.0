Return-Path: <SRS0=BvJc=RS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A31C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 05:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F12EE21872
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Mar 2019 05:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfCOF2w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Mar 2019 01:28:52 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:47928 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727152AbfCOF2w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Mar 2019 01:28:52 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id A93BD262512; Fri, 15 Mar 2019 01:28:45 -0400 (EDT)
Date:   Fri, 15 Mar 2019 01:28:45 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Christoph Anton Mitterer <calestyo@scientia.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
Message-ID: <20190315052827.GH23918@hungrycats.org>
References: <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org>
 <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
 <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
 <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
 <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
 <20190215054031.GC9995@hungrycats.org>
 <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
 <20190307200712.GG23918@hungrycats.org>
 <beebed47702d783e00d3478f217ffc646d47bb92.camel@scientia.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7J16OGEJ/mt06A90"
Content-Disposition: inline
In-Reply-To: <beebed47702d783e00d3478f217ffc646d47bb92.camel@scientia.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--7J16OGEJ/mt06A90
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2019 at 07:58:45PM +0100, Christoph Anton Mitterer wrote:
> Phew... too much [silent] corruption bugs in btrfs... :-(
>=20
> Actually I didn't even notice the others (which unfortunately doesn't
> mean I'm definitely not affected), so I probably cannot much do/check
> about them now... but only about the "recent" one that was fixed now.
>=20
> But maybe there should be something like a btrfs-announce list, i.e. a
> low volume mailing list, in which (interested) users are informed about
> more grave issues.
> Such things can happen and there's no one to blame about that... but if
> they happen it would be good for users to get notified so that they can
> check their systems and possibly recover data from (still existing)
> other sources.

I don't know if it would be a low-volume list...every kernel release
includes fixes for _some_ exotic corner case.

> What about the direct IO issues that may be still present and which
> you've mentioned above... is this used somewhere per default / under
> normal circumstances?

Direct IO is an odd case because it's not all that well understood
what the correct behavior is.  You can't prevent the kernel from making
copies of data and also expect full data integrity and also lock-free
performance, all at the same time.  Pick any two, and pay for it with
losses in the third.

The bug fixes here are more along the lines of "OK so you're using direct
IO which means you've basically admitted you don't care about *your* data,
let's try not to corrupt *other* data on the filesystem at the same time."

> I think by now I'm pretty confident that I, personally, am safe.

It took me two years to find this bug, and I had to write a tool to
encounter it often enough to notice.  A lot of people are safe.

> > If you had asked questions like "is this bug the reason why I've been
> > seeing random SHA hash verification failures for several years?" then
> > you should worry about this bug; otherwise, it probably didn't affect
> > you.
>=20
> I think you're right... but my data with many thousands of pictures,
> etc. from all life is really precious to me, so I better wanted to
> understand the issue in "depth"... and I think these questions and your
> answers may still benefit others who may also want to find out whether
> they could have been silently affected :-)

I found the 2017 compression bug in a lot of digital photographs.
It turns out that several popular cameras (including some of the ones I
own) put a big chunk of zeros near the beginnings of JPG files, and when
rsync copies those it will insert a hole instead of copying the zeros.
The 2017 bug affected "ordinary" holes so standard tools like cp and
rsync could trigger it.  Most photo tools ignore this data completely,
so when garbage appears there, nobody notices.

A similar thing happens to .o files:  ld aligns things to 4K block
boundaries, triggering the 2017 compressed read bug.  Nobody reads that
data either--it's just alignment padding.

I don't think I found an application that cared about the 2017 bug at all.
Only backup verifications.

The 2018 bug is a different story--when it hits, it's obvious, and
ordinary application things break--but it won't happen to typical photo
image files, even with aggressive dedupe.

>=20
> Cheers and thanks,
> Chris.
>=20
>=20

--7J16OGEJ/mt06A90
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXIs39wAKCRCB+YsaVrMb
nGIRAKDPzaTtxGj8vH026bzkUVCVbq6O4wCfWzRmgTh3shOmzv25DzLRnNQ1MCU=
=d3Yb
-----END PGP SIGNATURE-----

--7J16OGEJ/mt06A90--
