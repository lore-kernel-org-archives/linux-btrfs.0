Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC66C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 12:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86B4B2098A
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 12:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LM5QZ4hL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86B4B2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbeJRUw3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 16:52:29 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:43045 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbeJRUw3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 16:52:29 -0400
Received: by mail-lj1-f176.google.com with SMTP id r8-v6so27590303ljc.10
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 05:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pI3dPPzLXxs/Psh/LktR8L1QfhJnlYoYmlGIHnQUkyc=;
        b=LM5QZ4hLeuqykwj5LFSHZvavCcaNPTAE6j2Rc3eNhqSomr9V/LJ7oVONuZ0Hs3k08K
         pbuKIqanw9qcEYY/K3V3b3vPZqenlgw3wBnho+2HNuLWmMnwFVuobYZjQGu/PkDDOrgE
         YJJrUOyznbVpYzouJQQ3qiAT6UfeY1cwV0ZJMoLlQtQFsz5fT5hu4FGMXxhtpZvze5jd
         7a19QPMJdezIzEnQQ9Z8xstxxmpOcEW8Njm2n3vk9cbNjJ8XM/5fw+oRzf85zxCYMuoX
         F35LcZ0Yh8WJ8/dnd5aLlM9QNSoISRGcg62g/KY1QjoRP6p+//wTwyZZLJLoQz23Mxa7
         WLCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=pI3dPPzLXxs/Psh/LktR8L1QfhJnlYoYmlGIHnQUkyc=;
        b=oQzAkJmm3dZG1nIrPZH0kAOpRyBR+qK2rHUTSxnN475O0/zX0pbBfW+MiotgsWuzzf
         huDAgf/GZKFf51DPzvmXjD+NRmrqtQBprLw1NTzArWFQYRNEg2yuJQCzaM9m3/ieAMlV
         UKv7NA0hxDMc31xzEHCobUTL0VQm8x5y/2VOSKUpIqVmaV3uDs+1F2FRc7rvMrlzmnLk
         BB5X/RG9RICME8gG1o3uR9+EFD6VQis8gezn839CWuAf1aHU+dpXf2COJg9GN9Xs/mj6
         q/hdfhmbKUfumSzymdWJcLp3TmRHiZJFzmdm6AXEHew6KeNtCbbG+nTMeKCohl+fvpeY
         YCqw==
X-Gm-Message-State: ABuFfohxIEL9wWmk/+1hQsOvcTuMg2v9Io/HyNBLK3d8wZvDHpX21z0w
        SiSH1clrswo3Xz8z6vA7OqJXOzHf
X-Google-Smtp-Source: ACcGV639bU0nE5Nj4BtEYBslpUS0WJmIHyix38LuLDQRmSxOwXWNydraaaCHS5DHD5cgbLV9qSBBpg==
X-Received: by 2002:a2e:b04b:: with SMTP id d11-v6mr19389387ljl.93.1539867094379;
        Thu, 18 Oct 2018 05:51:34 -0700 (PDT)
Received: from [192.168.1.4] ([109.252.55.124])
        by smtp.gmail.com with ESMTPSA id x25-v6sm4701985ljb.78.2018.10.18.05.51.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Oct 2018 05:51:33 -0700 (PDT)
Subject: Re: Spurious mount point
To:     Chris Murphy <lists@colorremedies.com>,
        Anton Shepelev <anton.txt@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20181015180546.4dd598bf0fe61b61f56e99ce@gmail.com>
 <CAJCQCtSz+=uwXUFGxagoUOYxy99eCJGG-ezLVh0RO=vL=LReEg@mail.gmail.com>
 <20181016002601.5517a4ea66c2c9c5dbdb5471@gmail.com>
 <CAJCQCtR0zVDOS8u5zN2Ddo4+orrx62-L9e5GUnM=OWcwSitftQ@mail.gmail.com>
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
Message-ID: <2aebe72e-2864-9925-7346-ebdc83e0b6df@gmail.com>
Date:   Thu, 18 Oct 2018 15:51:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR0zVDOS8u5zN2Ddo4+orrx62-L9e5GUnM=OWcwSitftQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

16.10.2018 0:33, Chris Murphy пишет:
> On Mon, Oct 15, 2018 at 3:26 PM, Anton Shepelev <anton.txt@gmail.com> wrote:
>> Chris Murphy to Anton Shepelev:
>>
>>>> How can I track down the origin of this mount point:
>>>>
>>>> /dev/sda2 on /home/hana type btrfs (rw,relatime,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot/hana)
>>>>
>>>> if it is not present in /etc/fstab?  I shouldn't like to
>>>> find/grep thoughout the whole filesystem.
>>>
>>> Sounds like some service taking snapshots regularly is
>>> managing this.  Maybe this is Mint or Ubuntu and you're
>>> using Timeshift?
>>
>> It is SUSE Linux and (probably) its tool called `snapper',
>> but I have not found a clue in its documentation.
> 
> I wasn't aware that SUSE was now using the @ location for snapshots,

It does not "use @ for snapshots". It is using /@ as top level directory
for root layout. This was changed from using / directly quite some time
ago (2-3 years).

Snapshots are located in own subvolume which is either /.snapshots (if
your install is old) or /@/.snapshots and is always mounted as
/.snapshots in current root.

> or that it was using Btrfs for /home. For a while it's been XFS with a
> Btrfs sysroot.
> 

Default proposal is separate home partition with XFS, it can of course
be changed during installation.

Note that after default installation /@/.snapshots/1/snapshot is default
subvolume and *the* filesystem root, which gets mounted as "/". So it
could be result of bind-mount of /hana on /home/hana (/hana is resolved
to "default-subvolume"/hana => /@/.snapshots/1/snapshot/hana).
