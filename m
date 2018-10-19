Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F408DECDE43
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 14:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA2D9204EC
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 14:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA2D9204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbeJSWZR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 18:25:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:42782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727439AbeJSWZR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 18:25:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 601CFAF65
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2018 14:18:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A64D3DAF50; Fri, 19 Oct 2018 16:18:48 +0200 (CEST)
Date:   Fri, 19 Oct 2018 16:18:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] FSID change kernel support
Message-ID: <20181019141847.GI16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1539270206-27005-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539270206-27005-1-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 06:03:20PM +0300, Nikolay Borisov wrote:
> Here is the second posting of the fsid change support for the kernel. For 
> background information you can refer to v1 [0]. The main changes in this version
> are around the handling of possible split-brain scenarios. I've changed a bit 
> how the userspace code works and now the process is split among 2 transactions. 
> The first one flagging "we are about to change fsid" and once it's persisted on
> all disks a second one does the actual change. This of course is not enough 
> to guarantee full consistency so I had to extend the device scanning to 
> gracefully handle such cases. I believe I have covered everything but more 
> review will be appreciated. 

All the cases seem to be covered. Do you intend to add the design
document somewhere? The references in the code seem stale and puzzling.

> So patch 1 implements the basic functionality with no split-brain handling 
> whatsoever. Patch 2 is a minor cleanup. Patch 3 deals with a split-brain that 
> can occur if power loss happens during the initial transaction (the one setting
> the beginning flag). Patch 4 adds some information that is needed in the last 2 
> patches. Patch 5 handles failure between transaction 1 and transaction 2 and 
> finally patch 6 handles the case of power loss during transaction 1 but for an 
> fs which has already undergone at least one successful fsid change. More 
> details about the exact failure modes are in each respective patch.
> 
> One thing which could be improved but I ran out of ideas is the naming of the 
> ancillary functions - find_fsid_inprogress and find_fsid_changed. 

Hm, no better ideas so it can stay and be changed later.

> I've actually tested the split-brain handing code with specially crafted images. 
> They will be part of the user-space submissions and I believe I have full 
> coverage for that. 

Perfect, thanks.

Now the bad news from me :) There are several coding style and style
issues all over the patches so I'll list them here.

* BTRFS_SUPER_FLAG_CHANGING_FSID_v2 -- V2 with uppercase V, as other
  versioned symbols

* all references in changelogs or comments should refer to the super flag
  as CHANGING_FSID_v2, not FSID_CHANGING, not just CHANGING_FSID, nor
  FSID_CHANGE. This is because we want to be able to search for it and
  find all occurences

* error messages should stick to the preferred format,
  https://btrfs.wiki.kernel.org/index.php/Development_notes#Error_messages

* comments referring to UUID should use "UUID", there's a mixt of
  both ways added by the patches, error messages should use the
  uppercase form too

* find_fsid - type and name should be on one line, parameters on the
  next if they don't fit

* device_list_add - missing space before =

As these are not functional problems, I'll add the patchset to for-next
for testing.
