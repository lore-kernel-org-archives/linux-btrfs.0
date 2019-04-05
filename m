Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B58CC282CE
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 20:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 473D52146F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 20:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mokrynskyi.com header.i=@mokrynskyi.com header.b="l6CPEs7G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfDEUX3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 16:23:29 -0400
Received: from mx.mokrynskyi.com ([46.4.12.50]:50778 "EHLO mx.mokrynskyi.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbfDEUX2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 16:23:28 -0400
Received: from localhost (localhost [127.0.0.1])
        by mx.mokrynskyi.com (Postfix) with ESMTP id 236DC3A96
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Apr 2019 20:23:27 +0000 (UTC)
Authentication-Results: mx.mokrynskyi.com (amavisd-new);
        dkim=pass (1024-bit key) reason="pass (just generated, assumed good)"
        header.d=mokrynskyi.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mokrynskyi.com;
         h=content-transfer-encoding:content-language:content-type
        :content-type:in-reply-to:mime-version:user-agent:date:date
        :message-id:organization:from:from:references:to:subject
        :subject; s=dkim; t=1554495806; x=1555359807; bh=Qj52cwAaHifoFod
        1q3RkHuTO+JgXaPOdqUv79HE15P8=; b=l6CPEs7GEIo8pBIflxJPb4sryPiLdw9
        kFPWT2ku4Z8rii3lAZrQ0MaUCzFn/LkyJIhe8OA7/prnO1lUzgr6ZEWIH4KpnwkO
        JrQjiqdJh20Pk6fCIhViAmwHOSTOxq08vud4q8SiO0+om/g6evkedVpGZSycqYoj
        YfrvYmlBwazE=
X-Virus-Scanned: Debian amavisd-new at mx.mokrynskyi.com
Received: from mx.mokrynskyi.com ([127.0.0.1])
        by localhost (mx.mokrynskyi.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id H87VVGP-VlCP for <linux-btrfs@vger.kernel.org>;
        Fri,  5 Apr 2019 20:23:26 +0000 (UTC)
Received: from [192.168.1.2] (bomann.znet.kiev.ua [176.122.88.128])
        by mx.mokrynskyi.com (Postfix) with ESMTPSA id A160C3A82;
        Fri,  5 Apr 2019 20:23:26 +0000 (UTC)
Subject: Re: corrupt leaf, bad key order on kernel 5.0
To:     Hugo Mills <hugo@carfax.org.uk>
References: <af457d27-16b5-2900-8289-98462b6de770@mokrynskyi.com>
 <20190405193218.GC1084@carfax.org.uk>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   Nazar Mokrynskyi <nazar@mokrynskyi.com>
Organization: CleverStyle, Ecoisme
Message-ID: <d0ab0fb3-df1b-8eb2-e7a4-2203cc599c28@mokrynskyi.com>
Date:   Fri, 5 Apr 2019 23:23:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:67.0) Gecko/20100101
 Thunderbird/67.0
MIME-Version: 1.0
In-Reply-To: <20190405193218.GC1084@carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: uk
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

05.04.19 22:32, Hugo Mills =D0=BF=D0=B8=D1=88=D0=B5:
>> Yet another corruption of my root BTRFS filesystem happened today.
>> Didn't bother to run scrub, balance or check, just created disk image =
for future investigation and restored everything from backup.
>>
>> Here is what corruption looks like:
>> [=C2=A0 274.241339] BTRFS info (device dm-0): disk space caching is en=
abled
>> [=C2=A0 274.241344] BTRFS info (device dm-0): has skinny extents
>> [=C2=A0 274.283238] BTRFS info (device dm-0): enabling ssd optimizatio=
ns
>> [=C2=A0 310.436672] BTRFS critical (device dm-0): corrupt leaf: root=3D=
268 block=3D42044719104 slot=3D123, bad key order, prev (1240717 108 4144=
7424) current (1240717 76 41451520)
>    "Bad key order" is usually an indicator of faulty RAM -- a piece of
> metadata gets loaded into RAM for modification, a bit gets flipped in
> it (because the bit is stuck on one value), and then the csum is
> computed for the page (including the faulty bit), and written out to
> disk. In this case, it's not obvious, but I'd suggest that the second
> field of the key has been flipped, as 108 is 0x6c, and 76 is 0x4c --
> one bit away from each other.
>
>    I recommend you check your hardware thoroughly before attempting to
> rebuild the FS.
>
>    Hugo.

Hm... this might indeed be related to RAM being overclocked a bit too muc=
h. It worked fine for a long time, but apparently not 100% stable.
Rolled back overclock, thanks for suggestion!

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

