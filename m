Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF89C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 06:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 193D7206DD
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 06:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k27cM1MH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfCBGXS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Mar 2019 01:23:18 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:34388 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbfCBGXS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2019 01:23:18 -0500
Received: by mail-lj1-f176.google.com with SMTP id l5so22378269lje.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 22:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:openpgp:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=U1qgmZycAS9KLNE4Sh4LsG0Jt8WAx/tREJfnQ6bO2rY=;
        b=k27cM1MHiFPomU9Bl5EL12byQomrHSIMeFoXRBAkoWxD6K0QtmRRMugwIrC3ennGaq
         wG35x+mP0bye5N5IzYIiKTbaMSJtjAXk6qel8Iu2n2HgWJ6DcKsY9MLuWmf0e0la8DzO
         3UcLVnu2ROQB41WVvEt/iaaUC0VKgcPG75clExwvpxF4/BGQGSdG2JyPboh04eVUJI0d
         DxrGPONJ9FEBo+/dm4Vn4FJGSRkkbDX6+rPzLwS1cXhhUCJXCMrf1Ag3KosI33dZtcmY
         KmbZMlyOaPMqY7aQSeLtLw0ypW4XJ6wMzq7x99E3dmtSIVO015f3TXtnKvlgNPpDxdwq
         RRYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:openpgp:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=U1qgmZycAS9KLNE4Sh4LsG0Jt8WAx/tREJfnQ6bO2rY=;
        b=I4vu6Y6qu/6u5J6Uvdw/+WHGCZLC8ixu6DGD5+2vyyrZs6i4r6bauD2AhFO0u5aqsm
         aI4UMTq0Ar5jyZOQ3ZA+oc5mXo5HqyCg0c2VmdG8pWdr6vpnnA1ZqTa+C0v6KH0eYXwh
         BnEyg9ov7U3+M9EeIgJw3cx5ixi+dxet1xe//b64SpnYAWDPonOPZDYIfsNGJyjSQ2xF
         acQXaYzbYXjIuksqoCu9IrgdA6V5V9lhAF08hdKWLE7n5aoNa9jedXl90CLnTJU9hH+l
         h7SHc+ecH/oO0VYeaMWCt2b8fzW5ua8VRJZmWKmCv6xTcvv77Ar2YacqxD+pQugzseAy
         IFbw==
X-Gm-Message-State: APjAAAUnx80giPSE+YJb+pF9VkBbaqRSEAIJoPl0RpNW8l451gQthjSt
        2uEctlfHL2SDOjUrYxyuFRWDKuNcqEE=
X-Google-Smtp-Source: APXvYqzBP8KyZ9SI924yFanfh61tU3kPpCYzDFq62ppQDigxrnxgvpZ0h69MUO54EyTKywtfK4d+KQ==
X-Received: by 2002:a2e:97ce:: with SMTP id m14mr4858647ljj.162.1551507796062;
        Fri, 01 Mar 2019 22:23:16 -0800 (PST)
