Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35786C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 030FD20660
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 030FD20660
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbeK2A1q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 19:27:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:42564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727823AbeK2A1q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 19:27:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1784AAC55;
        Wed, 28 Nov 2018 13:26:06 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A808ADAC7E; Wed, 28 Nov 2018 14:25:49 +0100 (CET)
Date:   Wed, 28 Nov 2018 14:25:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/9] Switch defines to enums
Message-ID: <20181128132549.GM2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1543348078.git.dsterba@suse.com>
 <45dcab9e-fb88-8980-90d9-1875ea1ee992@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45dcab9e-fb88-8980-90d9-1875ea1ee992@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 09:33:50AM +0800, Qu Wenruo wrote:
> On 2018/11/28 上午3:53, David Sterba wrote:
> > This is motivated by a merging mistake that happened a few releases ago.
> > Two patches updated BTRFS_FS_* flags independently to the same value,
> > git did not see any direct merge conflict. The two values got mixed at
> > runtime and caused crash.
> > 
> > Update all #define sequential values, the above merging problem would
> > not happen as there would be a conflict and the enum value
> > auto-increment would prevent duplicated values anyway.
> 
> Just one small question for the bitmap usage.
> 
> For enum we won't directly know the last number is, my concern is if
> we're using u16 as bitmap and there is some enum over 15, will we get a
> warning at compile time or some bug would just sneak into kernel?

Do you have a concrete example where this would happen? Most bits are
used in 'long' that should be at least 32. I'm not aware of 16bit bits
flags.
