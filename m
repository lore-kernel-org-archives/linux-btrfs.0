Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7051E1E16
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 01:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786323965; cv=none; b=j+NFQRuC/j5crDfFNrOW7st0bya2nI2XMHH4jMAJAX5XAbwx4gMjj6E6rU5dWtv8EV1rZO+kV6nQILB1VeHa2s0nEf1H87q26Oo0j86FyCAG+MAjl0gnCE2jlSghW+JW83nxZaLSHz7TW/2WJt8OTbo4lqAA7MUgVgNFsTZEtko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786323965; c=relaxed/simple;
	bh=1+Jxozt/c+gVC9Q/aBJLm3ndLQiyjijLsdUHSByKpRc=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=Gem8v7G20yQSZKQpWGNwyilSXNmqxnmo2YGTzpwR3Bx1iOyWA54WWnQV5d514E21RnvVcuERR4cXKUuuviAGjFsR1vGTPkQoPTeP6IWOkZVCpC5fMHvTAptgpcOusdbglD44oKFjrWdr0Y91JDWCE4FmNmhbKaOWJPE63gVKLBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Edpv3Fbb; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Edpv3Fbb"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-480033bdcf4so632045f8f.2
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 18:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786323962; x=1786928762; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YwBdWIC8LpxmljpOo8ln4NERWLIBzujjahBFAApuj/s=;
        b=Edpv3FbbN6hVRsFgfRZgm4gUHeJo0YanXKSIfztoBLbinjJXN0fEI+sruuv9V+W4ko
         EF+nCSxvLymhXegUUkEEIlMNRT3MytnHGP3UignFU7E1bySLE74hrEsBD3rrG9ecWGHL
         kRqzfxlx7nUIWKscMhQIAdJtjxuAp1SU1RzFZApKPHWtwXFFJggiagGXWWffCkLiMOqB
         r5W2j2Jd9vKLRJrpiyF1SMwKPkg2tc5vs4pHQ2H0HjUMB5bveT5pqHjf5Hhep6bZkPBI
         VsIScptgTK2wtLwWOIKeEJJUK7KL8yUtfQlb4JA2xI5W8hOMEvvMkfKZzPzb4FV6wNmG
         lk3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786323962; x=1786928762;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YwBdWIC8LpxmljpOo8ln4NERWLIBzujjahBFAApuj/s=;
        b=rQ9BnOgVrUfkKPds8uYV8uCykgSXSRZPPVfCY+g1IXKNm3VaTyZLlmQ93fntbcbRsQ
         n9oV7jdUNqH88Uw0v2ol8qEGwuakqF/xiE6WOU7PtgSDYcE2HlWL2qiYW6qrJ+KNpuAH
         CncXnEvl/gZQI+F714KEsIlBLf7+adfBOEZPOdaDYgfWgLjENYX0nrwS/HRmJjF5fjlM
         XxZidHnYO5Mj+xOLbfMEH9mU7u91UDkeO8m9hLmqPqxM86LtdxO/JV4hLVhz4S7JtaRO
         WxOrzo96eaIvaDAtly+I8wwx5O9TcqWiIJOdt7FDUVwyHgrHqr9j/swtzxWOViC4ak2Y
         Cztw==
X-Forwarded-Encrypted: i=1; AHgh+RpzH+8SQ86sbomHJVKzWxSh3UVB1rHhK3oxZLEZ5qtXkamJujWxes2k/yUxUcRAquq4Ct3+zuzTrL/VUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvejb5PKrLaohrkLUHBs3fTWM/yMG4IWvkYH4uS6qM7LPMcibQ
	XFVsZS2r5RD1YZATsgLnAFVhJVeAe8hYEhm9sErexH2QXo2imxxGHXEf
