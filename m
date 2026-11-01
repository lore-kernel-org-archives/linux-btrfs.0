Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517509;
	b=uiGZK9kTemJXJ/38JzHfDjMjR4+Vx9mYSNFCIC1pR92gFv/lJ7eDoP1pAJYeqBnu+r9s
	 zIbzFTSW5tg1Iu63FQ1oRejJY03DJ3v2VLEVIk6S5r+yJsyLCaaAw1XkEgYnlwqQ8erlc
	 HcXGUjOipWYb1Q6nZljePDI7TMZ29l9Kf4DEENG6t1zwQfi255tqQDd037h0tkl3GSAqI
	 0vfkN4/xeBVlt2H/BsVZtW0srUhZ1nRu8YVybMttz2Fn2SfuRKOJgHFR7PGIqLBkr/Nm6
	 UCXkNZiY4ZKLhCp5bGe9pcyfJH9MhHp6DJOr7fDNzHgr+tY0GjVEibp49JxOs9qY7mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517509;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=X+BwoNYH8Zzqv3w5tIVg3636uhE4Ev+ncQBA55QTM0Y=;
	b=JZgvjxHs1BJFe118D2t6z6F5T1Di4sFIY5ZYsj7CpqE8vO+JrH4jna2HJgLoTyvtTHPX
	 7tFedXEQ9hSSbSmQXo/Lrf6aOXhLdIsbt/Gm4fUVCVUqhAO/Ci/5utgrY/idc9SImXxia
	 Q0cCmUkydcmPaGOBCP2Jg91gIpZX/JDvJCxnJeVHIUZ9mJI5XazZ+Aicgr5aRyrToUGJZ
	 YBP8M6fsSXaQHQ6V3xn/TARtGE7FYhIrGLw7IZkNxhhDg6sDgc63IyXGz0tmgm4FHVEjl
	 ow8jXdGC+mWzyEqrIPYkXcTGe5zLFKnL7e5IMwuwJI1wdqsAqKHuwvikA8HT7kxDAbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ffK5pmQk;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C11606A325
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 07:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52C11606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ffK5pmQk
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a35db1f202so20935335e9.3
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 00:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793517508; x=1794122308; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X+BwoNYH8Zzqv3w5tIVg3636uhE4Ev+ncQBA55QTM0Y=;
        b=ffK5pmQkqD7xyXFYTYf2tSVw1KfU9AScHuDeQEj0RaUM5ODUuEB3elvi7BIDxa0Wpf
         oGoDo5g4HwMt0T0SqlJn2SlTSGOUfIbvQ79nfoNdsEYpGRg4aOu5PZ6sZIvFZxrN9PGt
         IZXKXWAtg/E2YplhIvxZTkBTCo0KKbU8Zno6PK0NZi7qSW3/LlRzO222l8TB6cDdNi4j
         OEi/YbwnjtvR45G4Sgk7/cjGIf9t7q74+/zbVQQi6LXakNbrazZ1QFvPEPUNpT0KHdko
         WHqQpnNr5YUt8TpnuzIrTrr1A4+5w/w/6r4r9kPO0444XyUmba+PkTL3vfgUv1A98/cc
         hi9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793517508; x=1794122308;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X+BwoNYH8Zzqv3w5tIVg3636uhE4Ev+ncQBA55QTM0Y=;
        b=C/ycSx2nMiNuFVQyCT0onbg++F5QIaHzLm5jhS0k9JeNE2PAaEdquV0ImCvmTZS0V1
         VKA+3XkTSDDx7WdD9kLZi1ysvInWYBfob3VcYYlWUtyfGMrpPArnjkW03bm+I8E2mXVi
         FqhArBYJVoI3loDspZrxfJF6Jpv9Qg9tB9E9iCfd7YBGv/6h87kac+TyTWkdyEVCzjnW
         64EoOOY18zmnBS44ia2xmmnH/chkUK7qXn4hYwtri2eeUPjlFAoFWSU2dWvxGTNKifZ+
         pSnvyYa4FBtSk2fyenYHdyWanzPhExu7cbDMU7xojXODlGuoQXZgTSbVO7uNtnaT8xDX
         wyWw==
X-Forwarded-Encrypted: i=1; AKwUvByiZf2CbDOrBkW7ry67HXSM7lZFlp8amj4MWamiQDuzw2AZC1LgiYfNRG8t1qzHogLrQIqAs9thRXz28A==@vger.kernel.org
X-Gm-Message-State: AFq9FYInQf2q2GHjYgM6mfT57zzLd6xqB9a9WwC97hUgkanKg58bk/kV
	QPrN+LejEACX+1NV9sahbMR8DBZy+8sELNViZXpTjSgSerm046dfFhoqKTDmLsHTGIQ=
