Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DF25921E4
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788888722; cv=none; b=ttHdEKHFLtjNF1QEs0UcG4D46tQS8ak+Bto7x/AQct5O/+UmtUd9wNAidIc009BKbtloUsrBDuczZh5Qt8+IaX4CEqVpCiVm41FSxdv2X0K1VQRGU+58fxh2SzO2SWtFJivu0GkHNjyph0CmrEENGyMEzgEYJ+hCspbLx5Ds1do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788888722; c=relaxed/simple;
	bh=m6JwC8CwNv622R1ifVTgXDAtbkT015TpXaYRWGTFoj8=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=t/3UxyVuAW56oeGoskFBgxilzXPcXBF83UoNbr8vD4Pj6yN87sVr12OQtkqH3qJ3817Q/6vjJU8OSGYb8Fk8RCKFLkM1i8/lM2dd1myCJW15HJQzP57JpWG8QbcZsBkkzd5M5RDXiZB2CTKxe+UdEjVGRbDRmixxj3ZQztu0L14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dbh9mL0y; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dbh9mL0y"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-66f883abfdcso4441216d50.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 10:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788888719; x=1789493519; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vieaupvYicdOwc6vZ9Uq8eozU0pYXl0O/LI23IN1ePg=;
        b=dbh9mL0ynCh8dYG3OgSz2bcpfXbxu4MNLWRG84PQ9lLJUEEKPiv+8vGubtWexB5f5X
         39qYACb8t0pZXJtdzjlapXdN/KeG7/ypNu4+Cug/Yqtqj68JvVqT81g4FHvkipWwBVr4
         SBC/Nsc9GT40MAs5ciw3dzHDvxlBgNQoKsI1n9/L9ufYfdchlKk1nKoEa3S/AE0B4diB
         ySVEayeXp6HJqtwl8pbLdSLSHDaBd9ovKFSUTMVnFxqBeI1cPuLznMVNd+2XZ475u5OJ
         +ZfGIxG7r27s94vhdEnSe7hJfEqKzsbgMvzvbQyYEdeFVHNCw7/gpxpbrMr/OT/56Fp5
         QX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788888719; x=1789493519;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vieaupvYicdOwc6vZ9Uq8eozU0pYXl0O/LI23IN1ePg=;
        b=aurG4YxCCc/IcC1afwljjAgIXmG4iuYvqOlMIc1EtpxBOc+43x15UxhJgBgoMyw9Al
         xri+RchlDyLionTU/RsFi0PaiazK8LBynyZUaD7kfuqclecdKay/qQ0s2OhI7yfqDaQL
         go5Lhrgw3zelP5VC+Lo5nWdkbzgVtgD9yItGUyb1LTjxSr2fiWLoWfmNqaS3lvAY9A43
         9f05AdfyuMbRTUNEf8Sqs7XXT2+4k5d+4V189odKOcgasWSij5Qg1z/kV0y0Kf8Ywrs4
         kLWKLRrQ8eT0+x7NE4hc3p438k2uLSXAQuj5umUuQEiSQ4bALZVB5RUf2JYI29dJq//b
         JgIg==
X-Forwarded-Encrypted: i=1; AKwUvBz5+MW9SbaXnz+9rfi1N2u8KjgPacfB/DxdEWbOoDDQOz3IDoLLHUsTC1VCaWiw4okOwVc4as4ECrBuAw==@vger.kernel.org
X-Gm-Message-State: AFuF++mpTY9tEccnGs0GX0yx3EHpr0S2Gw9M14nLA2P4UZzmg3NGcPBa
	lYUzdkCHxkoF47cklQZLquKUzilEkplZxlnHtWn7b+TB4GqGbQEnzqZSj7n3aw==
X-Gm-Gg: AYBFou3akFEDxVnq+1lLNB9/f0Ib+y1i04El7jrzthCTldQYGeUv+kzJl0PEEbroRBN
	RkXb09yeFK0ukeC8iTMcjxYYOodHAy9kP64lOBG0pwz2Khr+rLxAJj4JQBUSr6roiKhxeVjJr3q
	6qgG3gUce+jBRvg5QsA+rtG/D4mBcaF0eStxAk0nqz8DKyxs9mTYfLGbLoproau4W6WCxikzl8m
	HW33txSAPD+obiyRTaEZf5aGpzmvJRrKp5LVt9dCrJFg+tWj3GoW9YQopli25BDWIhHhACoYCH/
	1c+s/XthDLww2kdHsNpyIcIfu5ZEvzn+dPJsw25HbWHZGIcGpOsNkdVFuw0duNV1CDX+53dHb7v
	jbSu4lvl2UmKboqH3Kf5SZujia15nWOu2S1GbUl2CsXChJO6s+wYNMFP0ctJRwq3L9f8vOhbO2Q
	fXuDfwMPz7wxY2d/StOIfQW91tY7LDehdWw0wyU9X0+qXWLCxoWqOcmLyYKgzTdF5WIylO4pdAN
	l5Lq854CyjtIN4blEIONwi8qxHAXkwh4UjrphHwR2oyvaet
