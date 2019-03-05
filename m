Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82FBC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 13:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DC3B206DD
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 13:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfCENfp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:35:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:48888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727325AbfCENfo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 08:35:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4857AB42;
        Tue,  5 Mar 2019 13:35:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EC898DA851; Tue,  5 Mar 2019 14:37:01 +0100 (CET)
Date:   Tue, 5 Mar 2019 14:37:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: gitignore: Ignore hidden files
Message-ID: <20190305133701.GZ31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190228022206.16356-1-wqu@suse.com>
 <20190305122709.GV31119@twin.jikos.cz>
 <b8d87129-e7a0-7375-1bc8-32e4076ed193@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8d87129-e7a0-7375-1bc8-32e4076ed193@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 05, 2019 at 08:35:39PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/3/5 下午8:27, David Sterba wrote:
> > On Thu, Feb 28, 2019 at 10:22:06AM +0800, Qu Wenruo wrote:
> >> A lot of editor/IDE related config files are dotfiles, like .vimrc
> >> or .clang_complete.
> >>
> >> Instead of adding gitignore entry for each editor/IDE, just ignore all
> >> dotfiles.
> > 
> > Fortunatelly it still works for tracked dotfiles like .travis.yml and
> > .gitignore itself.
> 
> Didn't notice .travis.yml, but indeed i should notice .gitignore.
> 
> Any idea what's the correct way to handle them?
> Just current .* or adding each possible dotfile?

I've left .* and tested that changes to .gitignore or .travis.yml are
recognized (diff, commit).
