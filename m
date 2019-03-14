Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984C2C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 18:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 779DD20811
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 18:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfCNSXQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 14:23:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:53532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726936AbfCNSXQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 14:23:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0AA8FB083;
        Thu, 14 Mar 2019 18:23:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 75656DAA20; Thu, 14 Mar 2019 19:24:32 +0100 (CET)
Date:   Thu, 14 Mar 2019 19:24:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     David Howells <dhowells@redhat.com>
Cc:     viro@zeniv.linux.org.uk, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/38] vfs: Convert btrfs_test to fs_context
Message-ID: <20190314182432.GA3516@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Howells <dhowells@redhat.com>,
        viro@zeniv.linux.org.uk, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <155257972443.13720.11743171471060355965.stgit@warthog.procyon.org.uk>
 <155257986484.13720.17532595013012451617.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155257986484.13720.17532595013012451617.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 14, 2019 at 04:11:04PM +0000, David Howells wrote:
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Chris Mason <clm@fb.com>
> cc: Josef Bacik <josef@toxicpanda.com>
> cc: David Sterba <dsterba@suse.com>
> cc: linux-btrfs@vger.kernel.org

Acked-by: David Sterba <dsterba@suse.com>
