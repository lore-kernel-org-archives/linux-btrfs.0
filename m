Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759DEC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32EE52085A
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:29:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32EE52085A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387467AbeKFBtb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:49:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:51824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729652AbeKFBtb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 20:49:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A2955B073;
        Mon,  5 Nov 2018 16:29:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E1570DAF91; Mon,  5 Nov 2018 17:28:49 +0100 (CET)
Date:   Mon, 5 Nov 2018 17:28:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding
 free extent
Message-ID: <20181105162849.GA9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
References: <20181022090946.1150-1-fdmanana@kernel.org>
 <20181024091303.20324-1-fdmanana@kernel.org>
 <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local>
 <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
 <20181024123959.icp7ssu5sjhqg6c3@MacBook-Pro-91.local>
 <CAL3q7H7dZm8s2Ey185Xw=bsjG6fZBeEWjQu+He2kQ5JYMPCHWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7dZm8s2Ey185Xw=bsjG6fZBeEWjQu+He2kQ5JYMPCHWg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 01:48:40PM +0100, Filipe Manana wrote:
> > Ah ok makes sense.  Well in that case lets just make btrfs_read_locked_inode()
> > take a path, and allocate it in btrfs_iget, that'll remove the ugly
> >
> > if (path != in_path)
> 
> You mean the following on top of v4:
> 
> https://friendpaste.com/6XrGXb5p0RSJGixUFYouHg
> 
> Not much different, just saves one such if statement. I'm ok with that.

Now in misc-next with v4 and the friendpaste incremental as

https://github.com/kdave/btrfs-devel/commit/efcfd6c87d28b3aa9bcba52d7c1e1fc79a2dad69
