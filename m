Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2A7313552;
	Wed, 27 May 2026 01:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779845783; cv=none; b=df7sjRjfbaEAAJXgEWnNkUoVI1aoTOimcHZuUjz8fjxuBcjPQi63yHa9h5uGwd4e1pkgfYkvPRO+yX5F6HWp4R8W/beTL5OqbuYIlYtf7nz1YBOdzkpnpwZBw7M09HcZyzR3a2wbukBaLW4w1Ms3AT9oiSohYWj+KaaKTKBVRPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779845783; c=relaxed/simple;
	bh=gWQbte/D+rvnVAws4u9sQB+RBkaJQqcbbOTzu2IeZg0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XWH/n4Yo+aR/y5Oz0AyLDY+L1gQ+m8ZzJPUItCL2R6Acd++OLbeesNOclvmhTehpJhc9C1EfBt5MeLPKDDDPOA9sc+O0PA/PvLWT4LYgZrA7DCPb64lX6Ruyb/e9s1XlkzFtaX5cOFcsFRIEvMm/2AzBUuE6bp5nJv8UpzuzAk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 64R1ZxZ5024720;
	Wed, 27 May 2026 10:35:59 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.5] (M106072072000.v4.enabler.ne.jp [106.72.72.0])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 64R1Zx2p024714
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 27 May 2026 10:35:59 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <d1b5a737-f0e3-4927-b762-430b37fbb2f9@I-love.SAKURA.ne.jp>
Date: Wed, 27 May 2026 10:35:56 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] loop: Fix NULL pointer dereference in lo_rw_aio()
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <20260518174013.4b72dd50a5bcb89daaed1f62@linux-foundation.org>
 <d43125ff-cc66-49b7-b16d-1b2650c68c23@I-love.SAKURA.ne.jp>
 <ag0lS_CbKO9R5CV8@fedora>
 <94076bc9-2c09-4bb6-8468-b6b8af419cb9@I-love.SAKURA.ne.jp>
 <ag1nfIFcykmQHbkk@fedora>
 <1ab8c579-eb76-4227-8a72-6ec819135219@I-love.SAKURA.ne.jp>
 <ag1223nAa0wZ8ALC@fedora>
 <fda8abc8-6aa2-463b-bf72-865f6b838034@I-love.SAKURA.ne.jp>
 <ahRocb0Vs_m6RF_O@fedora>
 <1a9f53d4-6f48-4df8-a3d8-2b0e442a163a@I-love.SAKURA.ne.jp>
 <ahZGxoI6oHQ_vSrx@fedora>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <ahZGxoI6oHQ_vSrx@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav405.rs.sakura.ne.jp
X-Virus-Status: clean

On 2026/05/27 10:20, Ming Lei wrote:
>> Of course we should try to figure out the root cause first, but how can we do?
> 
> Definitely unexpected write IO(after umount & loop closed) from btrfs is more serious,
> which may cause data loss, so CC btrfs list and maintainer.

Why do you assume that the culprit is btrfs?

https://syzkaller.appspot.com/bug?extid=bc273027d5643e48e5b3 indicated that
this similar race is also happening with jfs.

