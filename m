Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B58AC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 15:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF3762083B
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 15:06:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfBUPGY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Feb 2019 10:06:24 -0500
Received: from sender-op-o12.zoho.com ([135.84.80.197]:17472 "EHLO
        sender-op-o12.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfBUPGX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Feb 2019 10:06:23 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1550761578; cv=none; 
        d=zoho.com; s=zohoarc; 
        b=OFzA/19S1j4TEWrfAb5/OV00eHj8/TbF6mEdOx4GglgW0fTADyfY6Kav20Boanr7thmt5rtVzFMYslkSoEVEQva7KtDw7cyIZVdkyfew+k2gcteC0Ui7qnH8spO4b0Kz7z6blcqwY0p2VwYkMGMuA66lic1pRm6ig6Y6jZso9IQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com; s=zohoarc; 
        t=1550761578; h=Content-Type:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To:ARC-Authentication-Results; 
        bh=r2+YG+228E6OO3iWsM9nvq/wipbmbhHaf4Oy3TgYHSc=; 
        b=RSN99UbVujKde2mEAXuR0vNzDNVmjHXXrSCThL9KAh6OE/4d8JnI1IkoxJ8WKIOJ+gqDYiYL0n5xJ3ASj2AGM6RWRJhcUzamukDdtgIogdDiUizNp/rXABmYXWpHLyVZU0GZfOxO58X7Px2m40yiVLg/qpeidYze7oQ0UfxRQRI=
ARC-Authentication-Results: i=1; mx.zoho.com;
        dkim=pass  header.i=dlrobertson.com;
        spf=pass  smtp.mailfrom=dan@dlrobertson.com;
        dmarc=pass header.from=<dan@dlrobertson.com> header.from=<dan@dlrobertson.com>
Received: from nessie (pool-100-15-144-194.washdc.fios.verizon.net [100.15.144.194]) by mx.zohomail.com
        with SMTPS id 1550761576289383.6679739598776; Thu, 21 Feb 2019 07:06:16 -0800 (PST)
Date:   Thu, 21 Feb 2019 14:57:27 +0000
From:   Dan Robertson <dan@dlrobertson.com>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs/btrfs: init csum_list before possible free
Message-ID: <20190221145723.GA25507@nessie>
References: <20190219025643.20382-1-dan@dlrobertson.com>
 <20190219163144.GR9874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20190219163144.GR9874@twin.jikos.cz>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Thanks, it's been there since the first merge of scrub, but hard to hit.

Yeah, very hard to hit. Debated submitting a patch, but the fix seemed
simple enough, so figured I'd send one in.

Side note: I noticed most of the time ENOMEM is hit in fs/btrfs BUG or BUG_ON is
called. Would it be better (more in line with the fs/btrfs style) to call BUG or
BUG_ON e.g. BUG_ON(!sbio) instead of goto nomem at fs/btrfs/scrub.c:592?

Cheers,

Dan

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEF5dO2RaKc5C+SCJ9RcSmUsR+QqUFAlxuvFMACgkQRcSmUsR+
QqXG4hAAqLJdgtS4qn17hPcivnssj51yzWcf1D2DaXFQRU3QehSy9lVwdD0+nnFQ
rfmPyu0K/1h6bD2hZCxKq/mmUcjcPbEszDyXUCZVZ5TZ5+ei5ozEFY4x98edi0oX
jc+0LJK+aeoLO+hVP0wc+QFp5+6GG5PLTtrta1VZOgjuYWmzukk/VWleV7truT0y
pitSdsWpcye3tzu2ApYoyaJ94U5qOk0uloYUr2pgdZruIMqgXMAbv70U/UYKOvCd
8R1ZtycaXFgwHxgyrOeV3E71c0t8uqpH+Q9hvbdXxrn6QA4IN7eDPT+GWbCrF3A4
wPcHPrNvAtC15WlA76roacvBd6cnLnBUs9YZnle8aYEAg9wAEJuGKjG+06vxGjq4
/ogXS4Wm/ccn6GFHDISoKSfjrN4gHURlAjwuEh3PL66w+cohIVR3bS7f64ku2gTP
1Jf3gNnMXX2NEf96Mh5dC8nO+Aq3CYpZR65KpQidxUgufNs4QmFs+AbFeZ7GU9qM
rPEpzwLHxicXlKfpOv/abe+ZnI7Im05Pu1moGAGCzeeaGFXO9ipqg6nhMnCQ3oOf
7axhxNt+cGFR3NYiZpkzdfuXKHRZtoZZMsv3pO8XHofllpHvN5bvKDGh35vLdg+e
AIg0CRXy5SVYVfRC4GeNjqGA2XfqEqJrtGniZUrJy9ICLdnlvF0=
=aB3Q
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--

