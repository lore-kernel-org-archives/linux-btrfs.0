Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6834F55A6
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 21:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839874; cv=none; b=AiaIVNfiA81nu4pGUguBqi7SWukxaCoBhfDgw30HB/oihzVkvRsBIYHl25DES6LJoFAKITsZQILpgwVFmTSryXgQEWe+b6jzTDW8LHWEmYrUepVp3EgaZoSnmYtiAaNvHq4bd7ZgU3Ctk5tDwrUkikOPUuUVlv/igSPPGQHChBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839874; c=relaxed/simple;
	bh=47ZqpKPimIriyp8XV8Fb98YLwFN8cLyA4H4Jz9f3CTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQyloVAxO/YgDLFA6rcxdksCPxZhujF/+IBu1t4kaW44l75guEnJLNcvt2Bq66u343vFCHa9LobfNK3vK/TJ99l8O978cM5o7vmNNPaLC0CQz5MEnP6fWdkQyLxnrBk++aQmMcV4St+EcLes5Vy0Nkt9Up+mN3OG8lhl+6hkyt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=hOGDpZ7+; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="hOGDpZ7+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1791839864; x=1792444664; i=quwenruo.btrfs@gmx.com;
	bh=JNZkvY1hcjRNoIPvFZtaxgjArnmY2o2kB/mr+V6L9TI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hOGDpZ7+GxY6TLhlPstAVGNKQWofl6CrLjdkqQ87jtpmvmIK4R2ADupevKvjpnJG
	 HZfXQF2zLP55xyNDcVj5SAVTAnUz4gYsEIPewPl8j6INj2T6f8K7evEJlHZsASzjS
	 epLsOGoNEIxg3MiPQhh5ux7aUOGaDe2vT//3h9X1Viu/P2eK4CCFE0t7ZebKM7kwd
	 yJSzvOlKt372JfDETZeur7aFZAjyXq3SfyVh7gNlUNS1VUrHqTUotiNHIpZjNZfuT
	 T4kgCqAxnUQWvWQ9gd8gQsqv00Qt99aot5W+5iDE+4i/P5Oi2TzbAXuTnsV9v6S1j
	 8+b3+sqE2Kx3EKSuvA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MIx3I-1wx32D1kZW-00XZZi; Mon, 12
 Oct 2026 23:17:44 +0200
Message-ID: <7b088082-7a62-4859-b8bc-0562368e0634@gmx.com>
Date: Tue, 13 Oct 2026 07:47:38 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/2] btrfs: fix use-after-free on quota enable
 allocation failure
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
 Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
 syzbot+947286c775f432b073a8@syzkaller.appspotmail.com,
 Boris Burkov <boris@bur.io>
References: <cover.1791706855.git.wqu@suse.com>
 <f6c20a7063b1f67881a61cdbd707f4634df9ed0c.1791706855.git.wqu@suse.com>
 <CAPjX3FfauJ8S7ShhusSm7WX5MEMa3uDwEi-=F_BdA+RM0f_DJQ@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCaqsNDQUJFJfy
 XgAKCRDCPZHzoSX+qPcICACxEFp2nh6g7JQyRkN855kqXeAYiWGZRWbCo+QQcGU0vjlm6s5K
 4CRT8U6RtY0Ou1Ss/MYrpf3z0joYh0hoWDgiVqhUXLG5jM2FeBY6bHl8WHKsMOiVpcB6yJqu
 Umqira0lLmg0V+9zHkijuH9cqxIYURsDNNkUueMy3ZBBxLq14w5JFcqOU7tdHxa2NZoO/pck
 qEZSL9lrsmRFe2dzFnxw4nOhikr9tkAqQN2wpW2OG8D1oLNARDx3hnhMYj9pKZ0ICZDtl6J3
 ACi9ZIWLNGqwb8ayizmyKmCGouN0gLAuwGFq2qRpXGCxe2lTYknUk71CvBcCzFgCX8qlobxF
 NCYXzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <CAPjX3FfauJ8S7ShhusSm7WX5MEMa3uDwEi-=F_BdA+RM0f_DJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1QXaYWEnBVMjHjtyQmQHZ9l5iM9hCSeoEb2J78GmFioVi8EFSSt
 PCAPn2HJ/q4zE7mrFhlq44/XiQMD9luwWKUF1KE/BQVBmNfQpn6V5A8DeON33mk1A6AAcBf
 gkPuN2l0ptBbUZeIGDQ7QD2GKf7D+Gh4borhmle+DMqODaJ67OPRLjEnXj+sTLIBQV8FJWG
 qd/Z3+3j63eBDBKXejHzA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4jxfsbkpIhU=;wcjmGrotufGWPnQlDV7WYUIcLF6
 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
 sDU2WAOh7tk=



