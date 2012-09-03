Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:60458 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2ICBX0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Sep 2012 21:23:26 -0400
Message-ID: <5044067E.7000607@huawei.com>
Date: Mon, 3 Sep 2012 09:23:10 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: <dave@jikos.cz>
CC: Ben Wreder <benwreder@hotmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Tail packing
References: <DUB117-W3224DDE372041F789CA47FB5A60@phx.gbl> <20120902052537.GF17430@twin.jikos.cz>
In-Reply-To: <20120902052537.GF17430@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012/9/2 13:25, David Sterba wrote:
> On Fri, Aug 31, 2012 at 04:40:36PM +0200, Ben Wreder wrote:
>> The disk format description implies that btrfs should be able to
>> support tail packing. I just did some experimentation, and while small
>> files are packed, it seems that files occupying more than one block
>> are not. For example, a lot of 32769-byte files will end up taking
>> over 36KB on average (a small excess due to the metadata itself).
>>
>> So just to confirm - btrfs does not currently support tail-packing, is that correct?
> 
> Currently it's not the reiserfs-style tail packing. The feature is
> advertised as "Space-efficient packing of small files", as Josef
> replied, if a file fits into a leaf block, it's stored into the metadata
> blocks. The limit is 3916 bytes for 4k blocks, without compression. If
> compression is on, the 'small file' size limit is even higher for
> moderately compressible files.

If the actual size of the file is > 3916 bytes, no matter how compressible it is,
it won't be inlined.

> An example where this could apply is a
> maildir, and IIRC this was why reiserfs was chosen on mail servers.
> 

