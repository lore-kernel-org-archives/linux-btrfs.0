Return-Path: <SRS0=EUcM=33=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662EAC35247
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 00:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D75A217BA
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 00:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="0wJ2n8U5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbgBGAiM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 19:38:12 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40867 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgBGAiL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2020 19:38:11 -0500
Received: by mail-qt1-f194.google.com with SMTP id v25so611960qto.7
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2020 16:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lll014e4CAaZ3Kz2Y/7ru/mpUQD2fSGN1sJLx1JYegQ=;
        b=0wJ2n8U5xKYBTSofezUYsSR87N+7871HRT0Z44mzLy9SNGlRJw1JDWNGl8G6G+TgzU
         qt6zAhjyeSFuJe+gSh3vuu2dg23YzlyDqM/BzWK8wPfVaJ0Etg9uDn9tDmRTvYrYiZyF
         f99yuE/bBlj99lD4TVxBC2cyYSPp4JE46+TSiH/xbFPF8U6fjLxKcvdQ67SjmFukIkb9
         jIoRLdVKveEDxCazXkeMPRgt0jMaoHv4giAUIyhGLixVyh8aH+sFJ4UPegeeJCUojgKi
         aIfpkxIENn+NK9F589TNt9zi6AtNH5QbIeG2mMex0uEYMh4CQVI0omIUfMvO+SYcJytq
         OhBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lll014e4CAaZ3Kz2Y/7ru/mpUQD2fSGN1sJLx1JYegQ=;
        b=EtWS9wqG7qSebhLSGnmwjMfH7lPpsNUq1pRkeQ2cJS985iOC4+ZzWw+Ke9PyqYZYd4
         XbpT9lQ9MiqR/scfrZuOZ0VwsDSLiXjy7SgNA5mlSLVtv5BV9qV/f/z/oVuosXuLzGt6
         DoS0i0Zrj+7dDDipONaRUPc+nwvnRUH4WDavv8UgfsV8HrZuF9dWUR6Ye+23Ha0vp2wK
         igcoYBEy9kkc6da8g/G2jh3Qzbwq1Ba0TbAK3VMlsu05srK6n65sS+N8gHr0BYgV4zr+
         QpvWBeOjDSqUq6sHkh+KEzid1/8rT6IWk/hr20Tm8WrUnwNaOZkm/m33HfJEpvtIoQCw
         7hhQ==
X-Gm-Message-State: APjAAAXAnPWM0o77jJsiYOpaC41P2fCHCii3a3iMnBAwfflUyIqdV+O+
        MEXspDhSAoJHAA2CHcYUaibU4gWltCY=
X-Google-Smtp-Source: APXvYqxWO4NUQFH/UFDc1KTASxwppZlSdarfhqxBZbLavh4KAOT9Rh04hCXYXXohEIvcawc4PjWfTw==
X-Received: by 2002:ac8:71d7:: with SMTP id i23mr5264176qtp.50.1581035889485;
        Thu, 06 Feb 2020 16:38:09 -0800 (PST)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id c192sm490696qkg.125.2020.02.06.16.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 16:38:08 -0800 (PST)
Subject: Re: [PATCH] fstests: btrfs/022: Disable snapshot ioctl in fsstress
To:     Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20200206053226.23624-1-wqu@suse.com>
 <e3c530b6-af9d-97de-7008-5bc02c77e037@toxicpanda.com>
 <8199544d-c5cb-eb1e-ed7c-f9b170324997@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <7da58abd-eb5e-0a7f-f3bf-205f1daf95cd@toxicpanda.com>
Date:   Thu, 6 Feb 2020 19:38:07 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <8199544d-c5cb-eb1e-ed7c-f9b170324997@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/6/20 7:35 PM, Qu Wenruo wrote:
> 
> 
> On 2020/2/6 下午11:47, Josef Bacik wrote:
>> On 2/6/20 12:32 AM, Qu Wenruo wrote:
>>> Since commit fd0830929573 ("fsstress: add the ability to create
>>> snapshots") adds the ability for fsstress to create/delete snapshot and
>>> subvolume, test case btrfs/022 fails as _btrfs_get_subvolid can't
>>> handle multiple subvolumes under the same path.
>>>
>>> So manually disable snapshot/subvolume creation and deletion ioctl in
>>> this
>>> test case. Other qgroup test cases aren't affected.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>
>> Why not just fix _btrfs_get_subvolid?  You can use egrep to make sure
>> the name matches exactly.  Thanks,
> 
> Because we have other requirement, like limit tests.
> 
> If we have other snapshots/subvolumes, they don't have the same limit,
> thus unable to test qgroup properly.
> 

That's fair, but we should also fix _btrfs_get_subvolid since we know it doesn't 
work in this case.  Thanks,

Josef
