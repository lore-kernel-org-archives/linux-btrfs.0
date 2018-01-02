Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56598 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeABT41 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jan 2018 14:56:27 -0500
Date: Tue, 2 Jan 2018 11:44:13 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs allow compression on NoDataCow files? (AFAIK Not, but it
 does)
Message-ID: <20180102184413.GC22892@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <CAGqmi740EcovePxQswsZ=yh9E5Y1zLKCBaTvFN0EE_AuVPpQ7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi740EcovePxQswsZ=yh9E5Y1zLKCBaTvFN0EE_AuVPpQ7A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 20, 2017 at 11:59:20PM +0300, Timofey Titovets wrote:
> How reproduce:
> touch test_file
> chattr +C test_file
> dd if=/dev/zero of=test_file bs=1M count=1
> btrfs fi def -vrczlib test_file
> filefrag -v test_file
> 
> test_file
> Filesystem type is: 9123683e
> File size of test_file is 1048576 (256 blocks of 4096 bytes)
> ext:     logical_offset:        physical_offset: length:   expected: flags:
>   0:        0..      31:   72917050..  72917081:     32:             encoded
>   1:       32..      63:   72917118..  72917149:     32:   72917082: encoded
>   2:       64..      95:   72919494..  72919525:     32:   72917150: encoded
>   3:       96..     127:   72927576..  72927607:     32:   72919526: encoded
>   4:      128..     159:   72943261..  72943292:     32:   72927608: encoded
>   5:      160..     191:   72944929..  72944960:     32:   72943293: encoded
>   6:      192..     223:   72944952..  72944983:     32:   72944961: encoded
>   7:      224..     255:   72967084..  72967115:     32:   72944984:
> last,encoded,eof
> test_file: 8 extents found
> 
> I can't found at now, where that error happen in code,
> but it's reproducible on Linux 4.14.8
>

Please check the comments in this function need_force_cow(),

* Force cow if given extent needs to be defragged.

and using zlib makes it compress the data.

Thanks,

-liubo
