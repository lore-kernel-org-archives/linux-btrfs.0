Return-Path: <SRS0=i4Ze=4J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC14C35646
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE113206EF
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgBUOvl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:51:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:35296 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727096AbgBUOvk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:51:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 562B3AD61;
        Fri, 21 Feb 2020 14:51:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A123CDA70E; Fri, 21 Feb 2020 15:51:21 +0100 (CET)
Date:   Fri, 21 Feb 2020 15:51:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RESEND PATCH v2 0/2] Refactor snapshot vs nocow writers locking
Message-ID: <20200221145120.GK2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200130125945.7383-1-nborisov@suse.com>
 <20200130125945.7383-4-nborisov@suse.com>
 <20200130142144.GU3929@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130142144.GU3929@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 30, 2020 at 03:21:44PM +0100, David Sterba wrote:
> Please add comments with the lock semantics overview and to all the
> public functions. Having more assertions would be also good, like the
> tree locks do. Thanks.

The patches started to conflict with others so I've removed it from
for-next until the updated version with comments arrives.
