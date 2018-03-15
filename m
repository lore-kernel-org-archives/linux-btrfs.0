Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:45815 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbeCOVPs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 17:15:48 -0400
Received: by mail-ot0-f181.google.com with SMTP id w12-v6so8313117ote.12
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 14:15:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
References: <06b1fdb0d1884406a2d4c2e8be75e289@MOXDE7.na.bayer.cnb>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 15 Mar 2018 15:15:47 -0600
Message-ID: <CAJCQCtRwon1Qsz2MJ9hzvXvaNa3VyQm=VkG83gM82X+=iQP+FQ@mail.gmail.com>
Subject: Re: Crashes running btrfs scrub
To: Mike Stevens <michael.stevens@bayer.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 15, 2018 at 12:58 PM, Mike Stevens
<michael.stevens@bayer.com> wrote:
> First, the required information
>
> ~ $ uname -a
> Linux auswscs9903 3.10.0-693.21.1.el7.x86_64

For a kernel this old you kinda need to get support from the distro.
This list is upstream and pretty much always what you'll get from any
upstream, XFS, ext4, or Btrfs, with such an old kernel is the same
answer: if you want support for a distro kernel, go to the distro for
support. For upstream, typical response is to try with the current
stable kernel which is 4.15.10. If you can reproduce the problem there
too then it's a bug. 3.10 isn't even a longterm kernel getting
backports so it's really a non-starter. Sorry. You can get newer
kernels prebuilt from elrepo.org. They have 4.14.121 and 4.15.10.

http://elrepo.org/linux/kernel/el7/x86_64/RPMS/


>Data, RAID6: total=150.82TiB, used=88.88TiB
>System, RAID6: total=512.00MiB, used=19.08MiB
>Metadata, RAID6: total=191.00GiB, used=187.38GiB


Unfortunately no one is really supporting raid6, distro or even
upstream, for production purposes. Upstream is really your only
option, and you really need to be running a newer kernel because so
much raid5 and raid6 has changed, even aside from Btrfs itself.
There's tens of thousands of line changes in the code since 3.18 (EL 7
Btrfs is not really based on 3.10 tree, I think it's based on 3.18
tree but I don't have Red Hat's decoder ring).


> I was running a btrfs balance, which crashed.  Since then, I cannot do anything on the filesystems that does any real i/o, or it quickly goes read only.

Mount it read only - update the backups. Then update the kernel and
btrfs-progs. You can use the Fedora btrfs-progs package on EL 7.

Full listing
https://koji.fedoraproject.org/koji/packageinfo?packageID=6398

I recommend this package, only because I'm using it now on Fedora 28.
https://kojipkgs.fedoraproject.org//packages/btrfs-progs/4.15.1/1.fc28/x86_64/btrfs-progs-4.15.1-1.fc28.x86_64.rpm

For what it's worth, scrub is initiated and monitored by btrfs-progs
user space tools, but the real work is in the kernel code.


 >Running btrfs scrub results in this crash:
>
> Mar 15 11:10:43 auswscs9903 kernel: WARNING: CPU: 1 PID: 4588 at fs/btrfs/extent-tree.c:10367 btrfs_create_pending_block_groups+0x23e/0x240 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: Modules linked in: nfsv3 nfs fscache mpt3sas mpt2sas raid_class mptctl mptbase binfmt_misc ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_comment xt_multiport xt_conntrack nf_conntrack libcrc32c iptable_filter dm_mirror dm_region_hash dm_log dm_mod iTCO_wdt iTCO_vendor_support btrfs sb_edac edac_core intel_powerclamp coretemp intel_rapl iosf_mbi kvm_intel kvm irqbypass crc32_pclmul ghash_clmulni_intel aesni_intel lrw gf128mul glue_helper ablk_helper cryptd raid6_pq xor pcspkr joydev ses enclosure scsi_transport_sas sg mei_me i2c_i801 mei lpc_ich ioatdma shpchp wmi ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad nfsd nfs_acl lockd auth_rpcgss grace sunrpc ip_tables ext4 mbcache jbd2 sd_mod crc_t10dif crct10dif_generic ast drm_kms_helper syscopyarea sysfillrect
> Mar 15 11:10:43 auswscs9903 kernel: sysimgblt fb_sys_fops ttm drm ahci igb libahci libata crct10dif_pclmul crct10dif_common crc32c_intel megaraid_sas ptp pps_core i2c_algo_bit myri10ge i2c_core dca
> Mar 15 11:10:43 auswscs9903 kernel: CPU: 1 PID: 4588 Comm: btrfs Tainted: G        W      ------------   3.10.0-693.21.1.el7.x86_64 #1
> Mar 15 11:10:43 auswscs9903 kernel: Hardware name: Supermicro Super Server/X10DRL-i, BIOS 1.1b 09/11/2015
> Mar 15 11:10:43 auswscs9903 kernel: Call Trace:
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff816ae7c8>] dump_stack+0x19/0x1b
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff8108ae58>] __warn+0xd8/0x100
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff8108aedf>] warn_slowpath_fmt+0x5f/0x80
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0ac2fd2>] ? btrfs_finish_chunk_alloc+0x222/0x5e0 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0a7cb7e>] btrfs_create_pending_block_groups+0x23e/0x240 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0a7d215>] do_chunk_alloc+0x2f5/0x330 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0a816ee>] btrfs_inc_block_group_ro+0x18e/0x1b0 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0afad47>] scrub_enumerate_chunks+0x207/0x6a0 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff810c79ec>] ? try_to_wake_up+0x18c/0x350
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff816b2c00>] ? __ww_mutex_lock+0x40/0xa0
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0afc5f3>] btrfs_scrub_dev+0x233/0x5a0 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0ad2a00>] ? btrfs_ioctl+0xdc0/0x2d30 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc0ad2a59>] btrfs_ioctl+0xe19/0x2d30 [btrfs]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffffc026b1f1>] ? ext4_filemap_fault+0x41/0x50 [ext4]
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff81186deb>] ? unlock_page+0x2b/0x30
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff811b1f16>] ? do_read_fault.isra.44+0xe6/0x130
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff811e4629>] ? kmem_cache_alloc_node+0x109/0x200
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff811b6781>] ? handle_mm_fault+0x691/0xfa0
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff81121930>] ? audit_filter_rules.isra.8+0x280/0xf90
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff81219e90>] do_vfs_ioctl+0x350/0x560
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff8121a141>] SyS_ioctl+0xa1/0xc0
> Mar 15 11:10:43 auswscs9903 kernel: [<ffffffff816c0715>] system_call_fastpath+0x1c/0x21


Crashing while allocating new chunks, looks like, and then maybe gets
confused about what it's supposed to scrub. The ext4_filemap_fault is
curious. I can't really parse this trace, but I doubt this is a
hardware bug. I think it's a legit bug in the code, and it's almost
certainly fixed in newer kernels but the only way to know for sure is
to upgrade. 4.14.121 would be the minimum worth testing so flip a coin
on 4.15.10 and 4.14.121.



-- 
Chris Murphy
