Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31D1C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 12:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0112082C
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 12:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbfCEMZx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 07:25:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:38352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728027AbfCEMZx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 07:25:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33585AE3D
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Mar 2019 12:25:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5EF03DA7F5; Tue,  5 Mar 2019 13:27:10 +0100 (CET)
Date:   Tue, 5 Mar 2019 13:27:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: gitignore: Ignore hidden files
Message-ID: <20190305122709.GV31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190228022206.16356-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228022206.16356-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 28, 2019 at 10:22:06AM +0800, Qu Wenruo wrote:
> A lot of editor/IDE related config files are dotfiles, like .vimrc
> or .clang_complete.
> 
> Instead of adding gitignore entry for each editor/IDE, just ignore all
> dotfiles.

Fortunatelly it still works for tracked dotfiles like .travis.yml and
.gitignore itself.
