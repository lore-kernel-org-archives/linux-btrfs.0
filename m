Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793398717;
	b=MTZ2gWFW4henaGW9jXsfPnHPJ81BSkNjBGiFmPxhTfodrc5Ig+ZndzGfugHCo1t2ms6B
	 f24yv+nKwv4C+QDied+gGlH3RtHjHYf92aMHO7ca6pUTsw9fdD3lmtvnb6NTs3gL68mTx
	 2PaPrvemzvkAR6xp9KzMRxeJIUZDNMgK3JkRQN+scHGHljBDE//lyZu0eH3tSH7vUCx11
	 LTMpfs1vpfxNS21Ant0fIssu9eW3mJa1IJ7U3U7i3FCvVcRo0vjuPjYa5mgkF90xYcXQs
	 +/G+cZvz1nQ3o1/I69F1aDzE5UchjqvdDFKQyvFlhTnUi6OCEK9GELQWrNaxWzKHWaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398717;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=oduWj+GlQxLwzOkkNtIfxumS7HxJ34KJdwvcCvCC1hQ=;
	b=NFgKREMTx7jOt9MWqvX+o8vMssrVF88/64DjvELNwk1MQK/V57oMZnzZP3ypHKBwkvR6
	 fnLNnskapg68MuUVojW/TvMGoMyeafdO6mVrZINqcL2u7M2cHmJDzT5WoW6xBmiwmTGbn
	 8cjIqTxPOE4wW9c1KX0YHDkv6D22gv4pm5I8egJHViwCF9y3Y9pkgRp9Sdq9/ZGf80oi9
	 t/yO0cPRW6fKk07wzpiESApwBqNWBmCMTRRT3F2O1JTKCbZopyYOAjMzCVLUsh1dP55Cz
	 BVtaUvFUrBRQh0IDTHSuOEFvTHqB6v1MUSwBM0fMBpAUak4TMnXPoesLm0rlM+k7Gtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=N25W7GC9;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84295606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 22:18:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84295606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=N25W7GC9
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35d5d4a20so13084235e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 15:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793398715; x=1794003515; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oduWj+GlQxLwzOkkNtIfxumS7HxJ34KJdwvcCvCC1hQ=;
        b=N25W7GC9rVeS5QXC5L/KPuMSK+bhKYDsWsSl89dqBgjFTiMfe8Xsorb1mBxe2E8CSq
         EXf75SrKREx7P9x0bOsrivDMzNBHNLja7R7bv1aynZxmK7csfJszs36s66H6claQMP+X
         +1qPoeA13wR+yfMNsachC7wxeP71KgSovNHv6oBlr2Ji1EotltdA4Bb1SpaVNjvv+ynW
         qen6y/9gxmits48F4Czt3UjAEoAf+JLpINLl5lB9LvdNrBdkVScJ1GMKVNHZoJLdtu7T
         2QovK+/1eIfTRbOMCCfe+e5lvS5Pgrfco4Ao7TqUPFJrjq4+op5bBdOlE6bvWfyuxk0M
         L6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793398715; x=1794003515;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oduWj+GlQxLwzOkkNtIfxumS7HxJ34KJdwvcCvCC1hQ=;
        b=Vo1Bs+YqnRs6xgpVFeNNRBQAomVFsKDOdbi5mKTQAgkCVXKEqPvhp5et3J/f1kQ+qo
         eFlTcrVmxKSjoeiHP7sJgq4NeJ/B0+6Oh9VS55vEtCviIo19/w+oJMUH8wxPZQZs40cL
         bJPlnBULSYk1fxT0rcizLR3TvEwxh3ru63jf95y6Yxlq2ZYVxfgtcFne2/PjRY/ZQznN
         2QBt7LgErrdXaSQpuHByHjm/NQ7zTnY9jgjJkdnNFn0IJGKCnHapWKmAYioW3duWhNsb
         UTwKbUQG0VJXyH3ELtplkRnMRBNf8JwSUKOKxz4WfS2UZMVnnbkoWC0ZwFQIRKaaHIy2
         IooA==
