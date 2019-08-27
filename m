Return-Path: <SRS0=Pg1I=WX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB1BC3A5A3
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC9C7206BF
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Aug 2019 12:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbfH0Mpw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:45:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:34112 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfH0Mpw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Aug 2019 08:45:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7C3DAEC4;
        Tue, 27 Aug 2019 12:45:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6BA8EDA809; Tue, 27 Aug 2019 14:46:13 +0200 (CEST)
Date:   Tue, 27 Aug 2019 14:46:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs wiki, add Parrot as production user
Message-ID: <20190827124611.GG2752@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRtJ5LjO4vseJCP1zANF7dbjDtcsnoTTNs5YAmHt=NWRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtRtJ5LjO4vseJCP1zANF7dbjDtcsnoTTNs5YAmHt=NWRw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 26, 2019 at 06:55:47PM -0600, Chris Murphy wrote:
> https://blog.parrotlinux.org/parrot-4-4-release-notes/
> 
> Looks like they switched to Btrfs by default for / and /home.
> 
> I think they should be listed on
> https://btrfs.wiki.kernel.org/index.php/Production_Users

Added, thanks for the tip.
