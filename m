Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60E10F0
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 00:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781827523; cv=none; b=nE51vL5dFTajr6O1aUD8WoH/pgO45VgeUuf2ZmNMfNkT24iBngkexWohDrwAr840yQwB8AXRo2Rf1kxwdw4j6gZHSFhlHesmE8dtOFYS2NsTXRdvDSQEWPfeFE5ZeWOiZRUi8qdEOU4Mku+2JTRTuQM1vHDkt2laQX/4ta5iBgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781827523; c=relaxed/simple;
	bh=clRL7WYo7zRNHTgU8m5+WnXzniqpLY1ZMVmSuDoIaq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cUGdbl4aZiGXC6W/hotJ0PmjXVHzZY7gH9somRxTBEdyTOypQF0Qzr6qXHVsoY3BJItyhgtKmb1Ny4LjarsjvnTqSDP6mQDHdqixHXqUsBkdtNH+jg+rTx9ZTdYdU73ptpfEuc6IyDFdETXxtLNFqdZ/m0wbkI7pmQObNMvsTus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YK1EjN08; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YK1EjN08"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-462bb734793so1156758f8f.1
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2026 17:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781827520; x=1782432320; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CJMQehqUUvlPelDGLpUQuY6PSNumumFpzaSKtTf4cks=;
        b=YK1EjN087kTGh21hIW+2mc2re1zgYRuy4KF/v6rMiTCOmaFxXDzrYpOHyez2ACB7PZ
         qVXZLt6WUKsXwDFuj8RxoGmPN2u6PEonQNwcgTWKkg8Qa6YpMFK+OM59TaI+LQGYHKJ4
         TmtP7Bq5sKqoPFRGTuTHG3gpP1/CqVxAWpza34KdtBIy4A3Derjdj0TnD1RZu+qAu6C8
         tey5siCr3DQcxf/3lwlKCnJuNYHAFiXcv08sy0xvPYTB59Lq7pcqtVw7LAuNwLZ/1y1C
         A/4YnFeq/FxXokzdLTv2Ez0Eve/6EmInWrzNlNuXBdvMXEMvYGMCAn3SzhlMEx/ctGMD
         0U7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781827520; x=1782432320;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CJMQehqUUvlPelDGLpUQuY6PSNumumFpzaSKtTf4cks=;
        b=foo1sg80AXhkIVp+Z8p8y8mnZZNIGG6YPHYgkIXvpAoIyCnBi1BwnNggwED6AjO4//
         LaTeG6cLAOYn2Zokh4nPYvCXVTUPbeovvxZ7gmgAYQp06iKHVoysg30ir0+m8hC9qwhT
         0pQ4q5dmr7iPwHXJG/Z8L8Hveg8Eu4klN74gW4PBpiYyjzZn5emUAoGvFtf4RZ4XbRee
         fFVlEqIJOqd4gvC2yi2AW46IPWV+7XCAscHFtGgW+DBnKeGrb+kvfLc9VXi7ytkFUJDl
         7sTBqAu8TWriLxofn+bshEuVklaFPKIyUnZxKMF4D1VYkHDrHkFjJOuzON0oB7pe2Xz2
         Hinw==
X-Forwarded-Encrypted: i=1; AFNElJ/V9bI+hKEzBRjNhV/wet5n7oV5xoF0Gze3zFIg3wud3/DBq66EBmqHFJB3Bq7mg/Krx9dKzOD8QCxP1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEyxLxBu83U99SMebiYL3T6DVlOFoz/IMVA29P09eBBe4VN5ao
	bt95UlK7egYb7obkyU0MXyVBa1nO0B5DivVhVlAF4PaAT9euDr1NUVBS
X-Gm-Gg: AfdE7cnsaij3UiM4dqsL9Aui6TBIrIjWOo+K3kGE6PUf0dtyasyvyYy6dQsPT/tad4j
	jyu0LmlwTh0ilo+h9HeoqgUgR5IEIwUE7eoQI00L+VEp/l/TqBYxM5Go3sQDcn90BNHPJm1Ho1P
	7rAHAWkvy70fz04oONyt6FQ2Gmf/YJnnqhh32/mfcc9nPgJOIBc0yhrBGfQ0iIgcNJ6p2O0G5x2
	f/Xj/JqPBA+mXh7dyANX7RbJMcEGJ/afEUAwDHn2MG/HekhZ6WkpyZ5SSvUBqHVfs9xCe9qC+fE
	Utr+10NAg/eYlNpMYFDgsuO4Rjr6X2W0BRX66X4He6u4W2PEqDUa44cFkAbXp/ttHfHD/uDZPvL
	l6ijY9uICNLNBH4UVM4IuW41E7Ay0EuFmXPZEl2VXHJlyJgtfxGf9VtXB8PKvma1LVShQBQ4Sac
	BDDDqTIdDDNM7M9vqS5yQWLxudzvDaXB2fU1DktNidXHxCOUkMHy1PNRzH95WrEytM6pIxYLLcH
	tAp6zV7hao7DA==
X-Received: by 2002:a5d:6303:0:b0:460:3a90:b2b6 with SMTP id ffacd0b85a97d-4650005a302mr2084190f8f.11.1781827519847;
        Thu, 18 Jun 2026 17:05:19 -0700 (PDT)
