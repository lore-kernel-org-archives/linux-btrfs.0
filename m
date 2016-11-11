Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34931 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbcKKTcj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Nov 2016 14:32:39 -0500
Date: Fri, 11 Nov 2016 11:31:51 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: bi_vcnt checks for repair
Message-ID: <20161111193151.GA30930@dhcp-whq-twvpn-1-vpnpool-10-159-131-21.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20161110200601.GA2859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161110200601.GA2859@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2016 at 12:06:01PM -0800, Christoph Hellwig wrote:
> Hi all,
> 
> btrfs_check_repairable and bio_readpage_error have somewhat odd
> looking check for bi_vcnt, checking on how to proceed based on that.
> 
> Does anyone remember what they actually are checking for?  Depending
> on the exact devices merging bi_vcnt can mean quite a few different
> things, and we should probably check for what people actually intended
> to check.

(These two guys have been silent for some time. :) )

Try to explain it a bit, the following assumes that the data that's
being read has at least one copy in another device,

if a read bio contains two pages and the second one is failing on
checksum check, then we get into bio_readpage_error, in which it finds
this bio has two pages, so it creats a new bio (so-called validation
request) which only includes the fail-on-checksum victim page and issues
it with REQ_FAILFAST_DEV to read the page again in hope of passing the
checksum check, if it stills fails somehow, it comes into
bio_readpage_error again to do another try but along with a different
copy.

Overall, this bi_vcnt is to tell whether the bio is a normal one and a
validation one.  If the validation bio got merged somehow, then we need
to do something to prevent that from happening.

Thanks,

-liubo
