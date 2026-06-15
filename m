Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57DE3E2AD6
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 11:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781521586; cv=none; b=gJz+VTL9ux8G71bLahq6TtriC41zjR8PXG+Z9Q/17VPOiRrNnoDAuhh9oCbJ5leESypJZySGIUAlwdjGxd/+g00zFh1lOBlyop5Q7mlBtuSqeh2vXqAg5MX29CCS6PiAgo6IaSj0tlUrvdnn4Q+wlPgY/QEHy8eofjL40zsuaDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781521586; c=relaxed/simple;
	bh=pVYpOflrgdM667CJdZpwU7yyjUnaJqaNFQVGLGuJhqM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=NL8oBdkIzfQFrsJFbvCxFskw2dFDU+tN13IfS9Qk4d9GM7X8W0InZaVqWekw/zYCrIFlF9vZlklHD9zThzBXzGPJ87Ld910rLiKOuMDvDDbnJRibJr3LVio3v8lWMBtMjb+gapjCwrNWzlLS3qHBBDnAn/fpXcziFUErCa5frGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZwlZklFq; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZwlZklFq"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490aaeabdb4so21028585e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 04:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781521583; x=1782126383; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nYTMarzZOaQ1pyIqoECeZ9QUtleX7LzZgjURDUMK6fo=;
        b=ZwlZklFqhjh1UpmafAmAEHKc8u3cOqiLp8ycYa46g3CZi+GHqO86PrEsnr75TsYZ0c
         8WuVJ7695UCoIGnH/DFeNKU6zIQjetRBDSuLl7BbDL6fbnA+O5h/uoidYTbdZzAUKUTO
         x2MnU0WgQMPexqqdiPGox/eMOl/DFSzChmtDBv9Oo6ie1zHEV7C2Pcf//UVXONPyCJBf
         xqcUUm3dd+O8rgelRCbYutE0MoJhdsgU8IwJXAx9wTPMlIf6dQakul6VkPGBe2vbjgLj
         9dXDAWBMD1UwOH1UP2Lh1+4SlFPApWtXxn5Kpls+mCQIumoUKCSKq/yChRl4AZ/hQk63
         EF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781521583; x=1782126383;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYTMarzZOaQ1pyIqoECeZ9QUtleX7LzZgjURDUMK6fo=;
        b=Rs1NumxzWKvWoOOdqcxKu6pncU1D82Tbkz8FSizKIiw9iMmUqi6EO3g8MTjo4Qvxy1
         cFcqfty74wTF3fsH62SIJuzsO+/x0TJot1S0QLFH69kBjbBd0pgBVbooL1NYdI3MZpGO
         hdkmlEshz+0AmIt5pq0tDkkFIOjKoPOQcQUtwxPW5wpsuspL7Pphf92OF59gVeMXgRt9
         Eiyko97ynU2dovpqeHvAnB/bvC75j9AUyq7JEEWjSU1EmOqey0tux22acq6rLohbO6bJ
         oFwMb+EMlnsiTNQRSyz35rpqlVQcS81zvJls67kmRhXrwfJHcG86GPY/MKCoJMHOAi+J
         XjHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rVS7XAd6pq4m+t1CveWSGFiQRQaINCHx3ovFt825qRXfccu4j3B9jiAsC/iIDSMZ8D7rJAWBTlYv+yw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQV3UCu0QdKmHSjFeAkBgb6wqSo0SXqsoxqb5jl9TiNbefO7lZ
	ytfPPhlmW3FEkL5vFIYBEdK74nuM73w2bULNDJiMSutmEdl+WQz+Fbkys1QqCdl1
