Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BF4C004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BD96207DD
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 15:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BD96207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbeJXX6d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 19:58:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:45254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726414AbeJXX6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 19:58:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2BA30AEBB;
        Wed, 24 Oct 2018 15:29:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9DC86DABAA; Wed, 24 Oct 2018 17:28:59 +0200 (CEST)
Date:   Wed, 24 Oct 2018 17:28:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: Add the testcase for subvolume name
 length limit test
Message-ID: <20181024152859.GV16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180918084448.14195-1-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918084448.14195-1-suyj.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Sep 18, 2018 at 04:44:48PM +0800, Su Yanjun wrote:
> Total of three conditions are tested. One for short name, one with
> name length 255, the last one with more than 255.
> 
> This case should pass after commit
> 'btrfs-progs: change filename limit to 255 when creating subvolume'.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>

Applied, with some adjustments, thanks.
