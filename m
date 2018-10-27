Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF75C46475
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 18:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4C88204FD
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 18:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="QevfCKjx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="n+ZGLkwh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4C88204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=georgianit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbeJ1Cxy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 22:53:54 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33321 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbeJ1Cxy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 22:53:54 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 96D1621A02;
        Sat, 27 Oct 2018 14:12:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 27 Oct 2018 14:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm1; bh=zk2PsN7s6ZprUR/TOsJIyBeAA0h
        J9dGKrUuF1u9GDm0=; b=QevfCKjx37ZJlo/NPGU5jTg9409QkXF3FnNzJatOgFe
        4V0L+t1kPpD0jnsQsaYbW4NmgMSTKXoTXfEeRAhM4t6wwQ5F+MCgcgQnmbIbsDzO
        +Caw0bcURD2jUWPe0jbngjKDvu7uXVH8/42Ia9916+nUFYogi83p65l1LzJOwm49
        fCaKHon33ltnCWFQqc0FPwX2TIjVc75j2ATZqDixr+1ySbteNKHE6XWVc45dFz8w
        JMOV0d78iNc1YKWZ0TuIwVWmXgQPamgqWgK0fqE69I/qchxK7oExCw/gVnOAtoGp
        l0iUFqKehsOtnFYnJ7rrxLE4iGwPtbtzDpkTzBFM9cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zk2PsN
        7s6ZprUR/TOsJIyBeAA0hJ9dGKrUuF1u9GDm0=; b=n+ZGLkwhZ7GZg28zqj/gcu
        l0Cmktm8+Wdin7xGRXUpb4UAmeGwxUkv2vJ8uXTguhD3x145yW4LhWEk31oU42HK
        oArWC30jyQiJxqM98gmGJZ9vCWPL4PUL7j62bLrIi3psKZ/G4js05os54GvYj1gL
        KrUJIzS318Vg4dMdyNCK2WM+/zfSb+2HzKX/cGfQsS535jyNJnb84s5cN0r53bWm
        hhUG5PaUWbeotB6W6CGOZggxWnqv/OfqfpJ4uK+xL0uMsEL+ODw2ZMW6VMGeVclV
        BTxq9LRw14iK0Jsd1TrFUj+lTbsSmeHnxFXHwKcCd6H7+JKoaROm/eieSoVc58iA
        ==
X-ME-Sender: <xms:c6rUW13fY1iq8IuZUkhTtSUCTU_U801PcT_kRHUjBzEF3CEUcHEizg>
X-ME-Proxy: <xmx:c6rUW428KrZ1hYPf5SSRzGGgnn0TM09Mf5AHMAmqFsqK8tCVkgmTlA>
    <xmx:c6rUWwcCZLT60lO2ENoY4wnC0eyYJDy7whPyrCTul93quNgh2Jzucw>
    <xmx:c6rUW2hUyUJP86Exxnnb2LeZEfuq97nV8RMqxfgHISyV9oCVdq-iGw>
    <xmx:c6rUW8Zi0aJFjJsMKidHAa3dYpY5fyzilwn0NrFBLRNQWIAWp0IS2A>
    <xmx:c6rUWxKKt9Mw-SpinWvtRRDP_A3pCWYBTljCC3OA8zJjc_SWnFU9SQ>
    <xmx:dKrUW33KWbpIHSbtov1WIw5oCKQBbsy-sokcB_HI7G95a4amx8JHAQ>
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E96C102DD;
        Sat, 27 Oct 2018 14:12:03 -0400 (EDT)
Subject: Re: Have 15GB missing in btrfs filesystem.
To:     Marc MERLIN <marc@merlins.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
 <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
 <20181027174245.4isfcb6nv4pkklmd@merlins.org>
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
Message-ID: <d530a9d0-4cee-521b-6c95-ff56d0f7c130@georgianit.com>
Date:   Sat, 27 Oct 2018 14:12:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <20181027174245.4isfcb6nv4pkklmd@merlins.org>
Content-Type: multipart/mixed;
 boundary="------------9F6F8185D17DCB26A52A0730"
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------9F6F8185D17DCB26A52A0730
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2018-10-27 01:42 PM, Marc MERLIN wrote:

> 
> I've been using btrfs for a long time now but I've never had a
> filesystem where I had 15GB apparently unusable (7%) after a balance.
> 

The space isn't unusable.  It's just allocated.. (It's used in the sense
that it's reserved for data chunks.).  Start writing data to the drive,
and the data will fill that space before more gets allocated.. (Unless
you are using an older kernel and the filesystem gets mounted with ssd
option, in which case, you'll want to add nossd option to prevent that
behaviour.)

You can use btrfs fi usage to display that more clearly.


> I can try a defrag next, but since I have COW for snapshots, it's not
> going to help much, correct?

The defrag will end up using more space, as the fragmented parts of
files will get duplicated.  That being said, if you have the luxury to
defrag *before* taking new snapshots, that would be the time to do it.


--------------9F6F8185D17DCB26A52A0730
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: quoted-printable
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


--------------9F6F8185D17DCB26A52A0730--
