Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D698C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 10:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BC512084D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 10:52:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="orafhBPh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfDLKwO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 06:52:14 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:34098 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfDLKwO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 06:52:14 -0400
Received: from [192.168.178.50] (ip5f59220b.dynamic.kabel-deutschland.de [95.89.34.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 27F6D4A28069;
        Fri, 12 Apr 2019 13:52:12 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1555066332;
        bh=VKWDpqs8tRoTzkDLgtVFHvktV4h7xe9Dccg09LyvdLo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=orafhBPha5lduXyt3SUGOqppiVG4q19rJX7UAWcL+k0Dq/0K5exNAs+awddriUHma
         fumWDEXbcBGmp8Vxh8Ayu7B3iybSBlrOeAp3GjvCOOXGBfFGMDYRYu7bTQTqmdgsLO
         gs4XPqFL5iJZK/8ovtPqZHdsChlCv3au7ZOIpeJULQfyXHDq28h9DY/GtyX3+IMkoh
         ejJwtRNuzvpUHjhlzH72jNtBpZn08hsBs9y3Lc47mbHoP0Q5pb3TgD9ngbSL3kMI0a
         mOMWdxjUsSplPhLqhUT5Oiy8YU5qMifgEAwzxX9SzIhrRzAeMOSXzH7j/yzf9Zmg7k
         XyoD9K4BzBwdA==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Jeff Mahoney <jeffm@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
 <3a3537f5-b84c-ee01-b5da-d6bab5bdf221@avgustinov.eu>
 <CAJCQCtRp+53U_RG+n6oTpBrRRhSSR36OLBc++Q9dQDbHFovurw@mail.gmail.com>
 <beab578a-ccaf-1ec7-c7b6-1ba9cd3743ad@avgustinov.eu>
 <CAJCQCtR6Syn3LYCVOciGPLEpP91Jb9tYp=NncnC2aCNv6coyEw@mail.gmail.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <9bac5d98-4de7-e49b-58d2-8e81ce90252c@avgustinov.eu>
Date:   Fri, 12 Apr 2019 12:52:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR6Syn3LYCVOciGPLEpP91Jb9tYp=NncnC2aCNv6coyEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-05 09:07, Chris Murphy:
> On Fri, Apr 5, 2019 at 12:45 AM Nik. <btrfs@avgustinov.eu> wrote:
>>
>> Sorry, I forgot this. Hier is the output:
>>
>> # btrfs-image -c 9 -ss /dev/sdj3 /mnt/b/sdj3.img
>> WARNING: cannot find a hash collision for '..', generating garbage, it
>> won't match indexes
>>
>> The new image is same size, and since it seems small to me I am
>> attaching it to this mail.
> 
> What do you get for `btrfs insp dump-t -d /dev/` ?
> 
> Once I restore it, I get
> 
> 
> $ sudo btrfs insp dump-t -d /dev/mapper/vg-nik
> btrfs-progs v4.20.2
> checksum verify failed on 90195087360 found 6036BAAE wanted 7C05A75D
> checksum verify failed on 90195087360 found 6036BAAE wanted 7C05A75D
> bad tree block 90195087360, bytenr mismatch, want=90195087360,
> have=7681037117263365436
> Couldn't setup device tree
> ERROR: unable to open /dev/mapper/vg-nik
> $ sudo btrfs insp dump-t -r /dev/mapper/vg-nik
> btrfs-progs v4.20.2
> checksum verify failed on 90195087360 found 6036BAAE wanted 7C05A75D
> checksum verify failed on 90195087360 found 6036BAAE wanted 7C05A75D
> bad tree block 90195087360, bytenr mismatch, want=90195087360,
> have=7681037117263365436
> Couldn't setup device tree
> ERROR: unable to open /dev/mapper/vg-nik
> $
> 
> There is a valid superblock however. So it restored something, just
> not everything, not sure. Might be related to create failed success!
> 

Do anybody need something else from this filesystem? If not - I would be 
glad to reformat and reuse this ssd partition.

Kind regards,
Nik.
--
