Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792580718;
	b=QeAJ20us1w9QA8bNxWua2hvbYw73BUS8r8ksjdikUzfe8fDImO00s8B41ASjJPQ9oCBg
	 tH0U273q7r9wo/9yzs69FKbzhzJ2Kx7l6dGTq+RsoW2DksHj4DDgDt87C20R7pdz59/L2
	 m9G4Qiyo+CkyQMGpfRDOKBp0yi+Dt2yHaPY2LtpCisKj6J7MbB8cCpKEXA4+uT/OymQk7
	 0iq9YIdaudPwD7LApQkmWpNce2c8g7CR8vTU5LlNn+o+TvFLMpbzBvQ5xIOec9RrBhYvH
	 46iSiZscXG8spXAdU089hIfR8UaTuV0iRZLdgliML383tWAZFD48iY7PEFucSnLWyjg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580718;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=DOTQm6emqZY0Bb/0gsOPqW6BxamrDHAqmZS2wA16IT4=;
	b=WwVnZ583/uV61eAuaGarg9TArvH5mkIX/kV1RCZAxtM+8Fm+yP5YHLuIz+X6KVnXyf5k
	 LR3WUQzZjBJz8d5rd3lQL7VwfHH5yScMVuRgACXUMKakxlcxUSv4YXEMislaOFdkorsL4
	 YMtcz1GMmfHihUeq8L1eqZmNSYDXB3iuYPCWxoDHbK8n4H6LIG319RYFNV6Gino6jm/vQ
	 GRTDsI88WuZIw7tj8aMXuTrUaMf1NJr5p2+X9mj5qdg2QWierj9CF67t2Cw7YPLfNS0Ib
	 0dVsZOf6ub7hMX3h6hFaKIR7tAlIClFpZvZSh0T6BvdUfiK/4qyAmp3gf/hHkgCenFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=IpSqAP4d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8FB606A31B
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 11:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD8FB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=IpSqAP4d
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso4758955e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 04:05:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792580716; cv=none;
        d=google.com; s=arc-20260327;
        b=eU6bmIi+B6mzGEoi/JFqdMw5bIXVa9PPsUipujvHFVtDhG9pIvDAC1eD8thP6cV3nD
         gGBCaCPWCM2HZD7PPGfuKIRwkIyxBim241Zq0on2EgD8U1J7R27jNevwniMkMI1d9ddR
         8kPAXtZ6qjA460QdW/ev9oTcoAacFDHbIl4ZmANRSxNMcUxX9OZKJUmjwkp2wJAIk9QE
         cMEVlRjQ2yXMvLKpvS1nz7OXOTLzfOrjUVvG63dVBUmgW3pxzMpT1zwfzsHL7UoXBVcl
         5PL6OT0Mkw94i9JIAP0kX6yAmAY7yISqic1he01C79VTNkhGWif+eAJPnGnW2arufH71
         BJSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DOTQm6emqZY0Bb/0gsOPqW6BxamrDHAqmZS2wA16IT4=;
        fh=qqah261fotVJXqUgpbbGDF4UfQY7n3t1nQC2IWl0fpg=;
        b=EjnRBmHl4UAgSnl9wXRojPC4wgmJV00j8zOt2FvVjeVUI7A/taF4prVKXlrBvATPm6
         k9/eVvoEXQ8zvK10L8O+Bh5L95UKIS2G6BpUm8DORJVJ+zKnv5nC9PLUNWFfZiVdQkQa
         8i1P/qTWLy1R4G+kwFFPW8FwgQvtOcGDm8lRMw/brgyODsHCQW1k4GkSxes8UXmDthtL
         QPlllSy2SDHBievThxiFc5Fj18bXJwwnSY8t6k53x1zVULGzPyslSdayVxqfjMGUfN7V
         5yyhSh9ZcfRh+gBzfRxXnMbBT3YZAzrsTZqKz+1+2e8jJT2hy8RESulOHJtN/PoShKyr
         h8jA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792580716; x=1793185516; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DOTQm6emqZY0Bb/0gsOPqW6BxamrDHAqmZS2wA16IT4=;
        b=IpSqAP4drszOfzyUaWtE4Vb9AHMrHPLM8QA+/eeI7wsBlEhCq2YVFPBGuMD1FfjXdP
         6VG0YsmwYHb38Uqa5yS7bjKrotuJzhLzo6eDUd8IW/F+ksgDv2RstGK3TthSMwGE4f1p
         YMlp3Sck1SVeKroUH5e8jVBoY8iXDRyzxdJNZ6c9ICy2kk2WspSWT7+NqVzoHhPLIqQK
         4Iwle/v43l0ySIKuO20zM4I4z0n0dpKtdpmKRaIEx7PTBa82Y26b7/k7OzXJ6V6hBcwa
         f8ikvR6tJoIdtu7ktZS9ZcJF1Ul3zkyuu7AdDF0naNI1Su8tES7DkUKB1v8Ks5BoT1Lv
         uu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792580716; x=1793185516;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DOTQm6emqZY0Bb/0gsOPqW6BxamrDHAqmZS2wA16IT4=;
        b=y2OPCHSxfTQGVllH1cyp5+cu/6ngGLHk1YnBo2seGb6BPWtPNERf2bk3DDHGAbGEJa
         njDkFbsBkefccvET97Dk1lkS3LRbR22yldNBX99hTRF2h+Irossj5r3Ya5Idvjm9pRHj
         Ek1NopakXh23y6EE9a8XdCbf3CNEdTP0Rp78nkkf6GeFBvdLwvPkTMahcEY3sWck6ati
         lIh+r54z4y/nfUfltSa3MabgtfmCzSEleMhrv8CRugmtu9WAb4DgjK6LMGTLN/0E20XK
         qQEnndbzS87KtFdaZgBIN9V7uy249+Vyewr96u08WYEF6qUOgxYTU6Fut9V2fEC/pBFv
         xLdQ==
