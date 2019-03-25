Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C82C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C12420863
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfCYQec (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:34:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:44584 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729095AbfCYQe1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 12:34:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3CE0AC3C;
        Mon, 25 Mar 2019 16:34:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C2498DA825; Mon, 25 Mar 2019 17:35:38 +0100 (CET)
Date:   Mon, 25 Mar 2019 17:35:38 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix a NULL pointer dereference
Message-ID: <20190325163538.GK10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Kangjie Lu <kjlu@umn.edu>,
        pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190314075041.28966-1-kjlu@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190314075041.28966-1-kjlu@umn.edu>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 02:50:40AM -0500, Kangjie Lu wrote:
> btrfs_lookup_block_group may fail and return NULL. The fix goes
> to out when it fails to avoid NULL pointer dereference.

The subject, changelog and code change are not valid anymore after the
discussion. Please update them accordingly and resend. Thanks.
