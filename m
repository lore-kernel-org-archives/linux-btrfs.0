Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C723C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5541A20859
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="WFb/3Nbs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388292AbfAOR0a (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:26:30 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33424 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388275AbfAOR0a (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 12:26:30 -0500
Received: by mail-yb1-f195.google.com with SMTP id o73so1375677ybc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 09:26:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W3chvmWM25O1I5FF5x/hdwX6+hC6ejDLHmrf7sX+dNI=;
        b=WFb/3NbsYRXNTIUHVC+92fIvcRgIyh61cGCXUNLeqfop0cn20rJtfpBxsIYOMds77E
         a2ipCs8M1jzwfitR0Gs1G13YY10fnjjnkKFALgk1F0aL2qt5zTru/0dliMcf96ZuK2s8
         Eckh5cdP6LdS/3QLxMBfU9fBCiZuGILVgiZqKNxeXzBWlizl5MxK3E0bZRRuPHDZRMv2
         TKRxF3ClbozS34fTKtAU9aLhgkbS+a6mt0I2rfG2wqgAtCgADYwiwlrxigX1Hy8waN4+
         L7AsqOIGrTXuP7YkRR22oTeefEK0B2w0B3cvHDmjPpUJd3wFRB2lf3eFrfW42tuMR7/e
         f8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W3chvmWM25O1I5FF5x/hdwX6+hC6ejDLHmrf7sX+dNI=;
        b=PSTB3731H+oPt5k6tAHlFhG7P9jWs4Xh5lO7Fi/YRQASVvkx/pSVGGlxYTKEPoqj5h
         uEg1Qr3LrZxB3Ir0wJ9MYSJtRXNCUh9xW/cnLftmZprw7cilVyuUVqhqiYRzSnv7Z/al
         uweTo4NpEFRvfbgsazCqa7DMonmWjmpyQqnK3P98stZyMwayK0mLuh3n+8xWTD27ToCW
         ZGcC2o1KpY0KMJzIXZP5qmNSO3WCrc2Jb6XbRqLTXnRWC49xdMoxq5KTvESQWXXO3+2l
         //a5PXKyp8KSpKDpcZ5+GeEY+PdCO+p9Vxz07niKhlI9Mf3E45g3acK+QZpU4VBpRTwy
         +0Hw==
X-Gm-Message-State: AJcUukdDhB5PA21b3rEZ24s7TwECjkcqAfF3vAiNy/vO+1eMd7gk4f0X
        GiW+Q4WFepuCV3U6FMMQk2VYVCBsc7E=
X-Google-Smtp-Source: ALg8bN4hdWTRDxV696RQTmH715VjzosSHzUaIC9Eq+MmM45fxAZ1+4MTrU0ZtaDclUQ+vpjyC9c+ZQ==
X-Received: by 2002:a5b:cd0:: with SMTP id e16mr4006800ybr.2.1547573189107;
        Tue, 15 Jan 2019 09:26:29 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:d708])
        by smtp.gmail.com with ESMTPSA id n133sm1375372ywb.55.2019.01.15.09.26.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 09:26:28 -0800 (PST)
Date:   Tue, 15 Jan 2019 12:26:26 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
References: <20190115081604.785-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115081604.785-1-wqu@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
> 
> Which is based on v5.0-rc1.
> 

I've been testing these patches hoping to get rid of the qgroup deadlock that
these patches are supposed to fix, but instead they make the box completely
unusable with 100% cpu usage for minutes at a time at every transaction commit.
Thanks,

Josef
