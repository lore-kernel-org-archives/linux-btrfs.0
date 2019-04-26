Return-Path: <SRS0=BNt3=S4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0988FC43218
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 18:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9BFA2077B
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Apr 2019 18:27:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxGrIfcA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfDZS16 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Apr 2019 14:27:58 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:39514 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfDZS15 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Apr 2019 14:27:57 -0400
Received: by mail-lj1-f174.google.com with SMTP id q10so3778132ljc.6
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2019 11:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w4GUrAmQ0WR5Y0MdUrG5ZCJaQdaFRnaZxyUWnx3BBAA=;
        b=dxGrIfcAgmzNNTcn0/wxrL1IG09Av1fZQUvWPY9armOnOZyV4yGFMW/0lDtAJ6wCux
         NY5QNlO6ffGTNWVXNYDGTIPMsYHF1jjjDMYmTs1tTkgj8c0RcjibHR+nmKK4DYYZACK7
         q0gJmEI5prUskJlGoOFIZxVjn8hMwK51YheeKgW9W6a6FhPxl0Jz0HTzTknAU7Ca1zQs
         w7OY+XE4PRhg+q5MpEjDLJzM27s3xidxNSjrJSDfyKNR5en5PG58xzbpvNnfWEV/gtjp
         ggrD3CjrCJVjFeYcRYdLd2hrcLJgM/xbPGRsZ5Y1mBiPkj363J6w/+x8vBS++xZSlThW
         2uJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=w4GUrAmQ0WR5Y0MdUrG5ZCJaQdaFRnaZxyUWnx3BBAA=;
        b=RWPVOpYAzmwlBvILo3X7ysoY9o+M7g/svMHKQukkQS9k2UPtP6gasHgh9xz9p3P99W
         ymzlx9ZtG8GQoOi8K4GxBrJ27KSvDY7OaLWqkoW15arnq3PDup26l/p6OcIj19KKnGrC
         F+RKANO3UGyCbwFjnob+f4Yq9Xv60FMjvPQNmB9/6DhZ/c2RPlBOqqHE1y33a4SKX8eJ
         vnL8NL9Mfy1FIl5+v0IhUNbYuLpFYzxFZpCpBIymZA1nlcdI+ig7/lxbbGNQuibk544j
         plked2eBVERuOrNn3cvIFaQUPZYLKaPG3rr1pauOeK8nKDR5fnEVDzBOg12Nd6obaM7g
         AxPw==
X-Gm-Message-State: APjAAAXL1GSob6ys7rT2yYyHh7MXeqPO3/0n2jTJCNk3V8AdavW0bMlg
        JFQdfQaIJQl3aEOFRYWPtxJ18EehPHc=
X-Google-Smtp-Source: APXvYqyEHHtWnA7kKpHwz2f2USQd2qKOWR8NB21ijDktiWI5JMiYfPjelFZSsIJ2g/nIopYXbjhWmw==
X-Received: by 2002:a2e:968c:: with SMTP id q12mr13777072lji.36.1556303274692;
        Fri, 26 Apr 2019 11:27:54 -0700 (PDT)
Received: from [192.168.1.5] ([109.252.90.193])
        by smtp.gmail.com with ESMTPSA id h14sm5257226ljg.10.2019.04.26.11.27.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 11:27:53 -0700 (PDT)
Subject: Re: Some file lost when send back snapshot.
To:     MASAKI Haruka <reasonset@inflaton.co.jp>
Cc:     linux-btrfs@vger.kernel.org
References: <20190425223457.5a7dfd20@hydrangea>
 <aa5623ca-e1c2-4499-75ee-be818acf3333@gmail.com>
 <20190426135027.62dcaa31@hydrangea>
 <efad3130-e13d-2649-556e-6e932e5a4dc6@gmail.com>
 <20190427031225.7f04d7bb@hydrangea>
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
Message-ID: <8cdd6929-b768-795c-162f-cf41e8b94029@gmail.com>
Date:   Fri, 26 Apr 2019 21:27:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190427031225.7f04d7bb@hydrangea>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

