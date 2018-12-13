Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F77EC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:37:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C6B620851
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:37:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C6B620851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbeLMQhW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 11:37:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:39410 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727579AbeLMQhV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 11:37:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 58282AC85;
        Thu, 13 Dec 2018 16:37:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9CAA2DA7EE; Thu, 13 Dec 2018 17:36:58 +0100 (CET)
Date:   Thu, 13 Dec 2018 17:36:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 04/10] btrfs: only track ref_heads in delayed_ref_updates
Message-ID: <20181213163658.GG23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-5-josef@toxicpanda.com>
 <56dc2fa0-7b5d-fcad-1ab7-daadacb9d902@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56dc2fa0-7b5d-fcad-1ab7-daadacb9d902@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 07, 2018 at 03:01:45PM +0200, Nikolay Borisov wrote:
> 
> 
> On 3.12.18 г. 17:20 ч., Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > We use this number to figure out how many delayed refs to run, but
> > __btrfs_run_delayed_refs really only checks every time we need a new
> > delayed ref head, so we always run at least one ref head completely no
> > matter what the number of items on it.  Fix the accounting to only be
> > adjusted when we add/remove a ref head.
> 
> David,
> 
> I think also warrants a forward looking sentence stating that the number
> is also going to be used to calculate the required number of bytes in
> the delayed refs rsv. Something along the lines of:
> 
> In addition to using this number to limit the number of delayed refs
> run, a future patch is also going to use it to calculate the amount of
> space required for delayed refs space reservation.

Added to the changelog, thanks.
