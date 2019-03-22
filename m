Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E80C2C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 13:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C37392192D
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 13:54:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfCVNx7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:53:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:7181 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbfCVNx6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 09:53:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 06:53:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="124964705"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga007.jf.intel.com with ESMTP; 22 Mar 2019 06:53:51 -0700
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id C176C205C1; Fri, 22 Mar 2019 15:53:50 +0200 (EET)
Date:   Fri, 22 Mar 2019 15:53:50 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Petr Mladek <pmladek@suse.com>,
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Message-ID: <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Geert,

On Fri, Mar 22, 2019 at 02:37:18PM +0100, Geert Uytterhoeven wrote:
> Hi Sakari,
> 
> On Fri, Mar 22, 2019 at 2:25 PM Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > The printk family of functions supports %ps and %pS conversion specifiers
> > to print function names. Yet the deprecated %pf and %pF conversion
> > specifiers with equivalent functionality remain supported. A number of
> > users of %pf and %pF remain.
> >
> > This patchsets converts the existing users of %pf and %pF to %ps and %pS,
> > respectively, and removes support for the deprecated %pf and %pF.
> >
> > The patches apply cleanly both on 5.1-rc1 as well as on Linux-next. No new
> > %pf or %pF users have been added in the meantime so the patch is
> > sufficient as itself on linux-next, too.
> 
> Do you know in which commit they became deprecated, so the backporters
> know how far this can be backported safely?

That appears to be 04b8eb7a4ccd
("symbol lookup: introduce dereference_symbol_descriptor()"), the same
patch that made %p[fF] and %p[sS] functionally equivalent.

But my personal opinion would be not to backport the patch for two reasons:
the sheer number of files it touches (those format strings change for
various reasons) and the meager benefits it has on older kernels as any
backported patch using %s or %S still works as such. Porting a patch
forward should have no issues either as checkpatch.pl has been complaining
of the use of %pf and %pF for a while now.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
