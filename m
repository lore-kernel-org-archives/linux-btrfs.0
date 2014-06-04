Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49087 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbaFDN5c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 09:57:32 -0400
Message-ID: <538F2666.6030402@fb.com>
Date: Wed, 4 Jun 2014 10:00:06 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Philip Worrall <philip.worrall@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/8] Add support for LZ4 compression
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com> <20140603155353.GP22324@twin.jikos.cz>
In-Reply-To: <20140603155353.GP22324@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/03/2014 11:53 AM, David Sterba wrote:
> On Sat, May 31, 2014 at 11:48:28PM +0000, Philip Worrall wrote:
>> LZ4 is a lossless data compression algorithm that is focused on 
>> compression and decompression speed. LZ4 gives a slightly worse
>> compression ratio compared with LZO (and much worse than Zlib)
>> but compression speeds are *generally* similar to LZO. 
>> Decompression tends to be much faster under LZ4 compared 
>> with LZO hence it makes more sense to use LZ4 compression
>> when your workload involves a higher proportion of reads.
>>
>> The following patch set adds LZ4 compression support to BTRFS
>> using the existing kernel implementation. It is based on the 
>> changeset for LZO support in 2011. Once a filesystem has been 
>> mounted with LZ4 compression enabled older versions of BTRFS 
>> will be unable to read it. This implementation is however 
>> backwards compatible with filesystems that currently use 
>> LZO or Zlib compression. Existing data will remain unchanged 
>> but any new files that you create will be compressed with LZ4.
> 
> tl;dr simply copying what btrfs+LZO does will not buy us anything in
> terms of speedup or space savings.

I have a slightly different reason for holding off on these.  Disk
format changes are forever, and we need a really strong use case for
pulling them in.

With that said, thanks for spending all of the time on this.  Pulling in
Dave's idea to stream larger compression blocks through lzo (or any new
alg) might be enough to push performance much higher, and better show
case the differences between new algorithms.

The whole reason I chose zlib originally was because its streaming
interface was a better fit for how FS IO worked.

-chris
