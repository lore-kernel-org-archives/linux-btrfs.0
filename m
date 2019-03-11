Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D57C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 14:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1BE020657
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 14:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfCKOkC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:40:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:32814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726605AbfCKOkB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 10:40:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B107EADD3;
        Mon, 11 Mar 2019 14:40:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D8A75DA8D5; Mon, 11 Mar 2019 15:41:16 +0100 (CET)
Date:   Mon, 11 Mar 2019 15:41:16 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 0/9] Misc props.c cleanups
Message-ID: <20190311144116.GW31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
 <20190308150111.GT31119@twin.jikos.cz>
 <4008f7b2-c590-78c8-3004-0b635a5af688@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4008f7b2-c590-78c8-3004-0b635a5af688@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 09, 2019 at 08:04:14AM +0800, Anand Jain wrote:
> On 3/8/19 11:01 PM, David Sterba wrote:
> > On Fri, Mar 01, 2019 at 12:34:46PM +0800, Anand Jain wrote:
> >> v5: drops patch
> >>      [PATCH v4 03/10] btrfs: trivial, fix c coding style
> >>      Chanegs are mainly to use BUG_ON instead of ASSERT as in the
> >>       original code in patches 5-7/9. Fix ASSERT in 8/9. And add
> >>       a rename in 9/9. Each individual patches as the details of
> >>       the changes.
> > 
> > The cleanup makes it easier to follow and the transaction semantics is
> > more visible, good.
> > 
> > I've fixed up the small things commented under the patches, no need to
> > resend. Patchset added to 5.2 queue, thanks.
> > 
> 
> Thanks for the feedback, review and integration.
> 
> Just checked these branches scrub-misc, misc-next, for-next-20190307
> any idea which branch these patches went to.

It's in a local topic branch and will appear in for-next once the merge
window is over. I've pushed it out now as ext/anand/cleanup-props-v5 so
you can have a look.
