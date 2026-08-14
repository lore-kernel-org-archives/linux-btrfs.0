Received: from mta0.migadu.com (out-56.mta0.migadu.com [91.218.175.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE02405EB
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2026 05:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786684576; cv=none; b=Wywiqbg767J+QiZK9emFg+T6ktvLVdHXyFT4KRJlUkmyb/h6zsb2csrZDkhhN1gYqEEObMFX99jnwSDbV5myKwF0b2I32uRBBiuYoAtzKQ0m5QeYUqkpo2/jOA2HxcHw7QSRm9tr4NgNzzvSv1+IFqQ3U0QioFGzv2CG0XS7Ams=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786684576; c=relaxed/simple;
	bh=j4GJRfc1aJDPjMxnoYFQ35bEfPIds5rkg8YABFOZbLg=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XORmev5GbhjX87cABNAKCfia34h/7WSxAsFRikWIZGHRBa/erwO5bOr9Ew2YYUkSG4bVFjzuVhFJ3/1PyZMEvzlFOml6/in77W1YywJ/lUyeByzv64B9ykPxsSYztVNCyDxW13HxCP0Vuh5OUCkbjVJr/A1otH1lXAffsodNv6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f/By37gz; arc=none smtp.client-ip=91.218.175.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f/By37gz"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j4GJRfc1aJDPjMxnoYFQ35bEfPIds5rkg8YABFOZbLg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786684572; v=1; x=1787289372;
 b=f/By37gzEV30nug3y7azOcEUVaCHkY2DMkB0VHzpaE0PwTeP9PvLFX4vvNLARRrg8gG7zhQu
 O3x0m2rUIycIXhHhD06I14HYCng+LEhklg57BXG33EdsT+2yTwqK7kaCl7TJch07lkZAiYUZQLw
 G5/SsBXhKPiaT2UEr83/4mHo=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: from [192.168.1.116] (111.162.215.50)
	by smtp.migadu.com with ESMTPS id 83b9bc82b1922ad3;
	Fri, 14 Aug 2026 05:16:02 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <1168774a-74d3-4e77-98e3-cd688a2d7e0f@linux.dev>
Date: Fri, 14 Aug 2026 13:15:51 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, clm@fb.com, dsterba@suse.com, josef@toxicpanda.com,
 brauner@kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] btrfs: use mount idmap for defrag permission check
To: Seth Forshee <sforshee@kernel.org>, Qu Wenruo <wqu@suse.com>
References: <20260813034146.1207640-1-cui.tao@linux.dev>
 <bd66065f-bae5-482a-84d6-a78850c9cebe@suse.com> <an36yH30W965eqZk@ubuntu-x1>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <an36yH30W965eqZk@ubuntu-x1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/14 01:11, Seth Forshee 写道:
> On Thu, Aug 13, 2026 at 04:04:05PM +0930, Qu Wenruo wrote:
>>
>>
>> 在 2026/8/13 13:11, Tao Cui 写道:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> btrfs_ioctl_defrag() checks MAY_WRITE with nop_mnt_idmap, which skips
>>> the mount idmap.  On an idmapped mount the owner comparison then uses
>>> the caller's fsuid against the raw on-disk uid, dropping the mapping.
>>> Every other permission/owner check in btrfs ioctl uses
>>> file_mnt_idmap(file) (e.g. :1152, :1310, :1946); this one missed it.
>>>
>>> Switch to file_mnt_idmap(file).  It equals nop_mnt_idmap on a normal
>>> mount, and the check stays behind !capable(CAP_SYS_ADMIN), so only
>>> unprivileged callers on idmapped btrfs change.  The RO-fd note in the
>>> comment above is about the file descriptor, not this inode check, and
>>> is unaffected.
>>>
>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>>
>> Fixes: 4609e1f18e19 ("fs: port ->permission() to pass mnt_idmap")
> 
> This is a misattribution. Using nop_mnt_idmap there keeps the behavior
> the same as it was before the commit. Switching to the mount idmap opens
> up BTRFS_IOC_DEFRAG* to idmapped users when they weren't before, which
> is a separate policy decision that didn't belong in that change.
> 
Agreed, I'll resend it as a behavior change with no Fixes tag.
> Saying that these ioctls should be allowed for idmapped users just
> because others are isn't a good justification. Why are these ioctls safe
> for idmapped users?  Do they actually require this capability?
> 
The check isn't a privilege gate. 616d374efa23 added it to test "whether
the file could have been opened rw", and the caller can already do that
on the idmapped mount -- open O_RDWR, write(), fallocate(). Only the
regular-file branch changes, and defrag only reorganizes the caller's
own extents; the S_IFDIR branch (whole-subvolume defrag) keeps its
capable(CAP_SYS_ADMIN).

Nothing is weakened: !capable(CAP_SYS_ADMIN) stays exactly as is.

may_dedupe_file() in fs/remap_range.c already gates FIDEDUPERANGE the
same way -- capable(CAP_SYS_ADMIN), then i_uid_into_vfsuid(
file_mnt_idmap(file)) / inode_permission(idmap, MAY_WRITE) -- and dedupe
is stronger, since it can rewrite one file's extents from another file's
contents. Idmapped users can already dedupe on btrfs.

Thanks,
Tao

> Thanks,
> Seth

