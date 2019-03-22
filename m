Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E35EC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 17:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F3EB2190A
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 17:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfCVRF6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 13:05:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:20937 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbfCVRF6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 13:05:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 10:05:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="329774387"
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.86])
  by fmsmga006.fm.intel.com with ESMTP; 22 Mar 2019 10:05:52 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1h7Nc7-0004wO-0W; Fri, 22 Mar 2019 19:05:51 +0200
Date:   Fri, 22 Mar 2019 19:05:50 +0200
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
Message-ID: <20190322170550.GX9224@smile.fi.intel.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
 <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 22, 2019 at 03:53:50PM +0200, Sakari Ailus wrote:

> Porting a patch
> forward should have no issues either as checkpatch.pl has been complaining
> of the use of %pf and %pF for a while now.

And that's exactly the reason why I think instead of removing warning on
checkpatch, it makes sense to convert to an error for a while. People are
tending read documentation on internet and thus might have outdated one. And
yes, the compiler doesn't tell a thing about it.

P.S. Though, if majority of people will tell that I'm wrong, then it's okay to
remove.

-- 
With Best Regards,
Andy Shevchenko


