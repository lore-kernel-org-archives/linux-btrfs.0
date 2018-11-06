Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9010C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 15:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A19C20685
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 15:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A19C20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbeKGA37 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 19:29:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:50084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730508AbeKGA37 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 19:29:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 162E3B63E;
        Tue,  6 Nov 2018 15:04:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DB493DAE2D; Tue,  6 Nov 2018 16:04:03 +0100 (CET)
Date:   Tue, 6 Nov 2018 16:04:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.de>, Chris Mason <clm@fb.com>,
        David Sterba <DSterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Gu Jinxiang <gujx@cn.fujitsu.com>,
        Changbin Du <changbin.du@gmail.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
Message-ID: <20181106150402.GD24115@twin.jikos.cz>
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
 <20181105165137.GD9136@twin.jikos.cz>
 <CAK8P3a3QQY3EqcdpogDR0TzPg61=y24aCYRpWWZGLe15GGPvdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3QQY3EqcdpogDR0TzPg61=y24aCYRpWWZGLe15GGPvdA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 05, 2018 at 10:27:03PM +0100, Arnd Bergmann wrote:
> On 11/5/18, David Sterba <dsterba@suse.cz> wrote:
> > On Sun, Nov 04, 2018 at 11:32:03PM +0100, Arnd Bergmann wrote:
> >> >> Cc: Changbin Du <changbin.du@gmail.com>
> >> >> Fixes: 943b8435c3bd ("kernel hacking: add a config option to disable
> >> >> compiler auto-inlining")
> >> >
> >> > I can't find it in the mainline kernel, is the commit hash correct?
> >> > If not merged, we should still has a chance to further polish that
> >> > patch.
> >>
> >> It's in linux-next.
> >
> > I can't find it in current linux-next either, the final reference in
> > Fixes: must refer to a commit in Linus' tree.
> 
> Ah, right, it got rebased. The commit ID in today's linux-next
> is 917fad29febd. Most trees in linux-next don't rebase so this
> would not be an issue, but you are right that this one clearly
> did, so the line is wrong here.
> 
> The commit is now delayed until 4.21 I assume.
> 
> > You can take this fix with the patch that introduces the config option
> > (ack for that) in case merging through the btrfs tree would be too late
> > for it (ie. no common base for the git trees containg the new code and
> > fix).
> >
> > Or I can take it through btrfs tree in 4.20-rc cycle. In both cases the
> > Fixes: does not need to be there.
> 
> Please take it through the btrfs tree. Let me know if you need me
> to extend the changelog to explain that situation better.

Ok, I'll add it to my tree, the changelog is good, thanks.
