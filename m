Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECD5C10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 18:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C429206B7
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 18:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfDKSEZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 14:04:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:60358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726577AbfDKSEY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 14:04:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8800AC58;
        Thu, 11 Apr 2019 18:04:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E2CF3DA85B; Thu, 11 Apr 2019 20:05:31 +0200 (CEST)
Date:   Thu, 11 Apr 2019 20:05:30 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Is it a good idea to replace current eb leakage detector with
 bcc/ebpf based one?
Message-ID: <20190411180529.GC3476@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <d0a50191-4506-7e21-5be9-4a5940563904@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0a50191-4506-7e21-5be9-4a5940563904@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 10, 2019 at 02:34:10PM +0800, Qu Wenruo wrote:
> As we have memleak.py in bcc tools, and it provides better info
> including the calling stack, I'm wondering if we should replace current
> eb leakage check with bcc based one.

The built-in checks have the advantage that they're built in. So no
additional tools or frameworks are needed, either provided by distro or
downloaded and built. So for some low-level and crude sanity checks we
still want something that ships with the code and can be run as part of
normal development & testing loop.

Providing additional enhanced output is of course welcome, that's useful
when one is actually looking for a specific problem or gathering traces
for analysis.

So I think we want both, ie. no 'replace'.
