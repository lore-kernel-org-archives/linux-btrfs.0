Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35097 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2LLThW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 14:37:22 -0500
Received: by mail-ob0-f174.google.com with SMTP id ta14so1091383obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 11:37:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121101112114.GA4328@liubo.cn.oracle.com>
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
	<CANW9uyu0NyFj57AVp2X-Hc=AjXdwyP=wieOcteEbj2_Mx_F95w@mail.gmail.com>
	<50911FC0.4080104@oracle.com>
	<CANW9uyse7bw1+=GkV-aRQbDPh1E-t3G4VwkAGc5-76KMfYMjog@mail.gmail.com>
	<20121101112114.GA4328@liubo.cn.oracle.com>
Date: Wed, 12 Dec 2012 13:37:21 -0600
Message-ID: <CAKcLGm-u69MYQGcu3b4v=8TwSG8=axgLCWixDTthEUuinK_meA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>, linux-btrfs@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 1, 2012 at 6:21 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Nov 01, 2012 at 08:08:52PM +0900, Itaru Kitayama wrote:
>> Hi Liubo,
>>
>> I couldn't apply your V4 patch against the btrfs-next HEAD. Do you have
>> a github branch which I can checkout?
>>
>
> The current btrfs-next HEAD actually have included this v4 patch, so
> just pull btrfs-next and give it a shot :)
>

I'm still seeing similar issues using Josef's current btrfs-next
branch (which still includes the v4 version of the snapshot-aware
defrag patches).

