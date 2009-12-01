From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: (Little) Patch about null dereference with acl and posix.
Date: Tue, 1 Dec 2009 19:52:26 +0100
Message-ID: <200912011952.26313.johannes.hirte@fem.tu-ilmenau.de>
References: <61bf8f4f0911181328y794436ackb82acca35d578f46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: briaeros007 <briaeros007@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <61bf8f4f0911181328y794436ackb82acca35d578f46@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch 18 November 2009 22:28:27 schrieb briaeros007:
> Hello,
> For some days, i've got oops on my system and i've investigate it a bit.
> The trouble was with  "posix_acl_equiv_mode" , and for some reason
> (corrupted metadata ?) btrfs sometimes call it with "acl"==NULL
> This function doesn't like it.
> So in my patch I've first put a little error protection around the
> call, and then avoid to call btrfs_set_acl with acl=NULL.
> 
> I'm not sure if it's ok with best practice, but i've done the test
> which produce the oops, and know it doesn't (but some csum failed.
> Well if my btrfs is corrupted, it's comprehensible).
> 
> The patch is the following.
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 3616042..f8ade24 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -111,7 +111,8 @@ static int btrfs_set_acl(struct inode *inode,
> struct posix_acl *acl, int type)
>         switch (type) {
>         case ACL_TYPE_ACCESS:
>                 mode = inode->i_mode;
> -               ret = posix_acl_equiv_mode(acl, &mode);
> +               if (acl && mode)
> +                       ret = posix_acl_equiv_mode(acl, &mode);
>                 if (ret < 0)
>                         return ret;
>                 ret = 0;
> @@ -165,12 +166,13 @@ static int btrfs_xattr_set_acl(struct inode
> *inode, int type,
>                 } else if (IS_ERR(acl)) {
>                         return PTR_ERR(acl);
>                 }
> +               else
> +               {
> +                       ret = btrfs_set_acl(inode, acl, type);
> +                       posix_acl_release(acl);
> +               }
>         }
> 
> -       ret = btrfs_set_acl(inode, acl, type);
> -
> -       posix_acl_release(acl);
> -
>         return ret;
>  }

Thanx for this fix. I think I run into the same bug with rdiff-backup:

