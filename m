Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA983AEB2C
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2026 20:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781553663; cv=none; b=DQsFD8XhoNK1r7ENKcVH+Ku2lOspZ4FlG8hhznPtc1p/e5xvNkkydINJZuLtcKWVbIoJvmpdK3vsWR2C4dgD1+Hyp5Qt1FsdPdPF+a4ci4RoS0PAXwVn0JC8Ch/jPO5CYXqY/Ukp9LqelT/ea1g3arHlLz4FCMY6CWrLmqLE3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781553663; c=relaxed/simple;
	bh=qvJwg3Y1NFdH/yUqvyxU6lY4/j/lY0Vi8HPwRvyt8DY=;
	h=MIME-Version:Date:From:To:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=dfXthxVL7rCMlHJJjrFdT3BR8VnjpajH2eZZaSPm9VB0sF0AySiKMHB0x0XCS/zgFJj1h8jq4Zemh75GW1/kMHMgWfz6SfoZmKzyrEnnwaBGbNVx/BdTUP9bhgpAstBqusHmBJlqoOb1Newh+kq7t2y4PS87Y34HoYXLlFA8cWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com; spf=pass smtp.mailfrom=colorremedies.com; dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b=sHFy4MgT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GzBLg80w; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=colorremedies.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies.com header.i=@colorremedies.com header.b="sHFy4MgT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GzBLg80w"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C590514000F3;
	Mon, 15 Jun 2026 16:01:00 -0400 (EDT)
Received: from phl-imap-01 ([10.202.2.91])
  by phl-compute-01.internal (MEProxy); Mon, 15 Jun 2026 16:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	colorremedies.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to; s=fm2; t=1781553660; x=1781640060; bh=wZuSMkzMv+ZUuM1XXMk0y
	+CeKfHVmtoZJy+wVIuOcBE=; b=sHFy4MgTs3Jz8J4ml+IqkuPX4pVdwpf1tZQFA
	xjJ8fxqXaQ3vkZxqk0jGZSWc5HWK+URNRGL/6JjKeKavcXJpukNcZk+uyLWjvyd3
	MqTgeUa+eoi3kSObtW2lW06f/a6RpW9FwtSgLAZdc8i609T/HW7wHK63OrYnFP60
	axHwjIndW54JYFwz1kdgxu2KAWAGuxZb2Q0aLnZcOriypPR2eojd9JuNL2vih/Fk
	KJhyBpz6kOh7cTvtT6DcZeEj7ArmK8HTI7IxBGC0pScyk/nfo8yvjD2jdNM5/+ip
	NZeM0g+ZL2md1yJwwfUp3y7391AUdAx4NsYy6DGzmWnXQ8Fqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1781553660; x=1781640060; bh=w
	ZuSMkzMv+ZUuM1XXMk0y+CeKfHVmtoZJy+wVIuOcBE=; b=GzBLg80wFcacuGzJp
	czhtxpl56irESgFy7niGs6bc/8MTFo1UXSde3iTOlj+ZcpMKVqegjXjVEVkWfdAz
	ytwiXieipzoFI2N+jmof0KJPlouuPntDoIWagBnWmczW9b4aDMj94J8GrEruNc5A
	5fg47CNj1XIbXzmYsB8txgrR8ppRNp19QQMqtHMdfX92PAAa7PTPP0xGNTJ3sTwK
	f/Pbiew0S86mgNYlYz03iy4LRX0bkloij7Q1LLE8j93YrHdA3xp+H1Q9OvA8UBLx
	PDOk1moJ9n/crY74bK/Yxp2AxjljVDr1C8UtHMmYVUlp0iDh+MVNvDaMg17O23AV
	TbD/w==
X-ME-Sender: <xms:_Fkwar-mBqWB3WVzQF7MH_MxGwmfUonvLlvk-ZPY225jkeCZHkwt1Q>
    <xme:_FkwaihtR3MAQkn1kjeJMbF5VAUaixds86RTmqWEshJGQwu_uoZwIvnB97_zVf89q
    9RK4Vvj3Qn1GbRTJpINZd2gPOnZBDM90APT1fUZIoJqyU6lvGaM2g>