X-Gm-Gg: AYBFou0e27iJx7PGDxZgkcbwfURi1xgckVhGNwCjw4L0ckGqQ/k0y3WzNE2BsVU2BZA
	Xn53ldPw7xDZx8T3JQgNZ8Z+tf8cWbmC1FGGrKAOFrNWdQwQ9HpRb3nKDeCRw/jRLM+JbRzeDfN
	R7ziyA5uT20LTyAkenZO8cy9xVgapt17eExC7dik62jZL0pbloGgtm06F4UIYxL7uKL4AZnbQyU
	JlZmxampuYzQUETRTTUHjV/DWb7zHDEhQw8Kg4o8PX5DslvYRO7sMALW/OTIDPGHsKAbJ53Zj47
	uzrSGiETZicHCXDrvHC2nRMJkEZsN9vHbPg2bmHigCj0tGJNCCLDtcUA5KbwWYgS4KdoVrhJtvr
	S0Tej7kRlLZ1Uh/9oEHMi1dYXGvl/SyDcLJDps/0wVtj0yiHGjbNsiJIzGMRAI0Ac9DV3IroI8y
	c/vaGzKR2GEfATBDqkzEN5YWTVZuWWUEACNn8+mS7xY1LA9WJKpNglz4UOT+vs7cXW++Jc9bozl
	bv1PMmcz2UbeJf5wU1UslXaoDFc8CN0zfYxktDZ7b6DdIE8IKcRpfSHpzdEzWaQjwApMi1Lb1CT
	afLzC222GjTJHr7aSrdbn+j4gTK4XznU+1wBoqR8AA==
X-Received: by 2002:a05:600c:1f93:b0:4a1:7e76:d02f with SMTP id 5b1f17b1804b1-4ac180f299emr143671995e9.14.1793517507631;
        Sun, 01 Nov 2026 00:18:27 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac19f4a04esm22697298c88.15.2026.11.01.00.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 00:18:26 -0700 (PDT)
Message-ID: <b4962b1b-bc5e-4302-8456-73b9b8a6474b@suse.com>
Date: Sun, 1 Nov 2026 17:48:21 +1030
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
Subject: Re: [PATCH v2] btrfs: reject refs=0 subvolume without DEAD in
 SUBVOL_SYNC_WAIT
