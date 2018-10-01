Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB010C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 20:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A382208AE
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 20:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="FtVfy0sQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A382208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbeJBDNt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 23:13:49 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:52140 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbeJBDNs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2018 23:13:48 -0400
Received: by mail-it1-f194.google.com with SMTP id 74-v6so191678itw.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2018 13:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=OKzf2l29c2TyvjzB+KXWVUGG1VFwBPKf6fOWETKmja0=;
        b=FtVfy0sQ6wWHJc0p8cXv+yLysG39R3JHIToA19f6EZD/JwjEMazbHgqQfuJM0S1fHZ
         UEXcLaRLCL9w2FqSQvJtSSPALCrZwrq/bbeYyXhW7PWdAGkG5F4qqmni6QUNm+dn0N3I
         iDhXJhbqv7TTLklyb0k2ImamO3s6r4OC3/1/+/K/LlbdiGm30hiKukZv3BAN3XdLDjfA
         uU5l0bNQiKXO6lg73VBz66YFkpFcOArhPOsh7G9JUk8GpMFm+4FGXHoRlon7aIgaISRV
         Cgo49qEEDye6Xk4tcN9o+mJsxuah5KTHvO03aM+4Gh0pUqI+EdO9RO7DKNa4L+IzgOZU
         mSnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=OKzf2l29c2TyvjzB+KXWVUGG1VFwBPKf6fOWETKmja0=;
        b=J7oj5qVg91pBTrm7Xnbtyzi+REimZIxYisNze4CNqS7S0soQi1u+kHT0vIph+ZY2jB
         vs4x4uBzu6xQPFwEsSWm/k3CtUtsP3V88Vraty22WixfkrIYQj/VmBF57DUOPCKhgXPc
         ysZT76rPOaLaMbY+oNwBeqMgNSjUmK3RS7mFyOmcDTSJY8Sz+Un9Az12dojMq6DyLNPy
         iSRIfTJ8vMLK2rNbsQd++kCGITokRd3OtFNzhjhJNjw1TQrJaugFccSvnPYy2Ia7fT7y
         oYakkT40s58Xk1iBRp6e6sQQSZIWQm+bZeJD3n/JObGZolAonzePbzP2ivplZhPPbCW7
         deTg==
X-Gm-Message-State: ABuFfoj0gFkFeX/ZLxi5uG8LkXGwKnNEjdV1DKUZkAdeDyanJzHzweNo
        6Uir5E3EfXPBaf05m1pX3OZ62g==
X-Google-Smtp-Source: ACcGV61Uqg5SsZfPjHf5Ngln48uxDd/gIaqMuHztlzoAppuUKfcK/Sx8PQwA74BovW5Zh245MRy18Q==
X-Received: by 2002:a24:4254:: with SMTP id i81-v6mr10920917itb.95.1538426053647;
        Mon, 01 Oct 2018 13:34:13 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id v3-v6sm5428723ita.6.2018.10.01.13.34.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Oct 2018 13:34:13 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <D2D8FCF8-165B-44DE-ABC6-39C22C6E9A10@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_AD5824B2-7767-49B9-8F0D-027147B06E22";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [patch] file dedupe (and maybe clone) data corruption (was Re:
 [PATCH] generic: test for deduplication between different files)
Date:   Mon, 1 Oct 2018 14:34:08 -0600
In-Reply-To: <20180921044013.GD11392@hungrycats.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, fdmanana@kernel.org,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
References: <20180820010932.GV2234@dastard> <20180820153349.GA4334@magnolia>
 <20180823125849.GF13528@hungrycats.org> <20180830062743.GF5631@dastard>
 <20180831051045.GI26989@hungrycats.org> <20180906083809.GF27618@dastard>
 <20180907035305.GJ26989@hungrycats.org> <20180910090646.GB5631@dastard>
 <20180919041203.GA11397@hungrycats.org> <20180921025931.GI16550@dastard>
 <20180921044013.GD11392@hungrycats.org>
