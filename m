Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FEFC433DB
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Mar 2021 15:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF0AC619C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Mar 2021 15:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhCWPxB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 11:53:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:35698 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232902AbhCWPwj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Mar 2021 11:52:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0A565AE37;
        Tue, 23 Mar 2021 15:52:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 04553DA7AE; Tue, 23 Mar 2021 16:50:32 +0100 (CET)
Date:   Tue, 23 Mar 2021 16:50:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Neal Gompa <ngompa@fedoraproject.org>
Cc:     linux-btrfs@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Sheng Mao <shngmao@gmail.com>
Subject: Re: [PATCH 0/1] btrfs-progs: libbtrfsutil: Relicense to LGPLv2.1+
Message-ID: <20210323155032.GH7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Neal Gompa <ngompa@fedoraproject.org>,
        linux-btrfs@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Sheng Mao <shngmao@gmail.com>
References: <20210317200144.1067314-1-ngompa@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317200144.1067314-1-ngompa@fedoraproject.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 17, 2021 at 04:01:43PM -0400, Neal Gompa wrote:
> This is a patch requesting all substantial copyright owners to sign off
> on changing the license of the libbtrfsutil code to LGPLv2.1+ in order
> to resolve various concerns around the mixture of code in btrfs-progs
> with libbtrfsutil.
> 
> Each significant (i.e. non-trivial) commit author has been CC'd to
> request their sign-off on this. Please reply to this to acknowledge
> whether or not this is acceptable for your code.

Thanks! I think we have acks for all non-trivial contirbutions. For the
record, the trivial one are:

* dbf60b488e3b ("libbtrfsutil: update btrfs_util_delete_subvolume docs")
  a comment update, clarifying usage

* 2e67bf0ed69d ("btrfs-progs: docs: fix typos in READMEs, INSTALL and * CHANGES")
* b1d39a42a4ef ("btrfs-progs: fix typos in comments")
  treewide comment typo fixes

* 01e35d9f53eb ("btrfs-progs: treewide: Fix missing declarations")
  code changes, but adding static or missing includes

* 9fd37f951be6 ("btrfs-progs: complete the implementation RAID1C34 definitions")
  copied definitions from kernel code

I'm not sure about the commit adding pkg-config spec file, it's not code
but it's beyond what I'd consider trivial. I've added Sheng Mao to CC,
please acknowledge the change.

* 4498fe1a2a7c ("libbtrfsutil: add pkg-config spec file")

I'll update the changelog with all the reasons for relicensing that have
been brought up.