To: Qu Wenruo <wqu@suse.com>, Cheng Yongkang <teel4res@gmail.com>,
 David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261101062539.1744605-1-teel4res@gmail.com>
 <a92d223b-55fa-493e-821a-e5acc8afee08@suse.com>
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
In-Reply-To: <a92d223b-55fa-493e-821a-e5acc8afee08@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/1 17:21, Qu Wenruo 写道:
> 
> 
> 在 2026/11/1 16:55, Cheng Yongkang 写道:
>> btrfs_ioctl_subvol_sync() assumes that a cached root with zero
>> references has BTRFS_ROOT_SUBVOL_DEAD set, and asserts that before
>> waiting for the cleaner. Two states break the assumption:
>>
>> - A corrupt ROOT_ITEM with zero references and a matching orphan item,
>>    on a writable filesystem.
>> - A failed subvolume deletion. btrfs_delete_subvolume() zeroes the
>>    root references, aborts the transaction, which forces the filesystem
>>    read-only, and then clears DEAD again. No on-disk metadata is
>>    corrupted in this case.
>>
>> With CONFIG_BTRFS_ASSERT=y, both reach a BUG().
>>
>> Before waiting for a deleted subvolume, return -EROFS if the
>> filesystem is read-only, since the cleaner does not drop dead roots
>> then. The check runs on every iteration, so it also stops a waiter
>> when the filesystem becomes read-only during the wait. Subvolume
>> deletion holds subvol_sem for writing across the abort and the DEAD
>> rollback, and each iteration takes it for reading before inspecting
>> the root, so the read-only state and the cleared flag are seen
>> together. On a writable filesystem, report a zero-reference root
>> without DEAD and return -EUCLEAN instead of asserting.
>>
>> Subvolumes that were not deleted or do not exist still return -EEXIST
>> and -ENOENT, also on a read-only filesystem.
>>
>> Tested on btrfs for-next with CONFIG_BTRFS_ASSERT=y. A deletion made
>> to fail by fault injection after the references are cleared hits the
>> assertion in SUBVOL_SYNC_WAIT without this change and gets -EROFS with
>> it. A waiter on a deleted subvolume now returns -EROFS when the
>> filesystem is remounted read-only, instead of waiting until it is
>> signalled.
>>
>> Fixes: 6c83d153ed86 ("btrfs: add new ioctl to wait for cleaned 
>> subvolumes")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>> Link: https://lore.kernel.org/linux-btrfs/dd97efe9-91ec-495b-b698- 
>> acff1447421c@gmx.com/
>> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
>> ---
>> Changes in v2:
>> - Return -EROFS on a read-only filesystem before waiting for a deleted
>>    subvolume (Qu).
>> - Use unlikely() for the inconsistent-root check (Qu).
>> - Describe the failed-delete case separately from corrupt metadata.
>> - Add the Fixes tag and Cc stable.
>>
>> v1: https://lore.kernel.org/linux-btrfs/20261025180258.349175-1- 
>> teel4res@gmail.com/
>>
>> Testing notes (btrfs for-next d1dca33127ef, KASAN):
>> - The fault-injection case reached the cleared-references state in 2
>>    of 4 attempts on each kernel. The other attempts aborted earlier, and
>>    both kernels returned -EEXIST.
>> - FOR_ONE, FOR_QUEUED, COUNT and PEEK return the same results with and
>>    without this change for live, missing and deleted subvolumes, on
>>    writable and read-only mounts.
>> - The -EUCLEAN branch was not exercised. A crafted image with a
>>    zero-reference root and no DEAD flag hits the assertion without this
>>    change, but remounting that image read-write stalls in a transaction
>>    commit with or without this change, before the filesystem becomes
>>    writable.
>>
>>   fs/btrfs/ioctl.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 9857d6a9d456..5a1f2edfd831 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -5166,8 +5166,14 @@ static int btrfs_ioctl_subvol_sync(struct 
>> btrfs_fs_info *fs_info, void __user *a
>>               return -ENOENT;
>>           wait_for_deletion = true;
>> -        ASSERT(root_flags & BTRFS_ROOT_SUBVOL_DEAD, "root_flags=0x%llx",
>> -               root_flags);
>> +        if (unlikely(test_bit(BTRFS_FS_STATE_RO, &fs_info->fs_state)))
>> +            return -EROFS;
> 
> I'm not suggesting such an ad-hoc check, but some more comprehensive 
> checks, like mnt_want_write_file().
> As this one won't handle aborted transaction.
> 
> But it's not a good idea using that mnt_want_write_file() either, as 
> that will block pm suspension/hibernation, especially considering the 
> wait will only be handled by cleaner thread.
> 
> The default timeout for waking up cleaner is 30s, which is definitely 
> not suitable for such calls.
> 
> 
> If you are not sure what to do with the RW check and cleaner behavior, 
> just don't put an adhoc solution into the update.
> At least it won't be any worse.

With that said, there are more problems with the ioctl.

- No real user
   No one is utilizing BTRFS_SUBVOL_SYNC* flags. Btrfs-progs itself
   doesn't even bother it.

   So all these fixes are very low priority, unless there are some wild
   programs utilizing this.

   But even btrfs-progs doesn't utilize them, the possibility are very
   low.

- Incorrect return value
   For that wait loop, if we waited for several rounds, then the
   subvolume is properly removed. Then we just return -ENOENT, which is
   definitely not the correct return code.

- Inconsistent radix tree index checks
   There is a U32 radix tree check, but there is no such check for any
   other operations like btrfs_insert_fs_root(), which can lead to
   subvolid conflicts.

With that said, I'd say it's more meaningful to address those problems, 
and add a proper btrfs-progs support for it, along with test cases.

Sure, if you only want to fix the ASSERT(), that's fine.

But I would prefer to take a little more time to find out the real 
problems deeper behind the scene, other than dumping tokens to just grab 
some low hanging fruit.

> 
> 
>> +        if (unlikely(!(root_flags & BTRFS_ROOT_SUBVOL_DEAD))) {
>> +            btrfs_err(fs_info,
>> +                  "subvol %llu has refs 0 without DEAD flag",
>> +                  args.subvolid);
>> +            return -EUCLEAN;
>> +        }
>>           sched_ret = schedule_timeout_interruptible(HZ);
>>           /* Early wake up or error. */
>>           if (sched_ret != 0)
>>
>> base-commit: d1dca33127efacd86ac550aa86352f8ea9f29a5a
> 

