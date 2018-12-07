Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFECC07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 12:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09B6820892
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 12:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T3cF5YAR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09B6820892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbeLGMSs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:18:48 -0500
Received: from mail-it1-f180.google.com ([209.85.166.180]:53005 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbeLGMSs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2018 07:18:48 -0500
Received: by mail-it1-f180.google.com with SMTP id g76so6558072itg.2
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Dec 2018 04:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2G9d+38rG7OfcXFxq23CXr16BRMuKHUzgC4SXaEYhh0=;
        b=T3cF5YARxGCfXGTuJlraG4meYuaxap8XFHE84ZmAHqaQGgHbJp6rILdg11nD5y9PF+
         /gbD5tWK0F6rxjNcHP5CrCbspLXtNZABwneES2VJ/nWUUt5Z3LFGNjxRoSQHdDYoB3tC
         j/ceGuLtLEmKQVjrCs3oryY6q6x7dxpPmA2eqV9ZFvSCZgwMNNHunO0sR4hUmc2JImND
         zWZwWv0ED6/yIUkjhz7nWmaTl7c3rDnYgSLeF9PYY6rLtMJwY6e52h8dyPmNzEnM3ji0
         MO/dUW3PqS6BTVSqcroazvlTPJRkX/eaVfPZJ6REX1SCkuWgusD83brLCu4ADaHdfe6r
         1jEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2G9d+38rG7OfcXFxq23CXr16BRMuKHUzgC4SXaEYhh0=;
        b=qX9MNblzZ3IWET/YLDl59J6AQ2xqk/LIx3V9OUy9wjLL9JU0aU0Wf0FwhqrsBykv5s
         v7rCRQpc5ZRovTXl7eI14xnBZSx/MJcWKcj4itxqAvVKxs72LNzVGyyg1T2ATRyicS6g
         zzwMnpJQfMRt6YK8OZCQHsTTVp/jZ+BOg+/N51MFgfd2i00jNJYSLBXfk3IJbR+gRufg
         XRHQK4LGfZ9nNrtxOIGvS+jVfZXAgkOsCBZRBYoHr5Tc7PcGZVC2Y0lzK5Uf/asAetjj
         mqACooSTH69QZ3VL7V9xYS60tNzVaFPs1YIsXOhk3hXto1eGoDYmh96Reorfs4+ShE8m
         P9Xg==
X-Gm-Message-State: AA+aEWau6MB5ontZu63ahw29S/dQ0AXKHrxnwvvcdbFZdNQ0FECNt5v5
        6MofyHQii1cwvdWUagvz/sx5NnvkCv8=
X-Google-Smtp-Source: AFSGD/UAxs2v7MPePGTp19CHav2U9ClZloj9/Ijby+tfGtmS7oj6iNFIPUW7YkEFm1naP9PynKzvjg==
X-Received: by 2002:a24:5608:: with SMTP id o8mr1795252itb.35.1544185126948;
        Fri, 07 Dec 2018 04:18:46 -0800 (PST)
Received: from [191.9.209.46] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id k64sm2329984itb.7.2018.12.07.04.18.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 04:18:46 -0800 (PST)
Subject: Re: What if TRIM issued a wipe on devices that don't TRIM?
To:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Robert White <rwhite@pobox.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <bca3c064-0df5-a18c-7196-ac12c64141bf@pobox.com>
 <6c2a6a00-509d-1585-381f-68582c44591f@gmail.com>
 <90f90edd-c22c-b36e-4394-5a17b2a986ec@gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <62109e89-331d-a5ea-456a-a79bc1a31451@gmail.com>
Date:   Fri, 7 Dec 2018 07:18:43 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <90f90edd-c22c-b36e-4394-5a17b2a986ec@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-12-06 23:09, Andrei Borzenkov wrote:
> 06.12.2018 16:04, Austin S. Hemmelgarn пишет:
>>
>> * On SCSI devices, a discard operation translates to a SCSI UNMAP
>> command.  As pointed out by Ronnie Sahlberg in his reply, this command
>> is purely advisory, may not result in any actual state change on the
>> target device, and is not guaranteed to wipe the data.  To actually wipe
>> things, you have to explicitly write bogus data to the given regions
>> (using either regular writes, or a WRITESAME command with the desired
>> pattern), and _then_ call UNMAP on them.
> 
> WRITE SAME command has UNMAP bit and depending on device and kernel
> version kernel may actually issue either UNMAP or WRITE SAME with UNMAP
> bit set when doing discard.
> 
Good to know.  I've not looked at the SCSI code much, and actually 
didn't know about the UNMAP bit for the WRITE SAME command, so I just 
assumed that the kernel only used the UNMAP command.
