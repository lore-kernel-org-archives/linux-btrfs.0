Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B99C10F03
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 14:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E60CD218E2
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 14:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfCVO3R (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:29:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:45994 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727719AbfCVO3R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 10:29:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 434CCADBE;
        Fri, 22 Mar 2019 14:29:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7D8A7DA8A5; Fri, 22 Mar 2019 15:30:28 +0100 (CET)
Date:   Fri, 22 Mar 2019 15:30:28 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        ceph-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] treewide: Switch printk users from %pf and %pF to
 %ps and %pS, respectively
Message-ID: <20190322143028.GD28481@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <20190322132108.25501-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322132108.25501-2-sakari.ailus@linux.intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 22, 2019 at 03:21:07PM +0200, Sakari Ailus wrote:
> %pF and %pf are functionally equivalent to %pS and %ps conversion
> specifiers. The former are deprecated, therefore switch the current users
> to use the preferred variant.
> 
> The changes have been produced by the following command:
> 
> 	git grep -l '%p[fF]' | grep -v '^\(tools\|Documentation\)/' | \
> 	while read i; do perl -i -pe 's/%pf/%ps/g; s/%pF/%pS/g;' $i; done
> 
> And verifying the result.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---

For 

>  fs/btrfs/tests/free-space-tree-tests.c  |  4 ++--
>  include/trace/events/btrfs.h            |  2 +-

Acked-by: David Sterba <dsterba@suse.com>