X-Gm-Gg: Acq92OE3ANZ9Q59khbrz/8gee57QJCmUxTi/iU9AWLhv/ZqiU/OtmRDxm7jE9OABmR3
	AsE9YlUQH+NY8iRy0w5mSVVOfUZDh/8uWkGvWUaqD8dVIusoVeBGfIdCHFLhFsYf/7m0FxUj2Z9
	jalYnA9TjZ9sWqLzMxeb781adOU/LWkCsssOrqezLYyxyalDGs1lRjOd7tIx0oIYCb5iDjFEJEy
	PN7iEVIxaTVUFqLozs5cqSkuU9x0pViIC3qr6XvnIgDmKhyQSI5lgF/+U82eTLKKrOcqZCN8ljW
	mPfPnHF2xsNqJZWXX/BxUiOYHLrdkUlao1tYVZFA09mr8ZTVf78UAWE4+OqmTiDIN53UrR0Q/WT
	nkTWQx3H2xhAfM8FNRvO41nqaN4E/CdZOKLIUSZ4uEut5NtZDut5ogCbuCJU3hYDKBSjcYZYHIz
	iXodI/XJJ3jCltfHHxK8penD8Xb6E87czxyfBzBoqMAq5SjhiFIu2+9NMPODDi1GeY0kAmcEKxk
	p1RdWxRkLMYd1hM+MJTTnhh
X-Received: by 2002:a05:600c:4709:b0:490:5057:f5f7 with SMTP id 5b1f17b1804b1-4922007472cmr126376835e9.11.1781521582500;
        Mon, 15 Jun 2026 04:06:22 -0700 (PDT)
Received: from [192.168.10.168] (91-175-163-178.subs.proxad.net. [91.175.163.178])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea961f18sm261567895e9.2.2026.06.15.04.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 04:06:21 -0700 (PDT)
Message-ID: <a1f5967d-604a-4a4f-aa35-a67ce9cfe3a7@gmail.com>
Date: Mon, 15 Jun 2026 13:06:19 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Alban Browaeys <alban.browaeys@gmail.com>
Subject: Re: Btrfs ENOSPC / Stuck in RO with "exclusive operation balance
 paused in progress"
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Qu WenRuo <wqu@suse.com>
References: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
 <abd33b32-aadf-4206-81bc-c2c7832e13dd@gmail.com>
 <43f6ea2b-8b23-49c1-acfe-1d2617f28132@app.fastmail.com>
 <28d08133-999f-4d43-9cd5-67b856246687@gmail.com>
 <f519b8d1-f6d0-4975-9301-74571e87436f@gmail.com>
 <a0df776c-63a3-4ff8-afb5-dc6bce8768c9@gmail.com>
 <791bf200-b3b8-4811-bdf7-3ceaadb9a4f3@app.fastmail.com>
