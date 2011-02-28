From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Mon, 28 Feb 2011 14:20:22 -0600
Message-ID: <AANLkTikex7g4+dc9qiPdL_xRk5SoFxE3TCfN7dg3kaR2@mail.gmail.com>
References: <1298857223-sup-5612@think>
	<201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
	<20110228161056.GA2769@localhost.localdomain>
	<1298911556.11118.8.camel@mainframe>
	<AANLkTin_Hjr3StjWUGrwCHBzhk_kwj-G2WqxZM6=CqN2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	Chris Mason <chris.mason@oracle.com>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?Maria_Wikstr=F6m?= <maria@ponstudios.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin_Hjr3StjWUGrwCHBzhk_kwj-G2WqxZM6=CqN2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/2/28 Mitch Harder <mitch.harder@sabayonlinux.org>:
> 2011/2/28 Maria Wikstr=F6m <maria@ponstudios.se>:
>> m=E5n 2011-02-28 klockan 11:10 -0500 skrev Josef Bacik:
>>> On Mon, Feb 28, 2011 at 11:13:59AM +0100, Johannes Hirte wrote:
>>> > On Monday 28 February 2011 02:46:05 Chris Mason wrote:
>>> > > Excerpts from Mitch Harder's message of 2011-02-25 13:43:37 -05=
00:
>>> > > > Some clarification on my previous message...
>>> > > >
>>> > > > After looking at my ftrace log more closely, I can see where =
Btrfs is
>>> > > > trying to release the allocated pages. =A0However, the calcul=
ation for
>>> > > > the number of dirty_pages is equal to 1 when "copied =3D=3D 0=
".
>>> > > >
>>> > > > So I'm seeing at least two problems:
>>> > > > (1) =A0It keeps looping when "copied =3D=3D 0".
>>> > > > (2) =A0One dirty page is not being released on every loop eve=
n though
>>> > > > "copied =3D=3D 0" (at least this problem keeps it from being =
an infinite
>>> > > > loop by eventually exhausting reserveable space on the disk).
>>> > >
>>> > > Hi everyone,
>>> > >
>>> > > There are actually tow bugs here. =A0First the one that Mitch h=
it, and a
>>> > > second one that still results in bad file_write results with my
>>> > > debugging hunks (the first two hunks below) in place.
>>> > >
>>> > > My patch fixes Mitch's bug by checking for copied =3D=3D 0 afte=
r
>>> > > btrfs_copy_from_user and going the correct delalloc accounting.=
 =A0This
>>> > > one looks solved, but you'll notice the patch is bigger.
>>> > >
>>> > > First, I add some random failures to btrfs_copy_from_user() by =
failing
>>> > > everyone once and a while. =A0This was much more reliable than =
trying to
>>> > > use memory pressure than making copy_from_user fail.
>>> > >
>>> > > If copy_from_user fails and we partially update a page, we end =
up with a
>>> > > page that may go away due to memory pressure. =A0But, btrfs_fil=
e_write
>>> > > assumes that only the first and last page may have good data th=
at needs
>>> > > to be read off the disk.
>>> > >
>>> > > This patch ditches that code and puts it into prepare_pages ins=
tead.
>>> > > But I'm still having some errors during long stress.sh runs. =A0=
Ideas are
>>> > > more than welcome, hopefully some other timezones will kick in =
ideas
>>> > > while I sleep.
>>> >
>>> > At least it doesn't fix the emerge-problem for me. The behavior i=
s now the same
>>> > as with 2.6.38-rc3. It needs a 'emerge --oneshot dev-libs/libgcry=
pt' with no
>>> > further interaction to get the emerge-process hang with a svn-pro=
cess
>>> > consuming 100% CPU. I can cancel the emerge-process with ctrl-c b=
ut the
>>> > spawned svn-process stays and it needs a reboot to get rid of it.
>>>
>>> Can you cat /proc/$pid/wchan a few times so we can get an idea of w=
here it's
>>> looping? =A0Thanks,
>>>
>>> Josef
>>
>> It behaves the same way here with btrfs-unstable.
>> The output of "cat /proc/$pid/wchan" is 0.
>>
>> // Maria
>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>
> I've applied the patch at the head of this thread (with the jiffies
> debugging commented out) and I'm attaching a ftrace using the
> function_graph tracer when I'm stuck in the loop. =A0I've just snippe=
d
> out a couple of the loops (the full trace file is quite large, and
> mostly repititious).
>
> I'm going to try to modify file.c with some trace_printk debugging to
> show the values of several of the relevant variables at various
> stages.
>
> I'm going to try to exit the loop after 256 tries with an EFAULT so I
> can stop the tracing at that point and capture a trace of the entry
> into the problem (the ftrace ring buffer fills up too fast for me to
> capture the entry point).
>

