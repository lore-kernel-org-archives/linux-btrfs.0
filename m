Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379D53563D2
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 05:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776229963; cv=none; b=RfGpE+/fvGlmayrFE53kATaPfjqu/LxOytkMznRGrHbwF/YoUVsancEw1vyUIITAnIUyQY2gZuTKU5w31lGW5oB6kLSzLOVZZwjGDThXO2Uqzf3L6+TczWMyPnOMfve5nAD7GZJ23yUAws+4TndoDHNHwx5CDOQYCN+mjo8hkUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776229963; c=relaxed/simple;
	bh=uJjQXhjrWBdbVGhOiQ5I6u3vjnZCs8Gvzb1xXlomZvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzgergpnFrQGNZX+LdQZ0nnPIhrUX08LvNNEXS+qOACayZ/UPpWEcPb7W7yL+lQ53XAjMXTz+xs3JT4n0stvyogelzmRFaQh/ZdH1eG8iTOsfKNaPsJT1SKnMr0YRrkksykSfsReHgkN+ScN9smyrqYBelEo1JXlKEFBEk2cIS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=hjL+EjZg; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="hjL+EjZg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Resent-To:Resent-Message-ID:Resent-Date:Resent-From:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Sender:Resent-Cc:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6F0utLWZWFCToI7ZrVMH/g9rCAt0lFTPE0HztllBu8w=; b=hjL+EjZgCzway7XaN2Ywm7x1g/
	OBugeOMxzOyE1+Wwp56419AppUNvoZfynRcm+GxIrXBqUPdUBc2PLVC0/1ozaf2JJcwBF042oMqfP
	kocuaxhB17ViSwds87QUp+2KQaul5TtBwtIZOEmfN/QbFf4r7WC9GstOCN45RXfbkoNoWKdqtFvux
	beczk83ofneKrwoTzpu1222caHyk4DiRhnxyE37gSw6Nthg2ysxl6oRTQz5Zsod8Hp5YUMS5TrPUH
	jfFl1RMDQSPoV48yiTNKCj9CFURRz63BlegBVTU1P4buuTB9g5kKt1PGqq+UPa39I86YY2fLlSryW
	XLVNSlfQ==;
Received: from [24.6.49.44] (port=35892 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wCsYL-00000004AUG-3Yca by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>;
	Tue, 14 Apr 2026 22:12:41 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <merlin@merlins.org>)
	id 1wCsYK-006sa2-1z
	for linux-btrfs@vger.kernel.org;
	Tue, 14 Apr 2026 22:12:40 -0700
Resent-From: Marc MERLIN <marc@merlins.org>
Resent-Date: Tue, 14 Apr 2026 22:12:40 -0700
Resent-Message-ID: <ad8eSJgsV8xk7kVW@merlins.org>
Resent-To: linux-btrfs@vger.kernel.org
Date: Mon, 13 Apr 2026 12:40:53 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>,
	Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, To: Su Yue <Damenly_Su@gmx.com>,
	Su Yue <suy.fnst@cn.fujitsu.com>;
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <ad1GxXgWNBfgrRtN@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <ad0tdWyavEngGlQ-@merlins.org>
 <20260413184731.GA3448810@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413184731.GA3448810@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc@merlins.org
Message-ID: <20260413194053.6hQUZJW81k-d_PmJKUgxZWfysXHNJh8KXWShWVhZS7Q@z>

On Mon, Apr 13, 2026 at 11:47:31AM -0700, Boris Burkov wrote:
> I am currently a little confused about your full story, so please help
> me make sure I understand. I would like to fix any squotas problems you
> are seeing if possible. I'm going to restate what I have understood from
> your reports to try to confirm I am following properly.
 
Sure thing, thanks for caring and replying.
For moremagic, the first report, I'm very close to wiping the filesystem
and starting over since I can't mount it read/write.
Ironically if I do that it would be a good time to turn on squota but
at the same time, it may not be safe in 6.12.

> I will call this report 1. Report 1 is from a rpi running 6.12 with possible out
> of tree modules and raid5.
 
Correct. moremagic is running Raspberry Pi debian which I understand is
running its own kernel to support the chips on the board. Sadly it means
I'm stuck at 6.12 for that one. I didn't know it would be an issue for
btrfs, but if you feel squotas are not ready/safe in 6.12, I'll disable
them (well, it looks like I will be doing that no matter what since I
can't have moremagic crash its 22TB filesystem , but still your feedback
will be valued).

> I'll call this report 2. Report 2 is from a laptop with no fancy raid
> and upstream kernel 6.17.

