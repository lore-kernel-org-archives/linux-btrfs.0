Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D2C5476EA
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988407; cv=pass; b=eq74CN085zCrTHUlkQvci/i+ANB8eOl6RaHZ65cPOL9y7jnrGVCb8L0wfBcI4SJo0+4kkIFfMCBxFInpvhBbB5hdwRTFweB9aVN8GOtC9/HtvmpIek7zSrMSFUqoaF5NTddvaTPoeleFyB3NtY4KYZw75r3fyA53pLaNT8xl+Hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988407; c=relaxed/simple;
	bh=K+JgZANM79BMzvdQQbgZKcxf6FA9Q4RzNg49G9leob8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JcFvgyoqPZzfiXFZOewEUJro2+mTJikrlG0OoqxzF5yeBS52VP0mP46Gz1NhCCTlYyqqRkH/EWsiT9IKmHxXg7KW30tX4KEVIkj7j/8ZjiFt5TU+MSO1bEWMieRhlYXvCUwgWpAqMw/Lfy5h8t4XRhBoRax+TWLlHp7+X2WSi/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a+C0p2Mu; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a+C0p2Mu"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso9699715e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2026 07:33:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791988404; cv=none;
        d=google.com; s=arc-20260327;
        b=Ybkykjrmh8A0SvH8DJ1nHNb9RxgiFPEfcxRKpxScQZcoqcaaW82e4fq7kEhypGyiOi
         Wdtjab0ax0SX5wyppWrKJeXNgv09ibOPj/JDuTxuWzGUOcVLNZy2OH+nrgUJw3rASU42
         YtLdUXqRpXhfcKFRTz+vv3UgeSAR0O3iWBhTw/liDGWR72r7CU7WqeWTHDq/WnYycydn
         I+GB2iNYgtL99opsrn9ffczqweJlSL3bBPDAC+IBXxNCXbIlOh5hjoa40XrnNkhvLCD6
         gD4J6wuN4a7Gs4g58fUrknuy9q3QwNKiETHsOrKSpGw71r+iRC0p3KOnotuu1Q7BJFn6
         PPWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+qP4wN/W7q9mY9yMUiSCR6CJLQY/nrp9KPxCim2wkG4=;
        fh=qqah261fotVJXqUgpbbGDF4UfQY7n3t1nQC2IWl0fpg=;
        b=JD1aP1hwa0fVZLzVjXC8Sm5YflTMGK6GHYyA3cnop+4Zm4B0O7cwowM4VKI3yEbYpI
         MExgSmJcZJ/KrD/fiWNDpiZ73LHP5ecj6ytpqQBYFycl2ip6cQjch/pxeecIKM8ZkbYu
         srtKYNjgbKStkD4OnG36YLdZUMkt0AKinsGqswqOMQgs1FjoK4m2/a/5OaDjK/ME0uMZ
         MxwJj0VGA7kPiqz5Iq8fImyqaLFS6HdLTyYGNDCG8vZkj6vei0QgooWJc8vbCm2GUjGI
         JlvHO6mUwFCX0xlnwiwha/8VQADGdv3VdgB4iackFkc2ZX1xb5NENHy5B0e0EzY+69Z/
         iKtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791988404; x=1792593204; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+qP4wN/W7q9mY9yMUiSCR6CJLQY/nrp9KPxCim2wkG4=;
        b=a+C0p2MuoVzY0B+645+oOhNVuiNxhUr9HymYllEcu6hXUEmIEQP059CIUDcf3XHLci
         QKXt0W40srn57AU+FgZWBh+ZgPBzDMLp9ba78az8BJQujvSEENxgR9A1sWGGU9ZcuTS9
         pa93GmOQoAGDA5XaJDEch/QvI0zZisYYqPv4W9mnundXjActe9pO4bOPyfEqJUWvr6rv
         oHxfyNTpkAHzBdVO6Q0Jkg/YPCejiRgdXSRvUGG6LZfnKw3lRmuWzMKjp+bRaBpYxk8g
         d32F8h2A6OurooENXlUhI8k0Kf7GiJ5ON/dvWzgNgBOFB1zAobuqZL1JQaEq5IB/9ThC
         o3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791988404; x=1792593204;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+qP4wN/W7q9mY9yMUiSCR6CJLQY/nrp9KPxCim2wkG4=;
        b=CiOhC9n/mjXTPQL5SXyKmhORSFP2sowgJML4v7kEboWIBU7G0TsILnKiehMJdqRPpL
         qaGoDJSY48iw6/E7wx2Gykxyq5NZjC6UqLF64tNy46+zxPFsVcN0F8mMzjFt0hfRCr8E
         HXycb+cvtPzgX+R17ctJ4H0qI8wJJD2S2gsWTOw0sGWxpSZLucX7DnPrQUIVUUMRfZxa
         IxhfFZVf/ri5GpDd0D6gm0yjmS1RfqvGkwJrkHQszsFFYNJyvjYTITP/AdKJL8IxNIcp
         VwwLAKuQoL5KKcMWsEq6Mid+6/2oGOV0QFu87UsxJyaIH29QllSXjHI7YtwsnkHXZy2T
         zfIQ==
X-Gm-Message-State: AFq9FYJ2qW95h3y5lAz+Tx+8Oii24CcyXjROnrj+WXdPzG976lzSjYKV
	yFWcRiq+Jy26RZqJksEbIqII3h8x/2qXwrulPldRbLdJ9MEpXQym5GJLoGZmOS1mIa6eKA52Pig
	XnFlCBAs8VHdQXSEbEu3P3/b+UPDoBCNLGhuuZAvgaw==
X-Gm-Gg: AYBFou0tenc4kPZ2Mcza3EECJ9f2K7bx8DoMU76BcdkyCXOl1R52jd0G4RHz8mxZw4V
	K1TGwaxcAVIMqOEnlZRj6aiRY68wPypp/3JTmN3nDHu7YRA+GUtCFbb7TffZ50nOC9c0uxjckDS
	lGHO62UciX49UM0mxqnHmzUexDhOYxIfIyOk/fW0WqQiA3oqbkcI5fDDwa9dVIvJAPtqOBvEJYd
	fiYZ5lcOu2mHV82RiX0h/Xoe6ySuHw+OozO7wAuUKe6eM6rHpR3YGU2kJ7zomJCKNJA+QDfsUB9
	CxCs+uOnb9cTTTXb3Nl0eL8GeLj/jb8+rqRMO55v3k9BLXvyK1Eb5qtBsMwczCFe3xynx54FzyX
	bxwR89Vy0mc57xkYL5v3g+JzVQQ/4ihMg+tC+3oj4Rhn0/sVsCfrS9A==
X-Received: by 2002:a05:600c:620b:b0:49c:fc6c:be19 with SMTP id
 5b1f17b1804b1-4a18e4d12e7mr294161225e9.31.1791988403765; Wed, 14 Oct 2026
 07:33:23 -0700 (PDT)
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
Date: Wed, 14 Oct 2026 16:33:12 +0200
X-Gm-Features: AclHuK9ntosaQqea3B0H-ho3RLxvBMrtB2ReBZ3sn1YIETu04qzIUmr69db_Q4E
Message-ID: <CAPjX3Ff8LVf_ZWmWD=SY1MoX2V-W+_MyrW_ubfaKhsuh8rMyBA@mail.gmail.com>
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

Neither of these seems to come from an interrupt. By any chance, have
you seen a "sleeping while atomic" error in dmesg?

--nX

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