Content-Language: en-US, fr
In-Reply-To: <791bf200-b3b8-4811-bdf7-3ceaadb9a4f3@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Chris, Hi All,


 There is still a thing I wonder, reagarding the size of the used
 metadata, and knowing that small data are stored on the metadata
 partition, could it be possible to force btrfs to move these small data
 items to the data partition that has 16GB free?
 I doubt I have 1.5GB of pure metadata for around 50GB of data, even if
 there are a lot of small files.

 Le 15/06/2026 à 04:07, Chris Murphy a écrit :
 > 
 > 
 > On Sun, Jun 14, 2026, at 6:25 PM, Alban Browaeys wrote:
 >> Hi,
 >>
 >> I had space after the sdb3 btrfs /var partition, a 9GB swap partition. I
 >> deleted this swap partition and expanded the sdb3 btrfs size with parted
 >> But I don't seem to be able to expand the btrfs filesystem inside sdb3
 >> if I cannot mount it read write, is it so? Or is it only due to my
 >> pending operation?
 > 
 > If the file system goes read-only it cannot be modified at all, including resize.
 > 
 > 
 >> Can I get this btrfs partition back?
 > 
 > I think there's a bug. I do know know if the bug wrote confusion to disk, but either way the current kernel code can't handle it so it's a bug. One of your dmesg contained this
 > 
 >> [ 1084.779326] BTRFS info (device sdb3 state A): space_info METADATA (sub-group id 0) has -190382080 free, is full
 > 
 > Can you run 'btrfs check --readonly' on this file system?
 > 


 # btrfs check --readonly /dev/sdb3
 Opening filesystem to check...
 Checking filesystem on /dev/sdb3
 UUID: 13af326c-631f-482b-9c34-b59b4f100608
 [1/8] checking log skipped (none written)
 [2/8] checking root items
 [3/8] checking extents
 [4/8] checking free space tree
 [5/8] checking fs roots
 [6/8] checking only csums items (without verifying data)
 [7/8] checking root refs
 [8/8] checking quota groups skipped (not enabled on this FS)
 found 54982475776 bytes used, no error found
 total csum bytes: 50964248
 total tree bytes: 2142486528
 total fs tree bytes: 1951760384
 total extent tree bytes: 97910784
 btree space waste bytes: 569359506
 file data blocks allocated: 105614794752
  referenced 100030590976



 > My recommendation is to stop mounting it rw. Only mount it ro. The more it is changed the worse the problem is likely to get.


 So I did. I don't know if the previous attempt to mount it read write
 with default options that filed with ENOSPC did damages. But I have
 since refrained from attempting to mount it rw with any rescue option,
 I only mounted ro with the rescue options.

 > 
 > 
 >> Is there a way to copy the content of the partition mounted in ro in its
 >> current state, create a new partition and copy the content back to it?
 > 
 > mount -o ro
 > 
 > Then use rsync -a or cp -a
 > 
 > I think that's safest.
 > 


 Thank you, the doubt I had with rsync where about it flatting
 subvolumes. I don't know a tool that does what rsync does without
 flattening subvolumes. Thankfully the only subvolumes on this
 partitions are /var/li/docker/btrfs that Gemini told me would be
 recreated at startup by the docker dameon, so it told me to exclude
 them from the rsync. For now the only reliable backup I am confident is
 complete is the dd raw image... but it suffers from the same issue the
 raw device partition has, ie that it is likely in a possibly
 recoverable corrupt state (extends halfway in migration). Gemini told
 me to try btrfs-restore but it gave me thousands of errors like:
 "
 ERROR: zstd frame incomplete
 ERROR: copying data for /mnt/4/hermes-var-20260610-enospc-vanilla/restored_var/@var/backups/dpkg.arch.5.gz failed
 "


 > The other option I was suggesting might make it possible to fix, but I've never been able to try it in a case like what you're experiencing so it's entirely untested and therefore risky.
 > 
 > btrfstune -S1
 > 
 > This *changes the file system* therefore it's a risk. But I think it's a minimal change to just the superblock to make the file system a read-only seed device. This is the only exception to the rule that  you cannot add a device when a Btrfs is read-only. It is possible to add a device to a  seed device. But the unintuitive part is how to make it read-write.
 > 
 > btrfstune -S1 $device1
 > mount $device1 /mnt
 > btrfs device add $device2 /mnt
 > mount -o remount,rw /mnt
 > 

 Sadly I tried it and reported about it in my previous email (but my bad
 I should have shortened the bug citation block in the middle which
 probably lead you to conclude there was only citation until the end of
 the email). The issue is I cannot mark the filesystem as seed if an
 operation is pending. (and as seen before I cannot cancel this
 operation it seems if I cannot mount the filesystem read write, dead lock).
 Here it is:

 So with I tried with what I understood:
 with a copy of the image I did of the partition:
 /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
# btrfstune -S 1 /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
ERROR: please finish/cancel the running replace/balance before running this command

 I tried:
# btrfs check --clear-space-cache v2 /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
Opening filesystem to check...
Checking filesystem on /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
UUID: 13af326c-631f-482b-9c34-b59b4f100608
WARNING: --clear-space-cache option is deprecated, please use "btrfs rescue clear-space-cache" instead
ERROR: please finish/cancel the running replace/balance before running this command

# btrfs balance cancel /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
ERROR: not a directory: /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img

# btrfs rescue clear-uuid-tree /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
ERROR: please finish/cancel the running replace/balance before running this command



 and without the seed flag:
# dd if=/dev/zero of=/mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var_target.img bs=1M count=90000
90000+0 records in
90000+0 records out
94371840000 bytes (94 GB, 88 GiB) copied, 1340.52 s, 70.4 MB/s