Correct. amd4 system and Package: linux-image-6.17.11+deb14-amd64-unsigned
from upstream debian which I assume is clean.

> Is that all accurate?
> 
> Some further questions/observations:
> - I noticed that your paste from report 1 (https://pastebin.com/7HmQwy3n)
>   had 16k pages and 4k block size:
>   2026-04-10T10:43:22.673638-07:00 moremagic kernel: BTRFS warning (device dm-0): read-write for sector size 4096 with page size 16384 is experimental

Yeah, I saw that too. I don't have much of a choice on arm, they have
switched to 16k.
I tried formatting my new filesystems as 16k native and then had to
revert once I realized it broke btrfs send/receive (cannot send from 4k
FS to 16k fs).

>   which seems a bit risky on an old kernel. There were a lot of fixes for
>   subpage block size support in recent kernels. I believe it has been
>   quite stable for us on 6.16 but Qu can give the most authoritative
>   answer on when that got solid.

I would love to know, yes.

> - Is the laptop also running subpage block size? Do you have a full
>   dmesg from that systewhich you can share?

The laptop is as simple and basic 

> - On which of these systems did you enable squotas and when?

5 systems, I enabled them 4 days ago and already had 2 crashes
I did also enable block-group-tree at the same time since I read
it really helps when I have 100+ snapshots on a single filesystem
(due to backup server, btrfs send receive and historical snapshots)

- rPi5 with that 6.12 kernel (moremagic, the one with the crash). One
  crashed on a 4k btrfs disk array that was built a long time ago and I
  just converted to squota

- 2nd Rpi5 with same kernel (no choice) with FS I just rebuilt last
  night once I realized I can't use 16k pages. On top of raid5 on top of
  SSDs. It's currently doing a multi day long btrfs receive to populate
  aragorn:/mnt/btrfs_pool1# df -h | grep btrfs_pool
  /dev/mapper/dshelf1   30T  3.4T   26T  12% /mnt/btrfs_pool1 (raid5 8 SSDs)
  /dev/mapper/dshelf2   25T   84G   25T   1% /mnt/btrfs_pool2 (raid6 10 SSDs)

  This one is fresh so the squotas would be useful. I have not disabled
  them yet, but probably will as soon as you confirm it's probably not
  safe, especially with 16k pages in the kernel but 4k in the filesystem
  It's the only one I still have running now.

- laptop #1 where I enabled them on every filesystem (6.16.8-amd64, will
  reboot to 6.19.11 as soon as I can reboot), but given that squotas are 
  kind of useless on existing filesystems since you can't backfill
  missing quota data, I'm going to disable them now, I can't have that
  laptop crash

- laptop #2 (merlin, the one that crashed). Similar debian install and
  btrfs filesystems. btrfs_pool3 gets btrfs receive backups , 
  juggles snapshots and btrfs balance nightly.  Thankfully the
  filesystem was fixable, I've brought it back online and disabled
  quotas on all filesystems too.

- old file server running 6.16.8-amd64-preempt-sysrq-20241007 I built
  myself from source. It also has not crashed yet, but I had just
  enabled quotas on a big 22T spinning rust array that I'm finishing
  a bit send/received to. Given that I really don't want to lose that
  only backup left with the one I just lost on moremagic, and squota
  isn't that useful on an existing filesystem, I just turned that one
  off too. I ran for 2 days, but there were no nightly snapshots or
  btrfs balance happening nightly on it.

> I don't see any evidence for that, as discussed above about the object
> type referenced in the abort log. In fact, we don't really know that the
> freeing even had to do with the subvolume being deleted as we were
> running generic delayed refs as part of a consistency enforcing
> transaction commit before digging into qgroup logic. We have not
> connected the logical block that had the issue to subvol 83288, for
> which we would probably need a tree dump.
 
understood.

> Unfortunately, this second bullet is nonsense, the qgroup cleanup log
> is there simply because that is the caller of btrfs_commit_transaction
> that consumed the failed delayed ref errno and also logged its own
> failure. This is apparent from the stack trace and logs. This actually
> confused and distracted me quite a bit :)
 
apologies for that. Normally I only use gemini on stuff I personally
know and understand, so I can easily tell if it's full of crap, but in
the case of btrfs kernel code, I'm clueless, sadly.

Despite that, hopefully the multiple oops and tracebacks give some clue.
For now, I've disabled squota everywhere but one after my 2nd laptop got
hit overnight. I'll see if I get more issues on it later which won't
prove anything, but give some correlation ("crashed with squota after 3
days, fine for many days without").  I understand the rPi is more
problematic due to non standard kernel I can't upgrade.

Thanks much for your time,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
