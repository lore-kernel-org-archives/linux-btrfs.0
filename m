Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846ADC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 15:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5712F2083D
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 15:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbfCYPNN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 11:13:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:51572 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfCYPNN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 11:13:13 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Mar 2019 08:13:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,269,1549958400"; 
   d="scan'208";a="330511062"
Received: from ikahlonx-mobl.ger.corp.intel.com (HELO kekkonen.fi.intel.com) ([10.252.61.250])
  by fmsmga006.fm.intel.com with ESMTP; 25 Mar 2019 08:13:06 -0700
Received: by kekkonen.fi.intel.com (Postfix, from userid 1000)
        id 75F7A21D09; Mon, 25 Mar 2019 17:13:00 +0200 (EET)
Date:   Mon, 25 Mar 2019 17:13:00 +0200
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
Message-ID: <20190325151259.2w22y4ijqilrbaxj@kekkonen.localdomain>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
 <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
 <20190322170550.GX9224@smile.fi.intel.com>
 <20190324211008.lypghym3gqcp62th@mara.localdomain>
 <20190324211932.GK9224@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190324211932.GK9224@smile.fi.intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Andy,

On Sun, Mar 24, 2019 at 11:19:32PM +0200, Andy Shevchenko wrote:
> On Sun, Mar 24, 2019 at 11:10:08PM +0200, Sakari Ailus wrote:
> > On Fri, Mar 22, 2019 at 07:05:50PM +0200, Andy Shevchenko wrote:
> > > On Fri, Mar 22, 2019 at 03:53:50PM +0200, Sakari Ailus wrote:
> > > 
> > > > Porting a patch
> > > > forward should have no issues either as checkpatch.pl has been complaining
> > > > of the use of %pf and %pF for a while now.
> > > 
> > > And that's exactly the reason why I think instead of removing warning on
> > > checkpatch, it makes sense to convert to an error for a while. People are
> > > tending read documentation on internet and thus might have outdated one. And
> > > yes, the compiler doesn't tell a thing about it.
> > > 
> > > P.S. Though, if majority of people will tell that I'm wrong, then it's okay to
> > > remove.
> > 
> > I wonder if you wrote this before seeing my other patchset.
> 
> Yes, I wrote it before seeing another series.
> 
> > What I think could be done is to warn of plain %pf (without following "w")
> > in checkpatch.pl, and %pf that is not followed by "w" in the kernel.
> > Although we didn't have such checks to begin with. The case is still a
> > little bit different as %pf used to be a valid conversion specifier whereas
> > %pO likely has never existed.
> > 
> > So, how about adding such checks in the other set? I can retain %p[fF] check
> > here, too, if you like.
> 
> Consistency tells me that the warning->error transformation in checkpatch.pl
> belongs this series.

All other invalid pointer conversion specifiers currently result into a
warning only. I see that as an orthogonal change to this set. I found
another issue in checkpatch.pl that may require some discussion; would you
be ok with addressing this in another set?

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
