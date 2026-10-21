Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792568523;
	b=hjHu19vDsG3Yt7CNP2B+leN4pgpEOefZUGzkaKv2wKqilcWS087YTc2FKTn2C0n4LE2f
	 4n851ctRmIQfUb9s1hqVmZGDwbOT774DBOoJSdC+4BMUUqbKxwrxJnpzWAPxEtqw8JV4W
	 9i7YBa7U/NRtIxmwnXUbId0/yMgnYF5NOaftgHLJwnqsgua764iufUerG6SwVpuMDPerG
	 vvWwTTpP1iMQVkD5CAENY95QcnOYIdk2eyBsjW0Qj7Xh0jDjBKj0YWLzZuRAaKTIc/vPR
	 tMNNWLBWG0kulsYN4hYk+TIltp4GoqwIeS1t84+adi70QT+aomvVeqZc74Wz0XI/Xxg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792568523;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=QXR8ZICQN4QoDyLGwktdVYmEMXS0QQpfxluA3CqdAVI=;
	b=HYlFs+9Bh9gj4+em3eu8pt1+QdHm03pkVF3kld5OkboMfhBFwSK4nDQeubjXblJh5Feh
	 ubsJmp9vFJxOflGpOpv5ZVnpQzRLU/URywBP1V3phu/HbxAjCdngU2CC5PuUNrNznATIS
	 hrzEL+GhR7v77qytIVFU0h6Fbr+UdnIpoS71MmCF1AC9gFZKWZU8B+cVh6dFxuYZCIsJh
	 BgozGEWiE4PzQY0wNQhwRQXxs95hXB++aYaAcFdkUDnehQiPCg5QZ2OyHM5n0tAzN+YV0
	 m5jvSMg3ni4UtLwaYcPaWubfLhpvvpjmYsjyb4SsqzsxQUlnznyed2pfA4bnfkyQ/oA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WKwG9S9p;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADCDC606A319
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 07:42:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADCDC606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=WKwG9S9p
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e0d1da913so320380f8f.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 00:42:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792568521; cv=none;
        d=google.com; s=arc-20260327;
        b=bHPTsYfJUtVYby6UvcvmuBfcSPsS66+Q0sxc9+6TLQH/nky4cqVV3H2FIJrnvIcCVw
         9x9j3UZ5EeVf1sKMq2EVdEuKWXnRHw6B3jeA6QqrnjuOQjm+EEVSEzrSYGK1ts1VT4A2
         7egEatF3aqDRskIsX2RZjIEbB6qLWGm5rh8tWByekns3axx0X9Ad/ALvSKiI8dtQRY1V
         rcj+LH/UlqAckVk6Ge/2igWVAj0c5bsxLmIK2xI3RNla20384uDjrS0H+n4mt04mKjId
         863m/ncLoxaB8CYuXAW/KfVGw8C3/pJI0IPJ4TbzMWHtQ9yV424XXfVW4Xq1iB8+LQpS
         Ozuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QXR8ZICQN4QoDyLGwktdVYmEMXS0QQpfxluA3CqdAVI=;
        fh=qqah261fotVJXqUgpbbGDF4UfQY7n3t1nQC2IWl0fpg=;
        b=Fk1JMg3mlDgnMU3haWQn3ff5Kuph7v61DWqIGl2577pzrGvk6kdqsaF/gncIcGYLKi
         B07+rRVURnvVZ05+YOTT4lJaiVUN0dJ3xWuy4wjIyVBQWlRJT0nvszUQhy8BhhBcUNxs
         lXgC+UpJl4Fn1ELiUM373JU4cpVuS2MeR12q+fCqqP/BS4kZFfHBwIKxsLdnWSGn3B9h
         RG1OHUrZQAR7sHc/ZYDwLrdGIVYkGNBsvgSKrI2PDtpi1E2SNp8uMUwHo/QfoRz3OpZa
         ibx0ffM6mBMMcC5MXOhY0KnRUAqgPWMHNooCElwUr3J27vgqQNQrrFX84VaQruggXNv0
         a8vg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792568521; x=1793173321; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QXR8ZICQN4QoDyLGwktdVYmEMXS0QQpfxluA3CqdAVI=;
        b=WKwG9S9pO/F/XvRf/Re7VcukvZiTlH+Nw6PvsX5Zv7DzwVaLdM4ycgU/V2Noo3aTIB
         nzOq7+cM5L4P8mP1MiIVSJPI6v85ym+YblKD/ffPycy88LvtP9uz+v3ZUcz7VnC5kI4P
         dasXfgVagfdbU1Y1bK4a7hkpZfev4nBQdVW6DHPL0DnD9nioRxS7IJ57gtPn3AviCNvh
         49vCdpQzJ/Jy4WRn1VgcubEdv6mCl/CXW3TSlvalpAVrDkkHVD5ZcLrSeCefR6iyqLOH
         WQIU/vG5VQWoIza96nTZ2TYLsRxhReVm4Hbj+H6nOOtUwUzTj9S5qAklqwyuazSsXahf
         RuaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792568521; x=1793173321;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QXR8ZICQN4QoDyLGwktdVYmEMXS0QQpfxluA3CqdAVI=;
        b=lq4Qdepr0uXr5dkypYC7wbrFRCLwkNSzCcs0PJBt7dGqvx9CJg6guT6yftLlauT3PX
         XJXxXfXBMGBsPZX31YZXb16b8jyNKUDvVBcSwIRE12vOvB/8A9gMB7+rkeabtkpuGm9E
         JngZSddOD1CHty8ldVidIpg49X1iX7ZQHgZbC1hhlp2EkRodzRc3/oc3KPBctA346EAq
         XlABd/8BQqzr9dyZb4ofWzrdYOdD46nxU3BoDPbjUmKzgo3hJZ0KnanNwk/Jvj/0cNlm
         eV7IerlgjFnKPn4Ez1Xm85hzDjaJkPYgTVBfVQCguU+XjQcdRmv9la4z0Pj1sS6PhP6V
         ugaQ==
