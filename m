Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:51424 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbcLERVp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 12:21:45 -0500
Date: Mon, 5 Dec 2016 12:21:35 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161205172135.7tncgtcqhhgngmy4@codemonkey.org.uk>
References: <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
 <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
 <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 05, 2016 at 06:09:29PM +0100, Vegard Nossum wrote:
 > On 5 December 2016 at 12:10, Vegard Nossum <vegard.nossum@gmail.com> wrote:
 > > On 5 December 2016 at 00:04, Vegard Nossum <vegard.nossum@gmail.com> wrote:
 > >> FWIW I hit this as well:
 > >>
 > >> BUG: unable to handle kernel paging request at ffffffff81ff08b7
 > >> IP: [<ffffffff8135f2ea>] __lock_acquire.isra.32+0xda/0x1a30
 > >> CPU: 0 PID: 21744 Comm: trinity-c56 Tainted: G    B           4.9.0-rc7+ #217
 > > [...]
 > >
 > >> I think you can rule out btrfs in any case, probably block layer as
 > >> well, since it looks like this comes from shmem.
 > >
 > > I should rather say that the VM runs on a 9p root filesystem and it
 > > doesn't use/mount any block devices or disk-based filesystems.
 > >
 > > I have all the trinity logs for the crash if that's useful. I tried a
 > > couple of runs with just the (at the time) in-progress syscalls but it
 > > didn't turn up anything interesting. Otherwise it seems like a lot of
 > > data to go through by hand.
 > 
 > I've hit this another 7 times in the past ~3 hours.
 > 
 > Three times the address being dereferenced has pointed to
 > iov_iter_init+0xaf (even across a kernel rebuild), three times it has
 > pointed to put_prev_entity+0x55, once to 0x800000008, and twice to
 > 0x292. The fact that it would hit even one of those more than once
 > across runs is pretty suspicious to me, although the ones that point
 > to iov_iter_init and put_prev_entity point to "random" instructions in
 > the sense that they are neither entry points nor return addresses.
 > 
 > shmem_fault() was always on the stack, but it came from different
 > syscalls: add_key(), newuname(), pipe2(), newstat(), fstat(),
 > clock_settime(), mount(), etc.
> ------------[ cut here ]------------
 > The warning shows that it made it past the list_empty_careful() check
 > in finish_wait() but then bugs out on the &wait->task_list
 > dereference.

I just pushed out the ftrace changes I made to Trinity that might help
you gather more clues.

Right now it's hardcoded to dump a trace to /boot/trace.txt when it
detects the kernel has become tainted.

Before a trinity run, I run this as root..

#!/bin/sh

cd /sys/kernel/debug/tracing/

echo 10000 > buffer_size_kb
echo function >> current_tracer

for i in $(cat /home/davej/blacklist-symbols)
do
  echo $i >> set_ftrace_notrace
done

echo 1 >> tracing_on


blacklist-symbols is the more noisy stuff that pollutes traces.
Right now I use these: https://paste.fedoraproject.org/499794/14809582/
You may need to add some more.

(I'll get around to making all this scripting go away, and have trinity
just set this stuff up itself eventually)

Oh, and if you're not running as root, you might need a diff like below
so that trinity can stop the trace when it detects tainting.

	Dave

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8696ce6bf2f6..2d6c97e871e0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7217,7 +7217,7 @@ init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("trace_clock", 0644, d_tracer, tr,
 			  &trace_clock_fops);
 
-	trace_create_file("tracing_on", 0644, d_tracer,
+	trace_create_file("tracing_on", 0666, d_tracer,
 			  tr, &rb_simple_fops);
 
 	create_trace_options_dir(tr);
