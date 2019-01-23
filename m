Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBB0C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 15:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E19F52184C
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 15:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="g3cygmnC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AwzTiQ0b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbfAWPkK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 10:40:10 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32939 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725948AbfAWPkK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 10:40:10 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 4E34522A3B;
        Wed, 23 Jan 2019 10:40:09 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 23 Jan 2019 10:40:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:references:to:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=LWKBnEbaryxHp6nbzWG8483QNe3
        1Jg+Ax94zSO9SQZU=; b=g3cygmnCztHHIy9Elg7btEmByT4d03ZkIAvekvEkBN7
        ao3rZZE74zdgl3URaat8UkB/bcsJQlNYCwSt9XaY75n4tH7GqAFEdbcG7lQuwqJN
        zVUD54oJ4bsG1Il7HQuVE+lURNcpSVJp/BICsRBQaRqyjSlg65LlV1ZnCU0IyQRo
        UZGpLyJEGrsSLGkt/++w0F2NwUO4BfB4XutnQwl4OOpDhqhc970fqbn7owhFvRRo
        iSzV3nOm/47LAy6ofHjEpER4Zx4yKwBYOi3QjZhdBFUJIw5N24rFdzhLUWmOmQRr
        Bf3iGqvdbn5GjmgB2XD+E78YWhEsvGF73F4gJIEcoUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LWKBnE
        baryxHp6nbzWG8483QNe31Jg+Ax94zSO9SQZU=; b=AwzTiQ0bfeGmVlCxdQCXJF
        LDC4z3oOBndu+SzknNuqZ3RX3TnmDsCK0YGX1UlSr3YgnWCJySkVtmZNNbWCgbi2
        NMaNhkat0Hiknzt+dZiFFMVLqlzXhMae3q8ixZWx4BvM0dL3iZfvJ4wwixSC940j
        CtgiiOgWCqRduwLM35TPyFQ1/15NxH3Wfk/n00iYR2gSEGYKGX4+8Pb+qj3kfJBy
        KYg+nfIqTeFO2aBBvXWjYNgPcdW/bBEO3GmpwU12mWHZcsTt8zNpgntGNqEY+ZeB
        Q8uyqejmvKJbhWjnRTQR8JgY6WanSpqB2+ofg2OSF5FMV+Y4Bkum/BXtPV8++AXQ
        ==
X-ME-Sender: <xms:2IpIXNTDyfHamvUDa55IX74jXHkb7PtLyGHkrS4yDJ7qcVr7fbS1lQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledriedtgdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecufedt
    tdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepufhfvffhkffffg
    ggjggtsehmtderredtfeejnecuhfhrohhmpeftvghmihcuifgruhhvihhnuceorhgvmhhi
    sehgvghorhhgihgrnhhithdrtghomheqnecukfhppedufeehrddvfedrvdegiedrudefud
    enucfrrghrrghmpehmrghilhhfrhhomheprhgvmhhisehgvghorhhgihgrnhhithdrtgho
    mhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:2IpIXO-V-HJnxc60c_dRbnWAe1Tuj1uVfMn9cOy0m7sONBwelhP46Q>
    <xmx:2IpIXIt_gNphHaZacL-TA8hngD1G_GH1xT0jl5Vgi2-fhmzd9tMvoQ>
    <xmx:2IpIXOEuQzzczo143LWV6o62dxxVviMT8x7rNkjZZwZxKzmVhHNByQ>
    <xmx:2YpIXNgV3fg07nRc7jNqrqnrv_JffvqBMwhNaR-SlnjxkoDTvWUV2Q>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D7E0E474F;
        Wed, 23 Jan 2019 10:40:08 -0500 (EST)
