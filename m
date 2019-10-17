Return-Path: <SRS0=AqV7=YK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7018BECE58E
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 15:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E0D021835
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 15:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395161AbfJQPx0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 11:53:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:33334 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731326AbfJQPx0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Oct 2019 11:53:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C81EFB6EA;
        Thu, 17 Oct 2019 15:53:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 11307DA808; Thu, 17 Oct 2019 17:53:34 +0200 (CEST)
Date:   Thu, 17 Oct 2019 17:53:33 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH RESEND] btrfs-progs: btrfstune -M|m drop test_uuid_unique
Message-ID: <20191017155332.GK2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <20191010075352.8352-1-anand.jain@oracle.com>
 <51f0c05b-4c12-d835-5615-f8a0cd063508@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f0c05b-4c12-d835-5615-f8a0cd063508@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 17, 2019 at 09:03:00AM +0800, Anand Jain wrote:
> Ping (4th time).

Anand, the patch queue is big and ever growing, pinging can help to
bring back the attention but for patches that have disgreements or
unclear reasoning the turnaround time can be longer.

Specifically, patches that have impact on usability extra care must be
taken not to cause chaos by seemingly "simple" change.

> IMO this patch is good integrate.

I'll reply under the previous submission as there is the discussion in
progress.
