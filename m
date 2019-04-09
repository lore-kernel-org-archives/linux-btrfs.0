Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1B4C10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 13:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB2842084F
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 13:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfDINC1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:02:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:52356 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726464AbfDINC1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 09:02:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 634F5ACC1;
        Tue,  9 Apr 2019 13:02:24 +0000 (UTC)
Date:   Tue, 9 Apr 2019 15:02:23 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
        ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        Anna-Maria Gleixner <anna-maria@linutronix.de>
Subject: Re: [PATCH v2 1/1] treewide: Switch printk users from %pf and %pF to
 %ps and %pS, respectively
Message-ID: <20190409130223.qylyzna7syu5cdc4@pathway.suse.cz>
References: <20190325193229.23390-1-sakari.ailus@linux.intel.com>
 <20190326133510.cylhvyvc7l77bqdg@pathway.suse.cz>
 <20190403112814.7frkxkwmitzugzmt@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403112814.7frkxkwmitzugzmt@paasikivi.fi.intel.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed 2019-04-03 14:28:14, Sakari Ailus wrote:
> Ping.
> 
> On Tue, Mar 26, 2019 at 02:35:10PM +0100, Petr Mladek wrote:
> > Linus,
> > 
> > On Mon 2019-03-25 21:32:28, Sakari Ailus wrote:
> > > %pF and %pf are functionally equivalent to %pS and %ps conversion
> > > specifiers. The former are deprecated, therefore switch the current users
> > > to use the preferred variant.
> > > 
> > > The changes have been produced by the following command:
> > > 
> > > 	git grep -l '%p[fF]' | grep -v '^\(tools\|Documentation\)/' | \
> > > 	while read i; do perl -i -pe 's/%pf/%ps/g; s/%pF/%pS/g;' $i; done
> > > 
> > > And verifying the result.
> > 
> > I guess that the best timing for such tree-wide clean up is the end
> > of the merge window. Should we wait for 5.2 or is it still acceptable
> > to push this for 5.1-rc3?
> 
> The patch still cleanly applies to linux-next as wells as Linus's tree.
> Some %pf bits have appeared and fixed since (include/trace/events/timer.h);
> the fix is in linux-next so once that and this patch are merged, there are
> no remaining %pf (or %pF) users left.

I have pushed the patch into printk.git, branch for-5.2-pf-removal.
It is v2 without the include/trace/events/timer.h stuff.

Best Regards,
Petr
