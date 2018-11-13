Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5C4C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50F392086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LD7uLt2G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50F392086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732298AbeKNBjU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 20:39:20 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:44263 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731287AbeKNBjU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 20:39:20 -0500
Received: by mail-io1-f67.google.com with SMTP id r200so3693070iod.11
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2018 07:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mfm54LeJPIx5+zXoT5eyG6hZKrmahm0EzVoty026hQs=;
        b=LD7uLt2G/KOlC+1VwKHzpSeF8+VyRcs5D5hwbg2u+LhtU5MLsOCcPZNxasCIAVo0cc
         x7Pwi4kNJsYmhYxmHXiRKIOgQsxDsEidylcCn31KMZdp5vWIlf4npv3O9hYaQlPu18XP
         vY9OPWVmZoIOdqRfnSDSjq5FPkrSeA0FFAaydPh6pQO14H2tcrJ4gU7nxN3eKIisJO9C
         Ec8xB78Y075edNSqUyfIUIADfZhcTUpyAvzx7sYyoxT2pNBJtnOeBDcrOt2thhej98S5
         XvEu80A6+9tFLEByvoJBNTRHeZ9C/h2k8HOfQr+W6/1LLXMxfExAJb03hcRsaLjNzHFw
         rAWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mfm54LeJPIx5+zXoT5eyG6hZKrmahm0EzVoty026hQs=;
        b=sMJV16nemr91Sf6Y84ySLtoJG4ur3BR/F8J3fgrUCgHIuXK1HITcRlzfQVZdQNHREF
         XrKhhsdgs83xvoL3PB90XESOhWRJtrjkZX2JlBGE371xkvJdzBwkimBdckw54LJxLF5L
         ocvVVH2zfz+86F2Ds0WPXo8si5C0oBpwn8P05wkWfc8zOFTB0BAR/gpYpvCFnxu3vHNU
         vzKKz/5PHKLeZTB6VSYFIKoFMlmYPafxGOTgeb/R0Pmbk2+vAVolQHGTumwAlSpwaLn/
         8dz9LBtiJKZ64yBL+9MB2y/lWlTx9sh3Tianvl9Xa19AuSPWP0J372SgbbtcH7v073oC
         3WgA==
X-Gm-Message-State: AGRZ1gKR3HlPm9Bb1vz2P+Gi/CA0WbwWDqgZDj1volGPz+05Qplpkw89
        j5rp04y1pHjPi4l0K/NzSrJklUyjnD8=
X-Google-Smtp-Source: AJdET5f0iJNOvCNe4E9UoWEl6qNTZSj4p3pF9/gPqW4K1FhheInodlUKt6HN8TYpjYdjPPvnniwxTA==
X-Received: by 2002:a5e:c902:: with SMTP id z2-v6mr4356764iol.72.1542123640601;
        Tue, 13 Nov 2018 07:40:40 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id l18-v6sm6200475iob.24.2018.11.13.07.40.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Nov 2018 07:40:39 -0800 (PST)
Subject: Re: [PATCH RFC] btrfs: harden agaist duplicate fsid
To:     dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1538384164-3030-1-git-send-email-anand.jain@oracle.com>
 <98cd974b-d817-c30b-5cd7-d69214f44f39@gmail.com>
 <d209b853-4c15-4ef6-58b5-e1b08d409aeb@oracle.com>
 <20181113153149.GD24115@twin.jikos.cz>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <00297772-cdaa-bcee-382b-02ff61bd0cae@gmail.com>
Date:   Tue, 13 Nov 2018 10:40:36 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181113153149.GD24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/13/2018 10:31 AM, David Sterba wrote:
> On Mon, Oct 01, 2018 at 09:31:04PM +0800, Anand Jain wrote:
>>>> +        /*
>>>> +         * we are going to replace the device path, make sure its the
>>>> +         * same device if the device mounted
>>>> +         */
>>>> +        if (device->bdev) {
>>>> +            struct block_device *path_bdev;
>>>> +
>>>> +            path_bdev = lookup_bdev(path);
>>>> +            if (IS_ERR(path_bdev)) {
>>>> +                mutex_unlock(&fs_devices->device_list_mutex);
>>>> +                return ERR_CAST(path_bdev);
>>>> +            }
>>>> +
>>>> +            if (device->bdev != path_bdev) {
>>>> +                bdput(path_bdev);
>>>> +                mutex_unlock(&fs_devices->device_list_mutex);
>>>> +                return ERR_PTR(-EEXIST);
>>> It would be _really_ nice to have an informative error message printed
>>> here.  Aside from the possibility of an admin accidentally making a
>>> block-level copy of the volume,
>>
>>> this code triggering could represent an
>>> attempted attack against the system, so it's arguably something that
>>> should be reported as happening.
>>
>>>    Personally, I think a WARN_ON_ONCE for
>>> this would make sense, ideally per-volume if possible.
>>
>>    Ah. Will add an warn. Thanks, Anand
> 
> The requested error message is not in the patch you posted or I have
> missed that (https://patchwork.kernel.org/patch/10641041/) .
> 
> Austin, is the following ok for you?
> 
>    "BTRFS: duplicate device fsid:devid for %pU:%llu old:%s new:%s\n"
> 
>    BTRFS: duplicate device fsid:devid 7c667b96-59eb-43ad-9ae9-c878f6ad51d8:2 old:/dev/sda6 new:/dev/sdb6
> 
> As the UUID and paths are long I tried to squeeeze the rest so it's
> still comprehensible but this would be better confirmed. Thanks.
> 
Looks perfectly fine to me.
