Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45346 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932294AbcKWE3c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 23:29:32 -0500
Subject: Re: [PATCH 6/9] btrfs: calculate end of bio offset properly
To: Omar Sandoval <osandov@osandov.com>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-7-git-send-email-hch@lst.de>
 <20161118200438.GF19038@vader.DHCP.thefacebook.com>
 <20161122094240.GA15407@lst.de>
 <20161122185842.GA17735@vader.DHCP.thefacebook.com>
 <d7a2fef2-900b-236d-8de7-b079b24869a5@oracle.com>
 <20161123042156.GB29697@mew>
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <9e59123a-7450-b7a8-bce3-e9affa7a8cd8@oracle.com>
Date: Wed, 23 Nov 2016 12:32:26 +0800
MIME-Version: 1.0
In-Reply-To: <20161123042156.GB29697@mew>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/23/16 12:21, Omar Sandoval wrote:
> On Wed, Nov 23, 2016 at 12:21:41PM +0800, Anand Jain wrote:
>>
>>
>>>> Can anyone help me on how to get test coverage for the compression
>>>> code?
>>>
>>> I'm not surprised xfstests missed this one since it's just readahead.
>>> You might be able to get better coverage with
>>>
>>> export MOUNT_OPTS="-o compress-force"
>>
>>  And where the data is /dev/urandom the btrfs compression will
>>  bail out, so xfstest cases which uses /dev/urandom won't test
>>  the compression code.
>
> Isn't that just with "-o compress"? That's why I recommended "-o
> compress-force".

  Nope. compress-force doesn't enforce compress even if the data
  isn't compressible. I am not sure if its a bug, but its been
  like that.

  The difference between compress and compress-force is that
  compress-force will never give up and compress will give up
  compress by setting nocompress flag if the first extent is
  not compressible.

Thanks, Anand