X-Gm-Message-State: AFq9FYJxQIcxig2YcW7j6NvxPJQWtDq7U1b6U/oYJsjySni/iM5pYWPY
	FKvJEbPkYWMV+1Xt+ovfaZ0mz9D/mGByN2+u0bJ6dcMk77W6otpyuBXk5JCSh0ZSipXOL2hS10y
	ZAmmHLicRPoR3rO+V9we9Rg/crJLqGRk7fxZuE8QjYhSp4LeHfyGaFedQVQ==
X-Gm-Gg: AYBFou2RG7xIhReNNT4z6jMLd11gpL+agRQQxEjJiFd25+ErM/w2S9iAXYEs88+TkPY
	E2l7M2fHUYctWReHuWgpCBbgl6dlh30kxka/braVQKuvBrMEcjbCvWw/rCzVndDaNeRwdagGu0r
	gXYFic9MJUgks0mWlm8x/So4ToQd9UEEsuIryH0Y/R/3ZGObtL5230eVFnvhi0iLEs2Skaynh8a
	7I03bONsVSlcSuE1/E9/Vfx7EaZI8NPrQV4AFBpMzU0J3uAf/ncIWm+9V8rpRKGKo4wTQ7NzEgA
	KWCyQlz7tZ6fejQCqoZ8uYlxMxn2xQfuU8s07XETZdiWN+r4XYP2BLqvnnsQevLYwcEFFNv3PNQ
	uaP/CkF5DIBBZlJAZ5HyP8uzyIaMu+9U2yDgArnd6xdo7spfWmQDhUT5YYWNBwt99wOHuACbwU8
	ShAcm05xMF+O2NkIjLCi9Klgp/hKrBEraaoQ==
