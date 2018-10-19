Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683E9ECDE43
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 17:59:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F81821470
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 17:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YHjTl2HV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F81821470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbeJTCGt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 22:06:49 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:39620 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbeJTCGs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 22:06:48 -0400
Received: by mail-lj1-f182.google.com with SMTP id p1-v6so31587200ljg.6
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2018 10:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=if8g6RnXiZCggg9xWpOw36NKDh29lkHsHAfXRPvyQvg=;
        b=YHjTl2HVKIGGX2Z5YvSpI4hb3FhHDoXvQl3xUcMsb9ZK2snIuu8clIOq7I+l8Ug7cR
         1+02gh5ZKEd14vcWN/MR6zub4mmU03VGoY5KdG7COqN+sB0+yaLdzzGItUOoAZ0aQPFM
         H3cCr0TXLCo2M++BWY3ZkvMHrGyRq/lTRU6izdA8sJGoqGRoKjFEWJpDJnONYpWj+kzR
         zkylalxXfFjURGESKR8QAHn6tWBHoFNB8fJ5vqKeBQqJXBj9tBBgNqfvYnYrkpBGs7uf
         F/lxf3UjDiuQE2PY+cCHoqgY8bWF0163PZEi3oFsUHdX8PUMqoGaJ22lF8/mc94/ggDa
         d6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=if8g6RnXiZCggg9xWpOw36NKDh29lkHsHAfXRPvyQvg=;
        b=qCE35Ffy7wNgoRXcivr8HiSSVtc6sRooaPfWheYOkp13Ba3xPjEAAn/9eRRh63501c
         BBnKENDnEcdkBhaQUcbbJjV0HrBRbMmJFv4KhpuxnL+LnDwQR+PTpfcgX53XagyGFmP6
         Rx8O4t/D2+DF5HoEdAz03xdTEY4D7tjrh+PcoIE6BBNIORr5LZJAGvSIPLKUs2Jcs28Q
         OsL/aSOk+wkWGWkyqfJDIAdOJ7tyHOL7AAPYuG+7z+gVOji6uHY9KfwzcXoU8gtZD2VK
         fB/zHVc51QV6lVhThe4VVG3Yhu1pyRI6mMmM8X+CUB+SuHGRXIYnRhO8RqtSlffJ/Z+C
         EXWQ==
X-Gm-Message-State: ABuFfogijpbX5cLaal8LWE+omcZES9Oh21Fap7FrApO8JOvVZUaSNDdT
        3l3O+oKKOz+Ym1Ykamlvx89y0OXQ
X-Google-Smtp-Source: ACcGV62260H7sam8sctSuzTjI7cFOkpOdOt9R5FjyOlaFz8hcgKMzZ6/7wnFtoUB8QKZe54msvyeeg==
X-Received: by 2002:a2e:9d7:: with SMTP id 206-v6mr25301724ljj.127.1539971979148;
        Fri, 19 Oct 2018 10:59:39 -0700 (PDT)
Received: from [192.168.1.4] (109-252-55-124.nat.spd-mgts.ru. [109.252.55.124])
        by smtp.gmail.com with ESMTPSA id f81-v6sm5323781lfi.50.2018.10.19.10.59.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Oct 2018 10:59:38 -0700 (PDT)
Subject: Re: Is it possible to construct snapshots manually?
To:     Cerem Cem ASLAN <ceremcem@ceremcem.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAN4oSBcEi7Lxt7D3KrZ=jtU3g=DtN7mwUpPQ8zLrvwRjtKRCXw@mail.gmail.com>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
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
Message-ID: <225de89a-8a7f-a8aa-4250-15d7e7dd0350@gmail.com>
Date:   Fri, 19 Oct 2018 20:59:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAN4oSBcEi7Lxt7D3KrZ=jtU3g=DtN7mwUpPQ8zLrvwRjtKRCXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

19.10.2018 12:41, Cerem Cem ASLAN пишет:
> By saying "manually", I mean copying files into a subvolume on a
> different mountpoint manually, then mark the target as if it is
> created by "btrfs send | btrfs receive".
> 
> Rationale:
> 
> When we delete all common snapshots from source, we have to send whole
> snapshot for next time. This ability will prevent sending everything
> from scratch unless it's necessary.
> (https://unix.stackexchange.com/q/462451/65781)
> 

You can set received UUID as this link suggests. How it can be done was
posted on this list more than once.

> Possible workaround:
> 
> I've got an idea at the moment: What I want can be achieved by
> dropping usage of "btrfs send | btrfs receive" completely and using
> only rsync for transfers. After transfer, a snapshot can be created
> independently on the remote site. Only problem will be handling the
> renamed/relocated files, but `rsync --fuzzy` option might help here:
> https://serverfault.com/a/489293/261445
> 
> Anyway, it would be good to have a built in support for this.
> 

No. It is already possible to shoot oneself in the foot; there is no
need to make it easily done by accident or misunderstanding.
