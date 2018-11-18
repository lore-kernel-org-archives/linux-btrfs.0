Return-Path: <SRS0=WB35=N5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB093C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Nov 2018 19:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B57D20817
	for <linux-btrfs@archiver.kernel.org>; Sun, 18 Nov 2018 19:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seblu.net header.i=@seblu.net header.b="bGNtVuSN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B57D20817
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=seblu.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbeKSGFU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 01:05:20 -0500
Received: from mail.seblu.net ([212.129.28.29]:44800 "EHLO mail.seblu.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbeKSGFU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 01:05:20 -0500
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2018 01:05:19 EST
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 84C4352E07BD
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Nov 2018 20:37:13 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id gFQXzEtxe7pC for <linux-btrfs@vger.kernel.org>;
        Sun, 18 Nov 2018 20:37:13 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id DF18352E07C2
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Nov 2018 20:37:12 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net DF18352E07C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1542569832; bh=4A2+4xWMmu84SkgGgUCw3Mzxa867AOD9BVpWvkSRBqA=;
        h=Message-ID:From:To:Date:Mime-Version;
        b=bGNtVuSNS2KOIxNNkZvbiZf1TCHcYz/phASNrQjRQ4zOzG5hhGP9mQX1pDEG5fo1m
         NT3954i2NhU0ZG1mHZlwqZvFElf3m8HHE4VRAxTQSIupZKFk4QVSlI3mTYg75xnPh7
         RoyxqlEm1sy5kECBbFLlcJii1t+k/ZH7h97oJaqGb1K0hXDrjV90JcRlYyhw7T8gFs
         cWMcrMvW0Uos1ksjtt8KXuZxUJn2XHSXwC5hrkckPMDUHUFFbzsq4S91mSSXb4Dp3V
         frYXKEpetlPP66P9BQ+PjOrm0ImqfKBAQjktafAMMunK30fLXJphsxCYCTLkQrtC4E
         1i7mObxFJFgyg==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id d1YDbiLxwrcQ for <linux-btrfs@vger.kernel.org>;
        Sun, 18 Nov 2018 20:37:12 +0100 (CET)
Received: from dolores (astlambert-681-1-17-132.w90-86.abo.wanadoo.fr [90.86.138.132])
        by mail.seblu.net (Postfix) with ESMTPSA id 9751F52E07BD
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Nov 2018 20:37:12 +0100 (CET)
Message-ID: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
Subject: Broken filesystem, looking for guidance
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     linux-btrfs@vger.kernel.org
Date:   Sun, 18 Nov 2018 20:37:11 +0100
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-KG83IfqHt2XI725gR2mo"
X-Mailer: Evolution 3.28.5 
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-KG83IfqHt2XI725gR2mo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I opened a bug report[1] about a situation I have with a btrfs filesystem o=
n my
backup server. Looks like there is internal errors inside the filesytem whi=
ch
cannot be fixed by btrfs check. Currently, each time I cat a specific file,=
 the
filesystem is remounted read-only.

How can I get some help getting this file system back on track?

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D201525


S=C3=A9bastien "Seblu" Luttringer

--=-KG83IfqHt2XI725gR2mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIrBAABCQAdFiEEVyJOyaX8pvvJK7iqShr8NF6+GPgFAlvxv2cACgkQShr8NF6+
GPhPMQ/Ajwi31XyQAr9J3BpCXfYyhiTPxseICKgKDMR3/mcOr6VZurpj8YMiD0xt
cTtgoQ4KzJ9WrFNzjXJzL6+qp3l2hD2t8B053WLB/DL2LvsWpXjxY6k0ItVUU62l
F7RSYB2FNUFk3xlIKy4zLF8EhoEfq//2b09DhgF78WS/xPwSBH1VV4vDgHafSeUb
cA+v1k7m1u0Z/Z7MJd0PPiqafJxdx7Q/kGiFrd5HRPbm/A1++ccyY0cLshv3BtS/
Kv1nA6lh3AVisgiq5NNb5lhTsjsMpbtriSKFMd8hY7I3J9zBrbGoTQFnSDeMEiTX
/VcBY4Y2ml+0U6DzcmrtrLj1NKHpBmka15Iua/Zk+Qs8qIH/AMbqmDfz7kQQ3YMF
osZBWdr38zKneR+hMAcdrDM6XoKupU+oK9DsJHCvq1MfyUJb4oXWcWTPF0DKWvcB
660mgj2T/dJHDIuoCmzlCipMc9a4GPekJNFk6txtNQF65i30e+dAD+jTuldrnWT7
vW7+WU5xoTsHKb+Kv4PTZZKTrCrhBOiZPcJwCqqEhbaqtQ8fWhk8YccZvHW8vp/i
UJ0BxFL25/qJyrxz2SxKngBYPZOyHiHQr7n0O7gYMYmT+hXhiuB+MYqA/lwZHUO2
tKJ2YynCf/eCAx6uwpsElyGvssjR086dFsyJ8BV6
=7N1S
-----END PGP SIGNATURE-----

--=-KG83IfqHt2XI725gR2mo--

