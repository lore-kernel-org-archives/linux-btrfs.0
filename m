Return-Path: <SRS0=UsBE=QC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF467C282C7
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 11:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C74218B0
	for <linux-btrfs@archiver.kernel.org>; Sat, 26 Jan 2019 11:45:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJ7f3Etp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfAZLpZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 26 Jan 2019 06:45:25 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46382 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfAZLpY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Jan 2019 06:45:24 -0500
Received: by mail-pg1-f194.google.com with SMTP id w7so5242608pgp.13
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Jan 2019 03:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=XqRO/tTdIM/AsxuHDSdFJXx3zL0tsWdltHpoEQrfjGw=;
        b=PJ7f3EtprnrZjACNuGLoAgMrMyJKHz9k5DOCccLpL2QFjLBlDGLu7Ml+g9vhfSyaBl
         1Sd631Fxh9YMfWFUwo1M602Ug7iWHFdEdax5AfbyiLgWx0vOdZe+PScAXAZQPIx9fcFl
         ktVHri+Qj+8TccOZ6bvTGQDq7sF2tKbFTErt8NdrRDWPtMKf67lcwH+OKjJHDOsvTOkE
         1itHrN6+76Oz/inwrmiYM74vrjKmTUJ7ObkH78pvOWCHzF3psMlDFguDCWIR0kUaDu2L
         M07IvxLboMXlYbjKiA9OXEs2+cwe9UCsejZMkksSF7+ykyFdkIe2aIxWnelUOiQr7zFK
         LB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=XqRO/tTdIM/AsxuHDSdFJXx3zL0tsWdltHpoEQrfjGw=;
        b=cqYNYGl0C1gZP1+fQzAafseSHgcnaxTguMv4TI6kuNoRz9T4f1tBD9tuBWMKDe3coz
         u3FzT/IFPtDYeBARj+8RXDhxIozcogJ1yYIlHTN8911aM0+CAeImzN1gYREOoHRcLFl5
         J4/v8VALNwshc9P/Va9V+FOi+MJ4SXsZIBcnaZsMHEEdy3GTSzE/k7sXWir0XJZnVOVG
         MAi9z4bWEsS11lcdIqBY/5dq64nw1cfNN8OHIRZLsHOWQc1714DuSplDUwTEDMHUpHQw
         uI9tUW0BfcR63nxBiCziftqRNPkIdjfhw0dbwIMIx/eiT0twCXTJA8UvtLHdnf14nzJP
         yq2g==
X-Gm-Message-State: AJcUukc5tW+zbr+LDaDo5xfOvaGuN+/+4RaWvv/lrIvBL2xRE8QXJQpa
        tS8e2mcGEBMyyTskxM/GtW1UJBb0
X-Google-Smtp-Source: ALg8bN6I7g1iB/oUxJu0Ct33Z3IXlOPfsI/ZKS9479IWjPDQP0DHs5pDuDhcPoMDKsVvV7jgWH10+g==
X-Received: by 2002:a63:5153:: with SMTP id r19mr13125309pgl.281.1548503124053;
        Sat, 26 Jan 2019 03:45:24 -0800 (PST)
Received: from [192.168.178.53] (14-201-16-168.static.tpgi.com.au. [14.201.16.168])
        by smtp.gmail.com with ESMTPSA id g15sm114433301pfj.131.2019.01.26.03.45.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Jan 2019 03:45:23 -0800 (PST)
To:     linux-btrfs@vger.kernel.org
From:   DanglingPointer <danglingpointerexception@gmail.com>
Subject: RAID56 Warning on "multiple serious data-loss bugs"
Message-ID: <5d7f63b2-d340-7c3a-679b-26e97ac258a6@gmail.com>
Date:   Sat, 26 Jan 2019 22:45:20 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-AU
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



Hi All,

For clarity for the masses, what are the "multiple serious data-loss 
bugs" as mentioned in the btrfs wiki?
The bullet points on this page: 
https://btrfs.wiki.kernel.org/index.php/RAID56
don't enumerate the bugs.  Not even in a high level.  If anything what 
can be closest to a bug or issue or "resilience use-case missing" would 
be the first point on that page.

"Parity may be inconsistent after a crash (the "write hole"). The 
problem born when after "an unclean shutdown" a disk failure happens. 
But these are *two* distinct failures. These together break the BTRFS 
raid5 redundancy. If you run a scrub process after "an unclean shutdown" 
(with no disk failure in between) those data which match their checksum 
can still be read out while the mismatched data are lost forever."

So in a nutshell; "What are the multiple serious data-loss bugs?" If 
there aren't any, perhaps updating the wiki should be considered for 
something less the "dramatic" .