X-Mailer: Apple Mail (2.3273)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--Apple-Mail=_AD5824B2-7767-49B9-8F0D-027147B06E22
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 20, 2018, at 10:40 PM, Zygo Blaxell =
<ce3g8jdj@umail.furryterror.org> wrote:
>=20
> On Fri, Sep 21, 2018 at 12:59:31PM +1000, Dave Chinner wrote:
>> On Wed, Sep 19, 2018 at 12:12:03AM -0400, Zygo Blaxell wrote:
> [...]
>> With no DMAPI in the future, people with custom HSM-like interfaces
>> based on dmapi are starting to turn to fanotify and friends to
>> provide them with the change notifications they require....
>=20
> I had a fanotify-based scanner once, before I noticed btrfs =
effectively
> had timestamps all over its metadata.
>=20
> fanotify won't tell me which parts of a file were modified (unless it
> got that feature in the last few years?).  fanotify was pretty useless
> when the only file on the system that was being modified was a 13TB
> VM image.  Or even a little 16GB one.  Has to scan the whole file to
> find the one new byte.  Even on desktops the poor thing spends most of
> its time looping over /var/log/messages.  It was sad.
>=20
> If fanotify gave me (inode, offset, length) tuples of dirty pages in
> cache, I could look them up and use a dedupe_file_range call to =
replace
> the dirty pages with a reference to an existing disk block.  If my
> listener can do that fast enough, it's in-band dedupe; if it doesn't,
> the data gets flushed to disk as normal, and I fall back to a scan of
> the filesystem to clean it up later.
>=20
>>>> e.g. a soft requirement is that we need to scan the entire fs at
>>>> least once a month.
>>>=20
>>> I have to scan and dedupe multiple times per hour.  OK, the =
first-ever
>>> scan of a non-empty filesystem is allowed to take much longer, but =
after
>>> that, if you have enough spare iops for continuous autodefrag you =
should
>>> also have spare iops for continuous dedupe.
>>=20
>> Yup, but using notifications avoids the for even these scans - you'd
>> know exactly what data has changed, when it changed, and know
>> exactly that you needed to read to calculate the new hashes.
>=20
> ...if the scanner can keep up with the notifications; otherwise, the
> notification receiver has to log them somewhere for the scanner to
> catch up.  If there are missed or dropped notifications--or 23 hours a
> day we're not listening for notifications because we only have an hour
> a day maintenance window--some kind of filesystem scan has to be done
> after the fact anyway.

It is worthwhile to mention that Lustre has a persistent Changelog =
record
that is generated atomically with the filesystem transaction that the =
event
happened in.

Once there is a Changelog consumer that registers itself with the =
filesystem,
along with a mask of the event types that it is interested in, the =
Changelog
begins recording all such events to disk (e.g. create, mkdir, setattr, =
etc.).
The Changelog consumer periodically notifies the filesystem when it has
processed events up to X, so that it can purge old events from the log.  =
It
is possible to have multiple consumers registered, and the log is only =
purged
up to the slowest consumer.

If a consumer hasn't processed logs in some (relatively long) time (e.g. =
many
days or weeks), or if the filesystem is otherwise going to run out of =
space,
then the consumer is deregistered and the old log records are cleaned =
up.  This
also notifies the consumer that it is is no longer active, and it has to =
do a
full scan to update its state for the events that it missed.

Having a persistent changelog is useful for all kinds of event =
processing,
and avoids the need to do real-time processing.  If the userspace daemon =
fails,
or the system is restarted, etc. then there is no need to rescan the =
whole
filesystem, which is important when there are many billions of files =
therein.


Cheers, Andreas






--Apple-Mail=_AD5824B2-7767-49B9-8F0D-027147B06E22
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAluyhMEACgkQcqXauRfM
H+BWYQ/8DICsYTat4NTNg3KCHvp3VYtGBF7gt7NdwgHHrDPm/vpxG+IK57c5OSIP
A0Y+nqaJDg5SFB+SyPoQVkVWc5hx8xJq1Ah97T6loRlZC36oiS8fY7QNVvBr8+oj
vyGlaMTBc9ghoPCQNkJdwbvGotiqSukaSNHuOMCmyacCGk8zCrN158Ifn/ccYUQM
tSvDyQgak34blxR7+pIfgPMmXyzN+Osqbv7sfR64D0KY36iQhD7gqlBWmwKysXhJ
lMEhE7ZL8POAicDlCGoFwhRN86q75wjwL6devxbT7QTQU2O6adG5lTUxYrxGcNRk
0xdbESZDfBbLTya5aWDVEIdmfeX/4BzSqulbVzcCdh0objS/LDYcByqjk/cIsCvH
4+ZmIWMbbY9A6cUZE69ud3QAzTmaADsNhHcWrMFoGZ2QB5XzIPbzCOUGXbEwNHp7
7Tn8LjD39vWO3o69lNeoW6QAGNJe1jBrYAKpdtOPDWjX4I1EaLJDJSgP6X9moNX8
RTJv6uGsGLY1CCFlVPKk6c50RJSAFozgvPNZlTTwXePK3uoGJ4vyrCTbr7fLyeZt
hatyrzcdqANE6rWTJ/a2wwF0K5c5SonWLaCXVW+PtXvB29InqLMFhSFQy4vchDUf
InMuj3PQ8GfFH4XrdQCZWmq+zgJSTNXGjTkSpcNTapC9vyjlp60=
=L0Ao
-----END PGP SIGNATURE-----

--Apple-Mail=_AD5824B2-7767-49B9-8F0D-027147B06E22--
