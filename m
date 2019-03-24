Return-Path: <SRS0=p5gK=R3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C06B3C10F00
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 21:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97A10213F2
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 Mar 2019 21:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfCXVKT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 Mar 2019 17:10:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:10185 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfCXVKT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Mar 2019 17:10:19 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Mar 2019 14:10:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="331600917"
Received: from pnass-mobl.ger.corp.intel.com (HELO mara.localdomain) ([10.249.136.221])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2019 14:10:11 -0700
Received: from sailus by mara.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1h8ANd-0000IX-8x; Sun, 24 Mar 2019 23:10:09 +0200
Date:   Sun, 24 Mar 2019 23:10:08 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
Message-ID: <20190324211008.lypghym3gqcp62th@mara.localdomain>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
 <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
 <20190322170550.GX9224@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322170550.GX9224@smile.fi.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Andy,

On Fri, Mar 22, 2019 at 07:05:50PM +0200, Andy Shevchenko wrote:
> On Fri, Mar 22, 2019 at 03:53:50PM +0200, Sakari Ailus wrote:
> 
> > Porting a patch
> > forward should have no issues either as checkpatch.pl has been complaining
> > of the use of %pf and %pF for a while now.
> 
> And that's exactly the reason why I think instead of removing warning on
> checkpatch, it makes sense to convert to an error for a while. People are
> tending read documentation on internet and thus might have outdated one. And
> yes, the compiler doesn't tell a thing about it.
> 
> P.S. Though, if majority of people will tell that I'm wrong, then it's okay to
> remove.

I wonder if you wrote this before seeing my other patchset.

For others as the background, it adds %pfw to print fwnode node names.
Assuming this would be merged, %pfw could be in use relatively soon. With
the current patchset, %pf prints nothing just as %pO ("F" missing).

What I think could be done is to warn of plain %pf (without following "w")
in checkpatch.pl, and %pf that is not followed by "w" in the kernel.
Although we didn't have such checks to begin with. The case is still a
little bit different as %pf used to be a valid conversion specifier whereas
%pO likely has never existed.

So, how about adding such checks in the other set? I can retain %p[fF] check
here, too, if you like.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
