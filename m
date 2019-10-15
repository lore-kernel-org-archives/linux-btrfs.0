Return-Path: <SRS0=E4Z9=YI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328AFC10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 20:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 119E5217D6
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 20:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbfJOUQB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 16:16:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:37174 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727962AbfJOUQB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Oct 2019 16:16:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5334CAD05;
        Tue, 15 Oct 2019 20:15:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F0919DA7E3; Tue, 15 Oct 2019 22:16:09 +0200 (CEST)
Date:   Tue, 15 Oct 2019 22:16:09 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/34] btrfs: Use CONFIG_PREEMPTION
Message-ID: <20191015201609.GA2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20191015191821.11479-1-bigeasy@linutronix.de>
 <20191015191821.11479-25-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191015191821.11479-25-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 15, 2019 at 09:18:11PM +0200, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> CONFIG_PREEMPTION is selected by CONFIG_PREEMPT and by CONFIG_PREEMPT_RT.
> Both PREEMPT and PREEMPT_RT require the same functionality which today
> depends on CONFIG_PREEMPT.
> 
> Switch the btrfs_device_set_…() macro over to use CONFIG_PREEMPTION.
> 
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <josef@toxicpanda.com>
> Cc: David Sterba <dsterba@suse.com>

Acked-by: David Sterba <dsterba@suse.com>
