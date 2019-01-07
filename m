Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEF1C43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 17:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D3E2087F
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 17:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbfAGR2u (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 12:28:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:39028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727223AbfAGR2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 12:28:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2812ADC7;
        Mon,  7 Jan 2019 17:28:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 37A8FDA7E8; Mon,  7 Jan 2019 18:28:17 +0100 (CET)
Date:   Mon, 7 Jan 2019 18:28:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14] Add cli and ioctl to forget scanned device(s)
Message-ID: <20190107172816.GX23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 04, 2019 at 01:31:51PM +0800, Anand Jain wrote:
> Adds cli and ioctl to forget a scanned device or forget all stale
> devices in the kernel.

I've read my comments to previous postings and I suggested to add more
ways how to specify the device, eg. by uuid or fsid:devid. Have you
considered that?
