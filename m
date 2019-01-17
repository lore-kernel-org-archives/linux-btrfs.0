Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25945C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 12:33:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6C9D20657
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 12:33:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cx78Th8F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfAQMdH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 07:33:07 -0500
Received: from mail-io1-f44.google.com ([209.85.166.44]:45850 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfAQMdH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 07:33:07 -0500
Received: by mail-io1-f44.google.com with SMTP id c2so7618593iom.12
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 04:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ruoOUfupTrpPpWCIOZcSMC//+agArE035fEgtb/8Lfo=;
        b=Cx78Th8FkyHKsA2H3aOl6sjYCD8wcXFlcIcAmq2cx/WGbHLjuTThOSSXmSN2EtHsyK
         KQBumDYMd6x0QymvaIakX3BL6R66yvBrOPRC1lh2dm98FTBDHgGeTVkUikXIhcd5MiN+
         dQ1Ctrt76kwiCRAuXF6J1fgjNTZ+UeMfaacg+3SCZ1aZz2E/D+OF0KQ7HkHs186/zr51
         Ey/1MWqd5koK6t9kCJH0+1zp8DK+g9hrJ31Qx0dqeWYtvdSkoqFUc0+ewQraXrBkfG84
         j/vqgqWh4SJOWdqb6OOya4OtLPXz0omEWfMCD4/U+pyf0kG0qiwA+slMFjM9YAXvSk6A
         XgkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ruoOUfupTrpPpWCIOZcSMC//+agArE035fEgtb/8Lfo=;
        b=pFKoM46OG5Meb8UX+wu5ThacT15+Kf2zkAm4Qul8xcCulVGTac0MBm7nKbC0WiQZhY
         Dq5Oi04hAinJm7bR2PXjF08PvYoOpyXHWYxSUpFWUEqgoMwqVOdVjSVJAlIiTpVHPfbM
         0/abwMvzcN5NatumnBi0YtJfqy19dQzcLc6bl9QTv9Z3eWOi2U1IJBcuJalUDArbQDOJ
         X7HSY4gXhUuwC6y+6VU/NKIoqcvVyAnaIyIa2Kxr4ielPX3fKwTkY+TR13hB0Ds8z2bY
         hDR/F9oQfn6OopSVkDUTaMp2ZZazNHjywuf7+9LGEbbiDCHIyt+0bQdw0ykhceeP1VOe
         WV3w==
X-Gm-Message-State: AJcUukcKwCW5c/OzP/R7xZXun8pgMxCkmfLXQ1cacxZQtnj5NRH6dRTg
        AQpsA2RYVwyV5ntGpT9PjK8O4MYZPr8=
X-Google-Smtp-Source: ALg8bN7ARw4ZFIwji4ll3syCMps193g1pjrq0h4df4Xd+8KprEWHr/Dyfs4VEw2CLwzt5C3ym5AFAA==
X-Received: by 2002:a6b:b706:: with SMTP id h6mr7108452iof.295.1547728385485;
        Thu, 17 Jan 2019 04:33:05 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id y8sm596469ita.5.2019.01.17.04.33.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 04:33:04 -0800 (PST)
Subject: Re: question about creating a raid10
To:     Stefan K <shadow_7@gmx.net>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <3318002.5e9V1lv8s4@t460-skr>
 <20190116144208.GI5134@carfax.org.uk> <1980543.jviTh1pdNs@t460-skr>
 <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bbbb9a66-54a9-f8d0-4b9c-351cdb6529f7@gmail.com>
Date:   Thu, 17 Jan 2019 07:33:01 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTErRwS5Omb4Asob3sYx8Svt4yV8V5so7fcs+2BX8t3Gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-01-16 13:15, Chris Murphy wrote:
> On Wed, Jan 16, 2019 at 7:58 AM Stefan K <shadow_7@gmx.net> wrote:
>>
>>   :(
>> that means when one jbod fail its there is no guarantee that it works fine? like in zfs? well that sucks
>> Didn't anyone think to program it that way?
> 
> The mirroring is a function of the block group, not the block device.
> And yes that's part of the intentional design and why it's so
> flexible. A real raid10 isn't as flexible, so to enforce the
> allocation of specific block group stripes to specific block devices
> would add complexity to the allocator while reducing flexibility. It's
> not impossible, it'd just come with caveats like no three device
> raid10 like now; and you'd have to figure out what to do if the user
> adds one new device instead of two at a time, and what if any new
> device isn't the same size as existing devices or if you add two
> devices that aren't the same size. Do you refuse to add such devices?
> What limitations do we run into when rebalancing? It's way more
> complicated.
> 
> Btrfs raid10 really should not be called raid10. It sets up the wrong
> user expectation entirely. It's more like raid0+1, except even that is
> deceptive because in theory a legit raid0+1 you can lose multiple
> drives on one side of the mirror (but not both); but with Btrfs raid10
> you really can't lose more than one drive. And therefore it does not
> scale. The probability of downtime increases as drives are added;
> whereas with a real raid10 downtime doesn't change.
> 
> In your case you're better off with raid0'ing the two drives in each
> enclosure (whether it's a feature of the enclosure or doing it with
> mdadm or LVM). And then using Btrfs raid1 on top of the resulting
> virtual block devices. Or do mdadm/LVM raid10, and format it Btrfs. Or
> yeah, use ZFS.
I was about to recommend the same BTRFS raid1 on top of MD or LVM RAID0 
approach myself.  Not only will it get you as close as possible with 
BTRFS to the ZFS configuration you posted, it will also net you slightly 
better performance than BTRFS in raid10 mode.

Realistically, it's not perfect (if you lose one of the JBOD arrays, you 
have to rebuild that array completely and then replace the higher-level 
device in BTRFS, instead of just replacing the disk at the lower level), 
but the same approach can be extrapolated to cover a wide variety of 
configurations in terms of required failure domains, and I can attest to 
the fact that it works (I've used this configuration a lot myself, but 
mostly for performance reasons, not reliability).
