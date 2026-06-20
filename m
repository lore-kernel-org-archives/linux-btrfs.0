Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6CF349CE7;
	Sat, 20 Jun 2026 09:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781948586; cv=none; b=GJSpEcdCPCm2jy+y3z2MeDE6sFx8g25MsbSTdC9rlJS+DrRc0nXb31Y4vBiQM1SwgM79684K9t5cSHav2gfwDDnrnnVvVzuN0diynpy7nT+HRHlibfzoJPp0OxPz0R0OQW7lvJ16gerx3cD3z0w54slBvKHt9u4SxECDwHsw5Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781948586; c=relaxed/simple;
	bh=BDY6LnHyfiSqNxly7JKFxMIFRGnGAm2SZHM2bQbD3GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PKWCaBR0KWLcvjo5aHXrwtqtT4V7m3R3En2tybBm0JtA9VMc7N0BpoqHUMDesKZ2rTrYzZkPGdjM5nPdLu5GZL2ksmR7bDuynkp5JVJeqsJc0mboIqSfuQBwsg5VZyb3FcFEZZbOWdRGKNUJAuL45gKEZZPZcS6T4a4KFO6jCvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 65K9gLR5084017;
	Sat, 20 Jun 2026 18:42:21 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.6] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 65K9gLdB084014
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 20 Jun 2026 18:42:21 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <ebceac56-6a65-4918-b47c-1fb87aa66989@I-love.SAKURA.ne.jp>
Date: Sat, 20 Jun 2026 18:42:20 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] loop: Fix NULL pointer dereference in lo_rw_aio()
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
 <a9254bf0-fc7a-4b2e-a62f-064e71016fb6@I-love.SAKURA.ne.jp>
 <20260620073939.GF2636677@ZenIV>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20260620073939.GF2636677@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav203.rs.sakura.ne.jp

On 2026/06/20 16:39, Al Viro wrote:
> On Fri, Jun 19, 2026 at 11:33:11PM +0900, Tetsuo Handa wrote:
>> Sending this commit to linux.git will be the fastest way to identify who is issuing
>> I/O requests too late. Therefore, I want to get a conclusion on xfs/259 breakage.
>> Al, can you get the same result?
> 
> Not a peep in the logs, breakage still there (with cherry-picked fb1d5846e99c8aa4ce
> and CONFIG_KCOV enabled, that is).

Please test with debug printk() patch shown below. What messages do you get?

--------------------------------------------------------------------------------
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c3b607a3ddc4..7408f314a1fa 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1763,6 +1763,8 @@ static void lo_release(struct gendisk *disk)
 	mutex_unlock(&lo->lo_mutex);
 
 	if (need_clear) {
+		printk("Flush: task=%s[%d] dev=loop%d state=%d\n",
+		       current->comm, current->pid, lo->lo_number, lo->lo_state);
 		/*
 		 * Temporarily release disk->open_mutex in order to flush pending I/O
 		 * requests before clearing the backing device.
@@ -1813,6 +1815,8 @@ static void lo_release(struct gendisk *disk)
 		mutex_lock(&lo->lo_disk->open_mutex);
 		if (WARN_ON(data_race(READ_ONCE(lo->lo_state)) != Lo_rundown))
 			return;
+		printk("Teardown: task=%s[%d] dev=loop%d state=%d\n",
+		       current->comm, current->pid, lo->lo_number, lo->lo_state);
 		__loop_clr_fd(lo);
 	}
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index 09ab7fc72f86..9710460fb449 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1893,6 +1893,8 @@ static int do_umount(struct mount *mnt, int flags)
 		 */
 		lock_mount_hash();
 		if (!list_empty(&mnt->mnt_mounts) || mnt_get_count(mnt) != 2) {
+			printk("%s: task=%s[%d] !list_empty(&mnt->mnt_mounts)=%d mnt_get_count(mnt)=%d\n", __func__,
+			       current->comm, current->pid, !list_empty(&mnt->mnt_mounts), mnt_get_count(mnt));
 			unlock_mount_hash();
 			return -EBUSY;
 		}
@@ -1960,6 +1962,9 @@ static int do_umount(struct mount *mnt, int flags)
 		if (!propagate_mount_busy(mnt, 2)) {
 			umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
 			retval = 0;
+		} else {
+			printk("%s: task=%s[%d] propagate_mount_busy()!=0\n", __func__,
+			       current->comm, current->pid);
 		}
 	}
 out:
--------------------------------------------------------------------------------


