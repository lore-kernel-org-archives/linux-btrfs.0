Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3214C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6EEA20661
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 17:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfCGRyg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 12:54:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:49000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726217AbfCGRyf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 12:54:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2EEFFAC3F;
        Thu,  7 Mar 2019 17:54:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DD52BDA83C; Thu,  7 Mar 2019 18:55:50 +0100 (CET)
Date:   Thu, 7 Mar 2019 18:55:50 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] btrfs: Turn an 'else if' into an 'else' in
 btrfs_uuid_tree_add
Message-ID: <20190307175550.GO31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Nathan Chancellor <natechancellor@gmail.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>
References: <20190307163515.2168-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307163515.2168-1-natechancellor@gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 07, 2019 at 09:35:15AM -0700, Nathan Chancellor wrote:
> When building with -Wsometimes-uninitialized, Clang warns:
> 
> fs/btrfs/uuid-tree.c:129:13: warning: variable 'eb' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
> fs/btrfs/uuid-tree.c:129:13: warning: variable 'offset' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
> 
> Clang can't tell that all cases are covered with this final else if.

The chain of conditions is

if (ret >= 0)
else if (ret == -EEXIST)
else if (ret < 0)

I'd think that compiler should be able to somehow represent the coverage
of the ranges and report if it's not complete and leading to some
uninitialized variables.

What if the last condition is 'ret < -EINVAL' obscuring the numerical
value, it'd be easy to miss that there are 20 unhandled values. In such
case the final 'else' would be the right thing to do.

Anyway, I'll apply the patch because it makes the code easier to follow.
Thanks.
