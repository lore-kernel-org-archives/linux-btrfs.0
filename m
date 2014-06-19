Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31766 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757405AbaFSQMo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 12:12:44 -0400
Message-ID: <53A30BDD.6080309@fb.com>
Date: Thu, 19 Jun 2014 09:12:13 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP
 build_backref_tree+0x9fc/0xcc4
References: <20140609234007.GD19071@merlins.org> <53A08925.8020700@fb.com> <20140617185549.GP19071@merlins.org> <53A1AFB6.40906@fb.com> <20140618202135.GE19071@merlins.org>
In-Reply-To: <20140618202135.GE19071@merlins.org>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/18/2014 01:21 PM, Marc MERLIN wrote:
> First thanks for your answer and patch. While they didn't help, I'm happy to
> try another one or two if you'd like before I wipe the FS to recover.
>
> On Wed, Jun 18, 2014 at 08:26:46AM -0700, Josef Bacik wrote:
>>> 2) is your guess that the BUG_ON I'm getting shouldn't be triggered
>>> and your proposed patch could fix that, or that I do have an FS problem
>>> but that we're just going to make the kernel more lenient and not crash on
>>> it?
>>>
>>
>> All of these BUG_ON(!uppper->checked) are logic errors, not problems
>> with the fs, which is why I haven't turned them into an abort or
>
> I'm guessing you saw the comment from someone else in the other thread.
> BUG_ON is not helpful when you have end users. It effectively crashes the
> system when it can be unnecessary (a very secondary filesystem you don't
> depend on), and it tells users that anything wrong with btrfs on any
> filesystem can take their entire machine down needlessly
> (not counting the fact of course that it makes bug reporting on the list
> that much harder since syslog has no chance to capture and forward it)
>
> Can I appeal to you to remove all the ones you work with?
> If something is wrong, it should mount the FS read only and/or make it
> unaccessible, but not crash the entire system.
>
>> something else yet.  I'm thinking about chucking this whole function
>> anyway and using the backref walking code, but that is going to be a job
>> for future josef, present josef doesn't seem to have any time to do
>> anything despite sleeping a lot less.  Thanks,
>
> Yes, I understand that part. Good luck with getting sleep indeed.
>
> Back to your patch, unfortunately, it did not help.
> Let me know if you'd like me to try one more patch or two before I wipe the
> FS and start over.
> But for my own sanity, can you explain if I'm hitting reallocate bugs, or
> whether my filesystem is indeed correct?
>
> Thanks,
> Marc
>
>
> It crashed on another BUG_ON
> 	if (!list_empty(&cur->upper)) {
> 		/*
> 		 * the backref was added previously when processing
> 		 * backref of type BTRFS_TREE_BLOCK_REF_KEY
> 		 */
> 		BUG_ON(!list_is_singular(&cur->upper));
> 		edge = list_entry(cur->upper.next, struct backref_edge,
> 				  list[LOWER]);
> HERE ->		BUG_ON(!list_empty(&edge->list[UPPER]));
> 		exist = edge->node[UPPER];
> 		/*
> 		 * add the upper level block to pending list if we need
> 		 * check its backrefs
> 		 */
> 		if (!exist->checked)
>
>
> [  209.223856] BTRFS info (device sdb1): disk space caching is enabled
> [  209.283364] BTRFS: detected SSD devices, enabling SSD mode
> [  209.369267] BTRFS: checking UUID tree
> [  209.369286] BTRFS info (device sdb1): continuing balance
> [  209.412421] BTRFS info (device sdb1): relocating block group 82699091968 flags 1
> [  211.148796] BTRFS info (device sdb1): found 3719 extents
> [  213.351917] ------------[ cut here ]------------
> [  213.351941] kernel BUG at fs/btrfs/relocation.c:752!
> [  213.351951] invalid opcode: 0000 [#1] PREEMPT SMP
> [  213.351974] Modules linked in: des_generic nfsv3 nfsv4 xt_NFLOG nfnetlink_log nfnetlink xt_tcpudp xt_comment xt_multiport ip6table_filter ip6_tables iptable_filter ip_tables x_tables fuse autofs4 bnep rfcomm parport_pc ppdev binfmt_misc uvcvideo videobuf2_core videodev snd_usb_audio media snd_usbmidi_lib videobuf2_vmalloc videobuf2_memops hid_generic usbhid hid ecb btusb bluetooth rpcsec_gss_krb5 6lowpan_iphc nfsd nfs_acl auth_rpcgss nfs fscache snd_hda_codec_hdmi lockd sunrpc snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec intel_rapl x86_pkg_temp_thermal intel_powerclamp snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi coretemp snd_rawmidi snd_seq_midi_event kvm snd_seq snd_timer crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel snd_seq_device snd aesni_intel sb_edac edac_core soundcore ehci_pci tpm_infineon ablk_helper cryptd lrw ehci_hcd gf128mul glue_helper hp_wmi sparse_keymap rfkill aes_x86_64 tpm_tis lpc_ich p
smouse serio_raw tpm evdev microcode processor wmi lp parport loop uas usb_storage dm_mod firewire_ohci xhci_hcd firewire_core crc_itu_t usbcore isci usb_common e1000e libsas ptp pps_core scsi_transport_sas
> [  213.352787] CPU: 4 PID: 13538 Comm: btrfs-balance Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
> [  213.352795] Hardware name: Hewlett-Packard HP Z620 Workstation/158A, BIOS J61 v01.17 11/05/2012
> [  213.352881] task: ffff8800c9e30510 ti: ffff8807bc6ec000 task.ti: ffff8807bc6ec000
> [  213.352885] RIP: 0010:[<ffffffff812679c1>]  [<ffffffff812679c1>] build_backref_tree+0x174/0xcbe
> [  213.352894] RSP: 0018:ffff8807bc6efae0  EFLAGS: 00010283
> [  213.352897] RAX: ffff8807dd60b980 RBX: ffff8800c6f6a890 RCX: ffff8807dd60b990
> [  213.352900] RDX: ffff8807bc6efb58 RSI: 0000000000000000 RDI: 0000000000000000
> [  213.352903] RBP: ffff8807bc6efbb8 R08: ffff8807bc6efa9c R09: ffff8807bc6ef9d8
> [  213.352906] R10: ffff8800c6c3ee50 R11: 0000000000000000 R12: ffff88080329c000
> [  213.352909] R13: ffff8800354ae1c0 R14: ffff8800c6f6a890 R15: ffff880804ff6000
> [  213.352912] FS:  0000000000000000(0000) GS:ffff88082fc80000(0000) knlGS:0000000000000000
> [  213.352915] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  213.352918] CR2: 00007f182f620000 CR3: 0000000001c13000 CR4: 00000000000407e0
> [  213.352921] Stack:
> [  213.352924]  ffff8807dd60bac0 ffff8807c4fd8e50 ffff8800c69e6fa0 ffff880804ff6124
> [  213.352935]  ffff8800354ae200 ffff8807bc6efb68 ffff880804ff6120 ffff88003549dac0
> [  213.352950]  0000000000000003 ffff8807bc6efb58 ffff8800c6f6a800 ffff8800c6f6a890
> [  213.352961] Call Trace:
> [  213.352967]  [<ffffffff81269f25>] relocate_tree_blocks+0x16a/0x44c
> [  213.352971]  [<ffffffff8126ad56>] relocate_block_group+0x239/0x49a
> [  213.352975]  [<ffffffff8126b112>] btrfs_relocate_block_group+0x15b/0x26d
> [  213.352981]  [<ffffffff81249b80>] btrfs_relocate_chunk.isra.23+0x5c/0x5e8
> [  213.352987]  [<ffffffff8161faeb>] ? _raw_spin_unlock+0x17/0x2a
> [  213.352991]  [<ffffffff812458cc>] ? free_extent_buffer+0x8a/0x8d
> [  213.352995]  [<ffffffff8124c406>] btrfs_balance+0x9b6/0xb74
> [  213.352999]  [<ffffffff8161676d>] ? printk+0x54/0x56
> [  213.353003]  [<ffffffff8124c5c4>] ? btrfs_balance+0xb74/0xb74
> [  213.353007]  [<ffffffff8124c61d>] balance_kthread+0x59/0x7b
> [  213.353012]  [<ffffffff8106b4b4>] kthread+0xae/0xb6
> [  213.353015]  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
> [  213.353020]  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
> [  213.353024]  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
> [  213.353027] Code: e8 de 84 de ff 49 8d 45 40 48 89 c1 48 89 85 48 ff ff ff 49 8b 45 40 48 39 c8 74 38 49 3b 45 48 0f 85 25 0b 00 00 e9 22 0b 00 00 <0f> 0b 4c 8b 70 28 41 f6 46 71 10 75 1f 48 8b 4d a8 48 8b 9d 70
> [  213.353203] RIP  [<ffffffff812679c1>] build_backref_tree+0x174/0xcbe
> [  213.353208]  RSP <ffff8807bc6efae0>
> [  213.353213] ---[ end trace 07cbfc43e0fb0ccd ]---
> [  213.353216] Kernel panic - not syncing: Fatal exception
> [  213.353258] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> [  213.353262] ---[ end Kernel panic - not syncing: Fatal exception
>

Ok undo what you did and apply this and re-run.  It is going spit out a metric
shittone of data, but all I want is the last chunk of stuff between

running build_backref_tree
<some shit>
block <some more shit> wasn't checked
done building backref tree

I changed it to return an error instead of bugging, so if it still bugs attach
that as well so I can figure out where down the stack we need to fix.  Thanks,

Josef


diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 65245a0..915aab4 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -702,6 +702,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
  	int err = 0;
  	bool need_check = true;
  
+	printk(KERN_ERR "running build_backref_tree\n");
  	path1 = btrfs_alloc_path();
  	path2 = btrfs_alloc_path();
  	if (!path1 || !path2) {
@@ -722,6 +723,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
  	node->lowest = 1;
  	cur = node;
  again:
+	printk(KERN_ERR "building backref for bytenr %llu\n", cur->bytenr);
  	end = 0;
  	ptr = 0;
  	key.objectid = cur->bytenr;
@@ -757,6 +759,7 @@ again:
  		 */
  		if (!exist->checked)
  			list_add_tail(&edge->list[UPPER], &list);
+		printk(KERN_ERR "exist is %llu, checked %d\n", exist->bytenr, exist->checked);
  	} else {
  		exist = NULL;
  	}
@@ -865,6 +868,7 @@ again:
  				 *  cached, add the block to pending list
  				 */
  				list_add_tail(&edge->list[UPPER], &list);
+				printk(KERN_ERR "found shared ref %llu, needs checking\n", upper->bytenr);
  			} else {
  				upper = rb_entry(rb_node, struct backref_node,
  						 rb_node);
@@ -962,9 +966,10 @@ again:
  				 * if we know the block isn't shared
  				 * we can void checking its backrefs.
  				 */
-				if (btrfs_block_can_be_shared(root, eb))
+				if (btrfs_block_can_be_shared(root, eb)) {
+					printk(KERN_ERR "adding block in path %llu, level %d, cur level %d, need_check %d\n", upper->bytenr, upper->level, cur->level, need_check);
  					upper->checked = 0;
-				else
+				} else
  					upper->checked = 1;
  
  				/*
@@ -1019,6 +1024,7 @@ next:
  		edge = list_entry(list.next, struct backref_edge, list[UPPER]);
  		list_del_init(&edge->list[UPPER]);
  		cur = edge->node[UPPER];
+		printk(KERN_ERR "doing the checking for block %llu\n", cur->bytenr);
  		goto again;
  	}
  
@@ -1062,7 +1068,12 @@ next:
  			continue;
  		}
  
-		BUG_ON(!upper->checked);
+		if (!upper->checked) {
+			printk(KERN_ERR "block %llu wasn't checked\n",
+			       upper->bytenr);
+			err = -EINVAL;
+			goto out;
+		}
  		BUG_ON(cowonly != upper->cowonly);
  		if (!cowonly) {
  			rb_node = tree_insert(&cache->rb_root, upper->bytenr,
@@ -1114,6 +1125,7 @@ next:
  		}
  	}
  out:
+	printk(KERN_ERR "done building backref tree\n");
  	btrfs_free_path(path1);
  	btrfs_free_path(path2);
  	if (err) {
