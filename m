Return-Path: <SRS0=w/3l=65=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91133C433DF
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 May 2020 19:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 723DB20727
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 May 2020 19:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgEOT7w (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 May 2020 15:59:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:46624 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOT7w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 May 2020 15:59:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 431A7B033;
        Fri, 15 May 2020 19:59:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 12692DA732; Fri, 15 May 2020 21:58:58 +0200 (CEST)
Date:   Fri, 15 May 2020 21:58:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 rebased 0/5] readmirror feature (sysfs and in-memory
 only approach; with new read_policy device)
Message-ID: <20200515195858.GS18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <1586173871-5559-1-git-send-email-anand.jain@oracle.com>
 <a963d6c8-f0ec-7d41-ff0a-26d3ef9d013d@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a963d6c8-f0ec-7d41-ff0a-26d3ef9d013d@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 30, 2020 at 05:02:27PM +0800, Anand Jain wrote:
>   I am not sure if this will be integrated in 5.8 and worth the time to
>   rebase. Kindly suggest.

The preparatory work is ok, but the actual mirror selection policy
addresses a usecase that I think is not the one most users are
interested in. Devices of vastly different performance capabilities like
rotational disks vs nvme vs ssd vs network block devices in one
filesystem are not something commonly found.

What we really need is a saner balancing mechanism than pid-based, that
is also going to be used any time there are more devices from the same
speed class for the fast devices too.

So, no the patchset is not on track for a merge without the improved
default balancing. The preferred device for reads can be one of the
policies, I understand the usecase and have not problem with that
although wouldn't probably have use for it.