X-Forwarded-Encrypted: i=1; AKwUvBxosdWzC270UlKRyguTavN0F0eEJ+fRhkLYNi4+JuTPiYn0eEd4BxGBVvWvtQjHftMyfU0GnI6ekNsbrA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJZUoSY6Ir8Zlo6YIYSsusCVdLn34RXWU+lWRhCZXziccauddLy
	d6HVzEzI1siPtB8DBkvHopBbO/FRIq2QcrsrohYCgVGVgJHev0ljE8eawk5vdh7u934=
X-Gm-Gg: AYBFou3TCsJEj6Bcx+zpU5JA04E7UiG7CKR4Lz+0UcE3Mn4+TKEwFbEWHxkgYsksj/i
	+kabX+iOt6fYm4fpkD/YSdg4jNKFHYjYzotCeiECZWnwA37cxLxaeVXvr2ylsmzfdKNx+stUpdd
	iBl13ZbBba3TI0nebzDJ0CYKlGfo4bWjkUl0j+vw5n1SAayEEZqDtqptMGjSFCGC/WaiXNLq+F3
	85rfLswesGtZVRBE9vtWd48Hc5f76NUjnUMhT5hiGOny3waSl2HaFmKFek7u+plDdxr4a3kELnX
	K2TOP60KTvJW/uKULeVVQpnW2rKeMjqldlZRmd8axdw8Ze4TYd+1VkkauiIb6g1qvsanSufARZv
	+Skt13QCYjUifhuEssEZauN6jH+/57AvCGF7lLAt865iVkYTtephkuknQXmcy9e0n4Aawsr3nlF
	BqzdzIjG1XfOUnJg9+R3wNTVWSi5wsCsWLE5ubwnafLYR/aCv5IBYAHMOkOrnb0oFM7BLH6B/wi
	EjRi5m8HUVzDtyy8t56BZoEeIlNaLDYfEcWrCdqxRCHMhnf0c8c7UYYB4bheSpzWLhAfU3q4/YL
	mQWlKJFptIRcmTe7u2pwEw==
X-Received: by 2002:a05:600c:4e8c:b0:4a1:dade:f049 with SMTP id 5b1f17b1804b1-4ac1793ff26mr81431795e9.15.1793398714909;
        Fri, 30 Oct 2026 15:18:34 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845fb9f6sm5336668a91.17.2026.10.30.15.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 15:18:33 -0700 (PDT)
Message-ID: <56550269-7158-4286-ac12-0509252f5ce2@suse.com>
Date: Sat, 31 Oct 2026 08:48:24 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix a livelock in wait_for_commit() on PREEMPT_RT
To: Daniel Vacek <neelx@suse.com>, linux-btrfs@vger.kernel.org
Cc: "Naulls, Peter" <PeterNaulls@eaton.com>, linux-rt-devel@lists.linux.dev,
 stable@vger.kernel.org