Received: from [192.168.10.168] (91-175-163-178.subs.proxad.net. [91.175.163.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650b67a3e8sm2645644f8f.19.2026.06.18.17.05.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 17:05:19 -0700 (PDT)
Message-ID: <cb72893a-34b2-4937-aabe-4d88921c140d@gmail.com>
Date: Fri, 19 Jun 2026 02:05:17 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
 <a1f5967d-604a-4a4f-aa35-a67ce9cfe3a7@gmail.com>
 <75a19f88-5370-4a1c-9d95-cb66c5123ceb@app.fastmail.com>
Content-Language: en-US, fr
From: Alban Browaeys <alban.browaeys@gmail.com>
In-Reply-To: <75a19f88-5370-4a1c-9d95-cb66c5123ceb@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Have you seen I posted a link to a btrfs debug image in a previous  email in this thread?

"
partition sdb3_var_metadata-only-debug.img at https://drive.google.com/file/d/1OzEZLaTUNpWsL1ohGKOMW4GiR9oQakdP/view?usp=drive_link done with "btrfs-image -c 9 -t 4 /dev/sdb3 /mnt/4/hermes-var-20260610-enospc-vanilla/sdb3_var_metadata-only-debug.img". 
"

I made an image and a btrfs debug image, is there any use for me to keep the broken on disk partition? I believe I cannot expect to be able to recover this on disk partition in a week and thus should delete it and recreate it if I want the pc back?
And keep the disk partition image for debugging.

Le 15/06/2026 à 22:00, Chris Murphy a écrit :
> 
> 
> On Mon, Jun 15, 2026, at 5:06 AM, Alban Browaeys wrote:
> 
>>  # btrfs check --readonly /dev/sdb3
>>  Opening filesystem to check...
>>  Checking filesystem on /dev/sdb3
>>  UUID: 13af326c-631f-482b-9c34-b59b4f100608
>>  [1/8] checking log skipped (none written)
>>  [2/8] checking root items
>>  [3/8] checking extents
>>  [4/8] checking free space tree
>>  [5/8] checking fs roots
>>  [6/8] checking only csums items (without verifying data)
>>  [7/8] checking root refs
>>  [8/8] checking quota groups skipped (not enabled on this FS)
>>  found 54982475776 bytes used, no error found
>>  total csum bytes: 50964248
>>  total tree bytes: 2142486528
>>  total fs tree bytes: 1951760384
>>  total extent tree bytes: 97910784
>>  btree space waste bytes: 569359506
>>  file data blocks allocated: 105614794752
>>   referenced 100030590976
> 
> OK so the file system is consistent. And there's no log tree.
> 
> For some reason skip_balance is not able to abort the balance/convert before the file system runs into the problem and goes read-only. Read-only prevents us from doing everything else.
> 
> Clearly the file system wants to allocate at least one metadata block group but cannot, there's no unallocated space on the device and no way to resize or add more space.
> 
> At the moment it appears to be stuck. So it's a bug somewhere.
> 
> 


> 
>>  Ok. Though I believe that if btrfs-restore find incomplete zstd frame
>>  it might be that rsync will not be able to copy everything from the ro
>>  half converted btrfs partition?
> 
> I don't know what the btrfs restore complaint about zstd frames is about. That makes me think there is corrupt data blocks, and the block can't be decompressed by zstd. 


Could it be half transfered data during the conversion ?

> You could try:
> 
> mount -o ro $dev1 /mnt
> btrfs scrub start -Brd /mnt


# mount -o ro /dev/sdb3 /var
[820430.153273] BTRFS: device label SSDHOME devid 1 transid 44655875 /dev/sdb3 (8:19) scanned by mount (13961)
[820430.175471] BTRFS info (device sdb3): first mount of filesystem 13af326c-631f-482b-9c34-b59b4f100608
[820430.185087] BTRFS info (device sdb3): using crc32c checksum algorithm
[820430.221645] BTRFS info (device sdb3): enabling ssd optimizations
[820430.228181] BTRFS info (device sdb3): turning on async discard
[820430.234575] BTRFS info (device sdb3): enabling free space tree
# btrfs scrub start -Brd /var
WARNING: cannot create scrub data file, mkdir /v[820447.453110] BTRFS info (device sdb3): scrub: started on devid 1
ar/lib failed: Read-only file system, status recording disabled
WARNING: failed to open the progress status socket at /var/lib/btrfs/scrub.progress.13af326c-631f-482b-9c34-b59b4f100608: No such file or directory, progress cannot be queried
Starting scrub on devid 1
[820598.534072] BTRFS info (device sdb3): scrub: finished on devid 1 with status: 0

Scrub device /dev/sdb3 (id 1) done
Scrub started:    Fri Jun 19 01:51:24 2026
Status:           finished
Duration:         0:02:31
Total to scrub:   51.21GiB
Rate:             347.25MiB/s
Error summary:    no errors found


# btrfs fi df /var
Data, single: total=65.44GiB, used=49.21GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=3.00GiB, used=2.00GiB
GlobalReserve, single: total=181.56MiB, used=0.00B

 
> That will do a read-only scrub on the read-only file system. It can't fix anything but it will show if there's corrupted files.
> 
> In any case, the file system does mount ro normally. You can reliably get important information out. The most portable backup/restore for podman/docker/mobi is tar - I know they have internal backup commands that use tar but I do not know what options are actually used and therefore how to make a tar backup of your containers rather than relying on rsync - it's not my area. But I would investigate a more generic way of getting important containers out of the broken file system so you can preserve them no matter the file system or graph driver you decide to use.


Alban
