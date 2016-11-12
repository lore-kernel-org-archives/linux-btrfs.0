Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50830 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966604AbcKLReE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Nov 2016 12:34:04 -0500
Date: Sat, 12 Nov 2016 09:34:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
        Miao Xie <miaox@cn.fujitsu.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: bi_vcnt checks for repair
Message-ID: <20161112173401.GA27521@infradead.org>
References: <20161110200601.GA2859@infradead.org>
 <20161111193151.GA30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161111193151.GA30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 11, 2016 at 11:31:51AM -0800, Liu Bo wrote:
> Try to explain it a bit, the following assumes that the data that's
> being read has at least one copy in another device,
> 
> if a read bio contains two pages and the second one is failing on
> checksum check, then we get into bio_readpage_error, in which it finds
> this bio has two pages, so it creats a new bio (so-called validation
> request) which only includes the fail-on-checksum victim page and issues
> it with REQ_FAILFAST_DEV to read the page again in hope of passing the
> checksum check, if it stills fails somehow, it comes into
> bio_readpage_error again to do another try but along with a different
> copy.
> 
> Overall, this bi_vcnt is to tell whether the bio is a normal one and a
> validation one.  If the validation bio got merged somehow, then we need
> to do something to prevent that from happening.

Can't we just set a different end_io handler for the two cases?
