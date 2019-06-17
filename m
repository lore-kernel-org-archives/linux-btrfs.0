Return-Path: <SRS0=jqbo=UQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21FA0C31E5B
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 15:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E17EA2084A
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Jun 2019 15:37:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ZJDd5cdg";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ZJDd5cdg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfFQPhO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Jun 2019 11:37:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55062 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726047AbfFQPhN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Jun 2019 11:37:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 87D9B8EE105;
        Mon, 17 Jun 2019 08:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1560785833;
        bh=mWCugXceKyAOQu9MSBX5QJCVA4ce1/3KeOkdDZTDlzg=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=ZJDd5cdgW4MjM0z6OHQSERQcmoyLpA3Le8JwvP2LWXZklBFFatModPwtvIItyNCZH
         2ICFd7LJYzqpVh4DiYkQAb5b/Qx0jUOdPSpQdYMOoQwLSYiO60YkUbXAHoSQpOw8n5
         Q9Dy+jIYR5Xhpy0q5L7+dpmLXv1Lx+jKdQXpQECM=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lwtkd_OB5eyj; Mon, 17 Jun 2019 08:37:13 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.68.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E5C1B8EE0D7;
        Mon, 17 Jun 2019 08:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1560785833;
        bh=mWCugXceKyAOQu9MSBX5QJCVA4ce1/3KeOkdDZTDlzg=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=ZJDd5cdgW4MjM0z6OHQSERQcmoyLpA3Le8JwvP2LWXZklBFFatModPwtvIItyNCZH
         2ICFd7LJYzqpVh4DiYkQAb5b/Qx0jUOdPSpQdYMOoQwLSYiO60YkUbXAHoSQpOw8n5
         Q9Dy+jIYR5Xhpy0q5L7+dpmLXv1Lx+jKdQXpQECM=
Message-ID: <1560785821.3538.22.camel@HansenPartnership.com>
Subject: Re: Proper packed attribute usage?
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Date:   Mon, 17 Jun 2019 08:37:01 -0700
In-Reply-To: <f24ea8b6-01ff-f570-4b9b-43b4126118e6@gmx.com>
References: <f24ea8b6-01ff-f570-4b9b-43b4126118e6@gmx.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-nfwc8CkvWmyN3WVVNp70"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-nfwc8CkvWmyN3WVVNp70
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-06-17 at 17:06 +0800, Qu Wenruo wrote:
[...]
> But then this means, we should have two copies of data for every such
> structures. One for the fixed format one, and one for the compiler
> aligned one, with enough helper to convert them (along with needed
> endian convert).

I don't think it does mean this.  The compiler can easily access the
packed data by pointer, the problem on systems requiring strict
alignment is that it has to be done with byte accesses, so instead of a
load word for a pointer to an int, you have to do four load bytes.=20
This is mostly a minor slowdown so trying to evolve a whole
infrastructure around copying data for these use cases really wouldn't
be a good use of resources.

James

--=-nfwc8CkvWmyN3WVVNp70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iHUEABMIAB0WIQTnYEDbdso9F2cI+arnQslM7pishQUCXQeznQAKCRDnQslM7pis
hWJdAP9EjBUm7QtsCdZKbtHvyByuyW9chKBA9LNOyaGREnGOUAD+Pk1Ks1T/iidR
0dmNc9xeOMRZohls/XxRWORpuWZV8oY=
=/m9c
-----END PGP SIGNATURE-----

--=-nfwc8CkvWmyN3WVVNp70--

