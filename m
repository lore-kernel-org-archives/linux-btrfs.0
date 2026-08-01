Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6CF38D3F9
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785562297; cv=none; b=hUxvibjTiXhMrHvLDsyAgZnn9SM07QRg1rtMsP/0Irs1i6NOea0IlyhVHXBMpIoyUiGFGVihmAPpV01iV+olU8XMbUm31605SAXl9Us5vM1ChfXGaUunLGUrckWGyhkPrPjWZeDomJQzoh/g5Dt4/cv3r7R2bQfXgEL0p0B5Bxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785562297; c=relaxed/simple;
	bh=175FrjyGu1FcDCyNZ7vGfcQ3DqRQEjA4AlNjPkukCeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=J9YYshrrwBBlNli+rst4yvhKRe6v/6rdmcA7AOWwWvnBAIW0Yny2D8dxUJppK2le0xCHGECh37NrDXU6Vseo93qKSjCnKJDGH1FpWaCCGH7j7TaYy5VnT6iL/EPVGdUMmyrQuI8F686SiY+gQnOA9au0EZ6fX4QkTkozMfiLr5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Zeyxj35G; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zeyxj35G"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4954dff6536so3020335e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 22:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785562293; x=1786167093; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cJReBHgXpsVvB/TXyGESly6v1RBlvu0tX3lUEqgqrwQ=;
        b=Zeyxj35GkAxbm+vnCX8NRa4h8Zf+3M3ncCVL0ZKvz/Rq/wQBTQJcg3lWsAikxztnHB
         ZNL3dHwbWqlDtcMVFYm2CfbYoyacmT3dc5hqgrARkUqgKOXMI5BWDN1tgzBLCFF5bbD1
         k1MZm56omdXNi+2KDRHIrzAdG4BBPlARQJwO/9aEyZNF4Muv6MLP6gqqt0u+nLS7UaYX
         mkV5uhCPa/ghbInztxy/qYKA6WIiplgecoBGzEwzllRwer1gXjrgOXW/UMDIrDz5F3G6
         7JQUM/v7F5ZkFtBJDBWEi7qRKLWIlzXFk1mSgfYy6rdhyNUjxWiX0gKXyTiVLxJMnRQ3
         M5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785562293; x=1786167093;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cJReBHgXpsVvB/TXyGESly6v1RBlvu0tX3lUEqgqrwQ=;
        b=FlFfg3t+JFiISfjrZhvGvOusoBdu/OiV4zXfc07kyiojqVyz2Q6qR/Zpp9k+TuPQWS
         tsaw4OjfaGtvXY/SHsnoAk56Y9xPKcrmqfC3pHVZ90gz/cwQGrQYPvBVswSoESPlh7io
         WRTbF5wkSdZr785dvQnvnC4fQ0Ym3e4yzXGiJLs4iOxry3Q9SuxiQcPtPNLbrWJ8VLtb
         aX+pKGKAvSDG8e3ve8T5H2Ehqz3xuK4s1NxbBh2oB+fpHMpbytqr5ASCG9lpXBe/Xp6O
         z+cPXbL87FfLn6kdTuYae1giFuLWvCF5FRWmK0gRbamhJ+Gv+7kJR/NxOvLgX127eC7O
         kkbQ==
X-Forwarded-Encrypted: i=1; AHgh+RqavvseFPrtaeXkykF25XPO25VNTJwCPCqXYNQRU8LLE61fczFmnxJbFVLwD8Z4cEwzlgNRTimgdtpRGA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxD0io4O5lZBLcPcPZ0L5PHuA/LHrIIjqeuKW0QJf7EUFnoVEzH
	rIsic1in3eqCfi144SgSCSgQUIY0pkwHAtLlcGRy8TluMes9eGKwXYbwFw7gQafu7J4=
X-Gm-Gg: AR+sD118Y1bHOKmLJ8SpFGIfagrKMLvaNZC84FuDShJx5uSYUWNsG57njCxW3V4iEYq
	ooWaxbysiVcevewTxg0yV/QPT2sj8UEchCe5NFUgEWwa+AnLaPT0fSyc3+XHQ4endaQ7d8429Gu
	qWgTqyBrJQC61v9WcLijc0rkVCjP5AOsLqBA4y5WfQpgrPIdQkNqk9D01dazbMcRxEXOOxgI+NU
	bJdPgzPVfAFT+njzihql/ATq2Pq/dr6FOer0fAAWdob0gAv8LONpn32m+2pfuvo2nv2zuT+n4Xi
	ZceLPg+GLgdETtiZFGgbDlJ26XRS6KUkb7MDOuiAkfZtHvL9Gjj0xIlZj9/yIlSCaAMOxuMkgRP
	hwi3Rks0hM3lDqaMBqAVjO5foz7HiVXXDifo19ZJuwtec+0EPjH0egQUdmO3cVA4aIqOKrMJfjY
	0XjJab3kyk9NQ1Vyh8dk2M8Pjdk+/d5/sQ3DhTNaaY8E8o/x+AG+nPaQ==
