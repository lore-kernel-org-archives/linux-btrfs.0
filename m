Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1034C67879
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 00:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF3220858
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 00:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sSQlJvYS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BF3220858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbeJIHWT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 03:22:19 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42671 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725759AbeJIHWT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 03:22:19 -0400
Received: by mail-qk1-f193.google.com with SMTP id g20-v6so13180573qke.9
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2018 17:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BZZHxVlCzIUR5zjpP3CDgWoGbCrXhbEk4U4NQ0uzBvs=;
        b=sSQlJvYSR+D1myj9CH15jpPTyFJ+9ItiDvphJCZ8KuazXWuz7QF6bzmvuUwGUAXOd0
         8XoKeWtE6fFWyN8Ye4or4MYwgPswSkkYlzshvmGKPyjwjaEuuH1HNEZ9HtYvCuuEPHlY
         aSieqQPvrLByaMn4+taAXRKHLG8btIK5rjxuPAqhapVUVajhYaO3MJtiIBoY55q1kq2m
         +hT8wN8ILKGycH9cr3SWJDG1m7zu29h5OirGdR/qxqWxw6/VTSYwB3/s/SRH3NF5dyTh
         UXPMBzWvqBN6Hi2yFGN0mwBGqfTI/v1tSls/xNbQ8jvoNs+isHjmL0np9rlGLEN9tntY
         oFAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BZZHxVlCzIUR5zjpP3CDgWoGbCrXhbEk4U4NQ0uzBvs=;
        b=EoUe7q9HsWcN1jJIkvKm7jKeyRWeoY8Verh3hCGaLSBHc7iIE7Nql83/xCRaRE04UK
         eNNiTA/yiVTdjDydBrs4YcH6PVtdAG28LFkgex6dqVGV17BUfsxkadbjEcp0bsI7sfV2
         TQCwBKqGcOMXXRynllu7jEAY3XnyyhofJU9AI4wxfV8FapcEksq6a+up2hLj8EPHf2fq
         E06xxFQbykYIXixRu9iptt+Ok+7JCsi6zHFIU0uhkQ1VOrNq6+3vlFE2Gc6BdSILyJb7
         8xWA5LUr+WoqiKXz2ff4EFO7YZW8/Hb7KQomyunQ2XrWTR9tlod53vsK14QpLdSVghh0
         jq1A==
X-Gm-Message-State: ABuFfohfWEmHr+QdEJ8mORscAerHiuSLmS7wcI8vkOt226PZWBarghF0
        6jU/AvIZmWZWr26mBDhofkj8el0c
X-Google-Smtp-Source: ACcGV63BHr8WTvDe1DLlF9TYPESIIN08mTWyG/NoNMrWegjP3S3xv5trNRef8P84ZhCoSmWoGTP5rg==
X-Received: by 2002:a37:1f53:: with SMTP id f80-v6mr12649899qkf.109.1539043683951;
        Mon, 08 Oct 2018 17:08:03 -0700 (PDT)
Received: from DigitalMercury.dynalias.net (mtrlpq0313w-lp140-05-76-66-175-4.dsl.bell.ca. [76.66.175.4])
        by smtp.gmail.com with ESMTPSA id t22-v6sm9851426qtt.1.2018.10.08.17.08.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 17:08:03 -0700 (PDT)
Received: by DigitalMercury.dynalias.net (Postfix, from userid 1000)
        id 7DA8F246EAF0; Mon,  8 Oct 2018 20:08:02 -0400 (EDT)
Date:   Mon, 8 Oct 2018 20:08:02 -0400
From:   Nicholas D Steeves <nsteeves@gmail.com>
To:     Hugo Mills <hugo@carfax.org.uk>,
        Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: merge status of per-chunk degradable check [was Re: Which device is
 missing ?]
Message-ID: <20181009000801.lvyx4uv25wg66a3m@DigitalMercury.dynalias.net>
References: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
 <20181008161055.GB25913@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ry6geuznywx5zzxl"