X-Received: by 2002:a53:e043:0:b0:66f:8d89:90c with SMTP id 956f58d0204a3-66fb5a9a1a4mr6897735d50.43.1788888719462;
        Tue, 08 Sep 2026 10:31:59 -0700 (PDT)
Received: from localhost (23-91-225-113.cpe.distributel.net. [23.91.225.113])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-9104067b125sm122750816d6.29.2026.09.08.10.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 10:31:58 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>, linux-btrfs@vger.kernel.org
Subject: Re: How to exclude other filesystems but include subvolumes?
In-Reply-To: <20260907103339.GA786966@tik.uni-stuttgart.de>
References: <20260907103339.GA786966@tik.uni-stuttgart.de>
Date: Tue, 08 Sep 2026 13:31:52 -0400
Message-ID: <87v78f6453.fsf@navis.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Ulli Horlacher <framstag@rus.uni-stuttgart.de> writes:

> Many programs like find, tar, rsync, cp, du, etc have options to exclude
> other filesystems, eg rsync:=20
>   --one-file-system, -x    don't cross filesystem boundaries
>
> But this also excludes subvolumes, which are in the same filesystem.

Yes, because subvolumes are boundaries.

> How can I address a btrfs filesystem with all subvolumes, but exclude
> other filesystems?
>
> Example: I want to copy the / filesystem (with all subvolumes), what is t=
he
> best solution (for scripting!)?

The best solution that I've found is to 'mount -o subvolid=3D5
$your_root_device /somewhere' (I think /btrfs-admin or /.btrfs-admin is
logical), where only the root user and the sudo group can read the
mountpoint, and only root can write to it.  I suspect you'll agree that
it's important to include the output of 'btrfs sub list -pta
$subvolid_5_mountpoint' in that backup (for use by humans) as well in
JSON format if you want to someday automate restoration of the subvolume
structure.  Ie:

  1. Mount a top-level view.
  2. List the subvolume structure and insure it ends up in you
  replicant.
  2.5: Optionally recreate the subvolume structure at the target.
  3. Replicate everything in one shot, without '--one-file-system, -x'.

Best,
Nicholas

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEE4qYmHjkArtfNxmcIWogwR199EGEFAmqgRogTHG5zdGVldmVz
QGdtYWlsLmNvbQAKCRBaiDBHX30QYRckEACZJvijyTQbVZE8YDnxfVQh0a8+x692
3aSUSrmsIH6ySxDsw9VY4aAIuqdm8D/0xH0+59b0NTxPsXHki6ogtjDZctM4t3EX
15lQ7vNN4G06w66q9qjMZs9q0QAnfrKHJgcdg7//8Li75tx9ISPolNrqodJpXz6m
q9W9eEyBkct1hK081RobUjbMSAI8NWS1Zx0uosQlXPudRNbXjnZ4FcT6Fx08Ki3C
RFSVWg//9IATcsOdHmMKMfAMAez+lyZKXIWXSxrqCykbMFzuEIkZaowl7yIZ4a2R
1WIYCB6gd5Y/4/nZh+1yV0FwjC+2R1yVRKIOaf5mYyIzzHiHClz6DFT8x09WdrPZ
mEYivsM2QFHdM7D2HZ2QhVENl9b12RwFpSPdNZjB8Fi59sOZnfVy5CKNe5HuIFy/
ZX0wW2eGibkFmTLLbGQ9KJwhzcU7a2l8IsVE9OasjDGh4Tspx6kk9XJPQWIiPUib
7mtqOtr2Jrj4vHbXEuTxcQLrMpUGg8PExsIyD6sn60u/+LbIj+OPPwbNX5rdQUDY
AwYOxXIh91T7LhUQLW6W6pWTTCI6CNHyfZ0Rj81hID3NLfLOO4TIVQjP0lsftlS0
dJlmDtRB0xCKbcWzGEnnRZqqLb2zkv7ElonLkaouEMK/daYKTRB2Awqn96xdZl3T
rhIqgH7c6tdLwg==
=Ai9s
-----END PGP SIGNATURE-----
--=-=-=--
