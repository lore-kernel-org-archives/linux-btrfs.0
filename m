Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13C8C46475
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 21:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23ACA20848
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 21:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="FtypKzPd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lyzTt1LV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23ACA20848
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=georgianit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbeJ1GCZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Oct 2018 02:02:25 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41491 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbeJ1GCZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Oct 2018 02:02:25 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 7418921A1E;
        Sat, 27 Oct 2018 17:20:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 27 Oct 2018 17:20:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm1; bh=DP3IFV7O0PwvYCc3AZYI/vmuy/3
        QNS5F78JptSjjd7w=; b=FtypKzPdcYPvukOlKrXfW51YirSgRnVRauDwbme5bFv
        ALOhvNkNDJJtYoyrMJz6A2Umv7gk3qs70oIOTY6UDW41yIAm6Z3byZk4bg1c7PvG
        RFP9NHj0AlyxEB+Rn/G4wXocVAo5ugmCv9SEZ5LfInoQma18SUmCB8NpTs/QEIfz
        aDPiL5DcM9NCiBsJnDmAdcBpA1z3YEqYIS3EmQzNdvOZU+GmTnhMq6cvdynadCqA
        iKc82Ne1Yh0HcW/j1awFReVqU4V+0Dl89nPiWB8VyoRhxzDa6Stid2H9BbxyjFNm
        nefYZgRm+gG1E6ED+FF1WBsOHTQGJhv79zhlWeOYVyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DP3IFV
        7O0PwvYCc3AZYI/vmuy/3QNS5F78JptSjjd7w=; b=lyzTt1LV8uk6n7ys/02CXm
        9tedPBopJ8KE4zwWm3u6O1Uy2wKk6vxi8oDRV6wFVSVr2NfwRXZCmjCM0ETYDtPe
        EfVpEBggWtePxH9rk/8xCBkg3K8NTsnqiipCxxV45zn5ojz9I2mVBa4U20Z2WMpE
        KGNc/2GZrHQ1tWVmy/ftnqu1py33pNp4EmDQHXghTD/Xr50lNkPZv6vdyi22eW1/
        TP4YISp2GE3Y2qYlDPGhkho0lDSjt33jmN//Jj3OuJ3xoY0mAaZUyR6UtAyYBtcL
        rbXTVW/UtIRYuNjjXWtYzaU7vaesTVbtbiSZwWgU2Pa6s1UiKW5Bu4ORgTEZSzHQ
        ==
X-ME-Sender: <xms:htbUW2A6SDymiN6piThmnnvYVPBTbX_cJEx1ambMgnKzMYGYnrMaHA>
X-ME-Proxy: <xmx:htbUW8L1eoSqFazOv01Sp42zPaNmdV8k9ep8rlH6oPLlUGqYgUCQwg>
    <xmx:htbUW0tExwg-b7schdYM6T4MOCyo62pbNfJYPYIaaHTJUvmn-v6TJw>
    <xmx:htbUWzwaUWD9kYAHzombF8PCJDm29LVaQQqOgJKqV-XZdayxxWK73A>
    <xmx:htbUW-dwPTQfe9-xbk9tQsgqouq6OG29Jpg4Urwa7LAoq3wvKHgrCA>
    <xmx:htbUW0KyuVG-W4XocBaM9xBVKWeGH_obkQywVj5pdI3_k0AVqQak7w>
    <xmx:h9bUWzX4csyedVbH2iM0tgsyf4PneFmBMiuQVHLCN97hXMSY16PcyA>
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id 870D9102DD;
        Sat, 27 Oct 2018 17:20:06 -0400 (EDT)
Subject: Re: Have 15GB missing in btrfs filesystem.
To:     Marc MERLIN <marc@merlins.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
 <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
 <20181027174245.4isfcb6nv4pkklmd@merlins.org>
 <d530a9d0-4cee-521b-6c95-ff56d0f7c130@georgianit.com>
 <20181027201933.wrquhmdrg3z2fa2o@merlins.org>
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
Message-ID: <0d2b2e8e-571b-3001-6bab-9c74c005b868@georgianit.com>
Date:   Sat, 27 Oct 2018 17:20:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.8.0
MIME-Version: 1.0
In-Reply-To: <20181027201933.wrquhmdrg3z2fa2o@merlins.org>
Content-Type: multipart/mixed;
 boundary="------------9452B26E43C15F6FCCFB3768"
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------9452B26E43C15F6FCCFB3768
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2018-10-27 04:19 PM, Marc MERLIN wrote:

> Thanks for confirming. Because I always have snapshots for btrfs
> send/receive, defrag will duplicate as you say, but once the older
> snapshots get freed up, the duplicate blocks should go away, correct?
> 
> Back to usage, thanks for pointing out that command:
> saruman:/mnt/btrfs_pool1# btrfs fi usage .
> Overall:
>     Device size:		 228.67GiB
>     Device allocated:		 203.54GiB
>     Device unallocated:		  25.13GiB
>     Device missing:		     0.00B
>     Used:			 192.01GiB
>     Free (estimated):		  32.44GiB	(min: 19.88GiB)
>     Data ratio:			      1.00
>     Metadata ratio:		      2.00
>     Global reserve:		 512.00MiB	(used: 0.00B)
> 
> Data,single: Size:192.48GiB, Used:185.16GiB
>    /dev/mapper/pool1	 192.48GiB
> 
> Metadata,DUP: Size:5.50GiB, Used:3.42GiB
>    /dev/mapper/pool1	  11.00GiB
> 
> System,DUP: Size:32.00MiB, Used:48.00KiB
>    /dev/mapper/pool1	  64.00MiB
> 
> Unallocated:
>    /dev/mapper/pool1	  25.13GiB
> 
> 
> I'm still seing that I'm using 192GB, but 203GB allocated.
> Do I have 25GB usable:
>     Device unallocated:		  25.13GiB
> 
> Or 35GB usable?
>     Device size:		 228.67GiB
>       -
>     Used:                        192.01GiB
>       = 36GB ?    
> 


The answer is somewhere between the two.  (BTRFS's estimate of 32.44
Free is probably as close as you'll get to predicting.)

So you have 7.32GB  allocated but still free space for data, and 25GB of
completely unallocated disk space. However, as you add more data, or
create more snapshots and create metadata duplication, some of that 25GB
will be allocated for Metadata.  Remember that Metadata is Duplicated
(so that 3.42GB of Metadata you are using now is actually using 6.84GB
of disk space, out of the allocated 11GB

You want to be careful that unallocated space doesn't run out.    If the
system runs out of usable space for metadata, it can be tricky to get
yourself out of the corner.  That is why a large discrepency between
Data Size and Used would be a concern.  If those 25GB of space were
allocated to data, your would get out of space errors even if the 25GB
was still unused.

On that note, you seem to have a rather high metadata to data ratio..
(at least, compared to my limited experience.).  Are you using noatime
on your filesystems?  without it, snapshots will end up causing
duplicated metadata when atime updates.





--------------9452B26E43C15F6FCCFB3768
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


--------------9452B26E43C15F6FCCFB3768--
