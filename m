Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93050C10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 21:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 663AC2084F
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 21:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfDHVsL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 17:48:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:46398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbfDHVsK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 17:48:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A611AAEB2;
        Mon,  8 Apr 2019 21:48:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 36F62DA88B; Mon,  8 Apr 2019 23:49:17 +0200 (CEST)
Date:   Mon, 8 Apr 2019 23:49:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH] btrfs: tree-checker: Don't check device size as we can
 have valid 0 total_bytes
Message-ID: <20190408214917.GC29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190408042756.25969-1-wqu@suse.com>
 <c14dc283-69ef-8ef2-e314-8e144ecfd3fe@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c14dc283-69ef-8ef2-e314-8e144ecfd3fe@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 08, 2019 at 12:34:48PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/8 下午12:27, Qu Wenruo wrote:
> > Under the following call traces, btrfs can commit device with 0
> > total_bytes onto disk:
> > btrfs_rm_device()
> > |- btrfs_shrink_device()
> > |  |- btrfs_device_set_total_bytes(device, 0)
> > |  |- btrfs_update_device()
> > |  |- btrfs_commit_transaction() #1
> > |- btrfs_rm_dev_item()
> > 
> > This will trigger write time tree checker warning.
> > And further more, this can create valid btrfs with device->total_bytes
> > == 0 and triggering read time tree-checker if power loss happens after
> > above transaction #1 but before next transaction.
> > 
> > So this dev item check is too restrict.
> > 
> > Please fold this patch into commit 87d87c6dcbbe ("btrfs: tree-checker:
> > Verify dev item") in misc-next branch.
> > 
> > The fuzzed image can be already addressed by commit 1b3922a8bc74
> > ("btrfs: Use real device structure to verify dev extent") thus we don't
> > need that strict check anymore.
> 
> Just a kind reminder, folding the patch will be much easier than my
> original purpose to discard that patch completely.

Agreed and patch folded, thanks.
