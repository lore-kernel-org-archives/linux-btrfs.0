Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35200 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdH2RNW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Aug 2017 13:13:22 -0400
Received: by mail-io0-f182.google.com with SMTP id k22so23446327iod.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Aug 2017 10:13:21 -0700 (PDT)
Subject: Re: Decompression success/failure dependent on PAGE_SIZE?
To: =?UTF-8?Q?Marek_Beh=c3=ban?= <marek.behun@nic.cz>,
        linux-btrfs@vger.kernel.org
References: <20170829184342.2f6ec0b0@dellmb.labs.office.nic.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <974aff07-4549-1a7f-be13-e8a6ec6e16f2@gmail.com>
Date: Tue, 29 Aug 2017 13:13:18 -0400
MIME-Version: 1.0
In-Reply-To: <20170829184342.2f6ec0b0@dellmb.labs.office.nic.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-29 12:43, Marek Behún wrote:
> Hello,
> 
> so I've been studying the linux btrfs code and have come across this:
> 
> in inode.c function uncompress_inline the max_size size variable is set
> to min(max_size, PAGE_SIZE) and only max_size of output data are
> decompressed.
> 
> The code for compression (in lzo.c for example) uses PAGE_SIZEd chunks
> to compress an inline extent.
> 
> If I understand it correctly, then if the filesystem is created and used
> on a computer with PAGE_SIZE for example 16KB, and an extent of size
> 16KB is compressed to (for example 9KB) and stored as inline extent,
> and then the filesystem is mounted on a computer with PAGE_SIZE = 4KB,
> reading the extent will result in a failure or incomplete read.
> 
> Is this a bug, or is this behaviour a feature?
It's absolutely not a feature.  I've not actually seen this issue 
mentioned anywhere myself, but I'm willing to bet that the consensus 
among developers will be that its an unintentional limitation of the 
current design.  There are in fact issues when trying to use a 
filesystem with a block size smaller than PAGE_SIZE as well, so the 
general consensus is to not mix filesystems from different architectures 
unless you know the page size matches.
