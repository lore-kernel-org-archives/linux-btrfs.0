Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141BD3E833E;
	Fri, 31 Jul 2026 11:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785496340; cv=none; b=LvHkE6+DvvTI0PaNnIWS6WKSh8mzp/mSEvyKRz/TyWTACCdZXRFI5xvr9cK2Li4rWRTX/WXWkOgws4yVRWkiP8WgaJkaCiouLb49mCOeU0F8g0M1RKRKipaN3HVp405ceHdU6NZzhfkiOP3YpvUaLo6vukq+OM7yB41KrcOz7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785496340; c=relaxed/simple;
	bh=FtQ8JiVPTakOU+To7uNUf4yDsXJk57lj6qbz2DoQam0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mVHRbXq/CEkwxCe3orT+PpJqcK2jWxTPfHY8xjhu6GUF3oT0RvGU6LQMDi9nsI7N29ZWxBgQgn51rHXGv1vGN/hp2UobxrL4yMxwG7PwCCndmcZnetVROrbIY1qv+jj+jzZaNXeKu4tvXOPCS6gLQn47UgpjLGzqVIf95gaKaSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=BAPXZ9uR; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="BAPXZ9uR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785496332; x=1786101132; i=quwenruo.btrfs@gmx.com;
	bh=glJz1MHWIQsSxCa8TrMvOBC7mrGoghLwj2qxdmleRyE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BAPXZ9uRY/exv2XKn2PpFlpU2YxsHMcquRqtr3DB64VFDqPwTBg7494bvpcanxcp
	 ckFcTAnEQvP6zJB5SBXrrib+f+tHswDFyBHoVbJG5VRd5btvcliY5Eegj8WJNmTtY
	 PBzLaVk5NQ4B88GFhA7qD6srLFBMa73rfw/+X4ft6lWuQi9iF+Beoas6oo076MDDT
	 dc1jJW2aWUZYMOiZpkHIwOS+Tm73vMANp4FS5+Juouu8SN5gzZw9Xqu6esm0yhpSi
	 yDTER4plG3zLCj/CpTHlQUlHkYrKcF9WPH9y7VYqYlIlM2hVFbV2/WvFLnkAOoXBQ
	 fRrAjXk9X8TYO02okw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N0oG5-1xAsyv00eb-011pM8; Fri, 31
 Jul 2026 13:12:12 +0200
Message-ID: <11be35c2-7ede-4c83-b21f-39e52c3b04a2@gmx.com>
Date: Fri, 31 Jul 2026 20:42:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Lockdep circular dependency: btrfs_swap_activate() calls
 sysfs_notify()
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <782c4d5c-d93b-42b3-b4ca-58deb3d8a894@linux.ibm.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <782c4d5c-d93b-42b3-b4ca-58deb3d8a894@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UYOPKNmzi7e/S+5HmyIh/Z8qgxTugS+rlwH1jf+z0haB3rKcKsP
 ZtOM8pWrHCe911ZrYFOM/a9UMblKMxyF99xRIVuOq1LPExM4gpUc/Zi+Ff+O/ALlYMCpXQj
 DECnhP5JgknAnZ3BBDiaLsNxAnOF51KGui+s894CPXp6N6I+wbaqNgtHzxRo9L8ReH57qnC
 lpmgLc3oAH3Ht9junndlw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FdcKv8NlJJ4=;MBLfdto4JdySYc5NNL4dIJZI30+
 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
 XSH



=E5=9C=A8 2026/7/31 20:27, Christian Borntraeger =E5=86=99=E9=81=93:
> One or more of the following files ( btrfs-swapon-kernfs-repro.sh )=20
> violates IBM policy and all attachment(s) have been removed from the=20
> message.

If the bash script, as an attachment, violates the policy, can you just=20
paste the content as a reply?

As I still have some uncertainty on the LLM explanation.
A concrete reproducer would allow us to do our own experiments and get=20
everything more clear.

Otherwise really appreciated all your reports, no matter if it's=20
generated by LLM or not, as so far your reports are 100% real bugs.

Thanks,
Qu