X-Gm-Gg: AR+sD10Lcp6iLsnnteLG3dDlunGNzetwzcChmMsrpoTqVOsrseoL/xV3jlU8cXJS+tG
	+bLjSE68kp2YVPcZc5jEYS8vVw4EYQT+t7axywMw6msjqCxgED8yEdExHj+rM/t/XYnyX4OFwvn
	BWURLRktEcLdXKQQCMWi7SRNIHga0tQFDhe6+Bk/u+eQM9XVSCNuxVo4CVgkotdNCu4zU+X3Qgx
	BdWCuO0px2QWOK+Qfgaz098hLyeaLnZ45WRhM1yb3h0zajMi8e3TQ84I/t2UnDBYF0EuKShpX5y
	51rylIgectaU7hen9hyNQuevVWZZaxnU9K0Jhx5iDXLdomlF18Z4Q0TZSfW8d9/6YVivgm2fXzF
	TsEXSETndD36m9gTbRc2DAQc62ZD0FcAN8benYg1UDhFRKjxM1SE0gwg3g886NCcplqd2OZjPGW
	AbNjp3KjRxVfOdED+C3O+lhiP/V1sc3qAf8UOGMyrhInY2wAMbkhB7cmg3
X-Received: by 2002:a05:6000:2585:b0:47f:90cb:630c with SMTP id ffacd0b85a97d-47fec512a47mr56657060f8f.8.1786323962136;
        Sun, 09 Aug 2026 18:06:02 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021ec565sm27181386f8f.22.2026.08.09.18.05.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 18:06:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=00122f5a9225e58786db33b3f6f9143d8242812818e970719b847dbd0acd;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 10 Aug 2026 03:05:57 +0200
Message-Id: <DKKUZT0LUJOI.RE9GG62MU6K3@gmail.com>
From: "koraynilay" <koray.fra@gmail.com>
To: "Qu Wenruo" <wqu@suse.com>, "Zygo Blaxell"
 <ce3g8jdj@umail.furryterror.org>
Cc: "koraynilay" <koray.fra@gmail.com>, "Qu Wenruo"
 <quwenruo.btrfs@gmx.com>, <clm@fb.com>, <dsterba@suse.com>,
 <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
 <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
 <ankbNtvLr3ZnFjEk@hungrycats.org>
 <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>
In-Reply-To: <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>

--00122f5a9225e58786db33b3f6f9143d8242812818e970719b847dbd0acd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Aug 10, 2026 at 2:51 AM CEST, Qu Wenruo wrote:
>>>>> So either option 2 or 3 would be fine to me. Although I personally pr=
efer
>>>>> option 3 a little more, just because it's much cleaner code wise.
>>>>
>>>> Option 2 preserves legacy behavior that is 12 years old now, and it
>>>> costs a single comparison in two 'if' statements.
>>>>
>>>> Option 3 makes an already confusing situation worse--it makes the
>>>> underspecified behavior change depending on kernel version.
>>>
>>> One should never rely on something not documented in the first place.
>>=20
>> Option 3 prevents existing mount-option compression level specifications
>> from working when the attribute agress with the mount option; otherwise,
>> they would be blocked by a btrfs.compression string that doesn't specify
>> a level.  That's a _regression_.
>
> Let me be this clear, the current one nor option 2 is not working either.
>
> If the current algo is different from the XATTR algo, it will be=20
> whatever random number clamped to the XATTR algo for the current code.
>
> This applies to the option 2 solution. When mount option changed, the=20
> level will suddenly change from whatever previous mount option to the=20
> default.

TBF, I can see how it could be useful (or rather, how it could be good
to have it as an option) to have some files with btrfs.compression=3D"zstd"
and then use -o compress=3D to decide on the fly how much compressed the
new data added to them should be.
Both are (read: will be, after the per-inode patch) 1 command away, but
there *might* be use-cases where mount is more suitable.


>>      https://wiki.tnonline.net/w/Btrfs/Compression
>
> The first URL doesn't even resolve here.
(for some reason it's down right now :(, it was up < 1 hour ago).

Best,
koraynilay

--00122f5a9225e58786db33b3f6f9143d8242812818e970719b847dbd0acd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCankj9gAKCRDmj22qf5IG
XOliAQClXyJBVdGPtdHsTPKFXVbTqpk26UFnG2Ai2xFpzRP3PAEAjsXtj/k4Y6KV
k7P1SWYiCZPEq97FLFk/GOHz6F+6NQ4=
=oMiJ
-----END PGP SIGNATURE-----

--00122f5a9225e58786db33b3f6f9143d8242812818e970719b847dbd0acd--
