Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03A0C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 12:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D9462133D
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 12:51:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S/dsqPUL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbfDBMvR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 08:51:17 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41160 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730934AbfDBMvO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 08:51:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id a25so11530398edc.8
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 05:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VmnXCXeyOT/2rWI7H8lCG+oRt9ZkxnDCNgIW8vlI6aE=;
        b=S/dsqPULcLdAI0jQA80jVRoPb2h0LpxLi89l+42UP33xQl8AIgdvnaRroyfSNEmXBE
         n4mgCwq+eUhMsdSPoDr39DLmYZKiw54S6K7oszlfGQzwHURavZKV6mKrLt7o0FNwi68X
         NfO4wPH3+LE+/cSYJJI51Fu8WGaJmcbRXHnM91Hyw26ONU8feNeXLPR9VtxxTRn7b9nf
         IySgiiqrzEqamPbWQQf1MPPKiuRl8ZWpQlNDoFZB9dJ7i4s75/QmQf+f7DBhWGKcciGV
         p1yUjwyq9r0LZg6bi0Tz3uwwV/sKzFIHxJrfCQ/aWb1gC1lz/RGEyktpRcJe+d9KE918
         GxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VmnXCXeyOT/2rWI7H8lCG+oRt9ZkxnDCNgIW8vlI6aE=;
        b=tHKyqJOSjJcrBlsdPEMeZw+nn+2Ni7FyERecuMjaBwLNcKgJvDsgnvswTIlKvcPyS0
         wQohd5rHwXlBZdhEUxIcxwr4MmFeL/4uehPkHx5gdoHnBE8iDmSouqOjFsAUY8t0IiRc
         qOOd0nkvf/Y+57IntGWn25W40iOpknxvZUcIh03Mbn0s9l9aAuCm9s7sVBRoEgPfgoWl
         /Z7wwdfYsmQ8um386nfahL0eboPF/sloAcc5VzIpLUy+U8xvDjdSPHZ3Kt4D2pm3XYd4
         hFOJQXuPO4WzRR3NV8ao4mKl2rfXMYtZqHuQaxHNlw1ZU108LmoCo6Vz09sLRy5eSVbM
         MzWQ==
X-Gm-Message-State: APjAAAVyHZ4Nae1MU6CiFb2bP8CwkU+CGWG1U1CkxVOBeiUO7RQ9sZOz
        I4gPQOMLzTP2tHQUx2Q97mXRJcG3
X-Google-Smtp-Source: APXvYqzaM+Aw+f0hZ6jiBPHFDOlVRMfot09nlUtFN6DQevavnDw2YlFlh9e03jbZ4fNg87tedGjlEQ==
X-Received: by 2002:aa7:d710:: with SMTP id t16mr46557313edq.222.1554209472784;
        Tue, 02 Apr 2019 05:51:12 -0700 (PDT)
Received: from [10.20.1.223] (ivokamhome.ddns.nbis.net. [87.120.136.31])
        by smtp.gmail.com with ESMTPSA id bs21sm2451615ejb.11.2019.04.02.05.51.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 05:51:11 -0700 (PDT)
Subject: Re: [PATCH] fstests: btrfs/048: amend property validation cases
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20190402100742.8355-1-anand.jain@oracle.com>
 <20190402100742.8355-3-anand.jain@oracle.com>
From:   Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <903ccfcc-dfaf-3543-c29c-9d0c91125b75@gmail.com>
Date:   Tue, 2 Apr 2019 15:51:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190402100742.8355-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2.04.19 г. 13:07 ч., Anand Jain wrote:
> Add more property validation cases which are fixed by the patches [1]
>  [1]
>   btrfs: fix property validate fail should not increment generation
>   btrfs: open code btrfs_set_prop in inherit_prop
>   btrfs: fix vanished compression property after failed set
>   btrfs: fix zstd compression parameter
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> (As this fstest patch depends on the kernel patches,
>  this patch isn't sent to fstests mailing list yet).
> 

Doesn't matter, it's fine to have a test merged before respective kernel
patches have landed. In fact there is one btrfs test (can't remember
which one) authored by you which is failing, yet the respective kernel
patches have never been sent to the mailing list.
