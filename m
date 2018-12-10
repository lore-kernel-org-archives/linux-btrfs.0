Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35097C04EB8
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00F4F2081F
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 17:03:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00F4F2081F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbeLJRD0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 12:03:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:51254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726261AbeLJRD0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 12:03:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2D43AB00B;
        Mon, 10 Dec 2018 17:03:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6B1FFDAB58; Mon, 10 Dec 2018 18:03:02 +0100 (CET)
Date:   Mon, 10 Dec 2018 18:03:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.de>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] btrfs: delayed-ref: Introduce better documented
 delayed ref structures
Message-ID: <20181210170301.GJ23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.de>,
        Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <20181206065903.11343-1-wqu@suse.com>
 <20181206065903.11343-2-wqu@suse.com>
 <235ca34f-bcda-128d-dc3d-7465766271c7@suse.com>
 <fc949474-f177-0d8c-2773-8112ff06c3c4@gmx.com>
 <69bbbc9a-9288-d868-ddfa-21a5b6b605d0@suse.com>
 <e53c14bb-bc73-9091-79fc-4112c40de3a1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e53c14bb-bc73-9091-79fc-4112c40de3a1@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 10, 2018 at 07:37:57PM +0800, Qu Wenruo wrote:
> >>> Also please use explicit bool type:
> >>>
> >>> bool xxxx:1
> >>
> >> Is this valid? Haven't seen such usage in kernel code IIRC.
> > 
> > git grep 'bool .*:1' | wc -l
> > 417
> 
> grep -IR 'bool .*:1' fs/btrfs/ | wc -l
> 0
> 
> So I guess another cleanup?

No bool bitfields unless there's a space saved in the structure, please.
If there are less than 4 bool types in a structure, it's same as 4 bits
in u32 and is ok. The bit manipulation needs more instructions, checking
zero/non-zero of a byte is typically cheaper.

Looking at the structure, the 'int action' can be reduced and the hole
to the next u64 has enough bytes to squeeze a number of bools if needed.
