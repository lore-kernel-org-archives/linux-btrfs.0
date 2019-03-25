Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30874C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 21:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0361620848
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 21:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553548760;
	bh=6xFEjARh8mWEVuC4JxlsVeHPi9aB0xZUvNWpmt4JaE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=S9AudlDakcMLDUrBqiagrxCNWAseOLlOuzLK9oFzSpwSoZ9JsK6OBX8MbPxEdiSmn
	 iObxOmu4c6dtnxjPBJuMx6CESm0Mr2qm/yTFVXwAmY1Mkgv1svbcxha6algqdnuEqL
	 wnjdjrimLETvNGmtmorFI25+IXoGd+0fhZqetumA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbfCYVTJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729283AbfCYVTJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 17:19:09 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A8B2082F;
        Mon, 25 Mar 2019 21:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553548748;
        bh=6xFEjARh8mWEVuC4JxlsVeHPi9aB0xZUvNWpmt4JaE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U7HL23u9CbZZaNtYog7ZKs9rsXRYRPGQ9horOTfdo0J1+Qm5fCV9ZxpqzbEanSCUs
         A2n/jnd4afVjLPlgVNSV2SvdBwmnXUDAu8y1fdKl+dXtHStid/kQ/Gydel7i3ZZVKy
         5UySrtfRmJ7930+cnSKVM3QTG5mPAT59xoBoL8PQ=
Date:   Mon, 25 Mar 2019 16:19:06 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
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
Subject: Re: [PATCH v2 1/1] treewide: Switch printk users from %pf and %pF to
 %ps and %pS, respectively
Message-ID: <20190325211906.GA24180@google.com>
References: <20190325193229.23390-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190325193229.23390-1-sakari.ailus@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 09:32:28PM +0200, Sakari Ailus wrote:
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
> Acked-by: David Sterba <dsterba@suse.com> (for btrfs)
> Acked-by: Mike Rapoport <rppt@linux.ibm.com> (for mm/memblock.c)
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com> (for drivers/pci)

Thanks a lot for cleaning this up.  This has been annoying for a long time.
