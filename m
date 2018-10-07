Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24096C46475
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 00:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F81206B2
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 00:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="J6rxIsEt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NmToB6IK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0F81206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=georgianit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbeJGHhl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 03:37:41 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34487 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbeJGHhl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Oct 2018 03:37:41 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 78CCC21E76;
        Sat,  6 Oct 2018 20:32:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 06 Oct 2018 20:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm1; bh=QcK/edH42CPEaHtbGg2WeaCTMUZ
        +GXk5CHu01gd+4U0=; b=J6rxIsEtm7OIaXiHjOtdnCAKJ+Vg7slxOrcHhbZZNPR
        D18v2aVX5BpQIIDAACwSIwWe+Fhf2qgm6RgqpMn/rf1QwL3O3MhpRTtjxuJH2Qg/
        UBQ+oPBhYOuk9G4iY5dm/kMJfSNxu+PfqQdkXWuTFfQrVWj+W4DzFApRHkkhBbPD
        LB9fijeCM2ZDYtIqivtihkMx+poCAc8kLSxjEDSj6S1bj287vG9A0QhwxgdzPTPM
        SHXeuNgr6RJ9mROeTfUZ+inXBST9Gq02TDpN1zhiwKSHsJedQZPgHfoav3sFQwf5
        chz9feCTlTYiweAwCdw2DquEQCY/1mWa5XKxSYTb9dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QcK/ed
        H42CPEaHtbGg2WeaCTMUZ+GXk5CHu01gd+4U0=; b=NmToB6IKtb/UsJiW5MqVBD
        yW2oeVmJJRk3a+3NpyQfcX/y06qeIH9eBXMFZC965LtskNi+tZ8lxnS3CEyjSPfa
        DLVQZgrV1Yn8Ry0POABBF5UggIVHW8rRH5c1GwTl2tUuosPz7RccEpPlqLdvT+qq
        pW0BOBz2UyYPVprW7h14kR+bgXDFKJd9IZLU81UPT6cKKwJIhESVHMG2+rUXPCtr
        6iKnik5ihHxyq0oBRPWRcuzvy5ERUj/9f1/ZHCaMWl50PJpVDeXOuwObC3YTBP9k
        KHRL8QjGWMzuNRA8/bvfJ8kLBPsJqOXOdFZgjehZDeEHJIuwCHmAxMfrvI1HZOFQ
        ==
X-ME-Sender: <xms:FVS5W18lvKN7bBNWjlVWR97XreD3CKAoWLV_nuSxzTR5GDfBRUj-cA>
X-ME-Proxy: <xmx:FlS5W7gYYbeM-DKGC17_cxBRFp7NYlNI243za6WkhDXw1cjXuDcHyA>
    <xmx:FlS5W6HyEMxf0ijS6T0jgMlOwGvmPB2TeffUjZO7VA_qfssGFFySRQ>
    <xmx:FlS5W7mpQTJ6S1VPEFAELdBHmHQOyozoiznx6LSxyJHxZ_rd4dWX6w>
    <xmx:FlS5W9AsLMNvfp0wj993SUYbAKrAV9oxBV1BZJRJ63uLtHUoTCT6lQ>
    <xmx:FlS5W3_ZP6y1v6HPv1HxnpIc8OsnTVLTv3RL_dwpYwNaYOc5gHQz-w>
    <xmx:FlS5W2qhkCETbZ1Yvd7vykiGddzqOd-ZOtd3VSGM4KIq9L9skyz6Lg>
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id B29C4102E2;
        Sat,  6 Oct 2018 20:32:21 -0400 (EDT)
Subject: Re: Two partitionless BTRFS drives no longer seen as containing BTRFS
 filesystem
