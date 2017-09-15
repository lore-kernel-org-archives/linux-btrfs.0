Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19726 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751850AbdIOUQS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 16:16:18 -0400
Date: Fri, 15 Sep 2017 13:14:50 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: BTRFS and O_DIRECT could lead to wrong checksum and wrong
 data
Message-ID: <20170915191449.GB16835@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <cf8a733f-2c9d-7ffe-e865-4c13d99dfb60@libero.it>
 <20170915170122.GA16835@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <4639cd06-b201-5082-b967-e104f0f2e0d8@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4639cd06-b201-5082-b967-e104f0f2e0d8@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 15, 2017 at 08:57:41PM +0200, Goffredo Baroncelli wrote:
> On 09/15/2017 07:01 PM, Liu Bo wrote:
> >> Conclusion: even if the file is corrupted and normally BTRFS prevent to access it, using O_DIRECT
> >> a) no error is returned to the caller
> >> b) instead of the page stored on the disk, it is returned a page filled with 0x01 (according also with the function __readpage_endio_check())
> >>
> > We've queued a patch[1] to fix it, the behavior was introduced a long
> > time ago and we guess it was for testing purpose.
> > 
> > With the patch, you'll get -EIO from dio read, which is consistent
> > with buffered read.
> 
> I tried your patch, but it doesn't seem to address this issue. I still got -EIO with a normal file access, and a page filled by 0x01 with O_DIRECT.

Oh, nice, thanks for trying it out.

I see it now, the regression is actually introduced by a cleanup
patch,

commit 4246a0b63bd8f56a1469b12eafeb875b1041a451
    block: add a bi_error field to struct bio

It overrides our -EIO which should be returned by dio_end_io().


But I think we need further clarification on the correct behavior,
ie.

If a file got corrupted (wrong) data, both buffer'd read and O_DIRECT
read will return -EIO to userspace, and that parcularly corrupted page
will be reset with 0x01 for not exposing data to userspace.  No
exception should exist.

> 
> If I understand your patch, this address the case where there is no any checksum, which is not this case. The checksum exists and it is valid. It is the data wrong.
>

Not for the case of nodatacsum, it's actually for the case where some
checksum somehow got zero'd, and btrfs was not returning -EIO even if
it got a mismatch.

Anyway, your problem is surely a regression, thanks for reporting it.

Thanks,

-liubo
