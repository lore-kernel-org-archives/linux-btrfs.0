Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE22C282C7
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 204192087F
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 18:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="GBqCsC1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfA2Soa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 13:44:30 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45574 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbfA2Soa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 13:44:30 -0500
Received: by mail-qt1-f193.google.com with SMTP id e5so23356278qtr.12
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2019 10:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3HznCahcR9PJC4DfXzGXeZgIhzUTceviPpPfD0Lwqqg=;
        b=GBqCsC1Kkv1tH4l3FfUrLYKxSQi/1ZMoGK1QVrakqcnrzvoBgWpdCcWQv3SRR+DzyV
         979pbeFgq3fad/EX9WL2MGpt34MvXUSDee+Joge0ORw7rbg/jpcJaOEy9pkYUoyuBiw6
         SnuY618hW8XR/HZFG5uHwyLMIIfkuyE1udAfd77fTrp0nPh0YVfqkLqAeGRy8g0cSTJw
         A9gMIV0IN1fiOnVulShM8SyfLDoxXGQyoPBJ2szNhkE2OvEqFP+7GvNNS72DG/tswiMX
         sthbLfII+ln9/2MiyA3dU8+RwcqE/QR4ByeDTV9l0I4geGItOgPTg+kt7fPpIeerunVk
         9afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3HznCahcR9PJC4DfXzGXeZgIhzUTceviPpPfD0Lwqqg=;
        b=lW9q4LyQilF6tVmTvcXhdW9t/2T/T0N8YeDRjbf9YdJWjC1fTcLDkzrRDGcbdeqBGj
         YPH2L683pLotdO1FpikwNJbzySZC4hwFsTFcu14S+x7AZl2TLtDUEIjkMDUuZymwbhLd
         ql+dYIAkk0+0I0k4ELAWM6qo84j8Qhq5oX01Bq5SXaATM7K7hUEdfUC2ch6rP5Lu9tDS
         FVI7eb6UvCs0jpiUtS9sIDzCoF4dBh6yojAP+o+5c7mPhZEpvWVSyLdj1dUWI40BxM7O
         xLNRwIBzg/FWV/KrjyBDCEy9o5ze5rctamBqxG6k8n+TkkldyQ8CG9HTkyjbop/wUxwT
         hrUw==
X-Gm-Message-State: AJcUukcMNlgKCL2LWjLsJSMwwYnZGhksDrClXwy5ZSGvPCwts7Rzpk6n
        FlOM4BntzZO/GrSdo5/ZEYYujA==
X-Google-Smtp-Source: ALg8bN6w0eciTPm/Xv/pVG10jpw4y8z3tOJGMYpOHVWFs6fdWdyPR9KxuNLh7Htz2vMM61A5qBxnBA==
X-Received: by 2002:a0c:fa46:: with SMTP id k6mr25062176qvo.36.1548787468744;
        Tue, 29 Jan 2019 10:44:28 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id n72sm92516793qki.26.2019.01.29.10.44.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 10:44:28 -0800 (PST)
Date:   Tue, 29 Jan 2019 13:44:26 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] btrfs: move to fn pointers for get/put workspaces
Message-ID: <20190129184425.itcwgyrvqdwfmzjx@MacBook-Pro-91.local>
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-8-dennis@kernel.org>
 <20190129181716.hstuxkdzai4qiist@MacBook-Pro-91.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190129181716.hstuxkdzai4qiist@MacBook-Pro-91.local>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 29, 2019 at 01:17:17PM -0500, Josef Bacik wrote:
> On Mon, Jan 28, 2019 at 04:24:33PM -0500, Dennis Zhou wrote:
> > The previous patch added generic helpers for get_workspace() and
> > put_workspace(). Now, we can migrate ownership of the workspace_manager
> > to be in the compression type code as the compression code itself
> > doesn't care beyond being able to get a workspace. The init/cleanup
> > and get/put methods are abstracted so each compression algorithm can
> > decide how they want to manage their workspaces.
> > 
> > Signed-off-by: Dennis Zhou <dennis@kernel.org>
> 
> We're doing this to have special handling for extra workspaces to be free'd at
> some point in the future if they are unused.  This is fine by me, but why not
> just add a shrinker and let it be handled by memory pressure?  Then we avoid all
> this abstraction and allow for ztsd to have its shrinker for its extra
> workspaces.  You can even use the list_lru stuff to make it super simple, then
> you don't have to worry about all the infrastructure.  Thanks,
> 

Nevermind, I missed that you also change the get side to lookup the workspace
for the compression level instead of cycling through the idle_ws list.  In that
case this is fine by me.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
