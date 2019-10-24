Return-Path: <SRS0=miBu=YR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516D9CA9EAF
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F2852166E
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Oct 2019 15:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409718AbfJXPln (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 11:41:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:48212 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2409615AbfJXPln (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Oct 2019 11:41:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7DAB5AF6A;
        Thu, 24 Oct 2019 15:41:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C0E7CDA733; Thu, 24 Oct 2019 17:41:52 +0200 (CEST)
Date:   Thu, 24 Oct 2019 17:41:52 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] btrfs-progs: make quiet to overrule verbose
Message-ID: <20191024154151.GI3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20191024062825.13097-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024062825.13097-1-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 24, 2019 at 02:28:22PM +0800, Anand Jain wrote:
> When both the options (--quiet and --verbose) in btrfs send and receive
> is specified, we need at least one of it to overrule the other, irrespective
> of the chronological order of options.

I think the common behaviour is to respect the order of appearance on
the commandline. So 'command -vvv -q' will be the same as 'command -q',
while 'command -q -vvv' will be 'command -vvv'.

Eg. ssh behaves like that, OTOH rsync does not and -q beats -vvv. I
don't know about other commands that accept multiple -v and -q to get
more samples. The usage pattern where order on command line matters is
following the idea where there's a long line and adding -vvv to the end
will make it verbose.