26.04.2019 21:12, MASAKI Haruka пишет:
>> You have two subvolumes with the same received_uuid. Is the content of
>> these subvolumes the same? Is "missing" file present in both subvolumes?
> 
> No, each subvolume name (190312-010100, 190315-001000) is timestamp.
> These snapshot volumes were created by job scheduler on original (already lost) volume, so 190315-001000 is modified from 190312-010100.
> 

Which is your problem. Two subvolumes with the same received_uuid are
expected to have exactly the same content (received_uuid can be viewed
as dataset UUID). You send incremental stream against base uuid
9c10b77f-74fb-f94a-9a24-3c6d30c00ca2; on receiving side btrfs receive
looks for matching base subvolume and happens to pick 190312-010100.

There were patches to automatically remove received_uuid when subvolume
is changed to read-write. I do not know whether they were applied.

btrfs send/receive expects subvolumes to remain read-only. As soon as
you start fiddling with read-only status you already lost. btrfs should
have never allowed to change read-only into read-write in the first place.

> 190315-001000 has lost file,
> % ls /HySlave/190315-001000/local/pub/media/sound/notmusic_in_CD/
> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> 
> but 190312-010100 doesn't.
> % ls /HySlave/190312-010100/local/pub/media/sound/notmusic_in_CD/
> Little_My_Maid  el_louis  firstkiss  gakuensai  infinity-kid  kid-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
> 
> 
> 
> 
> On Fri, 26 Apr 2019 20:30:07 +0300
> Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 
>> 26.04.2019 7:50, MASAKI Haruka пишет:
>>> Thank you for your reply.
>>>
>>> # What does
>>>
>>> @Host A ("lily" master, new volume)
>>> aki@lily /mnt % socat TCP-LISTEN:25500 STDOUT | sudo btrfs receive -vv . 
>>>
>>> @Host B ("daisy" backup, having volumes)
>>> aki@daisy /HySlave % sudo btrfs send -v 190315-001000 | socat STDIN TCP:lily.local:25500 
>>>
>>> ( ...Transfared 11TB... )
>>>
>>> @Host A
>>> aki@lily /mnt % sudo btrfs subvolume snapshot 190315-001000 world
>>> Create a snapshot of '190315-001000' in './world'
>>> aki@lily /mnt % sudo btrfs subvolume snapshot -r world back1
>>> Create a readonly snapshot of 'world' in './back1'
>>>
>>> @Host A
>>> aki@lily /mnt % sudo btrfs send -vv -p 190315-001000 back1 | socat STDIN tcp-connect:192.168.1.17:25555
>>> At subvol back1
>>> BTRFS_IOC_SEND returned 0
>>> joining genl thread
>>>
>>> @Host B
>>> root@daisy /HySlave # socat TCP-LISTEN:25555 STDOUT | btrfs receive -vv .
>>> At snapshot back1
>>> receiving snapshot back1 uuid=32dda1a2-07bd-684f-b773-c5b4cd5f29c1, ctransid=2658 parent_uuid=9c10b77f-74fb-f94a-9a24-3c6d30c00ca2, parent_ctransid=2658
>>> BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=32dda1a2-07bd-684f-b773-c5b4cd5f29c1, stransid=2658
>>>
>>> # Host A current
>>>
>>> aki@lily /mnt % ls
>>> 190315-001000  back1  back2  world
>>> aki@lily /mnt % sudo btrfs sub li -Rqu .
>>> ID 258 gen 2698 top level 5 parent_uuid -                                    received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid bc90d05c-7430-7b42-b683-702d906bb993 path 190315-001000
>>> ID 2139 gen 2696 top level 5 parent_uuid bc90d05c-7430-7b42-b683-702d906bb993 received_uuid -                                    uuid 23c5fede-a338-d14a-afcd-677db2e97637 path world
>>> ID 2140 gen 2660 top level 5 parent_uuid 23c5fede-a338-d14a-afcd-677db2e97637 received_uuid -                                    uuid 32dda1a2-07bd-684f-b773-c5b4cd5f29c1 path back1
>>> ID 2142 gen 2672 top level 5 parent_uuid 23c5fede-a338-d14a-afcd-677db2e97637 received_uuid -                                    uuid a8e3e041-c1fc-e443-9baf-ab481ae32b8b path back2
>>>
>>>
>>> # Host B current
>>>
>>> aki@daisy /HySlave % pwd
>>> /HySlave
>>> aki@daisy /HySlave % ls
>>> 190312-010100  190315-001000  back1  back2
>>> [aki@daisy HySlave]$ sudo btrfs sub li -Rqu .
>>> ID 256 gen 36238 top level 5 parent_uuid -                                    received_uuid -                                    uuid 4e42555d-a715-0e47-bd0e-85d6eb8911e0 path slave
>>> ID 259 gen 35116 top level 256 parent_uuid -                                    received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid 4a91d585-ab25-0c49-b183-ae951b5377e1 path 190312-010100
>>> ID 3059 gen 7273 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-ae951b5377e1 received_uuid 9c10b77f-74fb-f94a-9a24-3c6d30c00ca2 uuid 114cd74f-80d8-af44-a9d0-fd8ce3c991b4 path 190315-001000
>>
>> You have two subvolumes with the same received_uuid. Is the content of
>> these subvolumes the same? Is "missing" file present in both subvolumes?
>>
>>> ID 3072 gen 35112 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-ae951b5377e1 received_uuid 32dda1a2-07bd-684f-b773-c5b4cd5f29c1 uuid fe7281d1-8b3e-8f46-a0b4-cdc52a1bb7aa path back1
>>> ID 3073 gen 36236 top level 256 parent_uuid 4a91d585-ab25-0c49-b183-ae951b5377e1 received_uuid a8e3e041-c1fc-e443-9baf-ab481ae32b8b uuid 65206183-f20d-4648-83ab-e0485b16f7af path back2
>>>
>>> # Files missing
>>>
>>> aki@daisy /HySlave % ls /HySlave/190315-001000/local/pub/media/sound/notmusic_in_CD 
>>> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
>>>
>>> aki@daisy /HySlave % ls /HySlave/back1/local/pub/media/sound/notmusic_in_CD
>>> Little_My_Maid  el_louis  firstkiss  gakuensai  infinity-kid  kid-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
>>>
>>> aki@lily /mnt % ls /mnt/190315-001000/local/pub/media/sound/notmusic_in_CD
>>> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
>>>
>>> ki@lily /mnt % ls /mnt/back1/local/pub/media/sound/notmusic_in_CD        
>>> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
>>>
>>> aki@lily /mnt % ls /mnt/world/local/pub/media/sound/notmusic_in_CD 
>>> Little_My_Maid  SMEE  el_louis  firstkiss  gakuensai  infinity-kid  kid-memories-off  ojyo_tokkyu  samusupi  wizards_harmony  yuukyuu-chara-seala
>>>
>>>
>>> SMEE is missing.
>>>
>>>
>>>
>>>
>>> Thanks.
>>>
>>>
>>> On Thu, 25 Apr 2019 20:55:59 +0300
>>> Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>>
>>>> 25.04.2019 16:34, MASAKI Haruka пишет:
>>>>  [...]  
>>>>
>>>> Please show
>>>>
>>>> 1. Full protocol of commands you executed (commands and their output),
>>>> e.g. captured using script.
>>>> 2. Commands used to determine missing files on both source and receive
>>>> sides.
>>>> 3. Listing of subvolumes on both source and receive sides with
>>>>
>>>> btrfs sub li -Rqu /mount/point
>>>>
>>>>  [...]  
>>>>
>>