X-Received: by 2002:a05:6000:1a85:b0:48e:1b11:7ee6 with SMTP id
 ffacd0b85a97d-48e26421274mr2503357f8f.2.1792568520902; Wed, 21 Oct 2026
 00:42:00 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <PH0PR17MB4277167A37B20340B231443FBB922@PH0PR17MB4277.namprd17.prod.outlook.com>
 <SJ0PR17MB4288FC2E7FFB577F5D6C6D9EBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
 <CAPjX3Ff8LVf_ZWmWD=SY1MoX2V-W+_MyrW_ubfaKhsuh8rMyBA@mail.gmail.com>
In-Reply-To: <CAPjX3Ff8LVf_ZWmWD=SY1MoX2V-W+_MyrW_ubfaKhsuh8rMyBA@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 21 Oct 2026 09:41:50 +0200
X-Gm-Features: AclHuK_Sr1YCyWP2xl6VVl4sjz2ONoMPWjMZj6uQvTKVQ-cw5jjrPMvB1zMB5v8
Message-ID: <CAPjX3FczY0fe3SfoLkY7hsBPWpw_i5wvPePTaxubMDhW5DrjqQ@mail.gmail.com>
Subject: Re: Btrfs PREEMPT_RT transaction-waiter livelock: experimental
 mitigation in kernel 6.6.78
To: "Naulls, Peter" <PeterNaulls@eaton.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Oct 2026 at 16:33, Daniel Vacek <neelx@suse.com> wrote:
> On Tue, 13 Oct 2026 at 19:46, Naulls, Peter <PeterNaulls@eaton.com> wrote=
:
> >
> > Originally posted to RT mailing list, see post and replies there:
> >
> > https://lore.kernel.org/linux-rt-users/PH0PR17MB4277167A37B20340B231443=
FBB922@PH0PR17MB4277.namprd17.prod.outlook.com/T/#u
> >
> > ________________________________________
> > From: Naulls, Peter <PeterNaulls@eaton.com>
> > Sent: Friday, October 9, 2026 11:34 AM
> > To: linux-rt-users@vger.kernel.org <linux-rt-users@vger.kernel.org>
> > Subject: Btrfs PREEMPT_RT transaction-waiter livelock: experimental mit=
igation in kernel 6.6.78
> >
> > Long term kernel hacker, but very infrequent contributor.
> >
> > We are using the RT kernel patch on x86 under kernel 6.6.78-rt51. Speci=
fically, this is the kernel from meta-intel in Yocto Scarthgap in the intel=
-kernel-rt recipe.
> >
> > It appears under some high load conditions, and especially triggered by=
 calls to sync(), there is a live lock condition in the btrfs code. I used =
copilot for this analysis, with apologies due here where relevant. I'm fami=
liar with kernel code, and I'm well aware how complex filesystem interactio=
ns can be.
> >
> > Here is the lock we observe:
> >
> >
> > sync (PID 52371)
> >   btrfs_commit_transaction+0xc48
> >     [return address immediately after rt_spin_lock(&fs_info->trans_lock=
)]
> >   btrfs_sync_fs
> >   sync_fs_one_sb
> >   ksys_sync
> >
> > ordered-I/O completion workers
> >   join_transaction+0x2b
> >     [return address immediately after rt_spin_lock(&fs_info->trans_lock=
)]
> >   start_transaction
> >   btrfs_join_transaction
> >   btrfs_finish_one_ordered
> >   btrfs_work_helper
> >
> > journal/fsync callers
> >   wait_current_trans+0x33
> >     [return address immediately after rt_spin_lock(&fs_info->trans_lock=
)]
> >   start_transaction
> >   btrfs_start_transaction
> >   btrfs_sync_file
> >   vfs_fsync_range
> >   fsync
> >
> > btrfs-transaction thread
> >   transaction_kthread+0x76
> >     [return address immediately after rt_spin_lock(&fs_info->trans_lock=
)]
> >   kthread
>
> Neither of these seems to come from an interrupt. By any chance, have
> you seen a "sleeping while atomic" error in dmesg?