To:     evan d <forumscollective@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
From:   Remi Gauvin <remi@georgianit.com>
Openpgp: preference=signencrypt
Autocrypt: addr=remi@georgianit.com; prefer-encrypt=mutual;
 keydata= xsBNBFogjcYBCADvI0pxdYyVkEUAIzT6HwYnZ5CAy2czT87Si5mqk4wL4Ulupwfv9TLzaj3R
 CUgHPNpFsp1n/nKKyOq1ZmE6w5YKx4I8/o9tRl+vjnJr2otfS7XizBaVV7UwziODikOimmT+
 sGNfYGcjdJ+CC567g9aAECbvnyxNlncTyUPUdmazOKhmzB4IvG8+M2u+C4c9nVkX2ucf3OuF
 t/qmeRaF8+nlkCMtAdIVh0F7HBYJzvYG3EPiKbGmbOody3OM55113uEzyw39k8WHRhhaKhi6
 8QY9nKCPVhRFzk6wUHJa2EKbKxqeFcFzZ1ok7l7vrX3/OBk2dGOAoOJ4UX+ozAtrMqCBABEB
 AAHNIVJlbWkgR2F1dmluIDxyZW1pQGdlb3JnaWFuaXQuY29tPsLAfgQTAQIAKAUCWiCNxgIb
 IwUJCWYBgAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ71Of8kdFam2V1Qf9Fs6LSx1i
 OoVgOzjWwiI06vJrZznjmtbJkcm/Of5onITZnB4h+tbqEyaMYYsEIk1r4oFMfKB7SDpQbADj
 9CI2EbpygwZa24Oqv4gWEzb4c7mSJuLKTnrhmwCOtdeDQXO/uu6BZPkazDAaKHUM6XqNEVvt
 WHBaGioaV4dGxzjXALQDpLc4vDreSl9nwlTorwJR9t6u5BlDcdh3VOuYlgXjI4pCk+cihgtY
 k3KZo/El1fWFYmtSTq7m/JPpKZyb77cbzf2AbkxJuLgg9o0iVAg81LjElznI0R5UbYrJcJeh
 Jo4rvXKFYQ1qFwno1jlSXejsFA5F3FQzJe1JUAu2HlYqRs7ATQRaII3GAQgAo0Y6FX84QsDp
 R8kFEqMhpkjeVQpbwYhqBgIFJT5cBMQpZsHmnOgpYU0Jo8P3owHUFu569g6j4+wSubbh2+bt
 WL0QoFZcng0a2/j3qH98g9lAn8ZgohxavmwYINt7b+LEeDoBvq0s/0ZeXx47MOmbjROq8L/g
 QOYbIWoJLO2emyxmVo1Fg00FKkbuCEgJPW8U/7VX4EFYaIhPQv/K3mpnyWXIq5lviiMCHzxE
 jzBh/35DTLwymDdmtzWgcu1rzZ6j2s+4bTxE8mYXd4l2Xonn7v448gwvQmZJ8EPplO/pWe9F
 oISyiNxZnQNCVEO9lManKPFphfVHqJ1WEtYMiLxTkQARAQABwsBlBBgBAgAPBQJaII3GAhsM
 BQkJZgGAAAoJEO9Tn/JHRWptnn0H+gOtkumwlKcad2PqLFXCt2SzVJm5rHuYZhPPq4GCdMbz
 XwuCEPXDoECFVXeiXngJmrL8+tLxvUhxUMdXtyYSPusnmFgj/EnCjQdFMLdvgvXI/wF5qj0/
 r6NKJWtx3/+OSLW0E9J/gLfimIc3OF49E3S1c35Wj+4Okx9Tpwor7Tw8KwBVbdZA6TyQF08N
 phFkhgnTK6gl2XqIHaoxPKhI9pKU5oPkg2eI27OICZrpTCppaSh3SGUp0EHPkZuhVfIxg4vF
 nato30VZr+RMHtPtx813VZ/kzj+2pC/DrwZOtqFeaqJfCi6JSik3vX9BQd9GL4mxytQBZKXz
 SY9JJa155sI=
Message-ID: <ca47dc8e-a99d-f1b9-d3c1-a79794d6f3ac@georgianit.com>
Date:   Sat, 6 Oct 2018 20:32:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <CAG__1a5fh+H2WnCp6Ofuic_MD-0YNcjReSngbCs1DQypzxNdyQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------1C733B578F1D5AD5D9743A09"
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------1C733B578F1D5AD5D9743A09
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2018-10-06 07:23 PM, evan d wrote:
> I have two hard drives that were never partitioned, but set up as two
> independent BRTFS filesystems.  Both drives were used in the same
> machine running Arch Linux and the drives contain(ed) largely static
> data.
> 
> I decommissioned the machine they were originally used in and on
> installing in a newer Arch build found that BRTFS reported no
> filesystem on either of the drives.
> 
> uname -a:
> Linux z87i-pro 4.18.9-arch1-1-ARCH #1 SMP PREEMPT Wed Sep 19 21:19:17
> UTC 2018 x86_64 GNU/Linux
> 
> btrfs --version: btrfs-progs v4.17.1
> btrfs fi show: returns no data

Did you try a btrfs device scan  ?

(Normally, that would be done on boot, but depending on how your arch
was configured, or if the devices are available early enough in the boot
process....)

--------------1C733B578F1D5AD5D9743A09
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


--------------1C733B578F1D5AD5D9743A09--