X-ME-Proxy-Cause: dmFkZTEIqElTnpDX+xdsUAZqwaMsaHbgDxgSA5AwwJszs7wkyua8JAYlzxyRZnITA6QWgD
    VwF3/1LkgY3+a9Nm+bm79Fd3UeGsaq/FpzHH2TcHa5GSIsdIyD+bfJ8fQ/sEJ/PdgZ/Cuf
    dLu0aF3umDR8VcldQqqlIOHXPCeuiOr/b0NRUeeRfbQ8GzGuQsZJZc77QjMFp7ElmGnQxb
    9Fgp88RtfN5XJo+bN5UEoTR83h+oWxekbbjMzHjrRmNJ75ltPi9/1D6EfeaU4BxvkV+c7l
    R3NmPv7AKzM056plx9oJ2h9fhM1dxJ6DgXWh90oJFzFc2sSZqOShnsZ8LioN+qYzTMRIdk
    lvf0VhdikvPUY42sbrr242Col/n4ab/mIK223gtNOOprem3QTZepaxjwN5+zBujaCdV9PA
    1SPTaSakbPRS2y3Rnu0lcQJy6oJOvGD4n2Y+lSWsbw84wHUHQ4GVAL9+JnELRrzEX/XmLh
    Bp3RU2y4gWlWQzpXfH854saMih1M+bvoBN7b/llEHqdY4oUdAzRCHGp1Au5J6rV1uZdcbf
    JuF57f2RVr3H38nVz8IF0xPkhocPDyP0LlfS1unB0r28TfV7kcRyZZ042+Y5z40FRxDf8C
    BtNPseMNmZ+ENHYbjs+rpqm6HBfcBrAPtAcVCgfO8AgnONOLVn8FGouYDYOw
X-ME-Proxy: <xmx:_Fkwat71SWxn63ltxRqi9wThxva3jO7dVbB6_mO-lvQFlmDt59V7ng>
    <xmx:_Fkwaiqn1aMSGud-QyBucjRbctcm83_ECcgEBwkw4Fy3v_lgoDo1nQ>
    <xmx:_FkwanhkQac1SBsFJGd_XE0t7CiYKG_C8WelpcnPL197Fk6oHnOJ-g>
    <xmx:_FkwakIYTbDhFm1RednRl49zZDDMFpj8Pfh86yZcLmplCRrEGBCrwg>
    <xmx:_FkwautWj4w09gw9jbp59OT-v8g7dAX7Ee-kAt6lIbJ1avNnxbdXbI-6>
Feedback-ID: i06494636:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9161618C0067; Mon, 15 Jun 2026 16:01:00 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A0sQEpqRO37s
Date: Mon, 15 Jun 2026 14:00:29 -0600
From: "Chris Murphy" <lists@colorremedies.com>
To: "Alban Browaeys" <alban.browaeys@gmail.com>,
 "Btrfs BTRFS" <linux-btrfs@vger.kernel.org>, "Qu WenRuo" <wqu@suse.com>
Message-Id: <75a19f88-5370-4a1c-9d95-cb66c5123ceb@app.fastmail.com>
In-Reply-To: <a1f5967d-604a-4a4f-aa35-a67ce9cfe3a7@gmail.com>
References: <068e841a-37fd-4fe5-ba2d-0ab93c55830d@gmail.com>
 <abd33b32-aadf-4206-81bc-c2c7832e13dd@gmail.com>
 <43f6ea2b-8b23-49c1-acfe-1d2617f28132@app.fastmail.com>
 <28d08133-999f-4d43-9cd5-67b856246687@gmail.com>
 <f519b8d1-f6d0-4975-9301-74571e87436f@gmail.com>
 <a0df776c-63a3-4ff8-afb5-dc6bce8768c9@gmail.com>
 <791bf200-b3b8-4811-bdf7-3ceaadb9a4f3@app.fastmail.com>
 <a1f5967d-604a-4a4f-aa35-a67ce9cfe3a7@gmail.com>
