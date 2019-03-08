Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E4AC43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 14:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4082520868
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 14:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfCHO75 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:59:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:50690 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbfCHO75 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Mar 2019 09:59:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1207DAFFA;
        Fri,  8 Mar 2019 14:59:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7E563DA93A; Fri,  8 Mar 2019 16:01:12 +0100 (CET)
Date:   Fri, 8 Mar 2019 16:01:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 0/9] Misc props.c cleanups
Message-ID: <20190308150111.GT31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 01, 2019 at 12:34:46PM +0800, Anand Jain wrote:
> v5: drops patch
>     [PATCH v4 03/10] btrfs: trivial, fix c coding style
>     Chanegs are mainly to use BUG_ON instead of ASSERT as in the 
>      original code in patches 5-7/9. Fix ASSERT in 8/9. And add
>      a rename in 9/9. Each individual patches as the details of
>      the changes.

The cleanup makes it easier to follow and the transaction semantics is
more visible, good.

I've fixed up the small things commented under the patches, no need to
resend. Patchset added to 5.2 queue, thanks.
