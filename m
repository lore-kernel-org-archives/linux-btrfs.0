Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E88E0C43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 15:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEEB320C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 15:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEEB320C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbeJAW1r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:27:47 -0400
Received: from sandeen.net ([63.231.237.45]:34958 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbeJAW1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 18:27:47 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 41B682AEC;
        Mon,  1 Oct 2018 10:49:20 -0500 (CDT)
Subject: Re: cross-fs copy support
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, Joshi <joshiiitr@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
Date:   Mon, 1 Oct 2018 10:49:19 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9UjKmgcLzBeTqjtP1UIvfHakosmYM3iHX"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9UjKmgcLzBeTqjtP1UIvfHakosmYM3iHX
Content-Type: multipart/mixed; boundary="Of3BxTUPGojsV2HfXW7xCSdriW3b0WC0K";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Joshi <joshiiitr@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org
Message-ID: <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
Subject: Re: cross-fs copy support
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
In-Reply-To: <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>

--Of3BxTUPGojsV2HfXW7xCSdriW3b0WC0K
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/1/18 9:48 AM, Qu Wenruo wrote:
>=20
>=20
> On 2018/10/1 =E4=B8=8B=E5=8D=8810:32, Joshi wrote:
>> I was wondering about the cross-fs copy through copy_file_range.
>=20
> The term "cross-fs" looks pretty confusing.
>=20
> If you mean "cross-subvolume", then it should work without problem in b=
trfs.
>=20
> If you mean reflink across two different file systems (not matter the
> same fs type or not).
> Then it's impossible to work.

I believe Joshi is talking about vfs_copy_file_range() not
vfs_clone_file range(), although _copy_ does call _clone_ if it can.

> Reflink (clone_file_range) works by inserting data pointers into the
> filesystem other than really copying the data.
> Thus if the source is outside of the fs, it's really impossible to work=
,
> as the source pointer/data is completely out of control of the dest fs.=


Yes, I would expect there to be problems with his modified kernel
for a filesystem that supports clone_file_range, because
vfs_copy_file_range() will clone if possible, and this should fail across=

filesystems.

In general, though, I don't know for sure why we don't fall back to
do_splice_direct() across filesystems, although the filesystems that
implement their own ->copy_file_range ops may have their own,
further restrictions within their implementations.

This call /is/ documented in the manpage as only being valid for
files on the same filesystem, though:
http://man7.org/linux/man-pages/man2/copy_file_range.2.html

-Eric


--Of3BxTUPGojsV2HfXW7xCSdriW3b0WC0K--

--9UjKmgcLzBeTqjtP1UIvfHakosmYM3iHX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAluyQgAACgkQIK4WkuE9
3uCwcg//dXNLuozv1pIWO7q7BXNSK5nO1F9jicwp/Ulkv+0iGDhWWx0kar9IEbvi
vXL7WgLbTHUCrlXr7rbwi8aGZH/ySPAPDwG/PuIbMVMIJzrfg6vvhtieGcB2lW6T
deVYw/10a/xOS4y1CyVsGMJ9FlsVIhwKeiHH6oqaU3hSDmZs4CQBgc4Tsz4elQFs
RjHjDxlEl0EH8kMsYl9HCQ8abgGePZrr1bcvWbi67HznpqHs/7FlZHkJNQcRwH7+
4yKpvBq+/08jtEiirJODxH9FQeG8iOIzWgn3/0zTcXA/qzOIl/kae0VRtj4j2Ej4
yhz0UtM3v2ldTgDrEQmD++3yadgLVx6yteoDc+nvCAvaJ2VaVpkJjOhtHQ0Xy8Zt
0IVyi3aLYj9NCjHUb1n86Xw17owuXwqmEmN3oaQ4GW7jvltbE7NoP6drhiDBLp9x
mMBLV9UMnPwBJgmV1fGhW82Qm7NHh8VqZOZhwaq8/BRn2+36Rcoowe+7NLZft7Ex
H8m0mic89HLCvspjFFsSbd0oJQtrlEC6EH25azRKO/4JE2NESgFsyxJf4FYMgw4/
g4LLsF8Ap5rHUvwLDeXvEGCwyY+zpvq6IWE6GFX78qLpdbbJ330Gs66zTcjuCuAU
7bADElcmZ9Z3zQgyuImeNqo+tXlFy2yVqKelwAHTtXaRTyJnN2k=
=X76r
-----END PGP SIGNATURE-----

--9UjKmgcLzBeTqjtP1UIvfHakosmYM3iHX--
