Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A3CC07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 04:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 548652082D
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 04:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2C3QSAo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 548652082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbeLGEJ4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 23:09:56 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:34288 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbeLGEJ4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2018 23:09:56 -0500
Received: by mail-lj1-f170.google.com with SMTP id u6-v6so2388961ljd.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2018 20:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UjG+fVRoUDK8D9pWdnaiXQqndtHzGi/4x1zuXJs6B2E=;
        b=m2C3QSAok5/NLt4UfcdN/NYTh+uZ3XqNdlocu45IZeYyfWoXi4l5345qyERmFVr1PI
         KobA6X28wEBmsu8W+05iwxWEhsXp4HLCeOJUwWFdsaBDsJgIR0AfCDzAtg0sZT8VcR07
         hWica9PbnaGIOXDNQyo0VixCShfHc3O119EsBIPGvVcb20XXEwLAXQUSvLZ752azpXXv
         pUDzLj/dK+Vw2QggeTGdQB5nrbJr+B/9ObpZH4+WExc9rgQ7GOt6unEEGlsiB/WwmzBz
         5zTyQap9eibraNYwwf19Id0hc7B5njLQYPqQRTFXhOQNHswSA63a/a29d1+fsfdB6t0o
         G4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=UjG+fVRoUDK8D9pWdnaiXQqndtHzGi/4x1zuXJs6B2E=;
        b=PSt17qCRopdR30SH5vTSCqZ8sNwZ+/Fa3K1x9jl6b1XqmYPpTAH9GlZ03scqQQ3r9D
         d1bozmSerlODZNO8HEpHQPh7uJX50eR+r8oDej8Ht4Qt9YPu9eHELXsXnb7MwBQe2uG0
         nDo6uO67hb+e5I4qTreat09RANg2MHIC+u0pAJzawmryVsQAZsSMnyooJUtI7m7avRk0
         2WtGIvHALidR8MRxGA2uIFz8OWCkRo2nIlvlhgDVAkqnT8TBrDPQOlbYh4kgtZAghuoa
         0PxBdkuZMIxDQzQ1Tb32n3QBhC2QQM7aUEPdbCiZWZ3ZDnaIv8xV5iSHpgPHdPvKrj/e
         rHHw==
X-Gm-Message-State: AA+aEWaCeM0e8jrojxpeAp+s/5siUntPKjMR1DlM2sNO/Uu412DKw9/N
        8pTAcHgMl2LA4sBWeGFOeqOc28Af6Bo=
X-Google-Smtp-Source: AFSGD/UpgodRJTcwOe4SeMyOvnP0l566BuXKaFUEsEi3G/ClblMxmaDAb1XjvfVN/9zH2Q0kHaOahg==
X-Received: by 2002:a2e:94ce:: with SMTP id r14-v6mr332846ljh.34.1544155793550;
        Thu, 06 Dec 2018 20:09:53 -0800 (PST)
Received: from [192.168.1.4] (109-252-55-124.nat.spd-mgts.ru. [109.252.55.124])
        by smtp.gmail.com with ESMTPSA id p19-v6sm382036ljb.47.2018.12.06.20.09.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Dec 2018 20:09:51 -0800 (PST)
Subject: Re: What if TRIM issued a wipe on devices that don't TRIM?
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Robert White <rwhite@pobox.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
 <6c2a6a00-509d-1585-381f-68582c44591f@gmail.com>
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
Message-ID: <90f90edd-c22c-b36e-4394-5a17b2a986ec@gmail.com>
Date:   Fri, 7 Dec 2018 07:09:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <6c2a6a00-509d-1585-381f-68582c44591f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

06.12.2018 16:04, Austin S. Hemmelgarn пишет:
> 
> * On SCSI devices, a discard operation translates to a SCSI UNMAP
> command.  As pointed out by Ronnie Sahlberg in his reply, this command
> is purely advisory, may not result in any actual state change on the
> target device, and is not guaranteed to wipe the data.  To actually wipe
> things, you have to explicitly write bogus data to the given regions
> (using either regular writes, or a WRITESAME command with the desired
> pattern), and _then_ call UNMAP on them.

WRITE SAME command has UNMAP bit and depending on device and kernel
version kernel may actually issue either UNMAP or WRITE SAME with UNMAP
bit set when doing discard.