X-Gm-Message-State: AFq9FYLEnwLXVvJJDCC9cyxkOpzSFoDTfxGmGt2z/XQxsgMC8zOTqWMm
	89fA19u5RLsajOsB5P/pl4XdQq84j4ih58cZQJm+1UGmqsuPr+oeE6d2L+LPlxJIyqQm+pJOu+b
	5miowd/IfT3E46wCIux7Tk8noRQkzmu1KaEEGorH3luyCaZ1QG7Vg/mIgQQ==
X-Gm-Gg: AYBFou3AFdnAqFZ8gdGYfcxjVwoN09FVswlCV3zyBm3qvNNOVkl2LaMylxaLPuNx2x8
	IyG9tTbprSmuCzhWA0dNk4XUp/TBrLcr/789Nmm24r3gPHSnqTDCa4n/7VhXdQcMaQ5suEoUrcO
	oQI+hlVDeonDYMGvB4sFex2EVXXBvRnOrCFaRv4LQ54ouPljwVRbv2DE4NLIopE6oFSRb2Xzp2h
	wcZUdXpfkrBb4Tz7ADWIHa+9s3cgPr14KCC8GOsAo4JjSxPLS6GQelE+1BxiY0Ze2dmYoBwhi/g
	RAW5DSYG5whevVoXDa+FlRCODLyaBlcR1BPEOcfz0vEgdyj5rRobi2p05G+8i1T++ttje4M6pcr
	s3CTgNHMuzvAvasvcIFul1V82dvAiS+5dI/zYTtvyxT+gkgBKdvfyj6Xp7A1UPybw4wu6Oj1nnu
	GxK8wR6K7YtukDLOS6AkAYj/FtyVAayfG2Zw==
X-Received: by 2002:a05:600c:3b22:b0:4a1:dade:f049 with SMTP id
 5b1f17b1804b1-4a1fdd19f80mr34007375e9.15.1792580716053; Wed, 21 Oct 2026
 04:05:16 -0700 (PDT)
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
In-Reply-To: <SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 21 Oct 2026 13:05:05 +0200
X-Gm-Features: AclHuK9n9d5C6a7qAudn7dUKMtanJA8IfX649azRQwDEbfX8w7JQSb36INI3T4s
Message-ID: <CAPjX3Ff-zn2hda=deMvCGM1UMM6Zghh-ywabBMTqFUbzC69YEA@mail.gmail.com>
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

Thinking about it again, I don't think this is a livelock situation. I
think it's just a severe lock contention due to the number of
threads/CPUs fighting in a tight loop (due to the
btrfs_commit_transaction() and wait_for_commit() design) and as a
result the overal progress and throughput goes south.

Would you mind testing the below change? It passes my tests though I
was not able to reproduce the exact situation. I still believe it's
going to address it for you and restore the expected performance.

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index aa03db69a016..569f5a5c9b91 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2536,6 +2536,10 @@ int btrfs_commit_transaction(struct
btrfs_trans_handle *trans)
  btrfs_clear_space_info_full(fs_info);

  fs_info->last_trans_committed =3D cur_trans->transid;
+
+ spin_lock(&fs_info->trans_lock);
+ list_del_init(&cur_trans->list);
+ spin_unlock(&fs_info->trans_lock);
  /*
  * We needn't acquire the lock here because there is no other task
  * which can change it.
@@ -2544,10 +2548,6 @@ int btrfs_commit_transaction(struct
btrfs_trans_handle *trans)
  wake_up(&cur_trans->commit_wait);
  btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMPLETED)=
;

- spin_lock(&fs_info->trans_lock);
- list_del_init(&cur_trans->list);
- spin_unlock(&fs_info->trans_lock);
-
  btrfs_put_transaction(cur_trans);
  btrfs_put_transaction(cur_trans);


--nX

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
