Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4F3545DB8
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 14:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791987802; cv=pass; b=SrAm2ZfK+mRFjM9HL9XigP1nS8ShGyUx+z1gDIuA8GUAuNauzRi8hn979tn66oepzpyXqXco/fj6IZcSSCBj0I2oPSPmCAJG45pkORS/fmOUkiLgxY5Unf2xEUSMr9wrhird0TZwck5RSA+tZY0EO4nQT4fGyaoN3m3FheBdmhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791987802; c=relaxed/simple;
	bh=NiwtywVpF1DyUrG3a4dzxvtWIjOFJFwcSiHnDjklwSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W+uhkhXT9tIIBlwUq//phl0SF++dKzAltVHapVyHz1w5crOgHrhM0be4/k24RKwTKINfnIAZJfbvl5aHLeah1ufoMQhlw1vW8zAkptUyjfZYXWJjVBbkmiA0clYIlzJwhpRoTfVL9aYfVEZngXegpbsHftePaDpt1aDs6eb8PYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HN4eZ5zL; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HN4eZ5zL"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b02b1b4cfso3952195f8f.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 07:23:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791987799; cv=none;
        d=google.com; s=arc-20260327;
        b=d7u9GFRAt7UNp7unZoQmw3/7b/uoCYM02dH0eAQXy/ueyKBcbqbBSQIKwKwr+/Ywnw
         /12iVHZAbSE8iiAvHBkYfCY8OnDJSsclqT24I4yOO1auKZDwnLZRGc3C+bHpQqg1vUdL
         A8o1XXcQAmpx8LzHhyhEray44Z97qleo9Y+ErFnotuC8iOF3h3x71DNdvdZ+pebACZQG
         BGySpvDQSuB+vnPWsFOtwsP2WaXVFbsPI5BlLyDMi3yjsVrOiF/YzST7roUdrdmh2htD
         T/e0F93Nbr4sdYDWYfzpH+g8snITE7Us1/kyMWsWx2aXTOUzft3bZnyAeQmCRAX7Q8z/
         7omQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7PVmPjFuUdThryUL5ks5u079XjN0XX+2XZ6PlbbwqYc=;
        fh=qqah261fotVJXqUgpbbGDF4UfQY7n3t1nQC2IWl0fpg=;
        b=hQiP3MFBWaqm8tFUos0yPYcBBiv+RCn2nkEb+10Ty1EY8XKwoKy42814fd82psCDRE
         g4Tq9/nDrtVG74rsIq52MQzIyunxKXGCQNOWGy9e/sb2IG0s/nc7Tco14crLeSENJv0G
         x61RwBOrj6cnVUcB8amZzvC2BUvWGuM8uj+QiJodECI8Ap57EIwAb5tnMVloszzBBG5/
         U5tY45lUJIWt5FKSAMGduMsou0detb21grfYDxNY1J7fARUX+radxt0KMx+culO+hr3E
         xS8qKT7qF//E+2SO1rihVIm6WWURUwxU+O1s8FW8/7rJvRXdeHNAIzTaGxfg2kXcPLBy
         UXnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791987799; x=1792592599; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7PVmPjFuUdThryUL5ks5u079XjN0XX+2XZ6PlbbwqYc=;
        b=HN4eZ5zLve+K51fdY4QkPrIKPjmd++6ivFI9S+ONmZro5b79zesw3KcM4MAQAC6nYv
         Xwd3vnqorR7xsMz3lJFVHmLTZOmeTB9woLJLZnBHsmWXtAtKCPfdHFZbeGWNIZ01jmKN
         6/HhXBENsQLXU6qz2FfINmb0j6Pz2mqYshFZTA9A1YumpH4VW6h7O9CYPJpvLssrEGzA
         fNntRnYgi8TuwUvpkL4FsEguXybhiRsVHbCjR0hk0TFg6QfVdgSxiT9xz+kqHirRGl5V
         qvWTRihhV5v6W1lNYUJmYFx1xWuIk4cFSDbv+rIjN8YFRhfPg19E1chBICnU4Ry7cSpM
         6vHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791987799; x=1792592599;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7PVmPjFuUdThryUL5ks5u079XjN0XX+2XZ6PlbbwqYc=;
        b=MzjbAJbMuwLfu7dqurB5eopqsqnaaQQv0AHse7KIr1vvU7RkM93La9rPDAK29EcOhF
         9e6UTXmtjOgCISikTWHudLa6xZ30J13ABoNbdNByKGKngvKnLUBqw5RX/pnzJVL0VCgK
         qItUV5qESQddbLhqqDpfermxsIMxYcaDL51101N4ELu+PJ9/q1JiiEO3i4qnfTT80AgQ
         Vw8KIsXs8F/NMzzvznSdXKhZKkMVD6VSDNY7Yq24CJAFdJVtZFPJj5yX5Jh5B1owRHHu
         /GJtrUCjf+Le/ULpBihFvYR0u2loKHJi9npQscJLrRc5LHsELEAIStPIwEPZoqpdUdW2
         jkSg==
