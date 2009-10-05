From: Chris Mason <chris.mason@oracle.com>
Subject: Re: system hang with btrfs master
Date: Mon, 5 Oct 2009 14:46:46 -0400
Message-ID: <20091005184646.GC2909@think>
References: <200910051440.50155.johannes.hirte@fem.tu-ilmenau.de>
 <20091005131300.GA25969@think>
 <200910051910.56283.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910051910.56283.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2009 at 07:10:55PM +0200, Johannes Hirte wrote:
> Am Montag 05 Oktober 2009 15:13:00 schrieb Chris Mason:
> > On Mon, Oct 05, 2009 at 02:40:49PM +0200, Johannes Hirte wrote:
> > > I'm using btrfs on two devices here, /usr on sda3 and /home on sdb
> > > (dm-crypt device on the whole disk). With btrfs-master the whole system
> > > hangs when accessing /home. The system hangs when I'm logging in into my
> > > account with KDE and is easily reproducible with dbench. On /usr the
> > > hangs appeared also but not as often as on the /home-device. I've tested
> > > on a third device with new created btrfs on top of dm-crypt, but wasn't
> > > able to reproduce the hangs. The filesystems are created without
> > > metadata-mirroring (-m single). I've bisected this to:
> > >
> > > commit 11833d66be94b514652466802100378046c16b72
> > > Author: Yan Zheng <zheng.yan@oracle.com>
> > > Date:   Fri Sep 11 16:11:19 2009 -0400
> > >
> > >     Btrfs: improve async block group caching
> > 
> > Hello,
> > 
> > Could you please capture the output of sysrq-l and sysrq-t during the
> > hang?
> > 
> > -chris
> > 
> 
> sysrq-p shows:
> 
> SysRq : Show Regs
> CPU 0:
> Modules linked in: netconsole snd_seq_midi snd_emu10k1_synth snd_emux_synth 
> snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event snd_seq 
> snd_pcm_oss snd_mixer_oss btrfs zlib_deflate crc32c libcrc32c aes_x86_64 
> aes_generic xts gf128mul dm_crypt snd_emu10k1 snd_rawmidi snd_ac97_codec 
> ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc snd_util_mem 
> snd_hwdep snd sg sr_mod ehci_hcd uhci_hcd ohci_hcd
> Pid: 2623, comm: dbench Not tainted 2.6.31-btrfs #3 To Be Filled By O.E.M.
> RIP: 0010:[<ffffffff811804b4>]  [<ffffffff811804b4>] find_next_zero_bit+0x1a/0xa0

Interesting, I've seen this as well, but haven't yet tracked it down to
a single commit.  This means the allocator is probably looping as we try
to cache extents.

We'll try to nail it down.

-chris
