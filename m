Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92D2C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 00:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9419820811
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 00:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="vD9FswlW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbfC0AWI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 20:22:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44172 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731824AbfC0AWI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 20:22:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id y7so12319957wrn.11
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 17:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=07uKDg88ytN4+ggY94pk0tnQNZiDqn84rgVWBUunKnM=;
        b=vD9FswlWSLdh1q1NmBIvTNpsisbhodltuCRCd4Z9Rj89xHnqXvUAi6NhLSoUZyBHEj
         1SAIfe7kNvgUYK76BclQi5Nnr6Mk6zYFNfbWY+9uI4HPQoIQgQaafrugr4PrJSzQAJ5X
         THFQVRKGTcPTkl+TT4jK/JlNMHRxOoFjHSzBVvosc1shggIplQaVCfodurcUg8CL0p2t
         NSRI/0ypvUDGCH5sQb+qvoudeNHyqrM5RyhPPybP/7VdOO/gaMbucFMj3dsChLnJ0iNr
         tJaANSJu043yThcgNjyvaLSgPTlqB/E7D+QCirXmevkooc5KmqF42sUFrEWXUfU5iPRc
         N3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=07uKDg88ytN4+ggY94pk0tnQNZiDqn84rgVWBUunKnM=;
        b=h/junLRatiYAhFtnN6xIsUCnTvarDkj9GbFN3/xodFFbY0NdwxYzKCh9La0yu3BByQ
         8sxIJDWG33iPtzinH9trceTyW5MTeV1IgrP1VY20jpJRXfhLU/xkC1vvfa5zclkH9L3F
         0Tb1w8oKBXiWK2plPoHlcOd2ie8shpQq9N6IK+FsiCBn8S5R2SApRDY1eSiXseBE42VO
         IaNeJA8dRpr+4/4aXrwdI+rTZgNrDNjuSUGHV7NGNSyz1RqvV2NKehX7EKPZgyM5Jl4o
         7z+eZMajc3UtCQoYwvdNUGjwD1JEuYf2752i05agAEmD+0RcIHy19YKgIz8i1lub6wkf
         Ogzw==
X-Gm-Message-State: APjAAAV/JjGvFYrhCIsF3fglRebC4hg4Mlg4ZtpHU1eO/xRrwRGH6CGN
        yZI3qWaySm035KDG4jOyBAR3ow==
X-Google-Smtp-Source: APXvYqz78g4WTbxPznI+4NzM/44fm7aoslCkZPuU8Etd1RulBaJ9HeSxEiwCxgJMsCqBbAiFYjbpCQ==
X-Received: by 2002:a05:6000:1286:: with SMTP id f6mr21122660wrx.93.1553646126313;
        Tue, 26 Mar 2019 17:22:06 -0700 (PDT)
Received: from pathfinder ([90.195.158.41])
        by smtp.gmail.com with ESMTPSA id i28sm38726010wrc.32.2019.03.26.17.22.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 26 Mar 2019 17:22:05 -0700 (PDT)
Date:   Wed, 27 Mar 2019 00:22:01 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     David Sterba <dsterba@suse.cz>
Cc:     clm@fb.com, jbacik@fb.com, amir73il@gmail.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v6 07/07] btrfs: use common file type conversion
Message-ID: <20190327002201.GA24884@pathfinder>
References: <20190326213934.GA20882@pathfinder>
 <20190326235539.GX10640@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326235539.GX10640@suse.cz>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 12:55:39AM +0100, David Sterba wrote:
> On Tue, Mar 26, 2019 at 09:39:34PM +0000, Phillip Potter wrote:
> > Deduplicate the btrfs file type conversion implementation - file systems
> > that use the same file types as defined by POSIX do not need to define
> > their own versions and can use the common helper functions decared in
> > fs_types.h and implemented in fs_types.c
> > 
> > Common implementation can be found via commit:
> > bbe7449e2599 "fs: common implementation of file type"
> 
> Now that the prerequisite patch is in master, I can pick the btrfs
> specific part. Thanks.

Thank you for this.

Regards,
Phil