X-Gm-Message-State: AFq9FYJy2kGO6A6tvLC3SNptJofMj5Iq7FEVTHZNCOeRDRutkztRX9Nc
	4YHmZVtGY1Z+CyiiMs+TAgdZpwDrWEgbsa+JoDEWQpQOHRfPvSZVC7690MXD/f8CphDtUiyNEQD
	2hpuYPhUOPRMq+ijX9MMCQmXyBoPZG9LXwua68JVZRWrd9oMdtIP9Ias=
X-Gm-Gg: AYBFou3KjUGwo9SDbKZblPmQusmHpEAX6inb27LUtGhRfIdjDfK5n4n0kWl0Uhqnq4Q
	NfbKp/dJVuRlYvwlkKOqxmb9EAFyZYtt5/IBcJxBDnknFpAC08vl8Ord53o7aEH/MFjx/U/SP1R
	ZaBVIM4spm5DgsF7EYD0JWeqUDwjnxBf8Yn/ArJ3+sSEvNolXSAv9Hb+Fx+RIGjIE7vUgxQjbCa
	FQEbOGR3Lx9CaOWgZW5cTSw34bojsbWsApVP3AUtivtW65743OZO/swNCwfsg7Eg53n2RHfZSim
	qJXML6S8msphYEY2ksDmgkEtlq40eHkueE/qiyEi7C3vgUPSKl98WQbrEaiXn62C/y8Ipka+o5y
	/FuBd4zscGzSG2SV8EcSh1JL14oCGxPvV9k5jfXKbRSBGJ9W3AaoNVVroJ6bmYjC7
X-Received: by 2002:adf:e983:0:b0:48c:7f94:8755 with SMTP id
 ffacd0b85a97d-48dbaced42bmr26835564f8f.20.1791987798854; Wed, 14 Oct 2026
 07:23:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <PH0PR17MB4277167A37B20340B231443FBB922@PH0PR17MB4277.namprd17.prod.outlook.com>
 <SJ0PR17MB4288FC2E7FFB577F5D6C6D9EBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
In-Reply-To: <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 14 Oct 2026 16:23:07 +0200
X-Gm-Features: AclHuK8a4o_tZUeolpmUt3I9KFtbE6do_KQ4X_Lvvuy1cirVengjJ3I0x4ffgcY
Message-ID: <CAPjX3FernXMUSLo++4gsEabS4AJKQMfDyF2XB0w9A5-HY3qi+w@mail.gmail.com>
Subject: Re: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
To: "Naulls, Peter" <PeterNaulls@eaton.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Oct 2026 at 19:46, Naulls, Peter <PeterNaulls@eaton.com> wrote:
>
> Originally posted to RT mailing list, see post and replies there:
>
> https://lore.kernel.org/linux-rt-users/PH0PR17MB4277167A37B20340B231443FB=
B922@PH0PR17MB4277.namprd17.prod.outlook.com/T/#u
>
> ________________________________________
> From: Naulls, Peter <PeterNaulls@eaton.com>
> Sent: Friday, October 9, 2026 11:34 AM
> To: linux-rt-users@vger.kernel.org <linux-rt-users@vger.kernel.org>
> Subject: Btrfs PREEMPT_RT transaction-waiter livelock: experimental mitig=
ation in kernel 6.6.78
>
> Long term kernel hacker, but very infrequent contributor.
>
> We are using the RT kernel patch on x86 under kernel 6.6.78-rt51. Specifi=
cally, this is the kernel from meta-intel in Yocto Scarthgap in the intel-k=
ernel-rt recipe.
>
> It appears under some high load conditions, and especially triggered by c=
alls to sync(), there is a live lock condition in the btrfs code. I used co=
pilot for this analysis, with apologies due here where relevant. I'm famili=
ar with kernel code, and I'm well aware how complex filesystem interactions=
 can be.