As promised, I'm put together a modified file.c with many trace_printk
debugging statements to augment the ftrace.

The trace is ~128K compressed (about 31,600 lines or 2.6MB
uncompressed), so I'm putting it up on my local server instead of
attaching.  Let me know if it would be more appropriate to send to the
list as an attachment.

http://dontpanic.dyndns.org/ftrace-btrfs-file-write-debug-v2.gz

I preface all my trace_printk comments with "TPK:" to make skipping
through the trace easier.

The trace contains the trace of about 3 or 4 successful passes through
the btrfs_file_aio_write() function to show what a successful trace
looks like.

The pass through the btrfs_file_aio_write() that breaks begins on line =
1088.

I let it loop through the while (iov_iter_count(&i) > 0) {} loop for
256 times when copied=3D=3D0 (otherwise it would loop infinitely).  The=
n
exit out and stop the trace.

=46or reference, here's a diff file for the debugging statements I've
added to file.c:

Let me know if you would like me to re-run this trial with different
debugging lines.

 fs/btrfs/file.c /usr/src/linux/fs/btrfs/file.c
--- fs/btrfs/file.c	2011-02-28 10:13:45.000000000 -0600
+++ /usr/src/linux/fs/btrfs/file.c	2011-02-28 13:07:11.000000000 -0600
@@ -53,12 +53,14 @@
 	int offset =3D pos & (PAGE_CACHE_SIZE - 1);
 	int total_copied =3D 0;