[  678.816570][ T1038] read_mapping_page failed!
[  678.816584][ T1038] ERROR: (device loop3): txCommit: 
[  678.816584][ T1038] 
[  678.816633][ T1038] jfs_write_inode: jfs_commit_inode failed!
[  678.895688][ T2183] lo_rw_aio(loop3) starting write with raw_refcnt=0x0, refcnt=1
[  678.956225][ T2183] lo_rw_aio(loop3) starting write with raw_refcnt=0x0, refcnt=1
[  678.970652][   T12] lo_rw_aio(loop3) starting write with raw_refcnt=0x0, refcnt=1
[  679.102838][ T4281] lo_rw_aio(loop3) starting write with raw_refcnt=0x0, refcnt=1
[  679.104701][ T4281] lo_rw_aio(loop3) starting write with raw_refcnt=0x0, refcnt=1
[  679.121329][ T2183] lo_rw_aio(loop3) starting write with raw_refcnt=0x0, refcnt=1
[  679.122119][ T2183] lo_rw_aio(loop3) starting write with raw_refcnt=0x0, refcnt=1
[  679.199283][ T2183] lo_rw_aio(loop3) starting read with raw_refcnt=0x0, refcnt=1
[  679.200014][ T2183] lo_rw_aio(loop3) starting write with raw_refcnt=0x0, refcnt=1
[  679.275613][ T5615] __loop_clr_fd(loop3) clearing lo_backing_file with raw_refcnt=0x0, refcnt=1
[  679.397358][   T13] bridge_slave_1: left allmulticast mode
[  679.397399][   T13] bridge_slave_1: left promiscuous mode
[  679.410004][   T13] bridge0: port 2(bridge_slave_1) entered disabled state
[  679.433576][ T2183] ------------[ cut here ]------------
[  679.433592][ T2183] d_inode(dentry) != file_inode(file)
[  679.433617][ T2183] WARNING: ./include/linux/fs.h:1368 at file_remove_privs_flags+0x58c/0x640, CPU#0: kworker/u8:12/2183
[  679.433676][ T2183] Modules linked in:
[  679.433695][ T2183] CPU: 0 UID: 0 PID: 2183 Comm: kworker/u8:12 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
[  679.433720][ T2183] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
[  679.433739][ T2183] Workqueue: loop3 loop_workfn
[  679.433805][ T2183] RIP: 0010:file_remove_privs_flags+0x58c/0x640
[  679.433848][ T2183] Code: 00 75 4d 44 89 e8 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 5f d4 80 ff e9 90 fe ff ff e8 55 d4 80 ff 90 <0f> 0b 90 e9 85 fb ff ff 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c b7
[  679.433867][ T2183] RSP: 0018:ffffc90007e374e0 EFLAGS: 00010293
[  679.433885][ T2183] RAX: ffffffff8243f7cb RBX: ffff888036fa8ca0 RCX: ffff88802c0abd80
[  679.433902][ T2183] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  679.433933][ T2183] RBP: ffffc90007e37638 R08: 0000000000000000 R09: 0000000000000000
[  679.433946][ T2183] R10: dffffc0000000000 R11: fffffbfff1f1597f R12: ffff888063726220
[  679.433962][ T2183] R13: 1ffff11006df5194 R14: 0000000000000000 R15: 1ffff1100c6e4c44
[  679.433978][ T2183] FS:  0000000000000000(0000) GS:ffff888125f1f000(0000) knlGS:0000000000000000
[  679.433998][ T2183] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  679.434016][ T2183] CR2: 00007f22e1be7dac CR3: 000000003e332000 CR4: 00000000003526f0
[  679.434038][ T2183] Call Trace:
[  679.434049][ T2183]  <TASK>
[  679.434072][ T2183]  ? __pfx_file_remove_privs_flags+0x10/0x10
[  679.434118][ T2183]  ? rt_mutex_post_schedule+0xd1/0x1c0
[  679.434172][ T2183]  ? generic_write_checks_count+0x449/0x550
[  679.434212][ T2183]  ? generic_write_checks+0xc8/0x110
[  679.434249][ T2183]  shmem_file_write_iter+0xaa/0x120
[  679.434286][ T2183]  lo_rw_aio+0xef0/0x1170
[  679.434349][ T2183]  ? __pfx_lo_rw_aio+0x10/0x10
[  679.434401][ T2183]  ? kthread_associate_blkcg+0x490/0x600
[  679.434432][ T2183]  ? rt_spin_unlock+0x160/0x200
[  679.434476][ T2183]  loop_process_work+0x637/0x11b0
[  679.434539][ T2183]  ? __pfx_loop_process_work+0x10/0x10
[  679.434582][ T2183]  ? look_up_lock_class+0x57/0x110
[  679.434626][ T2183]  ? register_lock_class+0x31/0x2e0
[  679.434661][ T2183]  ? __lock_acquire+0x6b5/0x2d10
[  679.434741][ T2183]  ? do_raw_spin_lock+0x12b/0x2f0
[  679.434785][ T2183]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  679.434830][ T2183]  ? process_one_work+0x8be/0x1630
[  679.434870][ T2183]  ? process_one_work+0x8be/0x1630
[  679.434922][ T2183]  ? process_one_work+0x8be/0x1630
[  679.434959][ T2183]  process_one_work+0x98b/0x1630
[  679.435026][ T2183]  ? __pfx_process_one_work+0x10/0x10
[  679.435060][ T2183]  ? do_raw_spin_lock+0x12b/0x2f0
[  679.435128][ T2183]  worker_thread+0xb49/0x1140
[  679.435202][ T2183]  kthread+0x388/0x470
[  679.435233][ T2183]  ? __pfx_worker_thread+0x10/0x10
[  679.435276][ T2183]  ? __pfx_kthread+0x10/0x10
[  679.435309][ T2183]  ret_from_fork+0x514/0xb70
[  679.435348][ T2183]  ? __pfx_ret_from_fork+0x10/0x10
[  679.435382][ T2183]  ? __switch_to+0xc79/0x1410
[  679.435415][ T2183]  ? __pfx_kthread+0x10/0x10
[  679.435447][ T2183]  ret_from_fork_asm+0x1a/0x30
[  679.435517][ T2183]  </TASK>

