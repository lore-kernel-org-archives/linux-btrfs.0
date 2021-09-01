Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979D3C432BE
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Sep 2021 17:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 754AB60FDC
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Sep 2021 17:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346012AbhIARlx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 13:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346006AbhIARlw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Sep 2021 13:41:52 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A184AC061575
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Sep 2021 10:40:54 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id f2so413419ljn.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Sep 2021 10:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pu5pHNR2RLAPoTYYKi1id/1h9JUOwpnuHawpA3+3k9g=;
        b=WdPLj2ArPK9QgRCuKqOMtsWnvIumqaqWkVNvzfrpv2/vkSN8zYFSGWwjuEDtfr7KGu
         3kTs//0VKdHQOLiwUKjKuUkbGvem7XOSuGnFq3kRejm9hOV5+Cs1AtFA5InLetaiVi5i
         x3TwMLv6MA1T1WtKErKZR4wxs8+DDRrJ0HiFPmB5hh/1os9PiYbxEg3XIWF6xtUcIbpl
         2OtuKRWuJbCdME3hmw/NypYOghuPCCgLiMxO8FK/Dk8+nd00UlHJk0eR757vbTH+rJWS
         dKmrdavBfPd62EH+3bGuO5bmA73qkul/w4P9FTI+cOKPvhJx7+TiSfSe/l4ro22zt0JC
         XMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pu5pHNR2RLAPoTYYKi1id/1h9JUOwpnuHawpA3+3k9g=;
        b=B413UD5pOlcm6/y78i9Su55/tEoqcILhQbLFBn2KVYrTZHzdKrypvYUATNS2Vbqpt8
         T8fE/HaNwibZ5QZOmI7+KnQq5OpYURlq2ue/75NVjOciuMH3Q8H3q1nK8DsKkFkm6w1O
         q/J2OGnGrWEPU+Uva4pAS7HXbsE+5yXagJv7A3ivHn+UdsJoLYWBk8Gu6m+FyA5dQfZz
         xcSBbNmDUaodCcaKfNRYCUpusSE6sAj6tyNpSXlV0Qqo40HKQG/LYOIhGFAzinabrE1A
         BOL1OtpAQQivcGdu7UN7C8E73cMXRaIPL1rkVoQbSYovo27TpzJD/+TiR+RLLGUkb0mM
         KQCw==
X-Gm-Message-State: AOAM532hFEu1lFUuxOEDyPkYZ7QQScKwl8zZlD2yiRsDoOtCOdz8uRHv
        C+uFFnITXxkkl0qClOf0gjwqHFVTBpg=
X-Google-Smtp-Source: ABdhPJx/M6iOVXAQ8fuI4raG2UipxX5AqFX0Fkua/6IuiWeqb7Vr7C12I5kGdUcnkQviJvwzmy8jeA==
X-Received: by 2002:a2e:9e1a:: with SMTP id e26mr678963ljk.265.1630518052539;
        Wed, 01 Sep 2021 10:40:52 -0700 (PDT)
Received: from ?IPv6:2a00:1370:812d:8deb:5c9c:cef9:590c:9452? ([2a00:1370:812d:8deb:5c9c:cef9:590c:9452])
        by smtp.gmail.com with ESMTPSA id t184sm13770lff.250.2021.09.01.10.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 10:40:51 -0700 (PDT)
Subject: Re: Backup failing with "failed to clone extents" error
To:     Darrell Enns <darrell@darrellenns.com>, fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAOaVUnV3L6RpcqJ5gaqzNXWXK0VMkEVXCdihawH1PgS6TiMchQ@mail.gmail.com>
 <CAL3q7H46BpkE+aa00Y71SfTizpOo+4ADhBHU2vme4t-aYO6Zuw@mail.gmail.com>
 <CAOaVUnXXVmGvu-swEkNG-N474BcMAGO1rKvx26RADbQ=OREZUg@mail.gmail.com>
 <CAL3q7H5UH012m=19sj=4ob-d_LbWqb63t7tYz9bmz1wXyFcctw@mail.gmail.com>
 <CAOaVUnVL508_0xJovhLqxv_zWmROEt-DnmQVkNkTwp0GHPND=Q@mail.gmail.com>
 <CAL3q7H7MxhvzLAe1pv+R8J=fNrEX2bDMw1xWUcoZsCCG-mL5Mg@mail.gmail.com>
 <CAOaVUnXB4qoAyVcm3H03Bj2rukZ+nbSzOdB4TsKpJjH8sqOr7g@mail.gmail.com>
 <CAL3q7H7vTFggDHDq=j+es_O3GWX2nvq3kqp3TsmX=8jd7JhM1A@mail.gmail.com>
 <CAOaVUnW6nb-c-5c56rX4wON-f+JvZGzJmc5FMPx-fZGwUp6T1g@mail.gmail.com>
 <CAL3q7H6h+_7P7BG11V1VXaLe+6M+Nt=mT3n51nZ2iqXSZFUmOA@mail.gmail.com>
 <CAL3q7H5p9WBravwa6un5jsQUb24a+Xw1PvKpt=iBdHp4wirm8g@mail.gmail.com>
 <CAOaVUnXDzd-+jvq95DGpYcV7mApomrViDhiyjm-BdPz5MvFqZg@mail.gmail.com>
 <CAL3q7H5y6z7rRu-ZsZe_WXeHteWx1edZi+L3-UL0aa0oYg+qQA@mail.gmail.com>
 <CAOaVUnW6GzK6ANOUz4x+BBXz90sgaT_TJuQUm869CYa6qH2KSA@mail.gmail.com>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ce80dccc-f829-5193-a97b-262c669fb29c@gmail.com>
Date:   Wed, 1 Sep 2021 20:40:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAOaVUnW6GzK6ANOUz4x+BBXz90sgaT_TJuQUm869CYa6qH2KSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 01.09.2021 20:16, Darrell Enns wrote:
> I'm not sure how this would happen. These subvolumes were all created
> with snapper (snap-sync just calls snapper). They were not received
> from another filesystem, and I don't think they've ever been RW
> (unless snapper for some reason does that?).
> 
> Received_uuid is actually the same on *all* my snapshots, and it's the
> same as the original "@root" subvolume as well. Is each one supposed
> to have a unique received_uuid? 

Received_uuid is expected to be managed by "btrfs receive" only. It can
be seen as "dataset identifier" - identical received_uuid means both
subvolumes have identical content (identical from btrfs point of view,
having the same files is not enough). It is valid to cascade
send/receive so if A was sent to B and then B was sent to C, both B and
C will have identical received_uuid equal to A uuid because the have the
same content (all three subvolumes are expected to be read-only and so
cannot be changed).

Unfortunately there are a lot of possibilities to completely break this
workflow. Your case is one example.


> Is this somehow because my "@root"
> subvolume was originally created by receiving from another btrfs?
> 

Most likely. Did you simply make received subvolume read-write?