Subject: Re: Btrfs ENOSPC / Stuck in RO with "exclusive operation balance paused in
 progress"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Jun 15, 2026, at 5:06 AM, Alban Browaeys wrote:
> Hi Chris, Hi All,
>
>
>  There is still a thing I wonder, reagarding the size of the used
>  metadata, and knowing that small data are stored on the metadata
>  partition, could it be possible to force btrfs to move these small data
>  items to the data partition that has 16GB free?

No. By default Btrfs has separate block group types so it's not possible for Btrfs to put metadata into the unused space in data block groups or vice versa. That is permitted with mixed block group type.

>  # btrfs check --readonly /dev/sdb3
>  Opening filesystem to check...
>  Checking filesystem on /dev/sdb3
>  UUID: 13af326c-631f-482b-9c34-b59b4f100608
>  [1/8] checking log skipped (none written)
>  [2/8] checking root items
>  [3/8] checking extents
>  [4/8] checking free space tree
>  [5/8] checking fs roots
>  [6/8] checking only csums items (without verifying data)
>  [7/8] checking root refs
>  [8/8] checking quota groups skipped (not enabled on this FS)
>  found 54982475776 bytes used, no error found
>  total csum bytes: 50964248
>  total tree bytes: 2142486528
>  total fs tree bytes: 1951760384
>  total extent tree bytes: 97910784
>  btree space waste bytes: 569359506
>  file data blocks allocated: 105614794752
>   referenced 100030590976

OK so the file system is consistent. And there's no log tree.

For some reason skip_balance is not able to abort the balance/convert before the file system runs into the problem and goes read-only. Read-only prevents us from doing everything else.

Clearly the file system wants to allocate at least one metadata block group but cannot, there's no unallocated space on the device and no way to resize or add more space.

At the moment it appears to be stuck. So it's a bug somewhere.


>  Here it is:
>
>  So with I tried with what I understood:
>  with a copy of the image I did of the partition:
>  /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
> # btrfstune -S 1 
> /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
> ERROR: please finish/cancel the running replace/balance before running 
> this command
>
>  I tried:
> # btrfs check --clear-space-cache v2 

Yeah I advise not removing either version of space cache until the balance is cancelled. But we can't cancel the balance before the file system goes read-only which mean the balance cannot be cancelled. This is unrelated to the free space tree.

But yeah too bad the seed flag cannot be set on such a file system.



> /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
> Opening filesystem to check...
> Checking filesystem on 
> /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
> UUID: 13af326c-631f-482b-9c34-b59b4f100608
> WARNING: --clear-space-cache option is deprecated, please use "btrfs 
> rescue clear-space-cache" instead
> ERROR: please finish/cancel the running replace/balance before running 
> this command
>
> # btrfs balance cancel 
> /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
> ERROR: not a directory: 
> /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
>
> # btrfs rescue clear-uuid-tree 
> /mnt/4/hermes-var-20260610-enospc-vanilla/tests/sdb3_var.img
> ERROR: please finish/cancel the running replace/balance before running 
> this command

Clearing trees while a balance is in progress is not recommended. So it's a good thing the tool doesn't permit it.



>  Ok. Though I believe that if btrfs-restore find incomplete zstd frame
>  it might be that rsync will not be able to copy everything from the ro
>  half converted btrfs partition?

I don't know what the btrfs restore complaint about zstd frames is about. That makes me think there is corrupt data blocks, and the block can't be decompressed by zstd. 

You could try:

mount -o ro $dev1 /mnt
btrfs scrub start -Brd /mnt

That will do a read-only scrub on the read-only file system. It can't fix anything but it will show if there's corrupted files.

In any case, the file system does mount ro normally. You can reliably get important information out. The most portable backup/restore for podman/docker/mobi is tar - I know they have internal backup commands that use tar but I do not know what options are actually used and therefore how to make a tar backup of your containers rather than relying on rsync - it's not my area. But I would investigate a more generic way of getting important containers out of the broken file system so you can preserve them no matter the file system or graph driver you decide to use.




-- 
Chris Murphy