Subject: Re: Incremental receive completes succesfully despite missing files
References: <110c46c8-6fe9-84ea-0f4e-8269fd8000ed@netspace.net.au>
 <CAJCQCtSOBcK=MXLUFVZk6YCrFx60UEH7PgOtPYbcRkfjG0XDyQ@mail.gmail.com>
 <3cfb98e1-92d4-150c-445c-9357cec9adca@netspace.net.au>
 <CAA91j0VSd=uC7ROT2+JsRszzAXWz+ti-Kf3hyw+aVS03sdn95g@mail.gmail.com>
 <8e5c7ee5-4507-66d2-6642-2e37ff11b897@mendix.com>
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From:   Remi Gauvin <remi@georgianit.com>
Openpgp: preference=signencrypt
Autocrypt: addr=remi@georgianit.com; prefer-encrypt=mutual;
 keydata= mQENBFogjcYBCADvI0pxdYyVkEUAIzT6HwYnZ5CAy2czT87Si5mqk4wL4Ulupwfv9TLzaj3R
 CUgHPNpFsp1n/nKKyOq1ZmE6w5YKx4I8/o9tRl+vjnJr2otfS7XizBaVV7UwziODikOimmT+
 sGNfYGcjdJ+CC567g9aAECbvnyxNlncTyUPUdmazOKhmzB4IvG8+M2u+C4c9nVkX2ucf3OuF
 t/qmeRaF8+nlkCMtAdIVh0F7HBYJzvYG3EPiKbGmbOody3OM55113uEzyw39k8WHRhhaKhi6
 8QY9nKCPVhRFzk6wUHJa2EKbKxqeFcFzZ1ok7l7vrX3/OBk2dGOAoOJ4UX+ozAtrMqCBABEB
 AAG0IVJlbWkgR2F1dmluIDxyZW1pQGdlb3JnaWFuaXQuY29tPokBPgQTAQIAKAUCWiCNxgIb
 IwUJCWYBgAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ71Of8kdFam2V1Qf9Fs6LSx1i
 OoVgOzjWwiI06vJrZznjmtbJkcm/Of5onITZnB4h+tbqEyaMYYsEIk1r4oFMfKB7SDpQbADj
 9CI2EbpygwZa24Oqv4gWEzb4c7mSJuLKTnrhmwCOtdeDQXO/uu6BZPkazDAaKHUM6XqNEVvt
 WHBaGioaV4dGxzjXALQDpLc4vDreSl9nwlTorwJR9t6u5BlDcdh3VOuYlgXjI4pCk+cihgtY
 k3KZo/El1fWFYmtSTq7m/JPpKZyb77cbzf2AbkxJuLgg9o0iVAg81LjElznI0R5UbYrJcJeh
 Jo4rvXKFYQ1qFwno1jlSXejsFA5F3FQzJe1JUAu2HlYqRrkBDQRaII3GAQgAo0Y6FX84QsDp
 R8kFEqMhpkjeVQpbwYhqBgIFJT5cBMQpZsHmnOgpYU0Jo8P3owHUFu569g6j4+wSubbh2+bt
 WL0QoFZcng0a2/j3qH98g9lAn8ZgohxavmwYINt7b+LEeDoBvq0s/0ZeXx47MOmbjROq8L/g
 QOYbIWoJLO2emyxmVo1Fg00FKkbuCEgJPW8U/7VX4EFYaIhPQv/K3mpnyWXIq5lviiMCHzxE
 jzBh/35DTLwymDdmtzWgcu1rzZ6j2s+4bTxE8mYXd4l2Xonn7v448gwvQmZJ8EPplO/pWe9F
 oISyiNxZnQNCVEO9lManKPFphfVHqJ1WEtYMiLxTkQARAQABiQElBBgBAgAPBQJaII3GAhsM
 BQkJZgGAAAoJEO9Tn/JHRWptnn0H+gOtkumwlKcad2PqLFXCt2SzVJm5rHuYZhPPq4GCdMbz
 XwuCEPXDoECFVXeiXngJmrL8+tLxvUhxUMdXtyYSPusnmFgj/EnCjQdFMLdvgvXI/wF5qj0/
 r6NKJWtx3/+OSLW0E9J/gLfimIc3OF49E3S1c35Wj+4Okx9Tpwor7Tw8KwBVbdZA6TyQF08N
 phFkhgnTK6gl2XqIHaoxPKhI9pKU5oPkg2eI27OICZrpTCppaSh3SGUp0EHPkZuhVfIxg4vF
 nato30VZr+RMHtPtx813VZ/kzj+2pC/DrwZOtqFeaqJfCi6JSik3vX9BQd9GL4mxytQBZKXz
 SY9JJa155sI=
Message-ID: <fdb6b51a-fbe4-c971-3c68-7e25f13aa323@georgianit.com>
Date:   Wed, 23 Jan 2019 10:40:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <8e5c7ee5-4507-66d2-6642-2e37ff11b897@mendix.com>
Content-Type: multipart/mixed;
 boundary="------------F1F0C53B62B1DD82727A16A3"
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------F1F0C53B62B1DD82727A16A3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2019-01-23 10:25 a.m., Hans van Kranenburg wrote:

> 
> But then only disallow if the subvol has a value in the received_uuid
> field, I'd say.
> 

That would only solve half the self-harm.  User can still make changes
to the parent subvolume on the sending side, and subsequent sends using
the same parent will be inconsistent.


--------------F1F0C53B62B1DD82727A16A3
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------F1F0C53B62B1DD82727A16A3--
