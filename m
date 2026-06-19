Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81B13DDAE;
	Fri, 19 Jun 2026 14:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781879638; cv=none; b=Axxh66A62NQbsYcLq0CJ53k5lN+zt4yOWYupEQFYetEusHxKy1g9ONXDnHw2PtkayN90Sk/t/1GioF9sXbcmhfjn0YJ9LAIiIAloy5TEE0uZPrEfUp3J5LW0stiH6kuY+RoK/sgcQC8ZvPSAjF/Ryc+dTAmPHri218CjjdQuqXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781879638; c=relaxed/simple;
	bh=umWe0F5faZ0lPKhxWGF3FOdyjrlE03wsyDnqzVzXdaA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jbDAtpNIiO0y2M4ZyjvrvNbD4tiT1RVxFojrlH0zA97WoJCT/9NSZwFAd7tHk8rud9/zKFNd1WH/qP97BJtBJhk/JP3MRbAPJfC+Bp7WMOtsepe+x/UcVaW4BB7iKGfZIWGqOxKkuEPgUpvu9gpB/roIQYWobJ7xbTH7IC7o6Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 65JEXE02039344;
	Fri, 19 Jun 2026 23:33:14 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 65JEXEKA039338
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 19 Jun 2026 23:33:14 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <a9254bf0-fc7a-4b2e-a62f-064e71016fb6@I-love.SAKURA.ne.jp>
Date: Fri, 19 Jun 2026 23:33:11 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] loop: Fix NULL pointer dereference in lo_rw_aio()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <tom.leiming@gmail.com>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
        Hillf Danton <hdanton@sina.com>
References: <20260529220600.1226-1-hdanton@sina.com>
 <b27609f0-59f0-403d-90af-274c55df817e@I-love.SAKURA.ne.jp>
 <3244d4dd-8254-47c0-9609-b1db53450c7c@I-love.SAKURA.ne.jp>
 <20260609175013.GH2636677@ZenIV>
 <9f8b5ab0-efbc-4cf3-a1f8-b43377416946@I-love.SAKURA.ne.jp>
Content-Language: en-US
In-Reply-To: <9f8b5ab0-efbc-4cf3-a1f8-b43377416946@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav404.rs.sakura.ne.jp
X-Virus-Status: clean

Sending this commit to linux.git will be the fastest way to identify who is issuing
I/O requests too late. Therefore, I want to get a conclusion on xfs/259 breakage.
Al, can you get the same result?

On 2026/06/13 20:00, Tetsuo Handa wrote:
> On 2026/06/10 2:50, Al Viro wrote:
>> Still breaks xfs/259, same as the version in next-20260605...
> 
> I installed xfstests-dev and reproduced a "umount: /home/test: target is busy." problem which Al Viro is
> experiencing with https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20260608&id=fb1d5846e99c8aa4ce8da7e6ee7643b01da25b8c .
> 
(...snipped...)
> 
> I initially suspected that the cause of "target is busy" error is that fput() from
> __loop_clr_fd() does not wait for completion before "losetup -d" completes. But a
> debug printk() patch shown below indicated a tendency:
> 
>   (a) __loop_clr_fd() is called by "udev-worker" rather than "losetup" when this problem happens
> 
>   (b) propagate_mount_busy()!=0 when do_umount() fails with -EBUSY
> 
> --------------------------------------------------------------------------------
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index c3b607a3ddc4..7408f314a1fa 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1763,6 +1763,8 @@ static void lo_release(struct gendisk *disk)
>  	mutex_unlock(&lo->lo_mutex);
>  
>  	if (need_clear) {
> +		printk("Flush: task=%s[%d] dev=loop%d state=%d\n",
> +		       current->comm, current->pid, lo->lo_number, lo->lo_state);
>  		/*
>  		 * Temporarily release disk->open_mutex in order to flush pending I/O
>  		 * requests before clearing the backing device.
> @@ -1813,6 +1815,8 @@ static void lo_release(struct gendisk *disk)
>  		mutex_lock(&lo->lo_disk->open_mutex);
>  		if (WARN_ON(data_race(READ_ONCE(lo->lo_state)) != Lo_rundown))
>  			return;
> +		printk("Teardown: task=%s[%d] dev=loop%d state=%d\n",
> +		       current->comm, current->pid, lo->lo_number, lo->lo_state);
>  		__loop_clr_fd(lo);
>  	}
>  }
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 09ab7fc72f86..9710460fb449 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1893,6 +1893,8 @@ static int do_umount(struct mount *mnt, int flags)
>  		 */
>  		lock_mount_hash();
>  		if (!list_empty(&mnt->mnt_mounts) || mnt_get_count(mnt) != 2) {
> +			printk("%s: task=%s[%d] !list_empty(&mnt->mnt_mounts)=%d mnt_get_count(mnt)=%d\n", __func__,
> +			       current->comm, current->pid, !list_empty(&mnt->mnt_mounts), mnt_get_count(mnt));
>  			unlock_mount_hash();
>  			return -EBUSY;
>  		}
> @@ -1960,6 +1962,9 @@ static int do_umount(struct mount *mnt, int flags)
>  		if (!propagate_mount_busy(mnt, 2)) {
>  			umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
>  			retval = 0;
> +		} else {
> +			printk("%s: task=%s[%d] propagate_mount_busy()!=0\n", __func__,
> +			       current->comm, current->pid);
>  		}
>  	}
>  out:
> --------------------------------------------------------------------------------

