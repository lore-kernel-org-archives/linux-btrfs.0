Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AEFC4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 11:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8185A20856
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 11:46:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oOZVV7kK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbfDBLqr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 07:46:47 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:34429 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729568AbfDBLqq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 07:46:46 -0400
Received: by mail-it1-f195.google.com with SMTP id z17so2547960itc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 04:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aR5egbEamYSQ+XwctkJmJ09UdNBdlbt7wGATJo8Qvyg=;
        b=oOZVV7kKHurz946O/mc2Fw7E/C/AgiNT+Y0JhEXauMfafEq0ooZAxBeSWsfCx2h3cE
         QYQWZEm8w/7RDUUy0Wa+vWyhyU6WtGtuwKAm7CHTUhnBnHDXFqbvOG97sWmXlXhrjxcW
         IUXj8Cp1dpg+NpZm/k5tpw/waEIvMv/gESaNbCfGdC7SbIzodpBsd9a4cWQur0tRXg9R
         dXHzdadGm8NRkFjr0SgWao2PrbUnPtcU+Y7sG69mtiHawxOOBvUg0jyyntCDGWv3qfZ3
         b8MThM34AVzWamsf5mvu0ivEnHx3Gjbpk6dhiYPEBxuvfW42ovo3ZUy8DfHS+Qby166u
         PJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aR5egbEamYSQ+XwctkJmJ09UdNBdlbt7wGATJo8Qvyg=;
        b=pVNjLhVw23nzHp17FWNQWbzAovz8XNwFQCCcsFF6iMQLV8+xMg+UGunsl2SFzkkBcI
         NFOMnko5e56TZUI4cvZhBFUnWnLOKrqsKSuls2iUDjIxl/4VrV8JwVqh0GkJaNlW1XBh
         QQ1X0ovJDMj+1TCsKuLWoofInRjw43IiiAt84D2dcmsNoamV/XbOJImL8ec4upbrOnw4
         tI4CJ4fFvM4UPzJXY8GKjH6xZ8TtEHGJVcw2luqDXXXJ2+pW7YGXkX6cT5/CU4DQmtkj
         U/5Z+qB4l+qjhvrrDoLFFqvCy/cJVJF+eH/GfXcAOshz9ZTb3d/zNGt0yZVESNauTjR9
         /RdA==
X-Gm-Message-State: APjAAAU0vzzMitYatnjeaJmA1w1vtxI2hqnbnv91OeV9UoAwa4vLdl5F
        ay4gB1QmagHzjuRCvobS9J2OdIi9IXI=
X-Google-Smtp-Source: APXvYqx6H4ImAiBeYvFlMBsDTeAte5G0FWUQohnPZDFa/RtXtH1mCync3LWTc4oSboihK7raz3dm/w==
X-Received: by 2002:a24:280e:: with SMTP id h14mr4245946ith.80.1554205605240;
        Tue, 02 Apr 2019 04:46:45 -0700 (PDT)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id p67sm219655itb.11.2019.04.02.04.46.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 04:46:44 -0700 (PDT)
Subject: Re: btrfs and write barriers
To:     Hendrik Friedel <hendrik@friedels.name>,
        linux-btrfs@vger.kernel.org
References: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2756c52f-eca4-7a26-aec7-46256ca1bdcb@gmail.com>
Date:   Tue, 2 Apr 2019 07:46:41 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <emae84cb43-e9f5-41a7-8a47-efca08cea36e@laptophendrik>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2019-04-01 15:22, Hendrik Friedel wrote:
> Dear btrfs-team,
> 
> I am aware, that barriers are essential for btrfs [1].
> I have some questions on that topic:
> 1) I am not aware how to determine, whether barriers are supported, 
> except for searching dmesg for a message that barriers are disabled. Is 
> that correct? It would be nice, if that could be determined before 
> creating the FS.
AFAIK, this is correct.  However, not supporting DPO or FUA is 
non-critical, because the kernel emulates them properly (there would be 
many problems far beyond BTRFS if it didn't, as most manufacturers treat 
FUA the same way they treat SCT ERC, it's an 'enterprise' feature, so 
consumers aren't allowed to have it).

> 2) I find the location of the (only?) warning -dmesg- well hidden. I 
> think it would be better to notify the user when creating the file-system.
A notification on creating the volume and ones when adding devices 
(either via `device add` or via a replace operation) would indeed be 
nice, but we should still keep the kernel log warning.  Note also that 
messages like what Qu mentioned as being fine are from the SCSI layer 
(yes, even if you're using ATA or USB disks, they both go through the 
SCSI layer in Linux), not BTRFS.

> 3) Even more, it would be good, if btrfs would disable the write cache 
> in that case, so that one does not need to rely on the user
I would tend to disagree here.  We should definitely _recommend_ this to 
the user if we know there is no barrier support, but just doing it 
behind their back is not a good idea. There are also plenty of valid 
reasons to want to use the write cache anyway.

> 4) If [2] is still valid, there are drives 'lying' about their barrier 
> support. Can someone comment? If that is the case, it would be even 
> advisable to provide a test to test the actual capability. In fact, if 
> this is still valid, this may be the reason for some btrfs corruptions 
> that have been discussed here. [I did read, that LVM/Device-Mapper does 
> not support barriers, but I think that this is outdated]There are two things to consider here, the FLUSH command which is 
mandatory as per SCSI, ATA, and pretty much every other storage protocol 
specification, and FUA/DPO, which is not.  If you have FLUSH, you can 
emulate FUA/DPO.

The only modern devices I know of that actually _lied_ about FLUSH are 
OCZ SSD's. They've stopped making them because the associated data-loss 
issues killed any consumer trust in the product.  The only other devices 
I've ever seen _any_ issue with the FLUSH implementation in are some 
ancient SCSI-2 5.25 inch full height disk drives where I work, which 
have a firmware bug that reports the FLUSH completed before the last 
sector in the write cache is written out (they still write that last 
sector, they just report command completion early).

As far as FUA/DPO, I know of exactly _zero_ devices that lie about 
implementing it and don't.  Unlike FLUSH, which is a required part of 
almost all modern storage protocols, FUA/DPO isn't required, so there's 
essentially zero incentive to claim you implement it when you don't 
(people who would be looking for it generally will know what they're doing

As far as that article you're linking about disks lying, note first that 
it's just over 14 years old (that's almost three times the MTBF for 
normal hard drives), and much has changed since then.  The actual issue 
there is not the disks doing write caching (which is what is actually 
being complained about), but the fact that Linux used to not issue a 
FLUSH command to the disks when you called fsync in userspace.
> 
> Greetings,
> Hendrik
> 
> 
> [1] 
> https://btrfs.wiki.kernel.org/index.php/FAQ#I_see_a_warning_in_dmesg_about_barriers_being_disabled_when_mounting_my_filesystem._What_does_that_mean.3F 
> 
> [2] https://brad.livejournal.com/2116715.html
> 

