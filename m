Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0898192B7D
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Feb 2026 06:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771829290; cv=none; b=pEgFXCgvTFwUNWN9Tr9obbDL3+CkO+tUCmTS2bksSxsBMHxtQ4kqxphiIxN82wSi9jioW8MtJDR7eFJUqu278uxyzFvqKWQI5UJ1fBiDAvrdK3nEBY9eVfd7MJxhHu0637p4h9L8aj1DJRJ744V+Mnk+PQJKyCWA7AVrWW2y1AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771829290; c=relaxed/simple;
	bh=1/JYDQKrfFCvY/qHZGMSwKmrB35Ggd/HQzlTB0tNHOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=k4wmLoLwrBBaT5JWlc90gVCu+/f4eC9CsfyRV+SsigoMo0Jc/zzOyUHOAO5OamyGdfSFNQBpLFlBkJjafFD7n15xG3Yn4vXFyeOKnRDohFXWQmYlIuJABInUGlrrCdTmUBUH+UyoKJ1u/7bXLsdjScwStO5Znd3oxCibCsPerOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr; spf=pass smtp.mailfrom=free.fr; arc=none smtp.client-ip=212.27.42.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=free.fr
Received: from [IPV6:2a01:e0a:156:6850:7018:89ff:fecb:6f21] (unknown [IPv6:2a01:e0a:156:6850:7018:89ff:fecb:6f21])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 390E019F5A5;
	Mon, 23 Feb 2026 07:47:59 +0100 (CET)
Message-ID: <b1c1247f-df00-4045-a508-fb9a5666114a@free.fr>
Date: Mon, 23 Feb 2026 07:47:59 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Stuck on a BTRFS problem
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <77535c20-da3e-4dfb-b3d7-9426c25b5da3@free.fr>
 <0211658c-8d28-46d1-8e41-21dc02cab276@suse.com>
Content-Language: en-US, fr
From: Phako <phako@free.fr>
In-Reply-To: <0211658c-8d28-46d1-8e41-21dc02cab276@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 22/02/2026 à 22:36, Qu Wenruo a écrit :
> 
> 
> 在 2026/2/22 23:33, Phako 写道:
>> Hello
>>
>> I recently changed the 2x2TB disks I had on my NAS (hardware RAID) 
>> with 2x16TB, after the migration (moved the data on an external HDD, 
>> then moved them back on the new system)
>> The actual configuration is a /dev/sda3 with a root and home subvolume.
>>
>> The OS is a Debian 13 stable with running the 6.12.73+deb13-amd64 kernel
>>
>> 2 days after the migration I noticed that one disk of the RAID array 
>> had a enormous number of UDMA CRC errors (93976 errors), I then clean 
>> the connection of the cables and HDDs and the CRC errors stopped 
>> increasing.
>> But a couple of day later, when I ran a btrfs scrub I get 5 csum error 
>> on 1 file.
>> I blamed the very bad cabling problem during the sync of the array and 
>> the transfert of the data back and deleted the corrupted file and copy 
>> it back from the external HDD.
>> But 2 weeks later after another scrub a new file with 5 csum errors is 
>> detected, and it's on the same physical address (590581006336) but 
>> with a different logical address than the first one, but smart and the 
>> RAID controller don't report physical error.
> 
> Please provide the scrub dmesg, to make sure we're talking about the 
> same "physical address".
> 
> The reason I'm asking is, you later used "btrfs ins dump-tree" and 
> passing the bytenr 590581006336.
> 
> But if it's really physical address, passing it to "btrfs ins dump-tree" 
> makes no sense, as that tool only accepts logical address.
> 
> In that case, the csum mismatch is completely expected, as it may not 
> even belongs to a metadata block group.
> 
> Thanks,
> Qu


Here is the scrub error output concerning the corrupted file_A.mp4 (now 
deleted)


Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 589498875904 on dev /dev/sda3 physical 
590581006336
Feb 09 15:51:16 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 589498875904 on dev /dev/sda3, physical 590581006336, 
root 257, inode 40442, offset 46055424, length 4096>
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 589498875904 on dev /dev/sda3 physical 
590581006336
Feb 09 15:51:16 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 589498875904 on dev /dev/sda3, physical 590581006336, 
root 257, inode 40442, offset 46055424, length 4096>
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 589498875904 on dev /dev/sda3 physical 
590581006336
Feb 09 15:51:16 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 589498875904 on dev /dev/sda3, physical 590581006336, 
root 257, inode 40442, offset 46055424, length 4096>
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 589498875904 on dev /dev/sda3 physical 
590581006336
Feb 09 15:51:16 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 589498875904 on dev /dev/sda3, physical 590581006336, 
root 257, inode 40442, offset 46055424, length 4096>
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 589498875904 on dev /dev/sda3 physical 
590581006336
Feb 09 15:51:16 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 589498875904 on dev /dev/sda3, physical 590581006336, 
root 257, inode 40442, offset 46055424, length 4096>
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 3, gen 0
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
Feb 09 15:51:16 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 5, gen 0


And days later, the scrub for the file_B.mp4 :

Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 3409178460160 on dev /dev/sda3 physical 
590581006336
Feb 21 21:34:53 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 3409178460160 on dev /dev/sda3, physical 590581006336, 
root 257, inode 230235, offset 31449088, length 4096>
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 3409178460160 on dev /dev/sda3 physical 
590581006336
Feb 21 21:34:53 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 3409178460160 on dev /dev/sda3, physical 590581006336, 
root 257, inode 230235, offset 31449088, length 4096>
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 3409178460160 on dev /dev/sda3 physical 
590581006336
Feb 21 21:34:53 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 3409178460160 on dev /dev/sda3, physical 590581006336, 
root 257, inode 230235, offset 31449088, length 4096>
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 3409178460160 on dev /dev/sda3 physical 
590581006336
Feb 21 21:34:53 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 3409178460160 on dev /dev/sda3, physical 590581006336, 
root 257, inode 230235, offset 31449088, length 4096>
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): unable to fixup 
(regular) error at logical 3409178460160 on dev /dev/sda3 physical 
590581006336
Feb 21 21:34:53 nas01 kernel: BTRFS warning (device sda3): checksum 
error at logical 3409178460160 on dev /dev/sda3, physical 590581006336, 
root 257, inode 230235, offset 31449088, length 4096>
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 41, gen 0
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 42, gen 0
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 43, gen 0
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 44, gen 0
Feb 21 21:34:53 nas01 kernel: BTRFS error (device sda3): bdev /dev/sda3 
errs: wr 0, rd 0, flush 0, corrupt 45, gen 0
