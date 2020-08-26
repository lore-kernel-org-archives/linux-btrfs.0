Return-Path: <SRS0=f55l=CE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF574C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 13:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24386208E4
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Aug 2020 13:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="bHgST7z6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgHZNhY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 09:37:24 -0400
Received: from mail-40140.protonmail.ch ([185.70.40.140]:44216 "EHLO
        mail-40140.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730134AbgHZNhX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Aug 2020 09:37:23 -0400
Date:   Wed, 26 Aug 2020 13:37:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1598449040;
        bh=iWU/i0hVnB+C4lhpgqOsylhh4wyExI7oC89Y3vyKPp4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=bHgST7z6CWhlEJDnTc/Z3EI4Eb+6oQbwzCp3SVlVrZ4FJ3eA8hmar7MqKxUXsyB8z
         YMEO+hnXOo4ze95xK5QpDiGty1uTUGbRGER+QYxr1P9lG9thPwQEqW5KlrRZXdCDG6
         KpvCLgSw1mIxms9ZoGOmKmVIlAg8W9NSbMmxCupo=
To:     Chris Murphy <lists@colorremedies.com>
From:   Andrii Zymohliad <azymohliad@protonmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Andrei Borzenkov <arvidjaar@gmail.com>
Reply-To: Andrii Zymohliad <azymohliad@protonmail.com>
Subject: Re: [Help] Can't login to my systemd-homed user account due to fallocate failure
Message-ID: <emBWetDIaC_TYsBRNRlPcz-yLjIOxlhIBny_K9bTqHxLO_kdKRZlGjMoHrVj4CwZ8aZAnMcXEyCj95vBFBxxOvJ1AANQr1sbeQ_CfZOrTH0=@protonmail.com>
In-Reply-To: <CAJCQCtQDt=x7WCX7KhWz_pPn4yB1YdZm9jN29jRuQDFy=ZTOjA@mail.gmail.com>
References: <bdJVxLiFr_PyQSXRUbZJfFW_jAjsGgoMetqPHJMbg-hdy54Xt_ZHhRetmnJ6cJ99eBlcX76wy-AvWwV715c3YndkxneSlod11P1hlaADx0s=@protonmail.com> <BfU9s11rmWxGNQdKqifkB1JKOJcgqAN49OZdV4LAOgo1W2AguRebwCPVosOiMVjMTzuSmsk_Efbkl02s31niRqtCS67WJ9S7_s4jiK9afeA=@protonmail.com> <E212ihR5U8HVCyaalepkxQUX3wOj6IXd1yUFHj-PFFtyU7ma-A49vmB8QwfQG5gUVo2nCMbVpPo7C2ccooRO0ExVrIbdLP9sBpnjMOcefHo=@protonmail.com> <lyGE8gPEf9cUEMJceWoJWD_ibk4viZXU0yG5VzbNe9yueGbkcnl1FkJrFZZufhWd5y2vNOgAwfYSpJ4Gia5Tow4wdmQXiGuETdyuNmnemJY=@protonmail.com> <CAJCQCtR3gbJxJn24qyDfHWh9kQG7BSC=NnoGHmRKPnaQ+P7yyg@mail.gmail.com> <8oT9s0Jlzpgp2ctPAXOixSR03oOiPXaitR0AiOkNdBsYHwjPMfjK7CoVAPXuvj71hiUTH-fKoSevAM-To8iSPPBvGRvZeBkU0Nd1_NPonyU=@protonmail.com> <CAJCQCtQH3h=NNr6PX3HZp7SbkgqZtNNdihi4aBMFvx+DN79XeA@mail.gmail.com> <6LDov933WqF3kLH8jtkEh-pfK6pRe0o6-Y9l3NcO2mVhswDL7rhbHyda71OnztoJKfgqqQT9jj1Ba52lz_ugNFmmRtzN33BlSa5pCvds0F8=@protonmail.com> <CAJCQCtQDt=x7WCX7KhWz_pPn4yB1YdZm9jN29jRuQDFy=ZTOjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> Try more of those shared addresses. If you can do python at all,
> there's python-btrfs
> https://github.com/knorrie/python-btrfs
>
> He gave this example, which I don't follow because I don't do python
> at all, but the vaddr is the filefrag -v address from before * 4096.
> You could just iterate by incrementing by 4096 and stop as soon as you
> get two files (or two inodes). And then us find -inum to track down
> the inode numbers to files.
>
> https://github.com/knorrie/python-btrfs

Which example exactly? There are many in the repo.

I'm ok with python, but to save time learning the API of the library I've m=
ade a simple bash script:

    mkdir -p shared_extents
    addrs=3D$(filefrag -v /home/azymohliad.home | grep shared | awk '{print=
 $3}' | tr -d '.')
    for addr in $addrs; do
        btrfs inspect-internal logical-resolve $[$addr * 4096] / > shared_e=
xtents/$addr.txt
        if [ $(wc -l shared_extents/$addr.txt | awk '{print $1}') -gt 1 ]; =
then
            cat shared_extents/$addr.txt
        fi
    done

It should print the outputs of "btrfs inspect-internal logical-resolve $[$a=
ddr * 4096]" if it's more than 1 line. And it prints nothing.
Every "btrfs inspect-internal ..." output here is just "//home/azymohliad.h=
ome" for each of these shared extents (I can double check it from "cat shar=
ed_extents/*").


