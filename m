Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AE3ECDE43
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 15:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1497120658
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 15:50:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1497120658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbeJSX53 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 19:57:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:59570 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727724AbeJSX53 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 19:57:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D78C4B012
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2018 15:50:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82D2EDAF50; Fri, 19 Oct 2018 17:50:40 +0200 (CEST)
Date:   Fri, 19 Oct 2018 17:50:39 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] FSID change kernel support
Message-ID: <20181019155039.GL16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1539270206-27005-1-git-send-email-nborisov@suse.com>
 <20181019141847.GI16290@twin.jikos.cz>
 <05980fc1-cdb1-b278-da4f-5a9f5b5c2a9a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05980fc1-cdb1-b278-da4f-5a9f5b5c2a9a@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 19, 2018 at 05:31:09PM +0300, Nikolay Borisov wrote:
> 
> 
> On 19.10.2018 17:18, David Sterba wrote:
> > On Thu, Oct 11, 2018 at 06:03:20PM +0300, Nikolay Borisov wrote:
> >> Here is the second posting of the fsid change support for the kernel. For 
> >> background information you can refer to v1 [0]. The main changes in this version
> >> are around the handling of possible split-brain scenarios. I've changed a bit 
> >> how the userspace code works and now the process is split among 2 transactions. 
> >> The first one flagging "we are about to change fsid" and once it's persisted on
> >> all disks a second one does the actual change. This of course is not enough 
> >> to guarantee full consistency so I had to extend the device scanning to 
> >> gracefully handle such cases. I believe I have covered everything but more 
> >> review will be appreciated. 
> > 
> > All the cases seem to be covered. Do you intend to add the design
> > document somewhere? The references in the code seem stale and puzzling.
> 
> I believe I have the critical portions of the design document (i.e the
> handling of various cases) described in each of the 3 patches that add
> split-brain handling. The doc could be added to the btrfs-dev-doc repo I
> guess.

Yeah, but what does 4/a mean in the comments? It's not referring to the
changelog where I'd look first. External documentation is fine but we
need some sort of reference in the code. The comments in 5/6 and 6/6 are
sufficient, just that the references could be more explicit. Possibly
the cases can be simplified and put into the .c as a bullet list.

The document is good for understanding, the nice-to-have part would be
some quick reference to check the logic. I'll give it another read to
see how much is really missing or not.
