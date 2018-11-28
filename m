Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80083C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4035F204FD
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 00:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="kr5cPZrm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4035F204FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbeK1Lg7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 06:36:59 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45320 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeK1Lg7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 06:36:59 -0500
Received: by mail-io1-f68.google.com with SMTP id w7so18561374iom.12
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 16:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j9Y8yMbcggqWLzez2a3Ikcx1kq3kp92m3z9xZRvBmUs=;
        b=kr5cPZrmdp6GHcf7N0DRnHUvEo3o81FKOAAP5pqQdgYqFH3sfkZECHiGogoyuRDqa+
         BSyVIjRz7w58Q75Ypi3q5jDzH90jRA+3o+d3qp7imfRwFn5x1n6uAMIFqxnwmD51EKMY
         /JqFbHWKTZHMro1g4uozI7a/TmzsgYrw/T4EzzPTwxlyEP9fHneo9D23HbFNRQ9BoFUk
         Hkj6APNxr4fbmImtBKJej4kWgO/b4aHOOV13XHjkzGLm12xqhCI7oeOF5BD+EATPQglD
         ZfYwE2M3gg7N2S1jJlz+IEC/fLEkQXWvESXMq96bREHoApyuZwNC5kJs8SVotoL1DwzA
         bH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j9Y8yMbcggqWLzez2a3Ikcx1kq3kp92m3z9xZRvBmUs=;
        b=gkWz5KDOlHoTxNNCBRLap3eakyy/nWuxZ2xrkXP4xltXMO2oCkToTAM/c8Mt/MD7SG
         7niH/qeq4KimATQtjFm7LbbH13UAMolRhe9RKkC0zEkgsMv7GdkF5lRIjCB4Lx7ReXVE
         nABN8922/ziI+o/ZyKlPeBrYUzi9TI0+rp6qBFDkaA96K5R8b5cPCFvnhtKQu/TFWJmI
         Sol3hzOu0SZUDvIFyI0fjRHx4/A+vJxz/+R1OOlu7t1+pNLplBl3DezoWSBotlZK4TPP
         iN++X9bjPfLadK78AxA11rwbKitD1e6g3rsqgSY56wi/BIznjigVNbfa0e/8xcX6pG9A
         0CAg==
X-Gm-Message-State: AA+aEWb2KP0Dm6z1LUHpwpAbMAMsksZuNGQEcK2+gENGMWn0pSR538oT
        mzh/dqUrYkdOXeNfV7pVhThNbMs+E+0=
X-Google-Smtp-Source: AFSGD/Ua79YlP691of7U7i8ZReDEGme//nLTQ2wIhempJstWN9dQBNSbjEuaPBnqHBO6SrTf/ORdCg==
X-Received: by 2002:a5e:834d:: with SMTP id y13mr28373924iom.298.1543365438727;
        Tue, 27 Nov 2018 16:37:18 -0800 (PST)
Received: from vader ([2620:10d:c090:200::5:71bd])
        by smtp.gmail.com with ESMTPSA id p198sm1160873itb.30.2018.11.27.16.37.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 16:37:18 -0800 (PST)
Date:   Tue, 27 Nov 2018 16:37:16 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] btrfs: switch BTRFS_*_LOCK to enums
Message-ID: <20181128003716.GO846@vader>
References: <cover.1543348078.git.dsterba@suse.com>
 <5293feb9eb97fdaaa34db024ead13c5ec19234e3.1543348078.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5293feb9eb97fdaaa34db024ead13c5ec19234e3.1543348078.git.dsterba@suse.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 08:53:55PM +0100, David Sterba wrote:
> We can use simple enum for values that are not part of on-disk format:
> tree lock types.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/locking.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
> index 29135def468e..684d0ef4faa4 100644
> --- a/fs/btrfs/locking.h
> +++ b/fs/btrfs/locking.h
> @@ -6,10 +6,12 @@
>  #ifndef BTRFS_LOCKING_H
>  #define BTRFS_LOCKING_H
>  
> -#define BTRFS_WRITE_LOCK 1
> -#define BTRFS_READ_LOCK 2
> -#define BTRFS_WRITE_LOCK_BLOCKING 3
> -#define BTRFS_READ_LOCK_BLOCKING 4
> +enum {
> +	BTRFS_WRITE_LOCK,

See btrfs_set_path_blocking() and btrfs_release_path(); 0 means no lock,
so this needs to be BTRFS_WRITE_LOCK = 1. I imagine that lockdep would
catch this.

> +	BTRFS_READ_LOCK,
> +	BTRFS_WRITE_LOCK_BLOCKING,
> +	BTRFS_READ_LOCK_BLOCKING,
> +};
>  
>  void btrfs_tree_lock(struct extent_buffer *eb);
>  void btrfs_tree_unlock(struct extent_buffer *eb);
> -- 
> 2.19.1
> 
