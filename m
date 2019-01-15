Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E75BC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 459E320657
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 12:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfAOME3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:04:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:55084 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727410AbfAOME3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 07:04:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECF10ADF0;
        Tue, 15 Jan 2019 12:04:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 73CCDDA83D; Tue, 15 Jan 2019 13:03:59 +0100 (CET)
Date:   Tue, 15 Jan 2019 13:03:59 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Leonard Lausen <leonard@lausen.nl>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical corrupt leaf bad key order
Message-ID: <20190115120359.GG2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Leonard Lausen <leonard@lausen.nl>, linux-btrfs@vger.kernel.org
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 07:48:47PM +0800, Qu Wenruo wrote:
> Super nice move, it shows the corruption and the cause.
> 
> 	item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33
> 	item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 42
> 	item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33

The key order is the most frequent and also very reliable report of the
memory bitlips. I think we should add an unconditional check before a
leaf or node is written so we catch such errors before the bad data hit
the disk.

This seems to happen way too often, I believe the check overhead would
be acceptable and at least give early warning.