=E5=9C=A8 2026/10/13 02:16, Daniel Vacek =E5=86=99=E9=81=93:
> On Sun, 11 Oct 2026 at 10:22, Qu Wenruo <wqu@suse.com> wrote:
>> From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
>>
>> [BUG]
>> There is a syzbot report that a use-after-free bug is triggered after a
>> failed btrfs_quota_enable():
>>
>>   loop0: detected capacity change from 32768 to 0
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>   BUG: KASAN: slab-use-after-free in __list_add_valid_or_report+0x4e/0x=
130 lib/list_debug.c:29
>>   Read of size 8 at addr ffff888040e0a528 by task syz.0.0/5324
>>
>>   CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted syzkaller #0 PREEMP=
T(full)
>>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debia=
n-1.16.3-2 04/01/2014
>>   Call Trace:
>>    <TASK>
>>    dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>    print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>>    print_report+0x58/0x70 mm/kasan/report.c:482
>>    kasan_report+0x117/0x150 mm/kasan/report.c:595
>>    __list_add_valid_or_report+0x4e/0x130 lib/list_debug.c:29
>>    __list_add_valid include/linux/list.h:104 [inline]
>>    __list_add include/linux/list.h:169 [inline]
>>    list_add include/linux/list.h:192 [inline]
>>    list_move include/linux/list.h:345 [inline]
>>    add_root_to_dirty_list+0x38b/0x470 fs/btrfs/ctree.c:232
>>    btrfs_force_cow_block+0xf09/0x1bf0 fs/btrfs/ctree.c:553
>>    btrfs_cow_block+0x3f1/0xaf0 fs/btrfs/ctree.c:696
>>    btrfs_search_slot+0xd70/0x2d20 fs/btrfs/ctree.c:-1
>>    btrfs_search_prev_slot fs/btrfs/free-space-tree.c:134 [inline]
>>    remove_free_space_extent fs/btrfs/free-space-tree.c:732 [inline]
>>    __btrfs_remove_from_free_space_tree fs/btrfs/free-space-tree.c:837 [=
inline]
>>    btrfs_remove_from_free_space_tree+0x4d6/0xda0 fs/btrfs/free-space-tr=
ee.c:866
>>    alloc_reserved_extent+0x4a/0x2b0 fs/btrfs/extent-tree.c:4976
>>    alloc_reserved_tree_block fs/btrfs/extent-tree.c:5155 [inline]
>>    run_delayed_tree_ref fs/btrfs/extent-tree.c:1815 [inline]
>>    run_one_delayed_ref fs/btrfs/extent-tree.c:1851 [inline]
>>    btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:2058 [inline]
>>    __btrfs_run_delayed_refs+0x18b5/0x43b0 fs/btrfs/extent-tree.c:2134
>>    btrfs_run_delayed_refs+0xdc/0x2a0 fs/btrfs/extent-tree.c:2246
>>    btrfs_commit_transaction+0x28a/0x3170 fs/btrfs/transaction.c:2267
>>    sync_filesystem+0x1d2/0x240 fs/sync.c:66
>>    btrfs_reconfigure+0x2dc/0x2100 fs/btrfs/super.c:1511
>>    reconfigure_super+0x232/0x8f0 fs/super.c:1128
>>    do_remount fs/namespace.c:3410 [inline]
>>    path_mount+0xd4e/0x1050 fs/namespace.c:4160
>>    do_mount fs/namespace.c:4181 [inline]
>>    __do_sys_mount fs/namespace.c:4397 [inline]
>>    __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>>    do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>>    do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>   RIP: 0033:0x7f9c8dd9f3ca
>>    </TASK>
>>
>>   Allocated by task 5323:
>>    kasan_save_stack mm/kasan/common.c:57 [inline]
>>    kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>    poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
>>    __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
>>    kasan_kmalloc include/linux/kasan.h:263 [inline]
>>    __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
>>    _kmalloc_noprof include/linux/slab.h:991 [inline]
>>    _kzalloc_noprof include/linux/slab.h:1312 [inline]
>>    btrfs_alloc_root+0x75/0x840 fs/btrfs/disk-io.c:638
>>    btrfs_create_tree+0xa8/0x5c0 fs/btrfs/disk-io.c:832
>>    btrfs_quota_enable+0x3d6/0x1e20 fs/btrfs/qgroup.c:1074
>>    btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
>>    vfs_ioctl fs/ioctl.c:51 [inline]
>>    __do_sys_ioctl fs/ioctl.c:597 [inline]
>>    __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>>    do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>>    do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>>   Freed by task 5323:
>>    kasan_save_stack mm/kasan/common.c:57 [inline]
>>    kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>>    kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>>    poison_slab_object mm/kasan/common.c:264 [inline]
>>    __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
>>    kasan_slab_free include/linux/kasan.h:235 [inline]
>>    slab_free_hook mm/slub.c:2748 [inline]
>>    slab_free mm/slub.c:6508 [inline]
>>    kfree+0x1c5/0x650 mm/slub.c:6801
>>    btrfs_quota_enable+0x1208/0x1e20 fs/btrfs/qgroup.c:1292
>>    btrfs_ioctl_quota_ctl+0x186/0x1f0 fs/btrfs/ioctl.c:3581
>>    vfs_ioctl fs/ioctl.c:51 [inline]
>>    __do_sys_ioctl fs/ioctl.c:597 [inline]
>>    __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>>    do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>>    do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> [CAUSE]
>> During btrfs_quota_enable(), a temporary quota_root is created, then
>> qgroup items are created for each subvolume and inserted into that root=
.
>>
>> If there are enough subvolumes, the level of quota_root will be bumped,
>> and add_root_to_dirty_list() will be called, adding
>> quota_root->dirty_list into fs_info->dirty_cowonly_roots.
>>
>> But if a problem is hit during btrfs_quota_enable() later, that
>> quota_root will be released through btrfs_put_root(), causing the whole
>> quota_root structure to be released, while leaving
>> fs_info->dirty_cowonly_roots still pointing to the released
>> quota_root->dirty_list.
>>
>> Later access through fs_info->dirty_cowonly_roots will trigger a
>> use-after-free bug.
>>
>> [FIX]
>> We can just call list_del_init(&root->dirty_list) when
>> btrfs_quota_enable() failed.
>>
>> Also to follow the existing error handling behavior, abort the
>> transaction when the memory preallocation failed.
>>
>> Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
>> Link: https://lore.kernel.org/linux-btrfs/6ac5a5e1.9ad129c8.3ce5b3.0010=
.GAE@google.com/
>> Closes: https://syzkaller.appspot.com/bug?extid=3D947286c775f432b073a8
>> Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>> [ Change the commit message to include a proper analysis. ]
>> Reviewed-by: Boris Burkov <boris@bur.io>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/qgroup.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index cf8dfd5c692b..a0651fbfe778 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1207,6 +1207,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_i=
nfo,
>>          prealloc =3D kzalloc_obj(*prealloc, GFP_NOFS);
>>          if (!prealloc) {
>>                  ret =3D -ENOMEM;
>> +               btrfs_abort_transaction(trans, ret);
>>                  goto out;
>>          }
>>          qgroup =3D add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJE=
CTID);
>> @@ -1296,6 +1297,12 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_=
info,
>>                   * sysfs entries.
>>                   */
>>                  btrfs_free_qgroup_config(fs_info);
>> +
>> +               if (quota_root) {
>=20
> How about
>=20
> +               if (quota_root && !list_empty(&quota_root->dirty_list)) =
{
>=20
> to avoid taking the lock if not needed?

I'd say we're already in the error path, we shouldn't bother efficiency=20
at all.
>=20
> --nX
>=20
>> +                       spin_lock(&fs_info->trans_lock);
>> +                       list_del_init(&quota_root->dirty_list);
>> +                       spin_unlock(&fs_info->trans_lock);
>> +               }
>>                  btrfs_put_root(quota_root);
>>          }
>>          mutex_unlock(&fs_info->qgroup_ioctl_lock);
>> --
>> 2.56.0
>>
>>
>=20

