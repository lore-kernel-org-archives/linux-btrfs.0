Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1704C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 12:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6895C2087A
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 12:26:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dwiPEPyv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6895C2087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbeKPWie (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 17:38:34 -0500
Received: from mail-it1-f173.google.com ([209.85.166.173]:38954 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeKPWie (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 17:38:34 -0500
Received: by mail-it1-f173.google.com with SMTP id m15so34001587itl.4
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 04:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UmLbCqHsWgLG32iUK9ZIb5/RhyicknCSe+PO5jlk9l0=;
        b=dwiPEPyvpIXfxzLaE+DHKE+EjFUUlQOCNpXweiiCy0uZ5x87G/NVKdYPCo78s6wxuT
         1TWdql5U+b2vmom/whktp7YF/gWjyKLffVctQ/wR5SDOiKDpRvO094y7OkhuXBs+7Y2f
         ANxw1mbUK7+FWV+B0zvbV/AmgETPm2Leyj/EPHwy9r7cSyJrVkj1VS6he1fQO9DR1V3H
         ms3d8tPrRSW32aNZuPlEZcsPhFMmmy0QW/w+Bv4pHdx9+U/fIaHRQD8ZLNLUSTIDq1jT
         kM4dDQVKAPVqSCHNWVkyHY0D4gM3BF9F3AvxAT+78Im0uijqhfV/a4MRtFNUASIkjLJ3
         5kHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UmLbCqHsWgLG32iUK9ZIb5/RhyicknCSe+PO5jlk9l0=;
        b=ZM9dde3UsZGcehqinc6ch5cWFMEnnwobk9IlE00DV193rzd1BOZ1jPeiwskfNtUN9E
         4JiDOqgUpUWl8NM29WQPLvYcmVSESSchaT7uiBDNVtZ1K3qEHjdSd5tfdXAme2jEI+T4
         P3zswuXE3UcTMs8JnfD1lhJRkIDc2WRDVMDTFsjitmjQmc64zPeV5Bmr5IvDxlvmQ6Zs
         zqtQ2LckTQaGu5G3MYL+i/y5wMKMX8hgT4tXpf9HwTDkSVpViEU1BJiIjHbD3INcNbc2
         zgVnY4GYGX0ShU9mlpU8OQgfNcb0nBvmBDwZnJ5/DfGk5oZBIkExFPRcYlUr6sOYmTz9
         AAjw==
X-Gm-Message-State: AGRZ1gKhOgvBppXcCJmZNFyCEx3xwHspvB9v/VIAyB0CC2hOycTXnlWA
        x3rpg6ZpkRQe+xa2BlJmH0UBVU7L8vI=
X-Google-Smtp-Source: AFSGD/WOVAEgaiqX2wXujQf2SrEhPT3zDDqpduLi+UfSV+yWKT4nqL9/+48FzGO49rvp6IsCJC2G9A==
X-Received: by 2002:a24:2c1:: with SMTP id 184-v6mr9311696itu.7.1542371183343;
        Fri, 16 Nov 2018 04:26:23 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id c21sm5562589iob.22.2018.11.16.04.26.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Nov 2018 04:26:22 -0800 (PST)
Subject: Re: BTRFS on production: NVR 16+ IP Cameras
To:     jacirez@rdcsafety.com, linux-btrfs@vger.kernel.org
References: <bf338fb1-11fe-baea-4099-af9dc267e597@rdcsafety.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0bafdbb4-82bf-5b28-b9bd-0fa1a4c2cb2b@gmail.com>
Date:   Fri, 16 Nov 2018 07:26:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <bf338fb1-11fe-baea-4099-af9dc267e597@rdcsafety.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-11-15 13:39, Juan Alberto Cirez wrote:
> Is BTRFS mature enough to be deployed on a production system to underpin 
> the storage layer of a 16+ ipcameras-based NVR (or VMS if you prefer)?
For NVR, I'd say no.  BTRFS does pretty horribly with append-only 
workloads, even if they are WORM style.  It also does a really bad job 
with most relational database systems that you would likely use for 
indexing.

If you can suggest your reasoning for wanting to use BTRFS though, I can 
probably point you at alternatives that would work more reliably for 
your use case.