[44507.850693] ------------[ cut here ]------------
[44507.850728] WARNING: at fs/btrfs/inode.c:7755
btrfs_destroy_inode+0x231/0x2c4 [btrfs]()
[44507.850732] Hardware name: OptiPlex 745
[44507.850735] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
mfd_core lrw xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
btrfs libcrc32c
[44507.850753] Pid: 15719, comm: umount Tainted: G        W
3.7.0-btrfs-next+ #1
[44507.850756] Call Trace:
[44507.850766]  [<ffffffff810364da>] warn_slowpath_common+0x74/0xa2
[44507.850770]  [<ffffffff81036522>] warn_slowpath_null+0x1a/0x1c
[44507.850787]  [<ffffffffa0041e0e>] btrfs_destroy_inode+0x231/0x2c4 [btrfs]
[44507.850793]  [<ffffffff81141670>] destroy_inode+0x3c/0x5f
[44507.850797]  [<ffffffff811417b5>] evict+0x122/0x1ac
[44507.850800]  [<ffffffff81142016>] iput+0xed/0x169
[44507.850816]  [<ffffffffa0038c18>] btrfs_run_delayed_iputs+0xd6/0xf6 [btrfs]
[44507.850831]  [<ffffffffa002db75>] btrfs_commit_super+0x2c/0xfd [btrfs]
[44507.850845]  [<ffffffffa002f289>] close_ctree+0x2c1/0x300 [btrfs]
[44507.850850]  [<ffffffff811424c9>] ? evict_inodes+0x106/0x115
[44507.850861]  [<ffffffffa00070b1>] btrfs_put_super+0x19/0x1b [btrfs]
[44507.850866]  [<ffffffff8112b321>] generic_shutdown_super+0x5b/0xdc
[44507.850869]  [<ffffffff8112b424>] kill_anon_super+0x16/0x24
[44507.850880]  [<ffffffffa000ad98>] btrfs_kill_super+0x1a/0x8f [btrfs]
[44507.850884]  [<ffffffff8112b647>] deactivate_locked_super+0x33/0x6c
[44507.850887]  [<ffffffff8112c25f>] deactivate_super+0x4e/0x66
[44507.850892]  [<ffffffff81145e64>] mntput_no_expire+0xf7/0x14d
[44507.850896]  [<ffffffff81146ced>] sys_umount+0x63/0x37a
[44507.850901]  [<ffffffff8183e642>] system_call_fastpath+0x16/0x1b
[44507.850905] ---[ end trace ba14fbf3de68a237 ]---
[44507.850907] ------------[ cut here ]------------
[44507.850924] WARNING: at fs/btrfs/inode.c:7756
btrfs_destroy_inode+0x2b9/0x2c4 [btrfs]()
[44507.850927] Hardware name: OptiPlex 745
[44507.850930] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
mfd_core lrw xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
btrfs libcrc32c
[44507.850947] Pid: 15719, comm: umount Tainted: G        W
3.7.0-btrfs-next+ #1
[44507.850949] Call Trace:
[44507.850956]  [<ffffffff810364da>] warn_slowpath_common+0x74/0xa2
[44507.850961]  [<ffffffff81036522>] warn_slowpath_null+0x1a/0x1c
[44507.850978]  [<ffffffffa0041e96>] btrfs_destroy_inode+0x2b9/0x2c4 [btrfs]
[44507.850982]  [<ffffffff81141670>] destroy_inode+0x3c/0x5f
[44507.850986]  [<ffffffff811417b5>] evict+0x122/0x1ac
[44507.850990]  [<ffffffff81142016>] iput+0xed/0x169
[44507.851003]  [<ffffffffa0038c18>] btrfs_run_delayed_iputs+0xd6/0xf6 [btrfs]
[44507.851033]  [<ffffffffa002db75>] btrfs_commit_super+0x2c/0xfd [btrfs]
[44507.851048]  [<ffffffffa002f289>] close_ctree+0x2c1/0x300 [btrfs]
[44507.851052]  [<ffffffff811424c9>] ? evict_inodes+0x106/0x115
[44507.851063]  [<ffffffffa00070b1>] btrfs_put_super+0x19/0x1b [btrfs]
[44507.851066]  [<ffffffff8112b321>] generic_shutdown_super+0x5b/0xdc
[44507.851070]  [<ffffffff8112b424>] kill_anon_super+0x16/0x24
[44507.851080]  [<ffffffffa000ad98>] btrfs_kill_super+0x1a/0x8f [btrfs]
[44507.851084]  [<ffffffff8112b647>] deactivate_locked_super+0x33/0x6c
[44507.851087]  [<ffffffff8112c25f>] deactivate_super+0x4e/0x66
[44507.851091]  [<ffffffff81145e64>] mntput_no_expire+0xf7/0x14d
[44507.851095]  [<ffffffff81146ced>] sys_umount+0x63/0x37a
[44507.851099]  [<ffffffff8183e642>] system_call_fastpath+0x16/0x1b
[44507.851101] ---[ end trace ba14fbf3de68a238 ]---
[44507.851104] ------------[ cut here ]------------
[44507.851121] WARNING: at fs/btrfs/inode.c:7758
btrfs_destroy_inode+0x28d/0x2c4 [btrfs]()
[44507.851123] Hardware name: OptiPlex 745
[44507.851124] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
mfd_core lrw xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
btrfs libcrc32c
[44507.851140] Pid: 15719, comm: umount Tainted: G        W
3.7.0-btrfs-next+ #1
[44507.851142] Call Trace:
[44507.851148]  [<ffffffff810364da>] warn_slowpath_common+0x74/0xa2
[44507.851152]  [<ffffffff81036522>] warn_slowpath_null+0x1a/0x1c
[44507.851168]  [<ffffffffa0041e6a>] btrfs_destroy_inode+0x28d/0x2c4 [btrfs]
[44507.851172]  [<ffffffff81141670>] destroy_inode+0x3c/0x5f
[44507.851176]  [<ffffffff811417b5>] evict+0x122/0x1ac
[44507.851180]  [<ffffffff81142016>] iput+0xed/0x169
[44507.851195]  [<ffffffffa0038c18>] btrfs_run_delayed_iputs+0xd6/0xf6 [btrfs]
[44507.851209]  [<ffffffffa002db75>] btrfs_commit_super+0x2c/0xfd [btrfs]
[44507.851223]  [<ffffffffa002f289>] close_ctree+0x2c1/0x300 [btrfs]
[44507.851227]  [<ffffffff811424c9>] ? evict_inodes+0x106/0x115
[44507.851237]  [<ffffffffa00070b1>] btrfs_put_super+0x19/0x1b [btrfs]
[44507.851241]  [<ffffffff8112b321>] generic_shutdown_super+0x5b/0xdc
[44507.851245]  [<ffffffff8112b424>] kill_anon_super+0x16/0x24
[44507.851255]  [<ffffffffa000ad98>] btrfs_kill_super+0x1a/0x8f [btrfs]
[44507.851259]  [<ffffffff8112b647>] deactivate_locked_super+0x33/0x6c
[44507.851263]  [<ffffffff8112c25f>] deactivate_super+0x4e/0x66
[44507.851266]  [<ffffffff81145e64>] mntput_no_expire+0xf7/0x14d
[44507.851270]  [<ffffffff81146ced>] sys_umount+0x63/0x37a
[44507.851274]  [<ffffffff8183e642>] system_call_fastpath+0x16/0x1b
[44507.851277] ---[ end trace ba14fbf3de68a239 ]---
[44507.969039] ------------[ cut here ]------------
[44507.969069] WARNING: at fs/btrfs/extent-tree.c:4351
btrfs_free_block_groups+0x2ad/0x34c [btrfs]()
[44507.969074] Hardware name: OptiPlex 745
[44507.969078] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
mfd_core lrw xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
btrfs libcrc32c
[44507.969104] Pid: 15719, comm: umount Tainted: G        W
3.7.0-btrfs-next+ #1
[44507.969107] Call Trace:
[44507.969119]  [<ffffffff810364da>] warn_slowpath_common+0x74/0xa2
[44507.969125]  [<ffffffff81036522>] warn_slowpath_null+0x1a/0x1c
[44507.969144]  [<ffffffffa0022ec0>] btrfs_free_block_groups+0x2ad/0x34c [btrfs]
[44507.969166]  [<ffffffffa002f188>] close_ctree+0x1c0/0x300 [btrfs]
[44507.969173]  [<ffffffff811424c9>] ? evict_inodes+0x106/0x115
[44507.969189]  [<ffffffffa00070b1>] btrfs_put_super+0x19/0x1b [btrfs]
[44507.969195]  [<ffffffff8112b321>] generic_shutdown_super+0x5b/0xdc
[44507.969201]  [<ffffffff8112b424>] kill_anon_super+0x16/0x24
[44507.969215]  [<ffffffffa000ad98>] btrfs_kill_super+0x1a/0x8f [btrfs]
[44507.969221]  [<ffffffff8112b647>] deactivate_locked_super+0x33/0x6c
[44507.969226]  [<ffffffff8112c25f>] deactivate_super+0x4e/0x66
[44507.969232]  [<ffffffff81145e64>] mntput_no_expire+0xf7/0x14d
[44507.969237]  [<ffffffff81146ced>] sys_umount+0x63/0x37a
[44507.969245]  [<ffffffff8183e642>] system_call_fastpath+0x16/0x1b
[44507.969249] ---[ end trace ba14fbf3de68a23a ]---
[44507.969252] ------------[ cut here ]------------
[44507.969271] WARNING: at fs/btrfs/extent-tree.c:4352
btrfs_free_block_groups+0x347/0x34c [btrfs]()
[44507.969275] Hardware name: OptiPlex 745
[44507.969279] Modules linked in: iTCO_wdt iTCO_vendor_support lpc_ich
mfd_core lrw xts gf128mul ablk_helper cryptd aes_x86_64 sha256_generic
btrfs libcrc32c
[44507.969302] Pid: 15719, comm: umount Tainted: G        W
3.7.0-btrfs-next+ #1
[44507.969306] Call Trace:
[44507.969315]  [<ffffffff810364da>] warn_slowpath_common+0x74/0xa2
[44507.969322]  [<ffffffff81036522>] warn_slowpath_null+0x1a/0x1c
[44507.969342]  [<ffffffffa0022f5a>] btrfs_free_block_groups+0x347/0x34c [btrfs]
[44507.969362]  [<ffffffffa002f188>] close_ctree+0x1c0/0x300 [btrfs]
[44507.969368]  [<ffffffff811424c9>] ? evict_inodes+0x106/0x115
[44507.969383]  [<ffffffffa00070b1>] btrfs_put_super+0x19/0x1b [btrfs]
[44507.969389]  [<ffffffff8112b321>] generic_shutdown_super+0x5b/0xdc
[44507.969394]  [<ffffffff8112b424>] kill_anon_super+0x16/0x24
[44507.969408]  [<ffffffffa000ad98>] btrfs_kill_super+0x1a/0x8f [btrfs]
[44507.969414]  [<ffffffff8112b647>] deactivate_locked_super+0x33/0x6c
[44507.969419]  [<ffffffff8112c25f>] deactivate_super+0x4e/0x66
[44507.969424]  [<ffffffff81145e64>] mntput_no_expire+0xf7/0x14d
[44507.969429]  [<ffffffff81146ced>] sys_umount+0x63/0x37a
[44507.969434]  [<ffffffff8183e642>] system_call_fastpath+0x16/0x1b
[44507.969439] ---[ end trace ba14fbf3de68a23b ]---
