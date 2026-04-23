Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9AA33291F
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776938684; cv=none; b=fH5n1AXZRogzS4Dp8rkzb0hWyQPGtBlfRrcIq/geWDLOwPlIkRK6PVClkPycPFMdXrKdWmUj+8oieEaOak+M24doc0CuXdnu3wGjPyxkRSWBx64J5AYT41JkaAXTE4DkhnTZKjjleFsC3r+JCDX+h/2zWzHDRvRdr34kk2uvCO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776938684; c=relaxed/simple;
	bh=+Dx3ru6wLSG8nvx1+Q40LopWad4E5n8FJBNcKUp1tIs=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6+SPWB3KeDlPgmsB6YGfaGbRHoyXtBvDnJ95s/Hz5ErXBT4InbGEewoA/79DAWTxprsaoVLQMrAvGeqZppKMXLllK/S+NYGjq1NmbcalTFoNXR6SL4h/zBJOFcY/Q5h201SVpZyeDLwaZdAQi53IF2Um6WJMc/3m5bJcjFy/uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=erF+doOS; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="erF+doOS"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 36E99321080;
	Thu, 23 Apr 2026 11:04:37 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1776938677;
	bh=lvmDVjYVFMcKz/g8WBOFcr5MveC0HytrKH25CkQxjmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=erF+doOSa6EjyluhXdQ1bUnwdn4PDw0N/pezexYZbEiOLi2fTGU/TF4fzRDXHh1p8
	 Oe+QBt7KQL3MPzMtGetuROidKV5EwQu3HWnT7kupuPKVScWU8Qh3/pmVZkH8IssnYM
	 x1Rc29QPLA+5hPzPnHNndWFpN00mqwM1p6UhGAPI=
Message-ID: <850c7c2d-ed97-424f-8ede-4491bacb02ac@harmstone.com>
Date: Thu, 23 Apr 2026 11:04:37 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: don't force DIO writes to be serialized
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, josef@toxicpanda.com, boris@bur.io
References: <20260422140339.417238-1-mark@harmstone.com>
 <20260422205728.GI12792@twin.jikos.cz>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <20260422205728.GI12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/04/2026 9.57 pm, David Sterba wrote:
> On Wed, Apr 22, 2026 at 03:03:35PM +0100, Mark Harmstone wrote:
>> Before btrfs switched to the new mount API in 2023, we were setting
>> SB_NOSEC in btrfs_mount_root(). This flag tells the VFS that the
>> filesystem may have files which don't have security xattrs, enabling it
>> to do some optimizations.
>>
>> Unfortunately this was missed in the transition, meaning that IS_NOSEC
>> will always return false for a btrfs inode. This means that
>> btrfs_direct_write() calls will always get the inode lock exclusively,
>> meaning that DIO writes to the same file will be serialized.
>>
>> On my machine, this one-line change results in a ~59% improvement in DIO
>> throughput:
> 
> That's quite an improvement. What's the actual fio script you've used?
> Also the DIO depends on the block group profile wrt the buffered
> fallback so that would be good to know too.

It is. There's a big dropoff in DIO write performance in 6.8 that we 
never recovered from. I'm going to look into some sort of automated 
performance so this kind of thing can't happen casually.

This was on a VM with 8 cores and 8GB of RAM, with a real NVMe exposed 
through PCI passthrough. The figures for XFS and ext4 in comparison are 
both about ~3GB/s.

# cat go
#!/bin/bash
mkfs.btrfs -f /dev/nvme0n1
mount /dev/nvme0n1 /mnt/test
mkdir /mnt/test/nocow
chattr +C /mnt/test/nocow
fio /root/test.fio

# cat /root/test.fio
[global]
rw=randwrite
ioengine=io_uring
iodepth=64
size=1g
direct=1
startdelay=20
force_async=4
ramp_time=5
runtime=60
group_reporting=1
numjobs=32
time_based
disk_util=0
clat_percentiles=0
disable_lat=1
disable_clat=1
disable_slat=1
filename=/mnt/test/nocow/fiofile
[test]
name=test
bs=4k
stonewall

