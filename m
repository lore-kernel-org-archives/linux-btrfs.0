Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929D5C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 21:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E6BC2082D
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 21:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="igCKTCrk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XsCrLsOn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E6BC2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=georgianit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbeJ3Grs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 02:47:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60803 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727427AbeJ3Grr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 02:47:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id AD56F220BD;
        Mon, 29 Oct 2018 17:57:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 29 Oct 2018 17:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm1; bh=TcGXJPfzfxHI923WvxmLURZ0xO9
        cLmSP0Nr57VwU/1s=; b=igCKTCrk8aeI2I4yNhXTaZesYiGl/+SUSAwB7JbL4OP
        SsSNQWeqno6NN5pvbcC5ktKP5P+iH64ucj4xgkDixw9emicfXe5rnC7MQC3aIS1T
        MW9uB6Zbz4rAjhtzJ4F3T1turI/t7bTxq6UEB/bb4sZ9XDMZsHmv8z1PwqDHxBAs
        bQ8K5Lxgh61UFjuZPbz1Rj40Qis0ytgvfyCt4MEhMNbCvlDo/WHjwOu4+6NwwA1/
        GPcFwDsRcP1IyBVmG9GUbq8p16PRejoQewYTh0p+0/kYpSAzOdQeB1mI3z6kEO8P
        AnQSustBe3RTJ0ZJM151t1iUQqa4z2yKCx1J8S1qbEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TcGXJP
        fzfxHI923WvxmLURZ0xO9cLmSP0Nr57VwU/1s=; b=XsCrLsOnh7Z8JWrxeR8MTq
        uZ6sXp54TS/G/VHIOCm8HTWt/LK5rtTVSYjY8I0qJt7A9pjJPg/szGuhs+fg7a7g
        R+YOx6qION7qy+zLYMlvgTwsZ5Ek3AM9VpuS8grzvWsoVAsZZaQQdFm+nfzUyt1s
        ST7Q8mG3daNKKuTAORIFrg/+6yGdkxawguxPq3s5qtJ1MzQb3oKGA9Q/Cmgtc4qL
        hTipcCF8zBaylnRnw8vJA9OWf1KInKNRBor4k56+ANmfQYFBhlt1kI3R68s6q30v
        HvGkov3KaZcWbG3qnYDxLwXZx5pQMjjgb/5bpLa6GywOTsgkjhmCdGq2bQieVitA
        ==
X-ME-Sender: <xms:OILXW5G9SDLrSd9XCLx-cKjvaCMRfBOfhmOfp4DdMLdjHColKJDhgg>
X-ME-Proxy: <xmx:OILXW0dConQZaGo3vt6oUlxTHoeuEHWAlIIdz8uktXD_Qj-EKpoa7Q>
    <xmx:OILXW8mAgG4k5xjaegvEf27pOKEZVynTVa7hPjnImJEObog5uTFGjQ>
    <xmx:OILXWxyNpwRPVfsSRO9GoqmQ5nOulBvqN5v20KDzsA6Iu5Bv1I2XxQ>
    <xmx:OILXW3zcW0eEFr806H-QKY2SQZ-yiJbRZ5SgalCn8582PL3OR_q7Aw>
    <xmx:OILXW5VTbk0qbSOyxrEdRGBFL-6W3jt_LX5J-1nnKHT-7WRCxUj9GQ>
    <xmx:OILXWyaOz_DhRzJIc_KzJhlgLQeuW265z4p_I-PAuowE65lyxGVyhw>
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id C305A102F0;
        Mon, 29 Oct 2018 17:57:11 -0400 (EDT)
Subject: Re: Understanding "btrfs filesystem usage"
To:     Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181029181141.GA31256@rus.uni-stuttgart.de>
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
Message-ID: <85a63523-7e77-f4ca-9947-2c957c5c577a@georgianit.com>
Date:   Mon, 29 Oct 2018 17:57:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <20181029181141.GA31256@rus.uni-stuttgart.de>
Content-Type: multipart/mixed;
 boundary="------------340F20BA012DB391EDFF02DA"
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------340F20BA012DB391EDFF02DA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2018-10-29 02:11 PM, Ulli Horlacher wrote:
> I want to know how many free space is left and have problems in
> interpreting the output of: 
> 
> btrfs filesystem usage
> btrfs filesystem df
> btrfs filesystem show
> 
>

In my not so humble opinion, the filesystem usage command has the
easiest to understand output.  It' lays out all the pertinent information.

You can clearly see 825GiB is allocated, with 494GiB used, therefore,
filesystem show is actually using the "Allocated" value as "Used".
Allocated can be thought of "Reserved For".  As the output of the Usage
command and df command clearly show, you have almost 400GiB space available.

Note that the btrfs commands are clearly and explicitly displaying
values in Binary units, (Mi, and Gi prefix, respectively).  If you want
df command to match, use -h instead of -H (see man df)

An observation:

The disparity between 498GiB used and 823Gib is pretty high.  This is
probably the result of using an SSD with an older kernel.  If your
kernel is not very recent, (sorry, I forget where this was fixed,
somewhere around 4.14 or 4.15), then consider mounting with the nossd
option.  You can improve this by running a balance.

Something like:
btrfs balance start -dusage=55

You do *not* want to end up with all your space allocated to Data, but
not actually used by data.  Bad things can happen if you run out of
Unallocated space for more metadata. (not catastrophic, but awkward and
unexpected downtime that can be a little tricky to sort out.)



--------------340F20BA012DB391EDFF02DA
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


--------------340F20BA012DB391EDFF02DA--
