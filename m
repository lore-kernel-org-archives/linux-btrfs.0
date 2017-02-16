Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:47686
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932082AbdBPPPg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Feb 2017 10:15:36 -0500
Date: Thu, 16 Feb 2017 20:44:09 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to dump/find parity of RAID-5 file?
Message-ID: <20170216151409.GA10977@giis.co.in>
References: <20170203104406.GA3670@giis.co.in>
 <15ae32eb-195a-712c-2746-cf7528b728a2@inwind.it>
 <20170214200929.GB24702@giis.co.in>
 <bfe89355-f549-7bda-ff0c-428c8b4ca4ed@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bfe89355-f549-7bda-ff0c-428c8b4ca4ed@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2017 at 07:24:55PM +0100, Goffredo Baroncelli wrote:
> The chunk-tree maps the logical address [145096704...145096704+134217728) [size=128MB] to the physical ones 
> 	devid3 : [63111168..63111168+67108864) [size=64MB]
> 	devid1 : [63111168..63111168+67108864) [size=64MB]
> 	devid2 : [83034112..83034112+67108864) [size=64MB]
> 
> So because the logical address is divided in pieces of 64k, interleaved by the parity, we know that:
> * first 128kb
> logical address [145096704      ..145096704+64k)   -> devid1, [63111168    ..63111168+64k)
> logical address [145096704+64k  ..145096704+2x64k) -> devid2, [83034112    ..83034112+64k)
>                 parity:                            -> devid3, [63111168    ..63111168+64k)
> * second 128kb
> logical address [145096704+2x64k..145096704+3x64k) -> devid2, [83034112+64k..83034112+2x64k)
> logical address [145096704+3x64k..145096704+4x64k) -> devid3, [63111168+64k..63111168+2x64k)
>                 parity:                            -> devid1, [63111168+64k..63111168+2x64k)
> And so on...
> 
> (NB: 145096704+2x64k == 145227776)
> 
> The fs-tree, maps the file content [0..131072) [size=128k] to the logical address [145227776..145227776+131072) [size=128k]
> 
> So the file content is stored starting from the disk devid2, at 83034112+64k=83099648 (first 64k). The second 64k is placed in disk devid3 at 63111168+64k=63176704; the parity is stored at disk1, 63111168+64k = 63176704
> 
> 
> BR
> G.Baroncelli
> 

Thanks for the detailed example with exact numbers. Now understood the address mapping better. With this as a reference, I think
it should be possible to access parity/data-stripes more sensible manner instead using expensive "cat /device/ | hexdump | grep"
combination. thanks.

Cheers.
Lakshmipathi.G
