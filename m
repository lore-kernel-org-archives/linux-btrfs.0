Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BFFC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 14:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E622223DD
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 14:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="CFIiK7pi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E622223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbeKMAC3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 12 Nov 2018 19:02:29 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42931 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbeKMAC3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Nov 2018 19:02:29 -0500
Received: by mail-qk1-f196.google.com with SMTP id m5so13433074qka.9
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2018 06:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dueVwKIV7ZGuQKHDV0v4Oz+hhpxyY2LDFfVzTb4mL0I=;
        b=CFIiK7piewBEr98CbYKCzXE30a8vx5ZlNdzPDHBBzwuIhLnUHwZWsBvMdvzROdk1gJ
         cUJeJNEj1tHuJZe7Z7cr8QRNBYujsTVX3nnhvPDOWR9H/EfHh3PzJEeDsHGg/ZdYpWgJ
         tcBA3nZlX2gV1UM77PwFg4aj9JU8VR2wr9HAwvjsEre/vj3FHMCL3xvuL6ksvkLVHeqF
         vSqW0JOLi3z8MUKdaIePMhuI5cSADVvqVc4luDfZAuw5+wmMzsWn0YT/i6JIFDZAT1J5
         gQ+LHm/L7U/TPYwDWNwZE09ZsTJJAzq9yCEGT8y4gkVqr7HizlI6iYcxUUqemiGcjYy3
         UQtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dueVwKIV7ZGuQKHDV0v4Oz+hhpxyY2LDFfVzTb4mL0I=;
        b=eLhb2XyaHa10V8kjsSl3+ZZYQLLty72yXxNJVdEIQOULNEm6IjYq5f4e95UYA8MKoC
         ElAfMZ3RqQ4vM/UZHUsK59beO8xn2vSf4AKO4bbFpxgRZxzddDZuANP2nwtQUxAzsVi6
         JIsg9G6knvw0fnGdZQco/Y9QYqOqs5fsUUmHYvOxXPLN6YAXaG9/pJKhExaU9cX0rvni
         3RyTtu6z0iWRgS2xtL19WbmFjvYwTHHVR+ZyOXdSfPvnGRVJVuDcOcIYT18maIKlvVTv
         40W1QJbE7D4ZaihI5na2bmWiWLzuyk2/TH0QuKA9pugmTEis7Z/mJRlBaB/sgBVnTLWa
         +Wgw==
X-Gm-Message-State: AGRZ1gLee6vn3HWglAg8Th027sgimZa0sRFIsSOhe9evA49OMZ8ZJBeD
        6Uz/NxFo80ycADhjPkoSVtHu4g==
X-Google-Smtp-Source: AJdET5djq9hH/OguqHXjYnZKY9N8w0enwBUbLbiP1xXdV7i+WOMdKbB5yKeVVDm8JFbf1Fo6pl6TMQ==
X-Received: by 2002:ac8:3768:: with SMTP id p37mr1023806qtb.351.1542031742854;
        Mon, 12 Nov 2018 06:09:02 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:d2de])
        by smtp.gmail.com with ESMTPSA id 3sm7378647qkd.84.2018.11.12.06.09.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Nov 2018 06:09:02 -0800 (PST)
Date:   Mon, 12 Nov 2018 09:09:01 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove no longer used io_err from btrfs_log_ctx
Message-ID: <20181112140900.jncuehi5dh6ou6mi@MacBook-Pro-91.local>
References: <20181112102430.16096-1-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112102430.16096-1-fdmanana@kernel.org>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 12, 2018 at 10:24:30AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The io_err field of struct btrfs_log_ctx is no longer used after the
> recent simplification of the fast fsync path, where we now wait for
> ordered extents to complete before logging the inode. We did this in
> commit b5e6c3e170b7 ("btrfs: always wait on ordered extents at fsync
> time") and commit a2120a473a80 ("btrfs: clean up the left over
> logged_list usage") removed its last use.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