# losetup -f --show /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
[475088.702700] loop0: detected capacity change from 0 to 166119424
/dev/loop0

 # mkdir -p /mnt/seed_workspace

# mount -o ro,rescue=all /dev/loop0 /mnt/seed_workspace
[475287.536430] BTRFS info: device /dev/loop0 (7:0) using temp-fsid 7d3aa685-b9cd-4cbc-87ed-c2d0288fdeba
[475287.546680] BTRFS: device label SSDHOME devid 1 transid 44655875 /dev/loop0 (7:0) scanned by mount (8576)
[475287.556933] BTRFS info (device loop0 state S): first mount of filesystem 13af326c-631f-482b-9c34-b59b4f100608
[475287.567325] BTRFS info (device loop0 state S): using crc32c checksum algorithm
[475288.554301] BTRFS info (device loop0 state ECS): enabling ssd optimizations
[475288.562226] BTRFS info (device loop0 state ECS): disabling log replay at mount time
[475288.570394] BTRFS info (device loop0 state ECS): turning on async discard
[475288.577648] BTRFS info (device loop0 state ECS): enabling free space tree
[475288.584915] BTRFS info (device loop0 state ECS): ignoring bad roots
[475288.591652] BTRFS info (device loop0 state ECS): ignoring data csums
[475288.598482] BTRFS info (device loop0 state ECS): ignoring meta csums
[475288.605308] BTRFS info (device loop0 state ECS): ignoring unknown super block flags


# losetup -f --show /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var_target.img
[475310.285452] loop1: detected capacity change from 0 to 184320000
/dev/loop1

# btrfs device add /dev/loop1 /mnt/seed_workspace
Performing full device TRIM /dev/loop1 (87.89GiB) ...
[475344.936908] BTRFS error (device loop0 state ECS): device add not supported on cloned temp-fsid mount
ERROR: error adding device '/dev/loop1': Invalid argument



 > This is now a two device Btrfs file system. The seed device remains read-only. The second device receives all the writes/changes as a feature of COW. In effect it's a kind of overlay.
 > 
 > What I'm suggesting is if you now do:
 > 
 > btrfs device remove $device1 /mnt
 > 
 > This tells the btrfs kernel code to replicate the contents of device1 onto device2. This command will not complete until the replication is complete, which could take hours (no idea, depends on how full the file system is).
 > 
 > $device2 size needs to be at least as much as the used amount for $device1.
 > 
 >> There are docker subvolumes on it wich seems they can be recreated by
 >> docker later on (I hope so) so rsync might be an option but if the
 >> docker subvolume need to be backed up rsync is not able to backup them
 >> correctly.
 > 
 > I do not know to what degree the docker btrfs graph driver uses reflinks. Using rsync or cp might dramatically explode the amount of storage needed. It could be docker usage is part of the problem if the problem is at all related to bookend extents. I seem to recall that docker graph driver does result in substantial amounts of bookend extents.
 > 
 > 
 >> And btrfs restore gives me thousands of
 > 
 > Btrfs restore may not help. It's a scraping tool. It's designed to get data out at all costs, even permitting extraction of corrupt files. It won't prefer reflinks or snapshots.


 Ok. Though I believe that if btrfs-restore find incomplete zstd frame
 it might be that rsync will not be able to copy everything from the ro
 half converted btrfs partition?


 >>
 >> Also should I expect this behavior to happen everytime I do a btrfs
 >> filessytem conversion without checking I have enough metadata space
 >> available beforehand or will this be prevented by some new code one day ?
 > 
 > This is always the hard part about file systems. Computers are ordinarily deterministic. But file systems are increasingly non-deterministic as they age. And once you hit the bug, the state of the file system has already changed making it important to stop making all changes to the file system in order to preserve that state for file system developers. The more we hammer on trying to fix it, it's like a crime scene being cleaned up or tampered with. It makes it impossible for the developers to understand what happened and therefore how to fix it so it doesn't happen again.

 Sure. Out of plain "mount /dev/sdb3 /var" I haven't done any rw mount
 attempts. I hope these attempts did not make the issue worst.


 Alban