I reviewed the code from tag
lts-v6.6.78-rt51-preempt-rt-250304T022441Z in
https://github.com/intel/linux-intel-lts/commits/6.6/preempt-rt/ repo,
which I believe is the version you are using. Specifically I audited
all the usages of the `trans_lock`. Though I do not see any code which
could potentially block while holding the lock. There must be
something missing.

Anyways, perhaps you could get a hint from lockdep. Have you tried
enabling it and checking the log while the reproducer hangs?
Possibly, could you share the reproduces shell script you mentioned so
that I can confirm and debug locally, please?

--nX

> --nX
>
> > The processes are then not killable, indicting a kernel thread problem.
> >
> > This was largely found because our userspace code calls sync() excessiv=
ely (being separately addressed), although that's not the proximate cause. =
We ended up writing shell script which writes blocks of data to a brtfs par=
tition over several threads and also calls sync and were able to repeat it =
within 10s of seconds. It is not repeatable in the non-RT kernel.
> >
> > To add:
> >
> > I have been extensively through the later kernels in 6.6, and later ser=
ies and have not found any direct fixe or references for this. I've also be=
en through the latest RT changes and btrfs mailing lists/changes (and this =
post might be served better there) and cannot find any direct reference to =
this. The only close match is:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit=
/?id=3D99da896614d17e8a84aeb2b2d464ac046cc8633d
> >
> > This is in related code. I put this patch into our 6.6.78 kernel and it=
 did not resolve the problem.
> >
> > With that in mind, I had copilot (again, apologies) have an attempt. It=
 came up with this:
> >
> > # Experimental mitigation for a suspected PREEMPT_RT Btrfs transaction-=
waiter
> > # livelock. wait_for_commit() can reselect a completed transaction that=
 remains
> > # on trans_list after its waiters are woken. Skip completed entries whi=
le still
> > # waiting for older incomplete transactions. This is a diagnostic hypot=
hesis,
> > # not a confirmed fix for the observed lockup.
> > # Review notes: the scan is O(n) under trans_lock. Completion state is =
published
> > # locklessly elsewhere; READ_ONCE provides a single load, not acquire o=
rdering.
> > # A multi-hour run did not reproduce the issue, but the lock owner and =
root cause
> > # remain unknown.
> > diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> > index e15e1855fa0a..0f05fabe451c 100644
> > --- a/fs/btrfs/transaction.c
> > +++ b/fs/btrfs/transaction.c
> > @@ -865,6 +865,7 @@ static noinline void wait_for_commit(struct btrfs_t=
ransaction *commit,
> >                                      const enum btrfs_trans_state min_s=
tate)
> >  {
> >         struct btrfs_fs_info *fs_info =3D commit->fs_info;
> > +       struct btrfs_transaction *next;
> >         u64 transid =3D commit->transid;
> >         bool put =3D false;
> >
> > @@ -893,10 +894,16 @@ static noinline void wait_for_commit(struct btrfs=
_transaction *commit,
> >                  */
> >
> >                 spin_lock(&fs_info->trans_lock);
> > -               commit =3D list_first_entry_or_null(&fs_info->trans_lis=
t,
> > -                                                 struct btrfs_transact=
ion,
> > -                                                 list);
> > -               if (!commit || commit->transid > transid) {
> > +               commit =3D NULL;
> > +               list_for_each_entry(next, &fs_info->trans_list, list) {
> > +                       if (next->transid > transid)
> > +                               break;
> > +                       if (READ_ONCE(next->state) =3D=3D TRANS_STATE_C=
OMPLETED)
> > +                               continue;
> > +                       commit =3D next;
> > +                       break;
> > +               }
> > +               if (!commit) {
> >                         spin_unlock(&fs_info->trans_lock);
> >                         break;
> >                 }
> >
> >
> > Note the O(N) time here. To that end, this is very unlikely to be the c=
orrect fix, but I hope it highlights the core problem. I ran this patch for=
 several hours with no apparent problem (versus seconds of a lockup in prev=
ious testing).
> >
> > If there's a later kernel patch I've missed, or something else I ought =
to be looking at or test or need more info, please let me know.
> >