Received: from [192.168.1.4] ([109.252.90.29])
        by smtp.gmail.com with ESMTPSA id y5sm2949lfe.61.2019.03.01.22.23.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Mar 2019 22:23:15 -0800 (PST)
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Getting qgroup reports in user space (without enabling qroup)?
Openpgp: preference=signencrypt
Autocrypt: addr=arvidjaar@gmail.com; prefer-encrypt=mutual; keydata=
 xsDiBDxiRwwRBAC3CN9wdwpVEqUGmSoqF8tWVIT4P/bLCSZLkinSZ2drsblKpdG7x+guxwts
 +LgI8qjf/q5Lah1TwOqzDvjHYJ1wbBauxZ03nDzSLUhD4Ms1IsqlIwyTLumQs4vcQdvLxjFs
 G70aDglgUSBogtaIEsiYZXl4X0j3L9fVstuz4/wXtwCg1cN/yv/eBC0tkcM1nsJXQrC5Ay8D
 /1aA5qPticLBpmEBxqkf0EMHuzyrFlqVw1tUjZ+Ep2LMlem8malPvfdZKEZ71W1a/XbRn8FE
 SOp0tUa5GwdoDXgEp1CJUn+WLurR0KPDf01E4j/PHHAoABgrqcOTcIVoNpv2gNiBySVsNGzF
 XTeY/Yd6vQclkqjBYONGN3r9R8bWA/0Y1j4XK61qjowRk3Iy8sBggM3PmmNRUJYgroerpcAr
 2byz6wTsb3U7OzUZ1Llgisk5Qum0RN77m3I37FXlIhCmSEY7KZVzGNW3blugLHcfw/HuCB7R
 1w5qiLWKK6eCQHL+BZwiU8hX3dtTq9d7WhRW5nsVPEaPqudQfMSi/Ux1kc0mQW5kcmVpIEJv
 cnplbmtvdiA8YXJ2aWRqYWFyQGdtYWlsLmNvbT7CZQQTEQIAJQIbAwYLCQgHAwIGFQgCCQoL
 BBYCAwECHgECF4AFAliWAiQCGQEACgkQR6LMutpd94wFGwCeNuQnMDxve/Fo3EvYIkAOn+zE
 21cAnRCQTXd1hTgcRHfpArEd/Rcb5+SczsBNBDxiRyQQBACQtME33UHfFOCApLki4kLFrIw1
 5A5asua10jm5It+hxzI9jDR9/bNEKDTKSciHnM7aRUggLwTt+6CXkMy8an+tVqGL/MvDc4/R
 KKlZxj39xP7wVXdt8y1ciY4ZqqZf3tmmSN9DlLcZJIOT82DaJZuvr7UJ7rLzBFbAUh4yRKaN
 nwADBwQAjNvMr/KBcGsV/UvxZSm/mdpvUPtcw9qmbxCrqFQoB6TmoZ7F6wp/rL3TkQ5UElPR
 gsG12+Dk9GgRhnnxTHCFgN1qTiZNX4YIFpNrd0au3W/Xko79L0c4/49ten5OrFI/psx53fhY
 vLYfkJnc62h8hiNeM6kqYa/x0BEddu92ZG7CRgQYEQIABgUCPGJHJAAKCRBHosy62l33jMhd
 AJ48P7WDvKLQQ5MKnn2D/TI337uA/gCgn5mnvm4SBctbhaSBgckRmgSxfwQ=
Message-ID: <8a91a9b3-8b4c-2df4-1c69-9e260816a2ca@gmail.com>
Date:   Sat, 2 Mar 2019 09:23:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Is there any user-space tool that can produce report similar to "btrfs
qgroup show" with multi-level qgroups? To clarify what I mean - here is
"btrfs qgroup show" output from openSUSE with enabled snapper.

qgroupid         rfer         excl parent
--------         ----         ---- ------
...
0/259         6.17GiB    262.43MiB ---
...
0/702         6.03GiB      1.30GiB 1/0
0/718         6.04GiB     89.88MiB 1/0
0/720         6.52GiB     87.28MiB 1/0
0/724         6.10GiB     29.16MiB 1/0
0/727         6.78GiB    217.02MiB 1/0
0/729         6.24GiB     39.25MiB 1/0
0/731         6.65GiB     72.67MiB 1/0
0/732         6.24GiB    212.18MiB 1/0
0/741         6.35GiB    778.79MiB 1/0
0/742         6.58GiB     74.09MiB 1/0
1/0          20.33GiB     14.42GiB ---
...

Without qgroups there is really no way to find out how much space
snapshots are taking. "btrfs fi du" just shows equivalent of "rfer" and
"excl" for each subvolume, but there is no way you can compute the
values shown for 1/0 qgroup from individual numbers.

I do not think "btrfs fi du" can do it as it only knows whether extent
is shared or not, it cannot know whether extent is shared between
specific subvolumes.

Is something like this even possible in user space without qgroups? It
is well known that qgroups are frowned upon and common advice is to
disable them as soon as someone reports performance issues.