References: <20261030153617.329733-1-neelx@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261030153617.329733-1-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/31 02:06, Daniel Vacek 写道:
> Peter reported [1] that running multiple RR tasks doing sync()
> on fully preemptible kernel may starve other/normal sync() tasks
> due to fs_info::trans_lock turned into rt_mutex.
> 
> This is caused by RR tasks contending over the mutex with priority over
> other tasks, which in turn lack progress and they are no longer able to
> remove TRANS_STATE_COMPLETED transactions from the fs_info::trans_list.
> 
> The offenders start looping in wait_for_commit() expecting the completed
> transactions to get off the trans_list but since they're bouncing the
> trans_lock the tasks with other/normal priority which are about to delist
> such transactions never get a chance to do so due to lower priority.
> 
> A simple reproducer can be found in the mentioned email thread [1].
> 
> The situation can be resolved by boosting the priority of the starved
> tasks or dropping priority of the offenders. Thought this fix prevents
> the situation from happening in the first place. We simply delist the
> transactions before changing them to completed state. That breaks the
> loop condition.
> 
> [1] https://lore.kernel.org/linux-btrfs/SJ0PR17MB4288C46458DCE2C015839D0FBB9E2@SJ0PR17MB4288.namprd17.prod.outlook.com/
> 
> Reported-by: Naulls, Peter <PeterNaulls@eaton.com>
> Fixes: 5fd76bf31ccfe ("btrfs: fix relocation crash due to premature return from btrfs_commit_transaction()")
> CC: stable@vger.kernel.org # 5.15+
> Tested-by: Naulls, Peter <PeterNaulls@eaton.com>
> Signed-off-by: Daniel Vacek <neelx@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/disk-io.c     | 18 +++++++-----------
>   fs/btrfs/transaction.c | 15 +++++----------
>   2 files changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c628c5081d92..6afcd6ca2a8a 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4312,10 +4312,6 @@ static void warn_about_uncommitted_trans(struct btrfs_fs_info *fs_info)
>   			   trans->transid, dirty_bytes);
>   		btrfs_cleanup_one_transaction(trans);
>   
> -		if (trans == fs_info->running_transaction)
> -			fs_info->running_transaction = NULL;
> -		list_del_init(&trans->list);
> -
>   		btrfs_put_transaction(trans);
>   	}
>   	ASSERT(!found);
> @@ -4937,7 +4933,13 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
>   				     EXTENT_DIRTY);
>   	btrfs_destroy_pinned_extent(fs_info, &cur_trans->pinned_extents);
>   
> -	cur_trans->state =TRANS_STATE_COMPLETED;
> +	spin_lock(&fs_info->trans_lock);
> +	if (cur_trans == fs_info->running_transaction)
> +		fs_info->running_transaction = NULL;
> +	list_del_init(&cur_trans->list);
> +	spin_unlock(&fs_info->trans_lock);
> +
> +	cur_trans->state = TRANS_STATE_COMPLETED;
>   	wake_up(&cur_trans->commit_wait);
>   }
>   
> @@ -4973,12 +4975,6 @@ static int btrfs_cleanup_transaction(struct btrfs_fs_info *fs_info)
>   		}
>   		btrfs_cleanup_one_transaction(t);
>   
> -		spin_lock(&fs_info->trans_lock);
> -		if (t == fs_info->running_transaction)
> -			fs_info->running_transaction = NULL;
> -		list_del_init(&t->list);
> -		spin_unlock(&fs_info->trans_lock);
> -
>   		btrfs_put_transaction(t);
>   		spin_lock(&fs_info->trans_lock);
>   	}
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index d265fac023e5..cd7dff5ba59b 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2124,12 +2124,7 @@ static void cleanup_transaction(struct btrfs_trans_handle *trans, int err)
>   
>   	spin_unlock(&fs_info->trans_lock);
>   
> -	btrfs_cleanup_one_transaction(trans->transaction);
> -
> -	spin_lock(&fs_info->trans_lock);
> -	if (cur_trans == fs_info->running_transaction)
> -		fs_info->running_transaction = NULL;
> -	spin_unlock(&fs_info->trans_lock);
> +	btrfs_cleanup_one_transaction(cur_trans);
>   
>   	if (trans->type & TRANS_SB_INTWRITER_MASK)
>   		sb_end_intwrite(fs_info->sb);
> @@ -2641,6 +2636,10 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>   		btrfs_clear_space_info_full(fs_info);
>   
>   	btrfs_set_last_trans_committed(fs_info, cur_trans->transid);
> +
> +	spin_lock(&fs_info->trans_lock);
> +	list_del_init(&cur_trans->list);
> +	spin_unlock(&fs_info->trans_lock);
>   	/*
>   	 * We needn't acquire the lock here because there is no other task
>   	 * which can change it.
> @@ -2650,10 +2649,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
>   	wake_up(&cur_trans->commit_wait);
>   	btrfs_trans_state_lockdep_release(fs_info, BTRFS_LOCKDEP_TRANS_COMPLETED);
>   
> -	spin_lock(&fs_info->trans_lock);
> -	list_del_init(&cur_trans->list);
> -	spin_unlock(&fs_info->trans_lock);
> -
>   	btrfs_put_transaction(cur_trans);
>   	btrfs_put_transaction(cur_trans);
>   