>=20
> **********************************************************************
> We had the calltrace at the bottom of this mail in our CI logs
> I also attached an AI generated reproducer that triggers this easily.
>=20
> For convenience, here is what AI came up with analysing the log, but
> I would like your take on it. Let me know if you want to see the
> AI proposed fix.
>=20
> ----
>=20
> btrfs_swap_activate() takes the inode's i_mmap_lock for write very
> early (inode.c:10120) and holds it across the entire function; the
> comment there explains the intent, which is to keep mmap writes from
> racing with the delalloc flush and the extent range lock.
>=20
> There are three btrfs_exclop_finish() calls inside that window:
>=20
>  =C2=A0 fs/btrfs/inode.c:10181=C2=A0=C2=A0 error path, swapfile on a rw =
subvolume
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 with an active snapshot
>  =C2=A0 fs/btrfs/inode.c:10202=C2=A0=C2=A0 error path, could not lock th=
e snapshot drew
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 lock
>  =C2=A0 fs/btrfs/inode.c:10399=C2=A0=C2=A0 the common "out:" path -- tak=
en on both
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 success and failure
>=20
> and btrfs_exclop_finish() (fs/btrfs/fs.c:224) ends with an unconditional
> sysfs_notify().=C2=A0 So the offending edge is taken on *every* successf=
ul
> swapon of a btrfs swap file, not only on an error path.
>=20
> The sysfs_notify() itself does nothing but a kernfs lookup plus a poll
> wakeup for userspace watching the "exclusive_operation" attribute.=C2=A0=
 It
