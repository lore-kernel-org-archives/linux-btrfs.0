From: "Marc R. O'Connor" <mroconnor@oel.state.nj.us>
Subject: kernel bug in file-item.c
Date: Tue, 28 Apr 2009 13:39:53 -0400
Message-ID: <49F73F69.4010205@oel.state.nj.us>
Reply-To: mroconnor@oel.state.nj.us
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_9lqur3x4o3APn4bkB2/gXw)"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_9lqur3x4o3APn4bkB2/gXw)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT

I have had two 'kernel bug' issues today both referencing file-item.c.
The first oops happened when i was cp'ing from and external HD(ext3) to
and ext3 partition. The second happened during boot up. I have attached
them both.

Im using btrfs that was merged into my kernel yesterday.

-- 

--
Marc R. O'Connor
Information Systems
Camden County Board of Social Services
600 Market St.
Camden, NJ 08102
mroconnor@oel.state.nj.us
856-225-8915 Ofc.
609-206-3458 Blackberry
319D8AF1 BB PIN


--Boundary_(ID_9lqur3x4o3APn4bkB2/gXw)
Content-type: text/plain; name=btrfs_bug_1
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=btrfs_bug_1

Apr 28 10:55:10 cosmo2 ------------[ cut here ]------------
Apr 28 10:55:10 cosmo2 kernel BUG at fs/btrfs/file-item.c:494!
Apr 28 10:55:10 cosmo2 invalid opcode: 0000 [#1] PREEMPT SMP
Apr 28 10:55:10 cosmo2 last sysfs file: /sys/devices/platform/hdaps/position
Apr 28 10:55:10 cosmo2 CPU 1
Apr 28 10:55:10 cosmo2 Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss udf isofs berry_charge tun hdaps tp_smapi thinkpad_ac$
Apr 28 10:55:10 cosmo2 Pid: 3144, comm: btrfs-transacti Not tainted 2.6.30-rc3-zen0 #5 4058CTO
Apr 28 10:55:10 cosmo2 RIP: 0010:[<ffffffff80356c0f>]  [<ffffffff80356c0f>] truncate_one_csum+0x116/0x12f
Apr 28 10:55:10 cosmo2 RSP: 0018:ffff8801384a3a90  EFLAGS: 00010286
Apr 28 10:55:10 cosmo2 RAX: 00000000ffffffff RBX: ffff880139d1c000 RCX: fffffffffffffff6
Apr 28 10:55:10 cosmo2 RDX: 0000000000000080 RSI: ffff8800bf5c308f RDI: ffff8801384a3a41
Apr 28 10:55:10 cosmo2 RBP: ffff8801384a3ad0 R08: ffff8801384a38d8 R09: ffff8801384a38d0
Apr 28 10:55:10 cosmo2 R10: 0000000000000005 R11: ffff8801394d6ea0 R12: ffff88003655e090
Apr 28 10:55:10 cosmo2 R13: ffff88003655f000 R14: ffff8801384a3b40 R15: 0000000000c03000
Apr 28 10:55:10 cosmo2 FS:  0000000000000000(0000) GS:ffff88002803b000(0000) knlGS:0000000000000000
Apr 28 10:55:10 cosmo2 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Apr 28 10:55:10 cosmo2 CR2: 000000000152a280 CR3: 0000000000201000 CR4: 00000000000006a0
Apr 28 10:55:10 cosmo2 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 28 10:55:10 cosmo2 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 28 10:55:10 cosmo2 Process btrfs-transacti (pid: 3144, threadinfo ffff8801384a2000, task ffff8801384a0040)
Apr 28 10:55:10 cosmo2 Stack:
Apr 28 10:55:10 cosmo2 0000000000c00000 0000000c00000004 ffff8800bf5c3000 ffff88003655e090
Apr 28 10:55:10 cosmo2 0000000000c00000 000000000000000c 0000000000c00000 ffff88013518b7e0
Apr 28 10:55:10 cosmo2 ffff8801384a3b90 ffffffff80356e95 0000000435154538 0000000000c02fff
Apr 28 10:55:10 cosmo2 Call Trace:
Apr 28 10:55:10 cosmo2 [<ffffffff80356e95>] btrfs_del_csums+0x26d/0x2a8
Apr 28 10:55:10 cosmo2 [<ffffffff8035016a>] __btrfs_free_extent+0x6a9/0x726
Apr 28 10:55:10 cosmo2 [<ffffffff80350359>] run_one_delayed_ref+0x172/0x17f
Apr 28 10:55:10 cosmo2 [<ffffffff8034f548>] ? select_delayed_ref+0x1c/0x75
Apr 28 10:55:10 cosmo2 [<ffffffff8035406b>] run_clustered_refs+0xf2/0x167
Apr 28 10:55:10 cosmo2 [<ffffffff803541b3>] btrfs_run_delayed_refs+0xd3/0x1d4
Apr 28 10:55:10 cosmo2 [<ffffffff8035e0ca>] btrfs_commit_transaction+0x8c/0x88e
Apr 28 10:55:10 cosmo2 [<ffffffff80248615>] ? autoremove_wake_function+0x0/0x34
Apr 28 10:55:10 cosmo2 [<ffffffff8035d9b0>] ? start_transaction+0xfa/0x106
Apr 28 10:55:10 cosmo2 [<ffffffff803595de>] transaction_kthread+0x171/0x20f
Apr 28 10:55:10 cosmo2 [<ffffffff8035946d>] ? transaction_kthread+0x0/0x20f
Apr 28 10:55:10 cosmo2 [<ffffffff8035946d>] ? transaction_kthread+0x0/0x20f
Apr 28 10:55:10 cosmo2 [<ffffffff802482ad>] kthread+0x55/0x80
Apr 28 10:55:10 cosmo2 [<ffffffff8020be6a>] child_rip+0xa/0x20
Apr 28 10:55:10 cosmo2 [<ffffffff80248258>] ? kthread+0x0/0x80
Apr 28 10:55:10 cosmo2 [<ffffffff8020be60>] ? child_rip+0x0/0x20
Apr 28 10:55:10 cosmo2 Code: af ce 48 89 de e8 cd bc fe ff 85 c0 74 04 0f 0b eb fe 4d 89 7e 09 4c 89 f1 4c 89 e2 48 89 de 4c 89 ef e8 4a 96 fe ff 85 c0 74 08 <0f> 0b eb fe 0f 0b eb fe 48 83$
Apr 28 10:55:10 cosmo2 RIP  [<ffffffff80356c0f>] truncate_one_csum+0x116/0x12f
Apr 28 10:55:10 cosmo2 RSP <ffff8801384a3a90>
Apr 28 10:55:10 cosmo2 ---[ end trace 2a213e7bc5e1ed02 ]---


--Boundary_(ID_9lqur3x4o3APn4bkB2/gXw)
Content-type: text/plain; name=btrfs_bug_2
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=btrfs_bug_2

Apr 28 11:14:43 cosmo2 ------------[ cut here ]------------
Apr 28 11:14:43 cosmo2 kernel BUG at fs/btrfs/file-item.c:494!
Apr 28 11:14:43 cosmo2 invalid opcode: 0000 [#1] PREEMPT SMP
Apr 28 11:14:43 cosmo2 last sysfs file: /sys/module/snd_seq/initstate
Apr 28 11:14:43 cosmo2 CPU 0
Apr 28 11:14:43 cosmo2 Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss udf isofs berry_charge tun hdaps tp_smapi thinkpad_ac$
Apr 28 11:14:43 cosmo2 Pid: 3200, comm: btrfs-transacti Not tainted 2.6.30-rc3-zen0 #5 4058CTO
Apr 28 11:14:43 cosmo2 RIP: 0010:[<ffffffff80356c0f>]  [<ffffffff80356c0f>] truncate_one_csum+0x116/0x12f
Apr 28 11:14:43 cosmo2 RSP: 0018:ffff880138cb5a90  EFLAGS: 00010286
Apr 28 11:14:43 cosmo2 RAX: 00000000ffffffff RBX: ffff880138dc0000 RCX: fffffffffffffff6
Apr 28 11:14:43 cosmo2 RDX: 0000000000000080 RSI: ffff88013a11f08f RDI: ffff880138cb5a41
Apr 28 11:14:43 cosmo2 RBP: ffff880138cb5ad0 R08: ffff880138cb58d8 R09: ffff880138cb58d0
Apr 28 11:14:43 cosmo2 R10: 0000000000000005 R11: ffff8801388f06e0 R12: ffff880131029090
Apr 28 11:14:43 cosmo2 R13: ffff88013104f000 R14: ffff880138cb5b40 R15: 0000000000c03000
Apr 28 11:14:43 cosmo2 FS:  0000000000000000(0000) GS:ffff880028023000(0000) knlGS:0000000000000000
Apr 28 11:14:43 cosmo2 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Apr 28 11:14:43 cosmo2 CR2: 00000000015a61a8 CR3: 0000000000201000 CR4: 00000000000006a0
Apr 28 11:14:43 cosmo2 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Apr 28 11:14:43 cosmo2 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Apr 28 11:14:43 cosmo2 Process btrfs-transacti (pid: 3200, threadinfo ffff880138cb4000, task ffff880138c247c0)
Apr 28 11:14:43 cosmo2 Stack:
Apr 28 11:14:43 cosmo2 0000000000c00000 0000000c00000004 ffff88013a11f000 ffff880131029090
Apr 28 11:14:43 cosmo2 0000000000c00000 000000000000000c 0000000000c00000 ffff88013102eea0
Apr 28 11:14:43 cosmo2 ffff880138cb5b90 ffffffff80356e95 000000043102ee38 0000000000c02fff
Apr 28 11:14:43 cosmo2 Call Trace:
Apr 28 11:14:43 cosmo2 [<ffffffff80356e95>] btrfs_del_csums+0x26d/0x2a8
Apr 28 11:14:43 cosmo2 [<ffffffff8035016a>] __btrfs_free_extent+0x6a9/0x726
Apr 28 11:14:43 cosmo2 [<ffffffff80350359>] run_one_delayed_ref+0x172/0x17f
Apr 28 11:14:43 cosmo2 [<ffffffff8034f548>] ? select_delayed_ref+0x1c/0x75
Apr 28 11:14:43 cosmo2 [<ffffffff8035406b>] run_clustered_refs+0xf2/0x167
Apr 28 11:14:43 cosmo2 [<ffffffff803541b3>] btrfs_run_delayed_refs+0xd3/0x1d4
Apr 28 11:14:43 cosmo2 [<ffffffff802a0156>] ? iput+0x2f/0x65
Apr 28 11:14:43 cosmo2 [<ffffffff8035e0ca>] btrfs_commit_transaction+0x8c/0x88e
Apr 28 11:14:43 cosmo2 [<ffffffff80248615>] ? autoremove_wake_function+0x0/0x34
Apr 28 11:14:43 cosmo2 [<ffffffff8035d9b0>] ? start_transaction+0xfa/0x106
Apr 28 11:14:43 cosmo2 [<ffffffff803595de>] transaction_kthread+0x171/0x20f
Apr 28 11:14:43 cosmo2 [<ffffffff8035946d>] ? transaction_kthread+0x0/0x20f
Apr 28 11:14:43 cosmo2 [<ffffffff8035946d>] ? transaction_kthread+0x0/0x20f
Apr 28 11:14:43 cosmo2 [<ffffffff802482ad>] kthread+0x55/0x80
Apr 28 11:14:43 cosmo2 [<ffffffff8020be6a>] child_rip+0xa/0x20
Apr 28 11:14:43 cosmo2 [<ffffffff80248258>] ? kthread+0x0/0x80
Apr 28 11:14:43 cosmo2 [<ffffffff8020be60>] ? child_rip+0x0/0x20
Apr 28 11:14:43 cosmo2 Code: af ce 48 89 de e8 cd bc fe ff 85 c0 74 04 0f 0b eb fe 4d 89 7e 09 4c 89 f1 4c 89 e2 48 89 de 4c 89 ef e8 4a 96 fe ff 85 c0 74 08 <0f> 0b eb fe 0f 0b eb fe 48 83$
Apr 28 11:14:43 cosmo2 RIP  [<ffffffff80356c0f>] truncate_one_csum+0x116/0x12f
Apr 28 11:14:43 cosmo2 RSP <ffff880138cb5a90>
Apr 28 11:14:43 cosmo2 ---[ end trace 55c51a1dd09bad23 ]---
Apr 28 11:14:43 cosmo2 note: btrfs-transacti[3200] exited with preempt_count 1


--Boundary_(ID_9lqur3x4o3APn4bkB2/gXw)
Content-type: text/plain; name=file-item.c.snippet
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=file-item.c.snippet

   } else if (key->offset >= bytenr && csum_end > end_byte &&
                   end_byte > key->offset) {
                /*
                 *         [ bytenr - len ]
                 *                 [ ]
                 *                 [csum     ]
                 * we need to truncate from the beginning of the csum
                 */
                u32 new_size = (csum_end - end_byte) >> blocksize_bits;
                new_size *= csum_size;

                ret = btrfs_truncate_item(trans, root, path, new_size, 0);
                BUG_ON(ret);

                key->offset = end_byte;
                ret = btrfs_set_item_key_safe(trans, root, path, key);
                BUG_ON(ret);
        } else {
                BUG(); <-------LINE 494
        }
        return 0;
}

