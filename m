Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B811A0712
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 02:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776046472; cv=none; b=mfUI+7GPs5WT+Ewp5gNnXtz2QFO+yM29ZRxvldgwZuPFWjIoruoNDVyObyLRItUoOPmwjaA5PL43lNqCVFsQDsC0QcMAqGEEoj+8ekLL9SRhrf7Hxq8iKOX26T7CfWXa6HArPteF4R4Nx7Jn4P7Xwp0Psn3/u5Ylc7H48reyexw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776046472; c=relaxed/simple;
	bh=UbaRYBgKlppVQwALPP43jASsEh99a6vHYP1SrHjXMfI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kIR0cnMofbnE/AK9gWDAQPLC+92IM1NEhG5otfOopOMdhQ1jOW0Uobm6SjwzSQG0+3rRtDVccJs743A8K3rdgLsBH2z4W4itExV3B04YNznr5vlfwvCin1UB9rkrEe9RWwNm9rxKRAdp+xJdM0pJC17mfQ5X43Zzr7mA0KhNrdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 89CA8401D4;
	Mon, 13 Apr 2026 02:14:20 +0000 (UTC)
Date: Mon, 13 Apr 2026 07:14:19 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Qu Wenruo
 <quwenruo.btrfs@gmx.com>
Subject: Re: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <20260413071419.70345051@nvm>
In-Reply-To: <adv-2iUrLuHK7MsJ@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
	<adr8DUbqkdFyvZsf@merlins.org>
	<adsDRShNS8OkIcbr@merlins.org>
	<advYoKqUCUmD4oO6@merlins.org>
	<adv-2iUrLuHK7MsJ@merlins.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 12 Apr 2026 13:21:46 -0700
Marc MERLIN <marc@merlins.org> wrote:

> One last ditch effort from Gemini:

I think you'd better not put LLM usage in the forefront of your messages :)
Let alone copy and paste entire unedited paragraphs from it.
It acts as a red herring to many people, and those who would otherwise read
your posts and try to answer, will just glance over entirely.

> moremagic:~# btrfs rescue zero-log /dev/mapper/crypt_bcache0
> Clearing log on /dev/mapper/crypt_bcache0, previous log_root 0, level 0
> moremagic:~# mount -o rw,clear_cache,skip_balance /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup
> mount: /mnt/btrfs_bigbackup: fsconfig() failed: No such file or directory.
>        dmesg(1) may have more information after failed mount system call.
> moremagic:~# mount -wno remount,skip_balance /mnt/btrfs_bigbackup/
> ^^^ works, filesystem is still there:
> 
> Read/write still failing :-/

Nothing wrong with just "this is what I tried and it didn't help", it's not as
important that LLM was the source of the ideas to try.

> Gemini says the following

Everyone has access to Gemini, and if Btrfs developers would be interested in
what it has to say about their filesystem, they could go and ask it directly :)

Secondly, I feel when others DO answer and something doesn't look right, you
may start your objection with "But Gemini said..."
And that's a whole another story, arguing with a person wielding an LLM and
trusting it more than a person in front of them. Many have been there by now
I'm sure. :)

> details, it would be nice to have a way to btrfs --repair or force
> cleanup/revert/delete on read-write mount to recover to a working state.
> Coping 22TB off from r/o FS is pointless, it's an offsite backup, never mind
> that I have nowhere to copy that too anyway, I really would like to
> get it back to read/write if there isn't massive corruption, and there
> does not seem to be.
> 
> Btrfs operates on a strict "clean up your mess first" policy.
> Read-Only: The kernel simply reads the B-trees as they currently exist
> on the disk. It completely ignores the Btrfs "to-do" list (the delayed
> refs and the aborted relocation tree).
> Read-Write: The kernel refuses to let you write new data until it
> finishes the aborted relocation from when the system crashed days
> ago. It tries to execute that "to-do" list, hits the corrupted Extent
> Tree/Squota bug (ENOENT), and instantly panics and aborts the mount to
> prevent further corruption.
> 
> Because there is no skip_relocation mount option in the Linux kernel,
> you cannot force this filesystem to mount Read-Write without clearing
> that broken tree. And because standard tools cannot clear a broken
> relocation tree offline, the RW mount is effectively bricked.

-- 
With respect,
Roman
