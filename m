Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3E6C169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 15:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35ABB21852
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 15:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfA2PWH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 10:22:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:55022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725730AbfA2PWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 10:22:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C706B0EF;
        Tue, 29 Jan 2019 15:22:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 622E7DA78C; Tue, 29 Jan 2019 16:21:28 +0100 (CET)
Date:   Tue, 29 Jan 2019 16:21:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: relocation: fix unused variable
Message-ID: <20190129152127.GN2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anders Roxell <anders.roxell@linaro.org>,
        clm@fb.com, josef@toxicpanda.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190129130146.11934-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190129130146.11934-1-anders.roxell@linaro.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 29, 2019 at 02:01:46PM +0100, Anders Roxell wrote:
> When CONFIG_BRTFS_ASSERT isn't enabled, variable root_objectid isn't used.
> 
> fs/btrfs/relocation.c: In function ‘insert_dirty_subv’:
> fs/btrfs/relocation.c:2138:6: warning: unused variable ‘root_objectid’ [-Wunused-variable]
>   u64 root_objectid = root->root_key.objectid;
>       ^~~~~~~~~~~~~
> 
> Reworked by adding a runtime check in the assfail function instead of
> the '#ifdef CONFIG_BTRFS_ASSERT #else ...", so the compiler sees the
> condition being passed into an inline function after preprocessing.

I've fixed the warning by avoiding the local variable but I like your
fix in general, thanks.
