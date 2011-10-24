From: Jim <jim@webstarts.com>
Subject: subvolume delete freezes
Date: Mon, 24 Oct 2011 16:59:00 -0400
Message-ID: <4EA5D194.9080206@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Good afternoon Btrfs list.
I was working with snapshots and created one of a small filetree as 
/btrfs/snaps/0000.101411.  Several days late, not having written to the 
snapshot, but having written to the original files, I tried to delete 
the snapshot.  btrfs subvolume delete /snaps/0000.101411 hung the 
machine.  I had to open a new terminal, ssh in, and use echo b > 
/proc/sysrq-trigger (all else had failed) to reboot the machine.  Here 
are the log entries I recovered.  I hope this means something to you 
guys because I am at a loss to explain what happened.

Oct 24 12:32:54 btrfs kernel: ame:4>Mon: nnfsdacl ss efs4vint ipmsi 
indleunrpq ga llcdemaacpiufreq frle mperfpt_Rnf_cack_nf_d_ipv ip_es 
nack_6t_REJECT nfconnk_ip6 nffragpv6 te nack ble_ter les  lzo_comd se sg 
pcspkr serio_raw i2dor_suppo mbcache jbdrc_t10dif [last unloaded: ash 
Tainted: G        W   3.1fff81049b [<fffff0
Oct 24 12:32:54 btrfs kernel: [<ffffffffa01ae3c0 [btrfs]
Oct 24 12:32:54 btrfs kernel: <0x210/0rfs_lookup_denf8113cb2b>] ? 
1146425106>] 
btfff8113ae718113cdc68113f380fffffff8[<fffffffffff81140f637>] 
?<ffffffff8113523c>] vfs_fstatat+0x4c/0x90
Oct 24 12:32:54 btrfs kernel: [<ffffffff811353at+fff8_syscallry+01bf/0
Oct 24 12:32:54 btrfs kernel: <4ffff9ab>stemtpat16/0end ace af9a4ae678 ]---
Oct 24 12:32:54 btrfs kernel: -cut ----4>WAING:btrf btrlean3c0 ]()
Oct 24 12:32:54 btrfs kernel: ame:4>Mon: nnfsdacl ss efs4 vint ipmsi 
indleunrpq ga llcdemaacpiufreq frle mperfpt_Rnf_cack_nf_d_ipv ip_es 
nack_6t_REJECT nfconnk_ip6 nffragpv6 te nack ble_ter les  lzo_comd se sg 
pcspkr serio_raw idor_supp mbcache jbd2 sr_mod cdrom rc_t10dif [last 
unloadeash Tainted: G        W   3fff81049b [<fffff0
Oct 24 12:32:54 btrfs kernel: [<ffffffffa01aea83c0 
[btr0x210/0x4rfs_lookupf8113cb2b>] ? d1146425>106>] 
btfff8113ae78113cdc68113f380fffffff[<fffffffff811f637>] ? 
cu<ffffffff8113523c>] vfs_fstatat+0x4c/0x90
Oct 24 12:32:54 btrfs kernel: [<ffffffff8113535b>at+0fff8_syscallry+01bf/0
Oct 24 12:32:54 btrfs kernel: <4ffff9ab>stemtpat16/0end ace af9a4ae679 ]---
Oct 24 12:32:54 btrfs kernel: -cut ----4>WAING:btrf btrlean3c0 ]()

I am running on kernel 3.1-rc4.  Thanks for any info.
Jim Maloney