>
> Here is the lock we observe:
>
>
> sync (PID 52371)
>   btrfs_commit_transaction+0xc48
>     [return address immediately after rt_spin_lock(&fs_info->trans_lock)]
>   btrfs_sync_fs
>   sync_fs_one_sb
>   ksys_sync
>
> ordered-I/O completion workers
>   join_transaction+0x2b
>     [return address immediately after rt_spin_lock(&fs_info->trans_lock)]
>   start_transaction
>   btrfs_join_transaction
>   btrfs_finish_one_ordered
>   btrfs_work_helper
>
> journal/fsync callers
>   wait_current_trans+0x33
>     [return address immediately after rt_spin_lock(&fs_info->trans_lock)]
>   start_transaction
>   btrfs_start_transaction
>   btrfs_sync_file
>   vfs_fsync_range
>   fsync
>
> btrfs-transaction thread
>   transaction_kthread+0x76
>     [return address immediately after rt_spin_lock(&fs_info->trans_lock)]
>   kthread
>
>
> The processes are then not killable, indicting a kernel thread problem.
>
> This was largely found because our userspace code calls sync() excessivel=
y (being separately addressed), although that's not the proximate cause. We=
 ended up writing shell script which writes blocks of data to a brtfs parti=
tion over several threads and also calls sync and were able to repeat it wi=
thin 10s of seconds. It is not repeatable in the non-RT kernel.
>
> To add:
>
> I have been extensively through the later kernels in 6.6, and later serie=
s and have not found any direct fixe or references for this. I've also been=
 through the latest RT changes and btrfs mailing lists/changes (and this po=
st might be served better there) and cannot find any direct reference to th=
is. The only close match is:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?=
id=3D99da896614d17e8a84aeb2b2d464ac046cc8633d
>
> This is in related code. I put this patch into our 6.6.78 kernel and it d=
id not resolve the problem.
>
> With that in mind, I had copilot (again, apologies) have an attempt. It c=
ame up with this:
>
> # Experimental mitigation for a suspected PREEMPT_RT Btrfs transaction-wa=
iter
> # livelock. wait_for_commit() can reselect a completed transaction that r=
emains
> # on trans_list after its waiters are woken. Skip completed entries while=
 still
> # waiting for older incomplete transactions. This is a diagnostic hypothe=
sis,
> # not a confirmed fix for the observed lockup.
> # Review notes: the scan is O(n) under trans_lock. Completion state is pu=
blished
> # locklessly elsewhere; READ_ONCE provides a single load, not acquire ord=
ering.
> # A multi-hour run did not reproduce the issue, but the lock owner and ro=
ot cause
> # remain unknown.

Right, the above does not explain why this only happens on RT.

Though the lock owner can be easily found using crash or drgn. One
could also expect it's task->sched_info.last_arrival timestamp would
be about close to those blocked tasks you found.

Would you mind sharing a vmcore (and (a link to) the debug symbols)?
Or eventualy the root access to the reproducer machine? (in case you
have an ephemeral VM)

I'll try to review the related code in the meantime.

--nX

> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index e15e1855fa0a..0f05fabe451c 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -865,6 +865,7 @@ static noinline void wait_for_commit(struct btrfs_tra=
nsaction *commit,
>                                      const enum btrfs_trans_state min_sta=
te)
>  {
>         struct btrfs_fs_info *fs_info =3D commit->fs_info;
> +       struct btrfs_transaction *next;
>         u64 transid =3D commit->transid;
>         bool put =3D false;
>
> @@ -893,10 +894,16 @@ static noinline void wait_for_commit(struct btrfs_t=
ransaction *commit,
>                  */
>
>                 spin_lock(&fs_info->trans_lock);
> -               commit =3D list_first_entry_or_null(&fs_info->trans_list,
> -                                                 struct btrfs_transactio=
n,
> -                                                 list);
> -               if (!commit || commit->transid > transid) {
> +               commit =3D NULL;
> +               list_for_each_entry(next, &fs_info->trans_list, list) {
> +                       if (next->transid > transid)
> +                               break;
> +                       if (READ_ONCE(next->state) =3D=3D TRANS_STATE_COM=
PLETED)
> +                               continue;
> +                       commit =3D next;
> +                       break;
> +               }
> +               if (!commit) {
>                         spin_unlock(&fs_info->trans_lock);
>                         break;
>                 }
>
>
> Note the O(N) time here. To that end, this is very unlikely to be the cor=
rect fix, but I hope it highlights the core problem. I ran this patch for s=
everal hours with no apparent problem (versus seconds of a lockup in previo=
us testing).
>
> If there's a later kernel patch I've missed, or something else I ought to=
 be looking at or test or need more info, please let me know.
>
