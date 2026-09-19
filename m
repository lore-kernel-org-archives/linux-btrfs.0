Received: from mail-ed2-f16.google.com (mail-ed2-f16.google.com [74.125.228.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299B9374A0B
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 22:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789857593; cv=none; b=f+8w/UpP8IUpHfHz8RnNPWEuZ8b/QYd8J9KQ8LMOKib5owKOXGcJ+xAjV9cu1QjHWsZi8Kwdy2X+3d2vHGT0F6RK/IWez5FnnvLURC4XfJHfPiPWLOylCQrUGsn1UKsXk7cis68r2BFlkk0dYva2h2InOSlksNr2SQaZVFaI4QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789857593; c=relaxed/simple;
	bh=kkAt/eaKkGWxGlEV0IFPli8yj9lKABfSLEW9+9k0vIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r52fgt6HktA7ux4ShewiQi73jw4/zWEKXM6npHRVYFFhttkCMJVJLuRCUuVQ4NzQiIvqFGzHzBwDovkOcrn1HJyL9vC7jxnL38Py4vZNdCybEuf4z+wMQ8LjYoqSomlB+yIDPSLYJ6hz2ayVLwG8zZ4kBQpB1q2pVFp+ynvei8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H1g4FVxf; arc=none smtp.client-ip=74.125.228.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H1g4FVxf"
Received: by mail-ed2-f16.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso3267546a12.0
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 15:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789857589; x=1790462389; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zPbOW7ljPUJ/32O+xU2Yfg+itAHCkAhcZtu1yMY0JGM=;
        b=H1g4FVxfPVFdZUDE3fGxYbR5Bi5hfMRzyEW9cPssCgMn0ht9ijgOITMRr6tNXnpP1C
         71RXbzBLtcmXEsFn1anaOUxJVNpVS/uNud2mqYVXtI8cLjJU+syM++Pbw1Y2gNOFqT1k
         MdrZHd1MBY7tDm56onrplj7iugzk26sz2XF6R0mv5Vzi7eim7Z3YI8t5q9jwf+xQYzjZ
         agy2AgiyzkCo4n12vv6AVze3dbU9+qJrXRiQ03Yqted//No2eSijX1kO65AQSDW8yNtL
         QdY4j4TJfWqPmRRcg/cbKzCrrZ2IwxBBB73Cnl8oq+pAAfsWUHMte9581ilPgaB59BrW
         BneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789857589; x=1790462389;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zPbOW7ljPUJ/32O+xU2Yfg+itAHCkAhcZtu1yMY0JGM=;
        b=UvuNdAJdIiIwfxPkUd0jPyiRTrMqwIJ88aQ7JCqNqWb3uX011w06MznKkGZhoARjNQ
         gV3py+RAGNdPcGGgdyYK4ITi9utrrrhjPTcWXPJ250Wl2HKxikNpG92ikUQHahtNQeNE
         sIeqiot7/MX7UzYB/ZXsTnrsUBHM5J/qKJCPl4C/1rVLNy2pAiT7LOdksnO2Epk4YfiR
         iJljKeFJ9sa2UTo5ekR6apav5vKgM3aWHgsYRWzhczxp5LZnCMxpNV1OVJXOXXvcN52p
         AEe+VYnDRB/YBf6U2o6LoGoLZYNTJQv4I+HrC6tiXUoQmiOEEBXILrw5yWOfnRP0xQKU
         wFrA==
X-Gm-Message-State: AFuF++kSnlGN6t0c4Zn9RfcynFuwK2jdl1FU7PFRIRN5LgKbGzsmfajc
	ZvrZVdsMrb4wxmdar346bLVeiMo86GKF5tBBfU3soGihdBc/EiDq3E0GPvW6+IUKAsw=
X-Gm-Gg: AYBFou1Se9YRaYOLZmA/Y3IiPWZUNcoqOR8pdjWwaFf7xUMzgUEjGykPcXFAcpEw9xx
	RRVPESgsrWcl4LQc/gLO9mBPjP4/dJ1fGzeiWOMui4e81i8EBz6aoYQjsGXMU0OQtf5gPIynC5b
	h1f58wjWeFVyjL86bG5zq8+b+3om+LB3v2JxypPGIgBEa/m1bav2CTrUS6AjQxJMdl2LdHoKmhY
	7cJHDjzh6KzzPL6KnzhkNbtnv/ttGUvg2kKhaNp5u1YU3CNBrtgTqShnN6D8vjdpVBLwC9YRBUA
	ekvPK9WeuJyyWNWNpjFzEXcmS0DHrsI3SvJDkimRlI7CGF9J+biavjPcSpecFVqzG2HkcGkQLRS
	JiC9sNpfxps7TtWTegZNa9dCY8mxZrOjt0KaP5ubGmUf/V8SX2XkRxL6RyVjJsPCUK9Kgj9WdgR
	et5Uz204NDaWzZW2XfLlLcU2mA3YhPkJBSe4Y8y/TNoTi0WtoZk1awXAdVK7nTgB4=
X-Received: by 2002:a05:6402:2803:b0:6a7:ea53:f628 with SMTP id 4fb4d7f45d1cf-6aa569a0782mr4271978a12.39.1789857589207;
        Sat, 19 Sep 2026 15:39:49 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5547a04dsm4088705a91.3.2026.09.19.15.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 15:39:46 -0700 (PDT)
Message-ID: <38c0b7f1-a876-45ab-92e2-223e2f70d82d@suse.com>
Date: Sun, 20 Sep 2026 08:09:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: qgroup rescan worker makes suspend fail
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Richard Weinberger <richard@nod.at>
Cc: linux-btrfs@vger.kernel.org
References: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
 <aq7HYO9SKdIaqvr_@mayhem.fritz.box>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <aq7HYO9SKdIaqvr_@mayhem.fritz.box>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/20 03:04, Johannes Thumshirn 写道:
> On Sat, Sep 19, 2026 at 01:40:27PM +0000, Richard Weinberger wrote:
>> Once in a while, suspending my laptop just causes the screen to freeze.
>> Initially, I thought Linux had crashed, but it usually recovers after 2 minutes,
>> though the suspend doesn't actually happen. You can imagine this can be very
>> unfortunate when you just close the laptop lid and pack the laptop into your
>> bag...
>>
>> After the problem started occurring more frequently, I investigated and found
>> that the qgroup rescan worker is the problem. In dmesg, logs like these can
>> usually be found:

To be honest, qgroup mode is no longer recommended, except for rigid 
subvolume layouts, and since you need rescan it's definitely the not 
recommended case.

The current only well known user is snapper, and we're pushing snapper 
not to utilize qgroup by default.

So unless you have a very clear use case, it's better just disable 
qgroups completely.
>>
>> [246013.777637] [ T278489] Freezing remaining freezable tasks
>> [246033.780538] [ T278489] Freezing remaining freezable tasks failed after 20.003 seconds (0 tasks refusing to freeze, wq_busy=1):
>> [246033.780576] [ T278489] Showing freezable workqueues that are still busy:
>> [246033.780582] [ T278489] workqueue events_freezable: flags=0x104
>> [246033.780590] [ T278489]   pwq 10: cpus=2 node=0 flags=0x0 nice=0 active=0 refcnt=2
>> [246033.780609] [ T278489]     inactive: pci_pme_list_scan
>> [246033.780642] [ T278489] workqueue btrfs-endio-meta: flags=0xe
>> [246033.780649] [ T278489]   pwq 57: cpus=0-13 node=0 flags=0x4 nice=0 active=0 refcnt=2
>> [246033.780660] [ T278489]     inactive: simple_end_io_work [btrfs]
>> [246033.781183] [ T278489] workqueue btrfs-qgroup-rescan: flags=0x2000e
>> [246033.781189] [ T278489]   pwq 56: cpus=0-13 flags=0x4 nice=0 active=1 refcnt=16
>> [246033.781199] [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s
>> [246033.781721] [ T278489] workqueue wg-kex-wginterproc: flags=0x6
>> [246033.781726] [ T278489]   pwq 57: cpus=0-13 node=0 flags=0x4 nice=0 active=0 refcnt=2
>> [246033.781736] [ T278489]     inactive: wg_packet_handshake_send_worker [wireguard]
>>
>> My first thought was that the worker is likely not freezable, but it is.
>> The problem is that the whole qgroup rescan is a single work item.
>> In my case, such a scan can take up to 10 minutes, even though I have a
>> fast NVMe SSD installed...
>>
>> Wouldn't it make sense to have rescan_should_stop() return true when
>> suspend starts? I think using a pm notifier could help here.
>> What do you think?
> 
> Something like this (completely untested):
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a1d83ad9a4c0..541735d8fdb6 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -17,6 +17,7 @@
>   #include <linux/error-injection.h>
>   #include <linux/crc32c.h>
>   #include <linux/sched/mm.h>
> +#include <linux/suspend.h>
>   #include <linux/unaligned.h>
>   #include "ctree.h"
>   #include "disk-io.h"
> @@ -3198,6 +3199,29 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info)
>   	return 0;
>   }
>   
> +static int btrfs_pm_notifier(struct notifier_block *nb, unsigned long action,
> +			     void *data)
> +{
> +	struct btrfs_fs_info *fs_info = container_of(nb, struct btrfs_fs_info,
> +						     pm_notifier);

IIRC this is a little too complex, we had similar cases in scrub, which 
checks "freezing(current)".

That looks like a much simpler solution.

Thanks,
Qu

> +
> +	switch (action) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +	case PM_RESTORE_PREPARE:
> +		set_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags);
> +		break;
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +	case PM_POST_RESTORE:
> +		clear_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags);
> +		btrfs_qgroup_rescan_resume(fs_info);
> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
>   /*
>    * Do various sanity and dependency checks of different features.
>    *
> @@ -3794,6 +3818,9 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
>   
>   	set_bit(BTRFS_FS_OPEN, &fs_info->flags);
>   
> +	fs_info->pm_notifier.notifier_call = btrfs_pm_notifier;
> +	register_pm_notifier(&fs_info->pm_notifier);
> +
>   	/* Kick the cleaner thread so it'll start deleting snapshots. */
>   	if (test_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags))
>   		wake_up_process(fs_info->cleaner_kthread);
> @@ -4370,6 +4397,8 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
>   	 */
>   	kthread_park(fs_info->cleaner_kthread);
>   
> +	unregister_pm_notifier(&fs_info->pm_notifier);
> +
>   	/* wait for the qgroup rescan worker to stop */
>   	btrfs_qgroup_wait_for_completion(fs_info, false);
>   
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 3eba8438593c..caa90dc98e59 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -26,6 +26,7 @@
>   #include <linux/wait_bit.h>
>   #include <linux/sched.h>
>   #include <linux/rbtree.h>
> +#include <linux/notifier.h>
>   #include <linux/xxhash.h>
>   #include <linux/fserror.h>
>   #include <uapi/linux/btrfs.h>
> @@ -234,6 +235,8 @@ enum {
>   	 */
>   	BTRFS_FS_UNALIGNED_TREE_BLOCK,
>   
> +	BTRFS_FS_PM_SUSPENDING,
> +
>   #if BITS_PER_LONG == 32
>   	/* Indicate if we have error/warn message printed on 32bit systems */
>   	BTRFS_FS_32BIT_ERROR,
> @@ -841,6 +844,8 @@ struct btrfs_fs_info {
>   	u8 qgroup_drop_subtree_thres;
>   	u64 qgroup_enable_gen;
>   
> +	struct notifier_block pm_notifier;
> +
>   	/*
>   	 * If this is not 0, then it indicates a serious filesystem error has
>   	 * happened and it contains that error (negative errno value).
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 05e35eb126dc..b4f1290d1e14 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3883,6 +3883,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>   	struct btrfs_trans_handle *trans = NULL;
>   	int ret = 0;
>   	bool stopped = false;
> +	bool pm_paused = false;
>   	bool did_leaf_rescans = false;
>   
>   	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
> @@ -3900,7 +3901,18 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>   	path->search_commit_root = true;
>   	path->skip_locking = true;
>   
> -	while (!ret && !(stopped = rescan_should_stop(fs_info))) {
> +	while (!ret) {
> +		if (rescan_should_stop(fs_info)) {
> +			stopped = true;
> +			break;
> +		}
> +
> +		if (test_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags)) {
> +			stopped = true;
> +			pm_paused = true;
> +			break;
> +		}
> +
>   		trans = btrfs_start_transaction(fs_info->fs_root, 0);
>   		if (IS_ERR(trans)) {
>   			ret = PTR_ERR(trans);
> @@ -3963,12 +3975,17 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
>   	complete_all(&fs_info->qgroup_rescan_completion);
>   	mutex_unlock(&fs_info->qgroup_rescan_lock);
>   
> +	if (pm_paused && !test_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags))
> +		btrfs_qgroup_rescan_resume(fs_info);
> +
>   	if (!trans)
>   		return;
>   
>   	btrfs_end_transaction(trans);
>   
> -	if (stopped) {
> +	if (pm_paused) {
> +		btrfs_info(fs_info, "qgroup scan paused for system suspend");
> +	} else if (stopped) {
>   		btrfs_info(fs_info, "qgroup scan paused");
>   	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
>   		btrfs_info(fs_info, "qgroup scan cancelled");
> @@ -4142,13 +4159,20 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_fs_info *fs_info,
>   void
>   btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
>   {
> -	if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags)) {
> -		mutex_lock(&fs_info->qgroup_rescan_lock);
> +	if (!test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags))
> +		return;
> +
> +	if (btrfs_fs_closing(fs_info))
> +		return;
> +
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	if (!fs_info->qgroup_rescan_running) {
> +		reinit_completion(&fs_info->qgroup_rescan_completion);
>   		fs_info->qgroup_rescan_running = true;
>   		btrfs_queue_work(fs_info->qgroup_rescan_workers,
>   				 &fs_info->qgroup_rescan_work);
> -		mutex_unlock(&fs_info->qgroup_rescan_lock);
>   	}
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>   }
>   
>   #define rbtree_iterate_from_safe(node, next, start)				\