> has no dependency whatsoever on i_mmap_lock, or on the inode at all.
>=20
>=20
> Both kernfs_rwsem acquisitions in the cycle are read acquisitions
> ({++++}), so the two of them alone cannot deadlock.=C2=A0 A real hang ne=
eds a
> third task waiting to take kernfs_rwsem for write, because rwsem
> write-fairness makes a later down_read() block behind a queued writer:
>=20
>  =C2=A0 T_swapon:=C2=A0 holds i_mmap_lock(write)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 blocks in down_read(kernfs_rwsem)=C2=A0=C2=A0 [queued behind T_w]
>  =C2=A0 T_w:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blocks in down_write(ke=
rnfs_rwsem)=C2=A0 [waiting for T_dir]
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 e.g. any sysfs node create/remove -- device hotplug,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 module load, cgroup or block-device attribute changes
>  =C2=A0 T_dir:=C2=A0=C2=A0=C2=A0=C2=A0 holds kernfs_rwsem(read) in kernf=
s_fop_readdir
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 faults on the user dirent buffer -> mmap_lock
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 -> btrfs_page_mkwrite -> down_read(i_mmap_lock)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 blocks behind T_swapon's write holder
>=20
>  =C2=A0 -> three-way deadlock.
>=20
> That is a narrow race, which is consistent with this having gone
> unnoticed for years, but every step of it is ordinary system activity.
> The dependency is genuine and worth fixing rather than annotating away.
>=20
> Suggested fix is to get the sysfs_notify() out from under i_mmap_lock
>=20
>=20
> real life log found in our CI:
> ----------------------------
> LOCKDEP_CIRCULAR (suite: tela-distro, case: tests/test_mempig/test_mempi=
g)
> WARNING: possible circular locking dependency detected
> 7.2.0-20260730.rc5.git10.af7a8a7752eb.300.fc44.s390x+debug #1 Not tainte=
d
> ------------------------------------------------------
> swapon/172010 is trying to acquire lock:
> 000002ea80a485a0 (&root->kernfs_rwsem){++++}-{3:3}, at:=20
> kernfs_find_and_get_ns+0x3c/0x80
> but task is already holding lock:
> 000002ebc465d270 (&ei->i_mmap_lock){++++}-{3:3}, at:=20
> btrfs_swap_activate+0x9a/0x1240
> which lock already depends on the new lock.
> the existing dependency chain (in reverse order) is:
> -> #3 (&ei->i_mmap_lock){++++}-{3:3}:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock_acquire+0x150/0x3f0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 down_read+0x5a/0x280
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_page_mkwrite+0x258/0x870
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_page_mkwrite+0x60/0x160
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_wp_page+0x128/0x750
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __handle_mm_fault+0x1be/0x590
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 handle_mm_fault+0xa2/0x370
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_exception+0x292/0x590
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __do_pgm_check+0x168/0x430
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pgm_check_handler+0x114/0x160
> -> #2 (sb_pagefaults){.+.+}-{0:0}:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock_acquire+0x150/0x3f0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_down_read_internal.constpro=
p.0+0x54/0x120
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_page_mkwrite+0xa6/0x870
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_page_mkwrite+0x60/0x160
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_fault+0x132/0x4a0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __handle_mm_fault+0x1be/0x590
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 handle_mm_fault+0xa2/0x370
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_exception+0x1a0/0x590
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __do_pgm_check+0x168/0x430
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pgm_check_handler+0x114/0x160
> -> #1 (&mm->mmap_lock){++++}-{3:3}:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock_acquire+0x150/0x3f0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __might_fault+0x7a/0xa0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 filldir64+0x11c/0x210
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kernfs_fop_readdir+0x150/0x4c0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 iterate_dir+0xcc/0x2d0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __do_sys_getdents64+0x7a/0x130
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __do_syscall+0x172/0x750
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 system_call+0x72/0x90
> -> #0 (&root->kernfs_rwsem){++++}-{3:3}:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 check_prev_add+0x160/0xf40
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __lock_acquire+0x12aa/0x15a0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock_acquire+0x150/0x3f0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 down_read+0x5a/0x280
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kernfs_find_and_get_ns+0x3c/0x80
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sysfs_notify+0x60/0xc0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_swap_activate+0x83c/0x1240
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __do_sys_swapon+0x278/0x9c0
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __do_syscall+0x172/0x750
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 system_call+0x72/0x90
> other info that might help us debug this:
> Chain exists of:
>  =C2=A0 &root->kernfs_rwsem --> sb_pagefaults --> &ei->i_mmap_lock
>  =C2=A0Possible unsafe locking scenario:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 CPU0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 CPU1
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ----=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 ----
>  =C2=A0 lock(&ei->i_mmap_lock);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock(sb_pagefaults);
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lock(&ei->i_mmap_lock);
>  =C2=A0 rlock(&root->kernfs_rwsem);
>  =C2=A0*** DEADLOCK ***
> 2 locks held by swapon/172010:
>  =C2=A0#0: 000002ebc465d3f0 (&sb->s_type->i_mutex_key#20){++++}-{3:3}, a=
t:=20
> __do_sys_swapon+0x5be/0x9c0
>  =C2=A0#1: 000002ebc465d270 (&ei->i_mmap_lock){++++}-{3:3}, at:=20
> btrfs_swap_activate+0x9a/0x1240
> stack backtrace:
> CPU: 6 UID: 0 PID: 172010 Comm: swapon Not tainted=20
> 7.2.0-20260730.rc5.git10.af7a8a7752eb.300.fc44.s390x+debug #1 PREEMPT
> Hardware name: IBM 8561 T01 701 (z/VM 7.4.0)
> Call Trace:
>  =C2=A0[<000003f7d5ab4e3e>] dump_stack_lvl+0xae/0x108
>  =C2=A0[<000003f7d5bbef24>] print_circular_bug+0x1a4/0x230
>  =C2=A0[<000003f7d5bbf13c>] check_noncircular+0x18c/0x1b0
>  =C2=A0[<000003f7d5bc0510>] check_prev_add+0x160/0xf40
>  =C2=A0[<000003f7d5bc408a>] __lock_acquire+0x12aa/0x15a0
>  =C2=A0[<000003f7d5bc44d0>] lock_acquire+0x150/0x3f0
>  =C2=A0[<000003f7d6c447ca>] down_read+0x5a/0x280
>  =C2=A0[<000003f7d60ad61c>] kernfs_find_and_get_ns+0x3c/0x80
>  =C2=A0[<000003f7d60b3b70>] sysfs_notify+0x60/0xc0
>  =C2=A0[<000003f7d635653c>] btrfs_swap_activate+0x83c/0x1240
>  =C2=A0[<000003f7d5f1d268>] __do_sys_swapon+0x278/0x9c0
>  =C2=A0[<000003f7d6c369a2>] __do_syscall+0x172/0x750
>  =C2=A0[<000003f7d6c4baa2>] system_call+0x72/0x90
> INFO: lockdep is turned off.

