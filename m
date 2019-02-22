Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC207C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 16:54:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0A120700
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 16:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfBVQya (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 11:54:30 -0500
Received: from sender-op-o12.zoho.com ([135.84.80.197]:17431 "EHLO
        sender-op-o12.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfBVQya (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 11:54:30 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550854465; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=ULFwff7YqrY2XaKK+0Qt0Zyl1KjylUMnHJYsgO8KNOE3XIpJJ+q5fa2CI/oAPEcZ69OcXArikvqM3y5NxZS9LFlgTpIrnM90sZlC1JlzeAgH6fbyfPZrpDo1dj+ScMh8aH/iU2oaHgOjvwS8b3Y60NbCl2I2JvigHy+Op0jsLzk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1550854465; h=Content-Type:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=pu4CvrAsqYRoKOS7al00ukLR5hJQoe0ZdqOrrFY49/I=; 
        b=BA/gdlIGBp7+pcFmyW7F8U33+soP0wvI25ho5TI5ME8AD414XtQTPLhum49wlYjyEIcdbMItt4DFi/+CDDVVS11b69k0sj2n0poehkKjvHuUZo8DkbOk6g0NBQOl72aikyGU1b3EWyNIt9srdPF7R4PHsPUR6uLbnv1722LT+Yg=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=dlrobertson.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com> header.from=<dan@dlrobertson.com>
Received: from nessie (pool-100-15-144-194.washdc.fios.verizon.net [100.15.144.194]) by mx.zohomail.com
        with SMTPS id 1550854463971691.5914578526114; Fri, 22 Feb 2019 08:54:23 -0800 (PST)
Date:   Fri, 22 Feb 2019 16:45:34 +0000
From:   Dan Robertson <dan@dlrobertson.com>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs/btrfs: init csum_list before possible free
Message-ID: <20190222164532.GA5443@nessie>
References: <20190219025643.20382-1-dan@dlrobertson.com>
 <20190219163144.GR9874@twin.jikos.cz>
 <20190221145723.GA25507@nessie>
 <20190222155701.GI9874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20190222155701.GI9874@twin.jikos.cz>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Got it. Thanks for the clarification.

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEF5dO2RaKc5C+SCJ9RcSmUsR+QqUFAlxwJyoACgkQRcSmUsR+
QqWLkBAAso77IF31PoI4NT+CxTorc2i+mJVoTpto6msf9pLq2k4HVcc0AQSAV7dK
eI+2pAyN0AfW3i8TgLMlL0eEwQViFzER06ArkIDpjh+5bFA0EjRGHbetbvHxAU/2
A/y4pu7G874SGXsCJSx3zgD4MnZ7ULTHPvV1owh0q4+C3FvgjMVJE7Nw6OT6s6Hx
QDpi4J+h9v7ca+2EphqSpO3kqF9p5AonToHiG5i12LqGcfnTYnt2dMYJ2t3Crko2
Di/U+qC7aDlYgJw/L4gNFngJVuTbnaehYu54efVZv2HrJR+etdz7FwqmnixaEPw+
ah5AW/bm09Pw775bN58qo+yjd9NdGFmZEf+T0DURDAHfCKGbbxDx4qWwyQYk3Mm3
7/qGVAbenrl22AomBaE4Mc+ctiCQPurtHhS+7efB16yuMRzSqYHMmGEdrNyXQ4zf
TBF4Mr1Wb2pplbf7q+xMAflyo6xW1r9XcsYdBbZx4IXkNEhuS+YyveqDKMoPLtI2
0FxDw33LuQgK0jY76UwFMWYZJL4O2DyL9ypE2wK2ivfUSTm1QjIlKKrApR7wXNFo
tOIPyKVTXHX8ToGKTfbbryxdTMEIbPnVQjecjyhBTNuHt7JbL44sDbtymb6x+Np1
w00xSyxJfFfir9mggnf9VHn+g+xANL80eaXaLMdV4ANDlQwtZeE=
=gT/C
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

