Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3A6C43461
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Apr 2021 13:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D23661476
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Apr 2021 13:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhD3Nqf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 09:46:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:40858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhD3Nqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Apr 2021 09:46:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2355AF19;
        Fri, 30 Apr 2021 13:45:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3FB7DDA838; Fri, 30 Apr 2021 15:43:22 +0200 (CEST)
Date:   Fri, 30 Apr 2021 15:43:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-btrfs@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: Supporting idmapped mounts
Message-ID: <20210430134322.GD7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-btrfs@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>
References: <20210430132517.ef7gvr7e5n5wdn33@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430132517.ef7gvr7e5n5wdn33@wittgenstein>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 30, 2021 at 03:25:17PM +0200, Christian Brauner wrote:
> Hey everyone,
> 
> Userspace seems to already be catching up with idmapped mount support.
> Systemd has started making use of it in their container manager and is
> in the process of expanding useage throughout their codebase (cf. [1]).
> One of the first requests obviously was "When can we get btrfs"? So I
> was thinking about starting to work on patches for btrfs to support
> them. Would you be interested in this if we implement it?

Yes of course, for feature parity.

> I'm preparing
> the necessary vfs changes currently. I already added a comprehensive
> generic test-suite to xfstests which would then also cover btrfs as
> well.

Great, thanks.  Does it needs vfs changes or is it just updating the
btrfs callbacks to pass the right namespace?
