Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F47BC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 13:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C81223CB
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 13:46:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57C81223CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732964AbeKMXoO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 18:44:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:36560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732767AbeKMXoO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 18:44:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 396A7B13A;
        Tue, 13 Nov 2018 13:46:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C5EC9DAD3E; Tue, 13 Nov 2018 14:45:45 +0100 (CET)
Date:   Tue, 13 Nov 2018 14:45:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v15.1 00/13] Btrfs In-band De-duplication
Message-ID: <20181113134545.GY24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 06, 2018 at 02:41:09PM +0800, Lu Fengqi wrote:
> This patchset can be fetched from github:
> https://github.com/littleroad/linux.git dedupe_latest
> 
> Now the new base is v4.20-rc1.

Before anybody spends more time with this patchset: this is a big
feature and quite intrusive to several btrfs subsystems. Currently it's
on hold as it requires finishing the design phase, it's still only the
in-memory backend and before we claim in-band dedupe, the persistent
hash tree needs to be at least drafted or prototyped.

At this point there are several features that are in a more complete
state so they get preferred when it comes to merging. I would have to
look up what was agreed long time ago as merging plan, but at this point
this series would require a lot of work.
