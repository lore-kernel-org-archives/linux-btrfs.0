Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF913C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 13:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6008320878
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 13:04:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fW1/joF1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6008320878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbeLFNEl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 08:04:41 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43351 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbeLFNEk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Dec 2018 08:04:40 -0500
Received: by mail-qt1-f194.google.com with SMTP id i7so363904qtj.10
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Dec 2018 05:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/rLg64+T+2R8gXZc8wyc2GhXGAG/YUkxxjO+U2eALNs=;
        b=fW1/joF1k1clWriVeDBBoTI5S/0fZCnRN/VUbHRjuw39HYnaEI80W7YNa7sSZNH1nI
         pVT3Qjps1sX41jUUnn+/kMHO3L/o6qIMto+F7i18hSCgrloQn067FXcxPcE30xrZqedP
         OakRvOJABPdJG/D7HXTlAWgiyDcxtjnbVun7uRGFZmIuFIxTYVtQfbJ3eIG6d4Uueh8J
         Llj1lv600sFIkELTA6TnEZ6jOBzSsx+8F+kl4XHcfX2Xi+aj6ZEOa2bFqCnqLHJOHeRt
         VFS5Um00EnEAmS9lxdSjV5z2OaKHuwjhaiD0Jz85BewlGSsxA9kI/nbgOjmbUqCKMY6R
         RyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/rLg64+T+2R8gXZc8wyc2GhXGAG/YUkxxjO+U2eALNs=;
        b=Khdj5QADEtZl4jD1CcmNQIaNRimDm0F7QHPluBjr6pxwzEm40GGABdnYmTbKtsIVZs
         Q7Z65hwBac6o/zke6BcrK4CPkBStGmUacqRLlAZNFGeYTFft751tylS9njRqIqOrqk8Z
         2JqAJdJlGeU0lzSCyU4p2cYh9wqiIeanBqTMAM7JSIo3vLlj9YisPtSYxmHczLzp844Z
         sE4narUea8lIcE13ttYyVjjU/dKPqI/K63wwWqAExabYOsCVyjwMqtTc2b1HcW5coUWu
         X3RXkAwj5mK0QMM5MGyXDAVZgkTK9GL9QpnKZBzNoEqcXhupNYsZ4Zt65kdkyW8kIHJW
         RzbA==
X-Gm-Message-State: AA+aEWa2J1yPboUZHxJxFxXE7YaVSyMi0+udMP/IVFC6r3YwoNE9QSUU
        uGg5qf4Xh4TEsyoQTAgX18ErFVtLQCc=
X-Google-Smtp-Source: AFSGD/WQuT43iL47G25IV5qGs+y9g8hGMgc97+Jw1quAVQ++ASwgFVhgWfyc2pucrUjImSnurPnt8Q==
X-Received: by 2002:ad4:40c9:: with SMTP id x9mr27373319qvp.165.1544101478596;
        Thu, 06 Dec 2018 05:04:38 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id j89sm201798qkh.34.2018.12.06.05.04.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Dec 2018 05:04:37 -0800 (PST)
Subject: Re: What if TRIM issued a wipe on devices that don't TRIM?
To:     Robert White <rwhite@pobox.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6c2a6a00-509d-1585-381f-68582c44591f@gmail.com>
Date:   Thu, 6 Dec 2018 08:04:33 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-12-06 01:11, Robert White wrote:
> (1) Automatic and selective wiping of unused and previously used disk 
> blocks is a good security measure, particularly when there is an 
> encryption layer beneath the file system.
> 
> (2) USB attached devices _never_ support TRIM and they are the most 
> likely to fall into strangers hands.
Not true on the first count.  Some really nice UAS devices do support 
SCSI UNMAP and WRITESAME commands.
> 
> (3) I vaguely recall that some flash chips will take bulk writhes of 
> full sectors of 0x00 or 0xFF (I don't remember which) were second-best 
> to TRIM for letting the flash controllers defragment their internals.
> 
> So it would be dog-slow, but it would be neat if BTRFS had a mount 
> option to convert any TRIM command from above into the write of a zero, 
> 0xFF, or trash block to the device below if that device doesn't support 
> TRIM. Real TRIM support would override the block write.
> 
> Obviously doing an fstrim would involve a lot of slow device writes but 
> only for people likely to do that sort of thing.
> 
> For testing purposes the destruction of unused pages in this manner 
> might catch file system failures or coding errors.
> 
> (The other layer where this might be most appropriate is in cryptsetup 
> et al, where it could lie about TRIM support, but that sort of stealth 
> lag might be bad for filesystem-level operations. Doing it there would 
> also loose the simpler USB use cases.)
> 
> ...Just a thought...
First off, TRIM is an ATA command, not the kernel term.  `fstrim` 
inherited the ATA name, but in kernel it's called a discard operation, 
and it's kind of important to understand here that a discard operation 
can result in a number of different behaviors.

In particular, you have at least the following implementations:

* On SCSI devices, a discard operation translates to a SCSI UNMAP 
command.  As pointed out by Ronnie Sahlberg in his reply, this command 
is purely advisory, may not result in any actual state change on the 
target device, and is not guaranteed to wipe the data.  To actually wipe 
things, you have to explicitly write bogus data to the given regions 
(using either regular writes, or a WRITESAME command with the desired 
pattern), and _then_ call UNMAP on them.
* On dm-thinp devices, a discard operation results in simply unmapping 
the blocks in the region it covers.  The underlying blocks themselves 
are not wiped until they get reallocated (which may not happen when you 
write to that region of the dm-thinp device again), and may not even be 
wiped then (depending on how the dm-thinp device is configured).  Thus, 
the same behavior as for SCSI is required here.
* On SD/MMC devices, a discard operation results in an SD ERASE command 
being issued.  This one is non-advisory (that is, it's guaranteed to 
happen), and is supposed to guarantee an overwrite of the region with 
zeroes or ones.
* eMMC devices additionally define a discard operation independent of 
the SD ERASE command which unmaps the region in the translation layer, 
but does not wipe the blocks either on issuing the command or on 
re-allocating the low-level blocks.  Essentially, it's just a hint for 
the wear-leveling algorithm.
* NVMe provides two different discard operations, and I'm not sure which 
the kernel uses for NVMe block emulation.  They correspond almost 
exactly to the SCSI UNMAP and SD ERASE commands in terms of behavior.
* For ATA devices, a discard operation translates to an ATA TRIM 
command.  This command doesn't even require that the data read back from 
a region the command has been issued against be consistent between 
reads, let alone that it actually returns zeroes, and it is completely 
silent on how the device should actually implement the operation.  In 
practice, most drives that implement it actually behave like dm-thinp 
devices, unmapping the low-level blocks in the region and only clearing 
them when they get reallocated, while returning any data they want on 
subsequent reads to that logical region until a write happens.
* The MTD subsystem has support for discard operations in the various 
FTL's, and they appear from a cursory look at the code to behave like a 
non-advisory version of the SCSI UNMAP command (FWIW, MTD's are what the 
concept of a discard operation was originally implemented in Linux for).

Notice that the only implementations that are actually guaranteed to 
clear out the low-level physical blocks are the SD ERASE and one of the 
two NVMe options, and all others require you to manually wipe the data 
before issuing the discard operation to guarantee that no data is retained.

Given this, I don't think this should be done as a mechanism of 
intercepting or translating discard operations, but as something else 
entirely.  Perhaps as a block-layer that wipes the region then issues a 
discard for it to the lower level device if the device supports it?
