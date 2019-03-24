Return-Path: <SRS0=p5gK=R3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1404C10F00
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 21:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1E1D20811
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 21:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfCXVTl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Mar 2019 17:19:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:61922 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfCXVTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Mar 2019 17:19:41 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Mar 2019 14:19:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="129807518"
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.86])
  by orsmga006.jf.intel.com with ESMTP; 24 Mar 2019 14:19:34 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1h8AWi-0006Gz-Fh; Sun, 24 Mar 2019 23:19:32 +0200
Date:   Sun, 24 Mar 2019 23:19:32 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Petr Mladek <pmladek@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        linux-um@lists.infradead.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-block@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        xen-devel@lists.xenproject.org,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Message-ID: <20190324211932.GK9224@smile.fi.intel.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
 <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
 <20190322170550.GX9224@smile.fi.intel.com>
 <20190324211008.lypghym3gqcp62th@mara.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190324211008.lypghym3gqcp62th@mara.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Mar 24, 2019 at 11:10:08PM +0200, Sakari Ailus wrote:
> On Fri, Mar 22, 2019 at 07:05:50PM +0200, Andy Shevchenko wrote:
> > On Fri, Mar 22, 2019 at 03:53:50PM +0200, Sakari Ailus wrote:
> > 
> > > Porting a patch
> > > forward should have no issues either as checkpatch.pl has been complaining
> > > of the use of %pf and %pF for a while now.
> > 
> > And that's exactly the reason why I think instead of removing warning on
> > checkpatch, it makes sense to convert to an error for a while. People are
> > tending read documentation on internet and thus might have outdated one. And
> > yes, the compiler doesn't tell a thing about it.
> > 
> > P.S. Though, if majority of people will tell that I'm wrong, then it's okay to
> > remove.
> 
> I wonder if you wrote this before seeing my other patchset.

Yes, I wrote it before seeing another series.

> What I think could be done is to warn of plain %pf (without following "w")
> in checkpatch.pl, and %pf that is not followed by "w" in the kernel.
> Although we didn't have such checks to begin with. The case is still a
> little bit different as %pf used to be a valid conversion specifier whereas
> %pO likely has never existed.
> 
> So, how about adding such checks in the other set? I can retain %p[fF] check
> here, too, if you like.

Consistency tells me that the warning->error transformation in checkpatch.pl
belongs this series.


-- 
With Best Regards,
Andy Shevchenko


