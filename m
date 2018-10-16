Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1908C5ACC6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 19:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B49A2098A
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 19:49:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="LU/2nFXf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B49A2098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbeJQDlu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 23:41:50 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33083 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbeJQDlu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 23:41:50 -0400
Received: by mail-lj1-f195.google.com with SMTP id z21-v6so22107763ljz.0
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Oct 2018 12:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=ueY253d/30iUWMQQkYF+x8j2WcC1UXNbwstlLyz6OoU=;
        b=LU/2nFXfNga6Vh7eeQnLxoutAv0U8FGqM1YEuXUg//+uX5oflWi3DXdomXY3URJwwt
         BOHFgFxCQTTYo020T+u4MacCaqYIZ5ga5PhMQrz4JYgNe9H9qF9ad0mHxNMC/TpvEBDq
         XaPJ5QsF76HUaC+64cW1qxoPHdnu6VOv0GyBpQo1Od7PtL3q4a8ySbqeleTh7FNutc8U
         aMfrbwqa5ytFVuu6FOXtvWdIStncM94GphwvGlYkQ+8Nna+KedZ5cuMC1oOMSjVWsExm
         O0ChGTAWUOqOGxnezlHRXGIzx9wP8A3Zbo4R8/7NkYydN5SMmw81Tq8pQC7jvjz3s2U5
         81TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=ueY253d/30iUWMQQkYF+x8j2WcC1UXNbwstlLyz6OoU=;
        b=i8pCUpXiRfibZRmqensjxsGEID8dn/yOtxGMzii/FmH5enjhOfn6SNFKrk9N/+06MI
         s0DS7+jU14Q5QH8AM5saM9w50ZRMnPydbAcQm7YMSzK94wuurFq2gHvaOfjzgbVl8vKs
         hdvnOrUY4mqdD1BwOIrNmUk5piqWTXKYfZvdvXZfsPkn9lVVDTKEJA3iSkA58n5cpCY4
         kN8ID2l1vNPi2QPNpXJvoBJ6bMj917Iz2Ec45v2oFnyYoKWl+nKKM4XjUiXlGDMnUglf
         eYeDD/OHK5OGXCqwhjl0WagZR5xdD7dZFtthzHlBKFNTjU6QZtunwbrNHvGnaTm9HxQc
         wlSA==
X-Gm-Message-State: ABuFfoiYogP7xqx+lcNVuL549msRnthCEaoe+3fM8DffUvGoVDDSjgEx
        mKTXcniPPQUbMCxTX7ZXS1yRlV892Jr+kra31i+8HQ==
X-Google-Smtp-Source: ACcGV60ZUE3QGCpmpQs/4BUJzZcd3wChm9P5Ju4rjyjj8vjezk0c9e7wQVkpexzVPB8CK+Uv100P27CajoiaktaoajA=
X-Received: by 2002:a2e:5645:: with SMTP id k66-v6mr14489450ljb.48.1539719388026;
 Tue, 16 Oct 2018 12:49:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Tue, 16 Oct 2018 12:49:47
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <11171664-790c-40ff-3925-1c179ab8e74b@oracle.com>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <11171664-790c-40ff-3925-1c179ab8e74b@oracle.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 16 Oct 2018 13:49:47 -0600
X-Google-Sender-Auth: XABYl4VmizK_AhuAfv41LFFUmTQ
Message-ID: <CAJCQCtSfuLTsxXfEkmz59PrOJ3LrXmGNG+_NKS_LPk9dHTgkug@mail.gmail.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 16, 2018 at 2:13 AM, Anand Jain <anand.jain@oracle.com> wrote:
>
>
> On 10/14/2018 06:28 AM, Chris Murphy wrote:
>>
>> Is it practical and desirable to make Btrfs based OS installation
>> images reproducible? Or is Btrfs simply too complex and
>> non-deterministic? [1]
>>
>> The main three problems with Btrfs right now for reproducibility are:
>> a. many objects have uuids other than the volume uuid; and mkfs only
>> lets us set the volume uuid
>> b. atime, ctime, mtime, otime; and no way to make them all the same
>> c. non-deterministic allocation of file extents, compression, inode
>> assignment, logical and physical address allocation
>>
>> I'm imagining reproducible image creation would be a mkfs feature that
>> builds on Btrfs seed and --rootdir concepts to constrain Btrfs
>> features to maybe make reproducible Btrfs volumes possible:
>>
>> - No raid
>> - Either all objects needing uuids can have those uuids specified by
>> switch, or possibly a defined set of uuids expressly for this use
>> case, or possibly all of them can just be zeros (eek? not sure)
>> - A flag to set all times the same
>> - Possibly require that target block device is zero filled before
>> creation of the Btrfs
>> - Possibly disallow subvolumes and snapshots
>> - Require the resulting image is seed/ro and maybe also a new
>> compat_ro flag to enforce that such Btrfs file systems cannot be
>> modified after the fact.
>> - Enforce a consistent means of allocation and compression
>>
>> The end result is creating two Btrfs volumes would yield image files
>> with matching hashes.
>
>
>> If I had to guess, the biggest challenge would be allocation. But it's
>> also possible that such an image may have problems with "sprouts". A
>> non-removable sprout seems fairly straightforward and safe; but if a
>> "reproducible build" type of seed is removed, it seems like removal
>> needs to be smart enough to refresh *all* uuids found in the sprout: a
>> hard break from the seed.
>
>
> Right. The seed fsid will be gone in a detached sprout.

I think already we get a new devid, volume uuid, and device uuid. Open
question is whether any other uuid's need to be refreshed, such as
chunk uuid since that appears in every node and leaf.


>> Any thoughts? Useful? Difficult to implement?
>
> Recently Nikolay sent a patch to change fsid on a mounted btrfs. However for
> a reproducible builds it also needs neutralized uuids, time, bytenr(s)
> further more though the ondisk layout won't change without notice but
> block-bytenr might.

Seems like the mkfs population method of such a seed, could be made
very deterministic as to what the start logical address and physical
address are. The vast majority of non-deterministic behavior comes
from the nature of kernel code having to handle so many complex inputs
and outputs, and negotiate them.


> One question why not reproducible builds get the file data extents from the
> image and stitch the hashes together to verify the hash. And there could be
> a vfs ioctl to import and export filesystem images for a better
> support-ability of the use-case similar to the reproducible builds.

Perhaps. I don't know the reproducible build requirements very well,
if all they really care about is the hash of the data extents, and
really how important fs metadata is. That is important when it comes
to fuzzing file systems that have no metadata checksumming like
squashfs; of course you'd have to checksum the whole file system
image.

Another feature the mkfs variety of seed image would need,
deduplication.  As far as I know, deduplication is kernel code only.
You'd want to be able to deduplicate, as well as compress, to have the
smallest distributed seed possible. And mksquashfs does deduplication
by default.


-- 
Chris Murphy
