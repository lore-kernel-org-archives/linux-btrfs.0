Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37815 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752280AbcIOURE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 16:17:04 -0400
Date: Thu, 15 Sep 2016 20:16:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        David Sterba <dsterba@suse.cz>, Waxhead <waxhead@online.no>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Is stability a joke? (wiki updated)
Message-ID: <20160915201657.GK7138@carfax.org.uk>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <20160912162747.GF16983@twin.jikos.cz>
 <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
 <CAJCQCtQUS-8F+pOtQ2VA9=j=-TGV=wOfj+3SnnMvY3HMTzd=9g@mail.gmail.com>
 <1ef8e6db-89a1-6639-cd9a-4e81590456c5@gmail.com>
 <CAJCQCtQq08bOpRbZq90wRLUGD62Rnqwx6vjJOv5hvPVwp=jz0w@mail.gmail.com>
 <24d64f38-f036-3ae9-71fd-0c626cfbb52c@gmail.com>
 <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WR+jf/RUebEcofwt"
In-Reply-To: <CAJCQCtR_hMPj8Nrf=U1L=WvDWq48Ns1K25p4JtKEJnVwb1231Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--WR+jf/RUebEcofwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 15, 2016 at 01:02:43PM -0600, Chris Murphy wrote:
> On Thu, Sep 15, 2016 at 12:20 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
> > 2. We're developing new features without making sure that check can fix
> > issues in any associated metadata.  Part of merging a new feature needs to
> > be proving that fsck can handle fixing any issues in the metadata for that
> > feature short of total data loss or complete corruption.
> >
> > 3. Fsck should be needed only for un-mountable filesystems.  Ideally, we
> > should be handling things like Windows does.  Preform slightly better
> > checking when reading data, and if we see an error, flag the filesystem for
> > expensive repair on the next mount.
> 
> Right, well I'm vaguely curious why ZFS, as different as it is,
> basically take the position that if the hardware went so batshit that
> they can't unwind it on a normal mount, then an fsck probably can't
> help either... they still don't have an fsck and don't appear to want
> one.
> 
> I'm not sure if the brfsck is really all that helpful to user as much
> as it is for developers to better learn about the failure vectors of
> the file system.
> 
> 
> > 4. Btrfs check should know itself if it can fix something or not, and that
> > should be reported.  I have an otherwise perfectly fine filesystem that
> > throws some (apparently harmless) errors in check, and check can't repair
> > them.  Despite this, it gives zero indication that it can't repair them,
> > zero indication that it didn't repair them, and doesn't even seem to give a
> > non-zero exit status for this filesystem.
> 
> Yeah, it's really not a user tool in my view...
> 
> 
> 
> >
> > As far as the other tools:
> > - Self-repair at mount time: This isn't a repair tool, if the FS mounts,
> > it's not broken, it's just a messy and the kernel is tidying things up.
> > - btrfsck/btrfs check: I think I covered the issues here well.
> > - Mount options: These are mostly just for expensive checks during mount,
> > and most people should never need them except in very unusual circumstances.
> > - btrfs rescue *: These are all fixes for very specific issues.  They should
> > be folded into check with special aliases, and not be separate tools.  The
> > first fixes an issue that's pretty much non-existent in any modern kernel,
> > and the other two are for very low-level data recovery of horribly broken
> > filesystems.
> > - scrub: This is a very purpose specific tool which is supposed to be part
> > of regular maintainence, and only works to fix things as a side effect of
> > what it does.
> > - balance: This is also a relatively purpose specific tool, and again only
> > fixes things as a side effect of what it does.

   You've forgotten btrfs-zero-log, which seems to have built itself a
reputation on the internet as the tool you run to fix all btrfs ills,
rather than a very finely-targeted tool that was introduced to deal
with approximately one bug somewhere back in the 2.x era (IIRC).

   Hugo.

> 
> Yeah I know, it's just much of this is non-obvious to users unfamiliar
> with this file system. And even I'm often throwing spaghetti on a
> wall.
> 
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Hugo Mills             | It's against my programming to impersonate a deity!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                              C3PO, Return of the Jedi

--WR+jf/RUebEcofwt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX2wG5AAoJEFheFHXiqx3ksDQQAJdvENc4JbfM7be7MS86Uvnj
sfXedt8+/fRTKO14TdWvQ3DnqBwLa4uqkE2wjzBq0ZjFc3P2vaQmaJgU0pgRzFwi
NxKtYwmpkjKdrZPYohKWlaayUkfzQ0y6kCwd0iijAB4XGsYChiVcxJGxLBlrTNWn
i9sLGtGk31/4vUqroJah07bEnMLcdUl7tzAmD5iODDCCzmuDk7rLbdhfH0Kscu++
EeVUNrgbmHWwYUvurvtYgVd73apmCRHrdNsdDsIQDNMNjzOeOzo0hVyeMvzdeLfj
bcrhht7UZB2HVT350Yl9DOyWV2d4Skoe0f31tu3k8Fz5b/atEQkJYGTZnrtAJ1TK
ff8HjOVBiIkubkccbIj6iQCnj1jMFDEQtZNF/Po4oADLukGUlcbx9MMeYWsBJlMA
jfzdAi7YlRcrF0a9nlIv0tGWkoGGu2bhaRne/wJIE6L3DwWqZY9Ap4Td26wxQTQp
oPlR2AwZiNj7hXquz6zEUgvcyTSMp7vFrTQBIOPPRWcnUokT02QyPEnEBCRw/Tpa
3AqmH5H3a9cbKIZsZqNc56pZd4tIX47oJZixXienal4/Yqsj+kvmPDKutCrEuFFg
d4wLeuiOEsFjb05xgxRtV8GBS3bXGZBa6iAITPoLSj1cykyXGMWj211hUBHUF9l4
wlmyea8y7TAv/4kDRRYq
=D0MW
-----END PGP SIGNATURE-----

--WR+jf/RUebEcofwt--
