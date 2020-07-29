Return-Path: <SRS0=lAVn=BI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2816C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 10:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B432076E
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Jul 2020 10:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgG2KaS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Jul 2020 06:30:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:43030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgG2KaR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Jul 2020 06:30:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4D707B04C;
        Wed, 29 Jul 2020 10:30:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8DB01DA882; Wed, 29 Jul 2020 12:29:47 +0200 (CEST)
Date:   Wed, 29 Jul 2020 12:29:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     spaarder <spaarder@hotmail.nl>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: using btrfs subvolume as a write once read many medium
Message-ID: <20200729102947.GA3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, spaarder <spaarder@hotmail.nl>,
        linux-btrfs@vger.kernel.org
References: <VI1PR02MB58697B26A91E68507032D9CDAE700@VI1PR02MB5869.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR02MB58697B26A91E68507032D9CDAE700@VI1PR02MB5869.eurprd02.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 29, 2020 at 09:02:14AM +0200, spaarder wrote:
> Hello,
> 
> With all the ransomware attacks I am looking for a "write once read
> many" (WORM) solution, so that if an attacker manages to get root
> access on my backup server, it would be impossible for him to
> delete/encrypt my backups.
> 
> Using btrbk I already have readonly daily snapshots on my backupserver.
> Is there any way to password protect the changing of the properties of
> these subvolumes, so an attacker could not just simply set the RO
> property to false? Any support for a feature request?

I could dust off my old idea of so called 'sealed' subvolumes, that
would do something similar to that: it could start as a read-write
subvolume or read-only snapshot, switched back and forth rw/ro any
number of times but once it's set as 'sealed', no switching allowed
anymore. It could be snapshotted again or deleted.

For your usecase, the deletion would be still be a problem though and
protecting against root actions would need some countermeasures outside
of filesystem reach.
