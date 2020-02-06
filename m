Return-Path: <SRS0=9o53=32=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D424C33CAC
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 16:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DEC020720
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 16:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="h22xUsnh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgBFQrd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 11:47:33 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39426 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFQrd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2020 11:47:33 -0500
Received: by mail-qk1-f196.google.com with SMTP id w15so6188013qkf.6
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2020 08:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XVG7v7bFBwwbQl9cPUzkj8ZxgF7lAxk5feqnNAL3RXk=;
        b=h22xUsnhdJsrHQwryenL7/L3SoNeXvRgwKddh8PQMgu/wTgMa5CdwETMJgD8ChbneF
         /yagSixq+jvAQ654XS6xNeqA5uTc24ZuUD5TrYGeUn/fi1c8zt5BRPgSXrvW7ujIbiVs
         Dmdk3ZSMJJSwv+glIUG34SHYUxx5n12Bn1nE1mY48Qy8c2kqd37XM17Ma5bQ+ZxscJr+
         h41Q2zoy/C65WfjgLEpP44XsVt6KzepfBuAQu9w6nbyK+MXEBRBpns9P7+mmO4zZwKLU
         m0mqbJ951DWiuDcm5TgoBNfgzcjgVEQc0PC5UR+P/bytiyvh17aVVntXBU6ivz/bKQ1b
         cjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVG7v7bFBwwbQl9cPUzkj8ZxgF7lAxk5feqnNAL3RXk=;
        b=TttYtStmsnSbAjnw1tN0bVlPrTVqtzvQrjSu/bf4RXmHr17Zymu8Ppv0LM+qBieSo3
         r4WAfINhdE2cLDJ0ZMcJW+IfS5qE4mWuE+EbNzgmCVPEilD01GrfVGqFbOZombOrNY+P
         +0es3CHCInDnLJJnDBB/WT/z4PVOENQBPMBva4BRYovWixhfKSo6aLxtGEjOzOUCynpb
         BFWMlOQNqBdofc34njLAVR37VEYjiXa59IaVWO08o1+XGy0gZse4XbNUbljLdY8og/wR
         MJAsR73/W6kATqH55svWO7fX3QCEz3SaPy9sosElMlFrB/2PyhBbaaNXZJkgdI2NL7UC
         XkVw==
X-Gm-Message-State: APjAAAXB70x8BdMcDU8twUprpdda2/eSYXv5UV/a4mvj6alZmPr6yjE6
        2k9d1C1w94nU2Vt31+fay5eGXQ==
X-Google-Smtp-Source: APXvYqxQTyFqJidCnScxft9PkR13gGGGB9EIMlccweOwemtfo1yKROui489TylByINemsvoatYOlGg==
X-Received: by 2002:a05:620a:20d4:: with SMTP id f20mr3068975qka.343.1581007651823;
        Thu, 06 Feb 2020 08:47:31 -0800 (PST)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w21sm2012878qth.17.2020.02.06.08.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 08:47:31 -0800 (PST)
Subject: Re: [PATCH 07/20] btrfs: factor out decide_stripe_size()
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Cc:     Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-fsdevel@vger.kernel.org
References: <20200206104214.400857-1-naohiro.aota@wdc.com>
 <20200206104214.400857-8-naohiro.aota@wdc.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <36283c9f-48da-7daa-3167-1efe9e64c66f@toxicpanda.com>
Date:   Thu, 6 Feb 2020 11:47:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200206104214.400857-8-naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2/6/20 5:42 AM, Naohiro Aota wrote:
> Factor out decide_stripe_size() from __btrfs_alloc_chunk(). This function
> calculates the actual stripe size to allocate. decide_stripe_size() handles
> the common case to round down the 'ndevs' to 'devs_increment' and check the
> upper and lower limitation of 'ndevs'. decide_stripe_size_regular() decides
> the size of a stripe and the size of a chunk. The policy is to maximize the
> number of stripes.
> 
> This commit has no functional changes.
> 
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
