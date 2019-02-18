Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97130C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 10:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51D0E2173C
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 10:38:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="VIyAEsac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfBRKiE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:38:04 -0500
Received: from mail-it1-f169.google.com ([209.85.166.169]:52324 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfBRKiD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 05:38:03 -0500
Received: by mail-it1-f169.google.com with SMTP id r11so40031618itc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 02:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jt/kXkL1VpZpIFsfX+ZKv/KSU1MRa/q6L8k0zUw6/Uc=;
        b=VIyAEsacocX8KceJNW3YBb/WiEzQtLUWuknl8KdaRByxbwmRPQvFIv2TcwpZZh2VMn
         Mlib7IhFcfNLfBYdxpF7/YU+vmJ9P1mVdoH3hmDm1SOjxz7oPoaLQV2hRfA84yYcrjfJ
         3AIWKcYH3o18iftnQ42rbXYpmOXyJQ3YW1X+dsf6P5vAN7JVmtO6REsvM1eKGW2VKtxf
         oVfKZRqh0u/xnrjMEiIIplcGuRK3GVNN10+A0txs+7UMHP3yNklAch8rar0iaLs2gQyB
         /vICfyHSzzTYZ3/ZQVypzewLTJF8HuyjUcMf4FgBx+Ptb7DKXYNML4NacQ3gx3T/rUxs
         eDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jt/kXkL1VpZpIFsfX+ZKv/KSU1MRa/q6L8k0zUw6/Uc=;
        b=UmLPkitNB6zCJj3ky7d3J5JBsw0eZRB/++1d6wIi9SAJg+HQvSejn146XIA4RVb/nJ
         4MFuGInYZfsrDMbjw4i1Beic39uqhDgt249ogixZGFn07Q2wsn1JHTBpng/OZdUQezQJ
         367D6KvasqPWqTiO/HJHrDaEKCtGmBdo8LAKT+uut37VdH5IKN9IipdqTbBDVHMOTZRU
         0Em5G2fh+rgx059DKhDzaMwg6qEuT/FMNSnUfPOPMsWxKrFwP2CxsYFHUGYuTVtsoX5Z
         waHW5p/zmLwQ+LlLySAZlxlWR+4nsPT1zXdbuetpdfE4ZgHB4FCCX/rihtdLmzm1qzB8
         yBuA==
X-Gm-Message-State: AHQUAuZxGBSJWTLTj+3wK3V4w+N8y1yM56WxBQyYtKxY0GW3Y+4D64bi
        y+tFB6DseQOh/GBkcXjTzTkMI9apP2cQ0+oRuPtrkSlz
X-Google-Smtp-Source: AHgI3IZE+y9SWd20QvK1M3pjpWQgt1dFfTk2cw4Jxd+gWa9hk51CyPb13xGWuchulcqA2JOjGC+0RZOAPMdgEesP3jY=
X-Received: by 2002:a24:3dc8:: with SMTP id n191mr10188674itn.29.1550486282760;
 Mon, 18 Feb 2019 02:38:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1511980478.git.dsterba@suse.com>
In-Reply-To: <cover.1511980478.git.dsterba@suse.com>
From:   Alex Lyakas <alex@zadara.com>
Date:   Mon, 18 Feb 2019 12:37:49 +0200
Message-ID: <CAOcd+r2vJfDQcF+zqZStHMiz4PYw1irsvHYK=PjUJ5nYuUffug@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs fixes for 4.15-rc2
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi David,

>   Btrfs: incremental send, fix wrong unlink path after renaming file (2017-11-28 17:15:30 +0100)
>
> ----------------------------------------------------------------
> David Sterba (2):
>       btrfs: add missing device::flush_bio puts
Is there a reason that this one should not be tagged as "stable"? At
least the missing bio_put in  free_fs_devices is not an error case,
and would happen every time.

Thanks,
Alex.
