Return-Path: <SRS0=TwUB=NV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8871AC43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Nov 2018 05:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CEAB20825
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Nov 2018 05:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="am8FSGYX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CEAB20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbeKJPki (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 10:40:38 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:43998 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728662AbeKJPki (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 10:40:38 -0500
Received: by mail-pl1-f196.google.com with SMTP id g59-v6so1878637plb.10
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 21:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YmFhFbCZOBA+QUkA40dOjXG+hg45wBEro0Qr8JDFU9E=;
        b=am8FSGYXLIQZA/TF46n8tORjZxq7K3i2PM3x9dB4Ww1LzredUNiDyWwl50h4UlDPn+
         0E9a5XkWJ6qnHGYPjDnQ7z2EpCEw3i8nh5W8+juz3XtbQpr6TNLrquv9Q5XJm4x50Z2M
         3pi5aRDEHek6hqTbRYl++VRc+qdsG9fvv3W+CdWptKfmLQbIaJvLOQk1FKCJ7V4jGfVi
         1lkv95aK6soY2ZBRqtVm5Y3gMY48lRL1BV2vW8+PSG1eqiXPIpXIIdgE6iYReLB6sbST
         EBioh2TQVBGG4WFsIRfPM8T0oswfaZjvcarCbxWfkH/mn9raHQkUWMYO8twmIfTS8ZVu
         or0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YmFhFbCZOBA+QUkA40dOjXG+hg45wBEro0Qr8JDFU9E=;
        b=ZT6T65eK+4l/4UBjBPmVBCQOB5kmNql16wMNF1hLVnAwvVom062kEiy4kw+GegBIoa
         2ZGwNOaTOICq6hkOtbWE2HaWhLMx3m7J9/c+QYpAzAF8Z2aNNjXSl378Z2v76YGMN2Kr
         u6FXFrCUiVnBNmXWLdoQs6uBUIlWxetZE+M6lhqS+FvfecOpEe747daIhhoTtf+23YFj
         zW4RYQCZf3XVgf7mhHQ1AVdmvvD9229H+JIYxADnChaQ1ey4Hbe+z6lSnVDwf8eLT/d7
         Y4koUpB4ZvoyUKQtN9d++upM7tXMmM6y43/CH94k3/rLAvVmsv355WKdy+PMhIrouNJR
         Qdag==
X-Gm-Message-State: AGRZ1gK1gPWd77SsPZNf7hHJdwvQ27o5rljAVv2WeBM/clDI5+uR9wRg
        Ac9+DWX3LlHL90sAw9yiVBD4gPFeMfQ=
X-Google-Smtp-Source: AJdET5f+piJe0vSX+gnhx9qLantZWReXxLYich+NYj/9sl2WYemZ+q5YZCkpfcdwCXvniMxqUTSKyg==
X-Received: by 2002:a17:902:9346:: with SMTP id g6-v6mr11247443plp.148.1541822839544;
        Fri, 09 Nov 2018 20:07:19 -0800 (PST)
Received: from vader ([2620:10d:c090:180::1:7deb])
        by smtp.gmail.com with ESMTPSA id h10sm7732512pgn.11.2018.11.09.20.07.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 20:07:18 -0800 (PST)
Date:   Fri, 9 Nov 2018 20:07:16 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v2] Btrfs: fix missing delayed iputs on unmount
Message-ID: <20181110040716.GA23447@vader>
References: <5d98091d3e089b4f74cb61fb2ed691e1f4dd1d6b.1541005462.git.osandov@fb.com>
 <20181107160119.GG24115@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107160119.GG24115@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 07, 2018 at 05:01:19PM +0100, David Sterba wrote:
> On Wed, Oct 31, 2018 at 10:06:08AM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > There's a race between close_ctree() and cleaner_kthread().
> > close_ctree() sets btrfs_fs_closing(), and the cleaner stops when it
> > sees it set, but this is racy; the cleaner might have already checked
> > the bit and could be cleaning stuff. In particular, if it deletes unused
> > block groups, it will create delayed iputs for the free space cache
> > inodes. As of "btrfs: don't run delayed_iputs in commit", we're no
> > longer running delayed iputs after a commit. Therefore, if the cleaner
> > creates more delayed iputs after delayed iputs are run in
> > btrfs_commit_super(), we will leak inodes on unmount and get a busy
> > inode crash from the VFS.
> > 
> > Fix it by parking the cleaner before we actually close anything. Then,
> > any remaining delayed iputs will always be handled in
> > btrfs_commit_super(). This also ensures that the commit in close_ctree()
> > is really the last commit, so we can get rid of the commit in
> > cleaner_kthread().
> > 
> > Fixes: 30928e9baac2 ("btrfs: don't run delayed_iputs in commit")
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> 
> I'll queue this patch for rc2 as it fixes crashes I see during testing.
> My version does more changes and would be more suitable for a series,
> that could actually document the shutdown sequence and add a few
> assertions on top.

Thanks, Dave! I'll keep an eye out for the further cleanups.

> Reviewed-by: David Sterba <dsterba@suse.com>