X-Received: by 2002:a05:600c:c490:b0:495:7538:d4ea with SMTP id 5b1f17b1804b1-4980c5fd773mr14469305e9.0.1785562293323;
        Fri, 31 Jul 2026 22:31:33 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm18564856eec.19.2026.07.31.22.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 22:31:32 -0700 (PDT)
Message-ID: <941a0de5-d518-4491-ac32-0704a6a253eb@suse.com>
Date: Sat, 1 Aug 2026 15:01:24 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [btrfs?] kernel BUG in compress_file_range
To: syzbot <syzbot+db04810ad3d91a0a4697@syzkaller.appspotmail.com>,
 clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <6a6d3d03.2d659fcc.1d46f5.01aa.GAE@google.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
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
In-Reply-To: <6a6d3d03.2d659fcc.1d46f5.01aa.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/1 09:55, syzbot 写道:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f5098b6bae76 Linux 7.2-rc5
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17829632580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b7079b368dcec295
> dashboard link: https://syzkaller.appspot.com/bug?extid=db04810ad3d91a0a4697
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b18067cdf26c/disk-f5098b6b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2b364c33a0f2/vmlinux-f5098b6b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2dfce6f90a4d/bzImage-f5098b6b.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+db04810ad3d91a0a4697@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/inode.c:977!

This one is from the BUG_ON() of memory allocation.

We need to properly handle the memory allocation error.

Thanks for the report,
Qu

> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 1 UID: 0 PID: 752 Comm: kworker/u8:6 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
> Workqueue: btrfs-delalloc btrfs_work_helper
> RIP: 0010:compress_file_range+0x1e27/0x2430 fs/btrfs/inode.c:977
> Code: af 0c 01 e8 db 39 8a fd e9 55 fd ff ff e8 51 fc ae fd 48 c7 c6 20 1d 28 8c 48 89 df e8 a2 ab ff fd 90 0f 0b e8 3a fc ae fd 90 <0f> 0b e8 32 fc ae fd 48 8b 54 24 78 48 b8 00 00 00 00 00 fc ff df
> RSP: 0018:ffffc9000454fac0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000020000 RCX: ffffffff845b3929
> RDX: ffff8880272e9f00 RSI: ffffffff845b42e6 RDI: ffff8880272e9f00
> RBP: 00000000fffffff4 R08: 0000000000000005 R09: 0000000000000000
> R10: 00000000fffffff4 R11: 0000000000000000 R12: 000000000001ffff
> R13: 0000000000000fea R14: ffff888068d78000 R15: 0000000000000016
> FS:  0000000000000000(0000) GS:ffff888123ede000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000110c3ea6fb CR3: 000000001cbb3000 CR4: 0000000000350ef0
> Call Trace:
>   <TASK>
>   btrfs_work_helper+0x214/0xc70 fs/btrfs/async-thread.c:312
>   process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
>   process_scheduled_works kernel/workqueue.c:3405 [inline]
>   worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
>   kthread+0x370/0x450 kernel/kthread.c:436
>   ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:compress_file_range+0x1e27/0x2430 fs/btrfs/inode.c:977
> Code: af 0c 01 e8 db 39 8a fd e9 55 fd ff ff e8 51 fc ae fd 48 c7 c6 20 1d 28 8c 48 89 df e8 a2 ab ff fd 90 0f 0b e8 3a fc ae fd 90 <0f> 0b e8 32 fc ae fd 48 8b 54 24 78 48 b8 00 00 00 00 00 fc ff df
> RSP: 0018:ffffc9000454fac0 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000020000 RCX: ffffffff845b3929
> RDX: ffff8880272e9f00 RSI: ffffffff845b42e6 RDI: ffff8880272e9f00
> RBP: 00000000fffffff4 R08: 0000000000000005 R09: 0000000000000000
> R10: 00000000fffffff4 R11: 0000000000000000 R12: 000000000001ffff
> R13: 0000000000000fea R14: ffff888068d78000 R15: 0000000000000016
> FS:  0000000000000000(0000) GS:ffff888123dde000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f16bf558fb0 CR3: 000000007c548000 CR4: 0000000000350ef0
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 

