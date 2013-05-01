Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52048 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3EAGkI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 02:40:08 -0400
Received: by mail-ob0-f170.google.com with SMTP id eh20so1102843obb.29
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Apr 2013 23:40:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130430175351.GF2580@localhost.localdomain>
References: <CADn-QaMao+mtnJVuwjbnqHgFzKhqUfn2uiDgN5hFw_fHP+mGcQ@mail.gmail.com>
 <CVrGRAreCXB@helmut.hullen.de> <20130430094131.GA8274@carfax.org.uk>
 <loom.20130430T133556-803@post.gmane.org> <20130430135816.GD2580@localhost.localdomain>
 <CADn-QaMFct-5XgMbqiWMG_pa-AzgOQOZLUc-CNTrAPpG7633Aw@mail.gmail.com> <20130430175351.GF2580@localhost.localdomain>
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Wed, 1 May 2013 08:39:47 +0200
Message-ID: <CADn-QaO_YqroR=EnrD1+tfRNRvLiLkhAMMAUxrbA_4s5-b5rxQ@mail.gmail.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921 __btrfs_write_out_cache+0x6b9/0x9a0
 [btrfs]()
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Josef

On Tue, Apr 30, 2013 at 7:53 PM, Josef Bacik <jbacik@fusionio.com> wrote:

> Can you run this patch and capture the output when you get the warning?  You
> should see some mesages before the -- [ cut here ] -- part, make sure to capture
> those.  Thanks,

Sure.

There you go (also on http://pastebin.com/7MHmgpPU):

 num_pages is 10000, blockgroup? yes
 block group offset=83999326208, size=167959920640
 ------------[ cut here ]------------
 WARNING: at fs/btrfs/free-space-cache.c:925
__btrfs_write_out_cache+0x9e2/0xa10 [btrfs]()
 Hardware name: HP Compaq dc5800 Microtower
 Modules linked in: arc4 md4 parport_pc ppdev rfcomm bnep bluetooth
nls_utf8 cifs fscache ext2 tpm_infineon snd_hda_codec_analog coretemp
kvm_intel kvm hp_wmi sparse_keymap gpio_ich snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_page_alloc dm_multipath
snd_seq_midi scsi_dh tpm_tis wmi snd_seq_midi_event snd_rawmidi
snd_seq snd_seq_device snd_timer nvidia(POF) mac_hid snd psmouse
microcode serio_raw lpc_ich mei soundcore lp parport btrfs
zlib_deflate libcrc32c hid_generic usbhid hid floppy e1000e
usb_storage
 Pid: 2803, comm: sync Tainted: PF          O 3.8.0-19-lowlatency #13
 Call Trace:
  [<ffffffff8105a8df>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff8105a93a>] warn_slowpath_null+0x1a/0x20
  [<ffffffffa0103f52>] __btrfs_write_out_cache+0x9e2/0xa10 [btrfs]
  [<ffffffff81094065>] ? cpuacct_charge+0x75/0x80
  [<ffffffff810145d1>] ? __switch_to+0x181/0x4d0
  [<ffffffffa0104015>] btrfs_write_out_cache+0x95/0xf0 [btrfs]
  [<ffffffffa00b8c07>] btrfs_write_dirty_block_groups+0x527/0x620 [btrfs]
  [<ffffffffa012adc2>] commit_cowonly_roots+0x15a/0x22c [btrfs]
  [<ffffffffa00c84ec>] btrfs_commit_transaction+0x62c/0xb00 [btrfs]
  [<ffffffff81080070>] ? finish_wait+0x80/0x80
  [<ffffffff811ca3a0>] ? fdatawait_one_bdev+0x20/0x20
  [<ffffffffa009a9f2>] btrfs_sync_fs+0x62/0x110 [btrfs]
  [<ffffffff811ca3c0>] sync_fs_one_sb+0x20/0x30
  [<ffffffff8119db59>] iterate_supers+0xe9/0xf0
  [<ffffffff811ca555>] sys_sync+0x55/0x90
  [<ffffffff816dfe9d>] system_call_fastpath+0x1a/0x1f
 ---[ end trace 88dd9bc54a43ce1a ]---

I don't think it has to do with how much data I write at that time.
I also get this error, when I copy a 6kb file and then invoke "sync"
to force a write.

But… Hm… No, I think it IS size related. As I said, I get this error
even with a file which is 6520 bytes "big". BUT I do NOT get this
error when I copy a file which is just 1129 bytes "small".

Some more tests - I start to get these errors with
filesizes > 3916 bytes. Filesizes <= 3916 bytes -> no error.

Does that make sense to you?

Alexander
--
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