+	/***************************
 	if ((jiffies % 10) =3D=3D 0)
 		return 0;

 	if ((jiffies % 25) =3D=3D 0) {
 		write_bytes /=3D 2;
 	}
+	**************************/

 	while (write_bytes > 0) {
 		size_t count =3D min_t(size_t,
@@ -82,10 +84,13 @@

 		/* Return to btrfs_file_aio_write to fault page */
 		if (unlikely(copied =3D=3D 0)) {
+			trace_printk("TPK: unlikely copied =3D=3D 0 in btrfs_copy_from_user
(total_copied=3D%i)\n",
+				     total_copied);
 			break;
 		}

 		if (unlikely(copied < PAGE_CACHE_SIZE - offset)) {
+			trace_printk("TPK: unlikely copied < PAGE_CACHE_SIZE - offset in
btrfs_copy_from_user\n");
 			offset +=3D copied;
 		} else {
 			pg++;
@@ -910,8 +915,13 @@
 	int will_write;
 	int buffered =3D 0;
 	int copied =3D 0;
+	int copied_problem =3D 0;
+	int copied_loop_count =3D 0;
+	int stop_ftrace =3D 0;
 	int dirty_pages =3D 0;

+	trace_printk("TPK: Entering btrfs_file_aio_write()\n");
+
 	will_write =3D ((file->f_flags & O_DSYNC) || IS_SYNC(inode) ||
 		      (file->f_flags & O_DIRECT));

@@ -953,6 +963,7 @@
 	BTRFS_I(inode)->sequence++;

 	if (unlikely(file->f_flags & O_DIRECT)) {
+		trace_printk("TPK: transferred to unlikely(file->f_flags \& O_DIRECT=
)\n");
 		num_written =3D generic_file_direct_write(iocb, iov, &nr_segs,
 							pos, ppos, count,
 							ocount);
@@ -984,6 +995,8 @@
 		 */
 		buffered =3D 1;
 		pos +=3D num_written;
+		trace_printk("TPK: end unlikely(file->f_flags \& O_DIRECT) with
num_written=3D%i\n",
+			     num_written);
 	}

 	iov_iter_init(&i, iov, nr_segs, count, num_written);
@@ -1003,6 +1016,8 @@
 	last_index =3D (pos + iov_iter_count(&i)) >> PAGE_CACHE_SHIFT;

 	while (iov_iter_count(&i) > 0) {
+		trace_printk("TPK: start section while (iov_iter_count() > 0)\n");
+
 		size_t offset =3D pos & (PAGE_CACHE_SIZE - 1);
 		size_t write_bytes =3D min(iov_iter_count(&i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
@@ -1010,6 +1025,9 @@
 		size_t num_pages =3D (write_bytes + offset +
 				    PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;

+		trace_printk("TPK: iov_iter_count()=3D%i || nr_segs=3D%lu || nrptrs=3D=
%i
|| offset=3D%lu || write_bytes=3D%lu || num_pages=3D%lu\n",
+						iov_iter_count(&i), nr_segs, nrptrs, offset, write_bytes, num_pa=
ges);
+
 		WARN_ON(num_pages > nrptrs);
 		memset(pages, 0, sizeof(struct page *) * nrptrs);

@@ -1022,6 +1040,19 @@
 			goto out;
 		}

+		if (unlikely(copied_problem)) {
+			copied_loop_count++;
+			trace_printk("TPK: copied problem(%i)\n",
+				     copied_loop_count);
+			/* Give up if we've already tried 256 times */
+			if (copied_loop_count > 256) {
+				ret =3D -EFAULT;
+				stop_ftrace =3D 1;
+				trace_printk("TPK: copied loop count exceeded, returning EFAULT...=
=2E\n");
+				goto out;
+			}
+		}
+
 		ret =3D btrfs_delalloc_reserve_space(inode,
 					num_pages << PAGE_CACHE_SHIFT);
 		if (ret)
@@ -1045,6 +1076,10 @@
 				       PAGE_CACHE_SIZE - 1) >>
 				       PAGE_CACHE_SHIFT;

+		if (copied =3D=3D 0) {
+			copied_problem =3D 1;
+		}
+
 		if (num_pages > dirty_pages) {
 			if (copied > 0)
 				atomic_inc(
@@ -1080,11 +1115,19 @@
 		num_written +=3D copied;

 		cond_resched();
+		trace_printk("TPK: end section while (iov_iter_count() > 0)\n");
+		trace_printk(" copied=3D%i || dirty_pages=3D%i || num_written=3D%i |=
|
ending iov_iter_count=3D%i\n",
+						copied, dirty_pages, num_written, iov_iter_count(&i) );
 	}
 out:
+	trace_printk("TPK: Reached: out:\n");
+
 	mutex_unlock(&inode->i_mutex);
-	if (ret)
+	if (ret) {
 		err =3D ret;
+		trace_printk("TPK: ret,err had value %i when out: was reached
(num_written: %i)\n",
+			     ret, num_written);
+	}

 	kfree(pages);
 	*ppos =3D pos;
@@ -1140,6 +1183,19 @@
 	}
 done:
 	current->backing_dev_info =3D NULL;
+	if (ret) {
+		trace_printk("TPK: btrfs_file_aio_write exiting with non-zero ret
value (%i)\n", ret);
+		trace_printk("TPK: Returning num_written (%i) ? num_written (%i) :
err (%i) =3D %i\n",
+				num_written, num_written, err, num_written ? num_written : err);
+	} else {
+		trace_printk("TPK: btrfs_file_aio_write exiting normally with (%i)",
+			     num_written ? num_written : err);
+	}
+=09
+	if (unlikely(stop_ftrace)) {
+		tracing_off();
+	}
+
 	return num_written ? num_written : err;
 }
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