Content-Disposition: inline
In-Reply-To: <20181008161055.GB25913@carfax.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--ry6geuznywx5zzxl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2018 at 04:10:55PM +0000, Hugo Mills wrote:
> On Mon, Oct 08, 2018 at 03:49:53PM +0200, Pierre Couderc wrote:
> > I ma trying to make a "RAID1" with /dev/sda2 ans /dev/sdb (or similar).
> >=20
> > But I have stranges status or errors=A0 about "missing devices" and I
> > do not understand the current situation :
[...]
>    Note that, since the main FS is missing a device, it will probably
> need to be mounted in degraded mode (-o degraded), and that on kernels
> earlier than (IIRC) 4.14, this can only be done *once* without the FS
> becoming more or less permanently read-only. On recent kernels, it
> _should_ be OK.
>=20
> *WARNING ENDS*

I think this was the patch that addressed this?:
  https://www.spinics.net/lists/linux-btrfs/msg47283.html
  https://patchwork.kernel.org/patch/7226931/

In my notes it wasn't present in <=3D 4.14.15, but my notes might be
wrong.  Does this patch resolve the one-shot -o degraded, reboot,
forever read-only behaviour, or is something else required?  When was
it merged?  Has it been or will it be backported to 4.14.x?  I'm
guessing 4.9.x is too far back, but it would be really nice to see it
there too :-)

Also, will this issue be resolved for linux-4.19?  If so I'd like to
update the Debian btrfs wiki with this good news :-)

Finally, is the following a valid workaround for users who don't have
access to a kernel containing this fix:

1. Make a raid1 profile volume (both data and metadata) with >=3D 3 disks.
2. Lose one disk.
3. Allocator continues to write raid1 chunks instead of single,
because it is still possible to write one chunk to two disks.
4. Thus reboot twice -> forever read-only averted?


Kind regards,
Nicholas

P.S. Please let me know if you'd prefer for me to shift this
documentation effort to btrfs.wiki.kernel.org.

--ry6geuznywx5zzxl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE4qYmHjkArtfNxmcIWogwR199EGEFAlu78V4ACgkQWogwR199
EGEo5RAApIBADwu+dnSZcrnXiLK3OZ71So/YClH+CntfKSkzNwipfO7G7Vex6ww+
qkgF0irFooPCSx2Klgnx9tbgHtfqshLk0GQ270n8imtIAQFuQcrcJywpclUehlZO
zPfBmBMLlsfSU7SmJ1I/3NV86FqgT7ZXuDhXXMYTvwZ3QXwPXhV51Xsjv7PFvm1R
HeaUoooEJvie+v8wnYt0rjlVelj58T0i9P0E96mrxTH2vKoIWaac0iy9x3GSRKnI
1IbJiACXXK99exCstp51GChKXvDkyGlXc+qPmiY3ErZKbJtHncZcGy5jAq7RIZJ+
O6OCJv0ki2VAXYBYIgqG+gbFvlM3KDwEAau3WVE0AyGg74n5b7DdPi96AK+7OUaJ
iewSKTXgcDR4Pu0XgmPZgU3ZDqnZIfQ182pyaVda2we3yHM6vn8iqkyQg0y8ZnKu
8PsK4N3INijtyfSeYFPt8QeH8CWLdfPT/qfXp4OYmhCScpCzwYapnzdl/zBvFZ+Q
Mf83CBsUOWFKu/TmdyH4KLLNnVpcv7nLNGSfhmhLbkTf3UoIhabQ4YEZXRBFK56A
WWlIT46fb3osdddnAdKRcD4yYkzkoyeeAUvpjNJPEX3yxcarzYklazCIHny/Uik5
+431IsOW3ARfFklUEkktD4WYbglMbXkRZPnP6EpjKLiedczETWM=
=eGtq
-----END PGP SIGNATURE-----

--ry6geuznywx5zzxl--