/*
 * deletes the csum items from the csum tree for a given
 * range of bytes.
 */
int btrfs_del_csums(struct btrfs_trans_handle *trans,
                    struct btrfs_root *root, u64 bytenr, u64 len)
{
        struct btrfs_path *path;
        struct btrfs_key key;
        u64 end_byte = bytenr + len;
        u64 csum_end;
        struct extent_buffer *leaf;
        int ret;
        u16 csum_size =
                btrfs_super_csum_size(&root->fs_info->super_copy);
        int blocksize_bits = root->fs_info->sb->s_blocksize_bits;

        root = root->fs_info->csum_root;


--Boundary_(ID_9lqur3x4o3APn4bkB2/gXw)
Content-type: text/x-vcard; charset=utf-8; name=mroconnor.vcf
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=mroconnor.vcf

begin:vcard
fn:Marc O'Connor
n:O'Connor;Marc
org:Camden County Board of Social Services;Information Technology
adr:;;600 Market St.;Camden;NJ;08102;USA
email;internet:mroconnor@oel.state.nj.us
tel;work:856-225-8915
tel;cell:609-206-3458
version:2.1
end:vcard


--Boundary_(ID_9lqur3x4o3APn4bkB2/gXw)
Content-type: Text/Plain; name=disclaimer.txt
Content-transfer-encoding: 7BIT
Content-disposition: attachment; Filename=disclaimer.txt
X-NAIMIME-Disclaimer: 1
X-NAIMIME-Modified: 1

This E-mail, including any attachments, may be intended solely for the personal 
and confidential use of the sender and recipient(s) named above. This message 
may include advisory, consultative and/or deliberative material and, as such, 
would be privileged and confidential and not a public document. Any Information 
in this e-mail identifying a client of the Department of Human Services is 
confidential. If you have received this e-mail in error, you must not review, 
transmit, convert to hard copy, copy, use or disseminate this e-mail or any 
attachments to it and you must delete this message. You are requested to notify 
the sender by return e-mail.

--Boundary_(ID_9lqur3x4o3APn4bkB2/gXw)--
