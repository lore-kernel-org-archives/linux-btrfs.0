Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80B3C46475
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2A052081D
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:52:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2A052081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbeKFCM3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 21:12:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:56016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729545AbeKFCM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 21:12:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 27984B092;
        Mon,  5 Nov 2018 16:51:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B9B93DAF91; Mon,  5 Nov 2018 17:51:39 +0100 (CET)
Date:   Mon, 5 Nov 2018 17:51:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Qu Wenruo <wqu@suse.de>, Chris Mason <clm@fb.com>,
        David Sterba <DSterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Gu Jinxiang <gujx@cn.fujitsu.com>,
        Changbin Du <changbin.du@gmail.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
Message-ID: <20181105165137.GD9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Arnd Bergmann <arnd@arndb.de>,
        Qu Wenruo <wqu@suse.de>, Chris Mason <clm@fb.com>,
        David Sterba <DSterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Gu Jinxiang <gujx@cn.fujitsu.com>,
        Changbin Du <changbin.du@gmail.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181103153941.1881966-1-arnd@arndb.de>
 <87d4e8ce-2142-9d6e-498a-c7e5b83964eb@suse.de>
 <CAK8P3a27sNTiKV--smXd1wUzkGY70uUhS1rif6tgUobE+YYcbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a27sNTiKV--smXd1wUzkGY70uUhS1rif6tgUobE+YYcbw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Nov 04, 2018 at 11:32:03PM +0100, Arnd Bergmann wrote:
> >> Cc: Changbin Du <changbin.du@gmail.com>
> >> Fixes: 943b8435c3bd ("kernel hacking: add a config option to disable
> >> compiler auto-inlining")
> >
> > I can't find it in the mainline kernel, is the commit hash correct?
> > If not merged, we should still has a chance to further polish that patch.
> 
> It's in linux-next.

I can't find it in current linux-next either, the final reference in
Fixes: must refer to a commit in Linus' tree.

You can take this fix with the patch that introduces the config option
(ack for that) in case merging through the btrfs tree would be too late
for it (ie. no common base for the git trees containg the new code and fix).

Or I can take it through btrfs tree in 4.20-rc cycle. In both cases the
Fixes: does not need to be there.
