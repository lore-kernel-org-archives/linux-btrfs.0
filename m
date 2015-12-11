Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19206 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbbLKPgG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 10:36:06 -0500
Date: Fri, 11 Dec 2015 10:35:59 -0500
From: Chris Mason <clm@fb.com>
To: Jon Christopherson <jon@jons.org>,
        Andrew Morton <akpm@linux-foundation.org>, Dave Jones <dsj@fb.com>
CC: <linux-kernel@vger.kernel.org>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: new oops in 4.4.0-rc4
Message-ID: <20151211153559.GD11257@ret.masoncoding.com>
References: <5669AA01.2000300@jons.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5669AA01.2000300@jons.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 10:36:17AM -0600, Jon Christopherson wrote:
> Hello,
> 
> I noticed this new oops since running 4.4.0-rc4. Happens shortly after boot
> and pretty much kills the system:
> 
> > [  177.774250] ------------[ cut here ]------------
> >[  177.774256] kernel BUG at /data0/Source/mainline/mm/page-writeback.c:2654!
> >[  177.774258] invalid opcode: 0000 [#1] SMP
> >[  177.774261] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi rfcomm bnep nfsd auth_rpcgss nfs_acl binfmt_misc nfs lockd grace sunrpc fscache xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi nvidia_modeset(POE) eeepc_wmi mxm_wmi asus_wmi sparse_keymap intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp dm_multipath nvidia(POE) btusb kvm_intel btrtl nls_iso8859_1 kvm btbcm irqbypass snd_hd
> a_intel wl(POE) btintel hid_logitech_hidpp joydev bluetooth serio_raw snd_hda_codec snd_hda_core snd_seq_midi cfg80211 snd_seq_midi_event snd_hwdep snd_rawmidi lpc_ich snd_pcm drm snd_seq snd_seq_dev
> ice snd_timer 8250_fintek snd mei_me mei soundcore wmi mac_hid parport_pc shpchp ppdev msr nct6775 hwmon_vid coretemp lp parport btrfs xor raid6_pq drbg ansi_cprng dm_crypt dm_mirror dm_region_hash dm_log hid_generic hid_logitech_dj usbhid hid crct10dif_pclmul crc32_pclmul ahci aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd psmouse libahci video
> >[  177.774357] CPU: 5 PID: 5158 Comm: thunderbird Tainted: P        W  OE   4.4.0-121-generic #201512100930
> >[  177.774360] Hardware name: System manufacturer System Product Name/P8P67 DELUXE, BIOS 3602 10/31/2012
> >[  177.774362] task: ffff88040b6d0000 ti: ffff8803af864000 task.ti: ffff8803af864000
> >[  177.774364] RIP: 0010:[<ffffffff81185b11>]  [<ffffffff81185b11>] clear_page_dirty_for_io+0xe1/0x1a0

Dave Jones sent in a report about this with trinity too, I'm digging in
today.  Since you can trigger this reliably, what was the last
known-good kernel for you?

-chris
