Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D20C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 20:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46BC208E7
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 20:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gokBHamo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A46BC208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbeLEUK6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 15:10:58 -0500
Received: from mail-it1-f179.google.com ([209.85.166.179]:55790 "EHLO
        mail-it1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbeLEUK6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 15:10:58 -0500
Received: by mail-it1-f179.google.com with SMTP id o19so23406813itg.5
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Dec 2018 12:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=peqcazCnLS7PVUVdGmv3lJtyCkyFYaWHMC2Nc+8Jw7s=;
        b=gokBHamoaaw/qA3xOvv6pZpgmKAfIhE4lcosmnbXuYDn7hdE0VTia+KiHvdgVzgVPE
         R+AQhsGhoq2fWpsV837feUdaOSOTFpUYGZjUb8PTXnYDV4aWhXEs0GMbr9D76jLH7cEB
         yp8USqyK7hVyr/xQmGgcoReywUMxM1kwLUq7+6BRqRPHMC6YxgDXWHky86XzH+mf80YC
         4UWWxHxRBXnWpGD8P9sHYIaMZh8O/b+NxouoR0p/fcpkSHFmxEHlLXhIxei85ti79C0b
         NglBwgFsN1eF+ENb3m7NqpkntZUvV1BkSrNH3O+PEm+jIxJAvg96c++KPBluTxu3S4Mm
         WC7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=peqcazCnLS7PVUVdGmv3lJtyCkyFYaWHMC2Nc+8Jw7s=;
        b=J+jbU2voocc1oK+6NR1I753dEpcHa+9CvfNxMCv1NVllxRF4t+t3Sy/SUWnK8urcfP
         9CsOW4kLHUNPlHJfYH3uMvXo1BESBcs8OmSKJhxgVheRoPR4+V5D3F+tc+7zxLFYlJ9v
         IpnB0rzQ9NVPXbjjZHV3ge1GyoH3flq/8NbSQv/bfcN4J+3iFJPmu+zLdf/BJdhOW5jj
         vUdR5O5eA0afbSGtLbvcRKE4Q8lgM3UuLrDzL2PiuTLpXrJnGjcEOoBLqT0t+CO9kJJ8
         w5See0SxCZJqMCDQiBYH4zGhCr7n8KR3Cjygjaq+0KxIiClOIHTVnT/jObrZZGOE/iaW
         XpTQ==
X-Gm-Message-State: AA+aEWZuV7CXx/nko5nP8d09spJtLoeydtV6MF6SMPu/gR00ppD4gjYY
        ms+rVgyB3Lc8TEOLrcu/gvhT1aMT39s=
X-Google-Smtp-Source: AFSGD/Ugkv8Dq3Jd9YQRtjXkDGbuIoJ7+bNYJzcX3Hib75Kghn8TUDzEvmoedinN6BpbBYGc0UBuwA==
X-Received: by 2002:a24:36cf:: with SMTP id l198mr17701449itl.102.1544040656350;
        Wed, 05 Dec 2018 12:10:56 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id t7sm8437506iom.27.2018.12.05.12.10.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 12:10:55 -0800 (PST)
Subject: Re: btrfs progs always assume devid 1?
To:     Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
References: <20181206005049.3642ebd0@natsu>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <42e4ba30-2535-e2f3-6ecb-539fe8fda947@gmail.com>
Date:   Wed, 5 Dec 2018 15:10:52 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181206005049.3642ebd0@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-12-05 14:50, Roman Mamedov wrote:
> Hello,
> 
> To migrate my FS to a different physical disk, I have added a new empty device
> to the FS, then ran the remove operation on the original one.
> 
> Now my FS has only devid 2:
> 
> Label: 'p1'  uuid: d886c190-b383-45ba-9272-9f00c6a10c50
> 	Total devices 1 FS bytes used 36.63GiB
> 	devid    2 size 50.00GiB used 45.06GiB path /dev/mapper/vg-p1
> 
> And all the operations of btrfs-progs now fail to work in their default
> invocation, such as:
> 
> # btrfs fi resize max .
> Resize '.' of 'max'
> ERROR: unable to resize '.': No such device
> 
> [768813.414821] BTRFS info (device dm-5): resizer unable to find device 1
> 
> Of course this works:
> 
> # btrfs fi resize 2:max .
> Resize '.' of '2:max'
> 
> But this is inconvenient and seems to be a rather simple oversight. If what I
> got is normal (the device staying as ID 2 after such operation), then count
> that as a suggestion that btrfs-progs should use the first existing devid,
> rather than always looking for hard-coded devid 1.
> 

I've been meaning to try and write up a patch to special-case this for a 
while now, but have not gotten around to it yet.

FWIW, this is one of multiple reasons that it's highly recommended to 
use `btrfs replace` instead of adding a new device and deleting the old 
one when replacing a device.  Other benefits include:

* It doesn't have to run in the foreground (and doesn't by default).
* It usually takes less time.
* Replace operations can be queried while running to get a nice 
indication of the completion percentage.

The only disadvantage is that the new device has to be at least as large 
as the old one (though you can get around this to a limited degree by 
shrinking the old device), and it needs the old and new device to be 
plugged in at the same time (add/delete doesn't, if you flip the order 
of the add and delete commands).