Dec  1 19:09:11 datengrab kernel: BUG: unable to handle kernel NULL pointer 
dereference at 0000000000000004
Dec  1 19:09:11 datengrab kernel: IP: [<ffffffff810c6c12>] 
posix_acl_equiv_mode+0x0/0x90
Dec  1 19:09:11 datengrab kernel: PGD 3609f067 PUD 7163067 PMD 0
Dec  1 19:09:11 datengrab kernel: Oops: 0000 [#1] SMP
Dec  1 19:09:11 datengrab kernel: last sysfs file: 
/sys/devices/pci0000:00/0000:00:18.3/temp1_input
Dec  1 19:09:11 datengrab kernel: CPU 0
Dec  1 19:09:11 datengrab kernel: Modules linked in: usb_storage snd_seq_midi 
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss aes_x86_64 aes_generic 
xts gf128mul dm_crypt snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm 
snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep sr_mod snd 
fglrx(P) k8temp sata_sil hwmon i2c_amd756 i2c_amd8111 ohci_hcd sg uhci_hcd
Dec  1 19:09:11 datengrab kernel: Pid: 22720, comm: rdiff-backup Tainted: P           
2.6.31.6-fglrx2 #2 To Be Filled By O.E.M.
Dec  1 19:09:11 datengrab kernel: RIP: 0010:[<ffffffff810c6c12>]  [<ffffffff810c6c12>] 
posix_acl_equiv_mode+0x0/0x90
Dec  1 19:09:11 datengrab kernel: RSP: 0018:ffff88001e051d60  EFLAGS: 00010246
Dec  1 19:09:11 datengrab kernel: RAX: 00000000000041c0 RBX: 0000000000000000 
RCX: 0000000000000000
Dec  1 19:09:11 datengrab kernel: RDX: 0000000000008000 RSI: ffff88001e051d84 
RDI: 0000000000000000
Dec  1 19:09:11 datengrab kernel: RBP: ffff880056b315e8 R08: ffff880056b315e8 R09: 
ffff880056b315e8
Dec  1 19:09:11 datengrab kernel: R10: ffff88001e051e38 R11: 0000000000004000 
R12: 0000000000000000
Dec  1 19:09:11 datengrab kernel: R13: 0000000000008000 R14: 00000000ffffffff R15: 
00000000ffffffff
Dec  1 19:09:11 datengrab kernel: FS:  00007f6b1e98d700(0000) 
GS:ffff8800015e0000(0000) knlGS:0000000000000000
Dec  1 19:09:11 datengrab kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Dec  1 19:09:11 datengrab kernel: CR2: 0000000000000004 CR3: 000000004c641000 
CR4: 00000000000006f0
Dec  1 19:09:11 datengrab kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
Dec  1 19:09:11 datengrab kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 
DR7: 0000000000000400
Dec  1 19:09:11 datengrab kernel: Process rdiff-backup (pid: 22720, threadinfo 
ffff88001e050000, task ffff88005b0f3980)
Dec  1 19:09:11 datengrab kernel: Stack:
Dec  1 19:09:11 datengrab kernel: ffffffff81171176 ffff880056b315e8 ffffffff8109d127 
ffff880013e8b033
Dec  1 19:09:11 datengrab kernel: <0> 000041c01e051e98 ffff880056b315e8 
ffff880056b315e8 0000000000008000
Dec  1 19:09:11 datengrab kernel: <0> 0000000000000000 ffff880056b316a0 
00000000ffffffff 00000000ffffffff
Dec  1 19:09:11 datengrab kernel: Call Trace:
Dec  1 19:09:11 datengrab kernel: [<ffffffff81171176>] ? btrfs_set_acl+0x5a/0x1ab
Dec  1 19:09:11 datengrab kernel: [<ffffffff8109d127>] ? dput+0x2c/0x145
Dec  1 19:09:11 datengrab kernel: [<ffffffff81171307>] ? 
btrfs_xattr_set_acl+0x40/0x68
Dec  1 19:09:11 datengrab kernel: [<ffffffff8115db45>] ? 
btrfs_removexattr+0x20/0x60
Dec  1 19:09:11 datengrab kernel: [<ffffffff810a448b>] ? 
vfs_removexattr+0x78/0x104
Dec  1 19:09:11 datengrab kernel: [<ffffffff810a4550>] ? removexattr+0x39/0x45
Dec  1 19:09:11 datengrab kernel: [<ffffffff810972b6>] ? do_path_lookup+0x34/0x47
Dec  1 19:09:11 datengrab kernel: [<ffffffff81097c37>] ? user_path_at+0x59/0x7f
Dec  1 19:09:11 datengrab kernel: [<ffffffff810a1690>] ? 
mntput_no_expire+0x23/0xd4
Dec  1 19:09:11 datengrab kernel: [<ffffffff810a4658>] ? sys_removexattr+0x42/0x5f
Dec  1 19:09:11 datengrab kernel: [<ffffffff8100ad6b>] ? 
system_call_fastpath+0x16/0x1b
Dec  1 19:09:11 datengrab kernel: Code: eb 10 83 fa 20 74 09 85 ff 75 1a 83 fa 
08 75 15 30 d2 48 83 c0 08 4c 39 c0 0f 82 6c ff ff ff 31 c0 85 d2 74 05 b8 ea ff ff 
ff c3 <8b> 47 04 48 8d 4f 08 31 d2 4c 8d 44 c7 08 31 c0 eb 67 8b 39 66
Dec  1 19:09:11 datengrab kernel: RIP  [<ffffffff810c6c12>] 
posix_acl_equiv_mode+0x0/0x90
Dec  1 19:09:11 datengrab kernel: RSP <ffff88001e051d60>
Dec  1 19:09:11 datengrab kernel: CR2: 0000000000000004
Dec  1 19:09:11 datengrab kernel: ---[ end trace 85485144383149ad ]---


After applying your patch, rdiff-backup works now. :)

regards
  Johannes
