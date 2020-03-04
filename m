Return-Path: <SRS0=Ri2p=4V=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6305DC3F2CE
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 18:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33A0720870
	for <linux-btrfs@archiver.kernel.org>; Wed,  4 Mar 2020 18:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="hygTPlq5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbgCDSrQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 13:47:16 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41729 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729600AbgCDSrQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2020 13:47:16 -0500
Received: by mail-qt1-f195.google.com with SMTP id l21so2169975qtr.8
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Mar 2020 10:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MVd8GVST0RzNO7Z0hrAQX81JFcNlLr6eYr68umFC8Rg=;
        b=hygTPlq5a/uOvKQTbykNnAeg64T63BadNlEaSGMGLSrWWjHCiUAj9M7V/gMapGz2LI
         04yQh7Dmf93Cs9GHLh9gppe+5/7PKNdACBYZ+6JZ9Fs1C6+nZEiQFh0hrc26hP1kNNPU
         HZCdivn7vZKjm41XtM/umshn85JvXZuaj3WTnzVlzBGYDKgyxLfSL3WriRYnATyou37y
         7c9QdHDHQZLmnTzKdqAbmzszMOyCa6m2kXPqpQ/2nykbjHBXVaYZKzWxG5zaSd7Z46L0
         u47MuGz3O7uuj/ZdJgjYiSTRuVs5FXxyGMI4VIFJSroEdluCQtR6VH+F+uuW3h41CbAZ
         EAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MVd8GVST0RzNO7Z0hrAQX81JFcNlLr6eYr68umFC8Rg=;
        b=dW5S0tJ79jLJ8PuImGeCAuPLniQ9PUvr+awpy+gzoaWbT0KGw8sq/+rCOYHQXPh5IH
         kzQDk7nstWcW6n0xMocG4LPKsd1CAWbrt0pzio+2770vAOXGTz3cxGO8Yr+YFQC5U2ul
         RZDabiS6X0Ma29P0jZhs/7fJ1Pn7pEnET1DjgCrRYWvSBKqjxla8n3mMyB3aYsO/6l4e
         fE8Pe9ulkeDoKqUyr/UJRz7SraePno6Y24CJytAvQMVfGX0X/7UVm+rSUzw0ig1I/KD+
         C08DZiuFnPAS/QGemgJwwAr2cXSlb7rcJu7nXGL8ZpNwbCRCD7Ybmk15EeuGDX1leP4W
         IdjQ==
X-Gm-Message-State: ANhLgQ3mMsaUGpmazOHhwXZg6XkOZNoj+YYDZ/pq5qCk7IyUaYu2zGKM
        A3MrYipa85jJSrHWmAhcuafYH/n/hjo=
X-Google-Smtp-Source: ADFU+vtCBFqDUshxK+ssGUEBufIfUAptv0G3buIif55mJfg6qRr5657s51dM56til+sG/90n6L/cJw==
X-Received: by 2002:ac8:7b8e:: with SMTP id p14mr3675140qtu.352.1583347633580;
        Wed, 04 Mar 2020 10:47:13 -0800 (PST)
Received: from [192.168.1.106] ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id w48sm15393154qtc.40.2020.03.04.10.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 10:47:12 -0800 (PST)
Subject: Re: [PATCH 2/8] btrfs: do not init a reloc root if we aren't
 relocating
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20200304161830.2360-1-josef@toxicpanda.com>
 <20200304161830.2360-3-josef@toxicpanda.com>
 <27cd0745-6e4c-be69-5604-00b36a3cfcd7@suse.com>
From:   Josef Bacik <josef@toxicpanda.com>
Message-ID: <1af0b245-d1b6-a043-f74c-e3d80c08590e@toxicpanda.com>
Date:   Wed, 4 Mar 2020 13:47:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <27cd0745-6e4c-be69-5604-00b36a3cfcd7@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/4/20 1:44 PM, Nikolay Borisov wrote:
> 
> 
> On 4.03.20 г. 18:18 ч., Josef Bacik wrote:
>> We previously were checking if the root had a dead root before accessing
>> root->reloc_root in order to avoid a UAF type bug.  However this
>> scenario happens after we've unset the reloc control, so we would have
>> been saved if we'd simply checked for fs_info->reloc_control.  At this
>> point during relocation we no longer need to be creating new reloc
>> roots, so simply move this check above the reloc_root checks to avoid
>> any future races and confusion.
>>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> 
> Doesn't this patch essentially obviate the reloc_root_is_dead. W.r.t
> ->reloc_ctl it's important to note that it's being set under reloc_mutex
> which this function is also called under so we are guaranteed consistent
> value.
> 

Yes it does, but I want to keep the cleanups separate from the fixes.  I threw 
this in here because it's more of a correctness/fix than a cleanup.  Thanks,

Josef
