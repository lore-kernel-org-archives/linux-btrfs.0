Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48217 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753257AbdH2Oam (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:30:42 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
CC: Chris Mason <clm@fb.com>, "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Tue, 29 Aug 2017 14:30:19 +0000
Message-ID: <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org>
 <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
 <20170715012216.njq6az3y34qyomtb@merlins.org>
 <20170715231245.GA28281@merlins.org> <20170829031637.GA15290@merlins.org>
In-Reply-To: <20170829031637.GA15290@merlins.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry Marc, I‚Äôll wire up a bcc script to try and catch when this happens.  In order for it to work it‚Äôll need to read the extent tree in before you mount the fs, is that something you‚Äôll be able to swing or is this your root fs?  Also is it the only btrfs fs on the system?  Thanks,

Josef

On 8/28/17, 11:17 PM, "Marc MERLIN" <marc@merlins.org> wrote:

On Sat, Jul 15, 2017 at 04:12:45PM -0700, Marc MERLIN wrote:
> On Fri, Jul 14, 2017 at 06:22:16PM -0700, Marc MERLIN wrote:
> > Dear Chris and other developers,
> > 
> > Can you look at this bug which has been happening since 2012 on apparently all kernels between at least
> > 3.4 and 4.11.
> > I didn't look in detail at each thread (took long enough to even find them all and paste here), but they seem pretty
> > similar although the reasons how they got there may be different, or at least not as benign as a race condition
> > between snapshot creation and deletion for those who do hourly snapshot rotations like me.
> 
> I just finished 2 check repairs, one with each mode, they both come back
> clean.
> Yet my FS still remounts read only with the same
> BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2967: errno=-17 Object already exists
> BTRFS info (device dm-2): forced readonly
> BTRFS warning (device dm-2): failed setting block group ro, ret=-30 

So this still happens pseudo randomly every 2 weeks maybe?

Last one is below.
It did not happen during a btrfs snapshot although I'm not entirely sure
what else was running at the time.

Any update on this problem?

------------[ cut here ]------------  
WARNING: CPU: 6 PID: 3783 at fs/btrfs/extent-tree.c:2967 btrfs_run_delayed_refs+0xbd/0x1be  
BTRFS: Transaction aborted (error -17)  
Modules linked in: asix veth ip6table_filter ip6_tables ebtable_nat ebtables ppdev lp xt_addrtype br_netfilter bridge stp llc tun autofs4 softdog binfmt_misc ftdi_sio nfsd auth_rpcgss nfs_acl nfs lockd grace fscache sunrpc ipt_REJECT nf_reject_ipv4 xt_conntrack xt_mark xt_nat xt_tcpudp nf_log_ipv4 nf_log_common xt_LOG iptable_mangle iptable_filter lm85 hwmon_vid pl2303 dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_nat nf_conntrack x_tables sg st snd_pcm_oss snd_mixer_oss bcache kvm_intel kvm irqbypass snd_hda_codec_realtek snd_hda_codec_generic snd_cmipci snd_mpu401_uart snd_hda_intel snd_opl3_lib snd_hda_codec snd_hda_core snd_hwdep eeepc_wmi snd_rawmidi snd_seq_device tpm_infineon tpm_tis  
 snd_pcm asus_wmi snd_timer tpm_tis_core rc_ati_x10 snd ati_remote sparse_keymap rfkill i2c_i801 usbserial hwmon usbnet libphy pcspkr wmi soundcore input_leds tpm rc_core parport_pc evdev i915 lpc_ich i2c_smbus parport battery mei_me e1000e ptp pps_core fuse raid456 multipath mmc_block mmc_core dm_crypt dm_mod async_raid6_recov async_pq async_xor async_memcpy async_tx crc32c_intel blowfish_x86_64 blowfish_common aesni_intel aes_x86_64 lrw glue_helper ablk_helper cryptd sata_sil24 fjes mvsas xhci_pci libsas xhci_hcd ehci_pci ehci_hcd thermal usbcore fan r8169 mii scsi_transport_sas [last unloaded: asix]  
CPU: 2 PID: 3783 Comm: btrfs-transacti Tainted: G     U          4.9.36-amd64-preempt-sysrq-20170406 #1  
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3904 04/27/2013  
 ffffb7eb67affc98 ffffffffae39b00b ffffb7eb67affce8 0000000000000000  
 ffffb7eb67affcd8 ffffffffae066769 00000b9767affd58 ffff974f736da960  
 ffff9756319df000 00000000ffffffef ffff975302da7a50 ffffffffffffffff  
Call Trace:  
 [<ffffffffae39b00b>] dump_stack+0x61/0x7d  
 [<ffffffffae066769>] __warn+0xc2/0xdd  
 [<ffffffffae0667de>] warn_slowpath_fmt+0x5a/0x76  
 [<ffffffffae28dd5f>] btrfs_run_delayed_refs+0xbd/0x1be  
 [<ffffffffae29ed64>] commit_cowonly_roots+0x10d/0x2b2  
 [<ffffffffae2fb5ed>] ? btrfs_qgroup_account_extents+0x131/0x181  
 [<ffffffffae28de48>] ? btrfs_run_delayed_refs+0x1a6/0x1be  
 [<ffffffffae2a131a>] btrfs_commit_transaction+0x46b/0x8fb  
 [<ffffffffae29c560>] transaction_kthread+0xf5/0x1a1  
 [<ffffffffae29c46b>] ? btrfs_cleanup_transaction+0x436/0x436  
 [<ffffffffae081e94>] kthread+0xd1/0xd9  
 [<ffffffffae081dc3>] ? init_completion+0x24/0x24  
 [<ffffffffae003add>] ? do_fast_syscall_32+0xb7/0xfe  
 [<ffffffffae6ed4b5>] ret_from_fork+0x25/0x30  
---[ end trace 4c5fcb9daa07c11a ]---  
BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2967: errno=-17 Object already exists  
BTRFS info (device dm-2): forced readonly  
BTRFS warning (device dm-2): Skipping commit of aborted transaction.  
BTRFS: error (device dm-2) in cleanup_transaction:1850: errno=-17 Object already exists  
BTRFS error (device dm-2): pending csums is 131072  

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIBAg&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=qcSpYy8ZFdhWPMDeFU0pClrt2eWlHLnDl5rqwzlssdk&s=591MXZleq8AqL3ZpDgJYq2y-sRj1LSE4F_32mkIa9Pg&e=   


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
