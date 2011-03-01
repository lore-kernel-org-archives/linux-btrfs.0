From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Mon, 28 Feb 2011 23:09:21 -0600
Message-ID: <AANLkTi=4HW0vFa4D_WAo=Xi0XC51na_EmhqAF9YEenb0@mail.gmail.com>
References: <1298857223-sup-5612@think>
	<201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
	<20110228161056.GA2769@localhost.localdomain>
	<1298911556.11118.8.camel@mainframe>
	<AANLkTin_Hjr3StjWUGrwCHBzhk_kwj-G2WqxZM6=CqN2@mail.gmail.com>
	<AANLkTikex7g4+dc9qiPdL_xRk5SoFxE3TCfN7dg3kaR2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	Chris Mason <chris.mason@oracle.com>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?Maria_Wikstr=F6m?= <maria@ponstudios.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikex7g4+dc9qiPdL_xRk5SoFxE3TCfN7dg3kaR2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/2/28 Mitch Harder <mitch.harder@sabayonlinux.org>:
> 2011/2/28 Mitch Harder <mitch.harder@sabayonlinux.org>:
>> 2011/2/28 Maria Wikstr=F6m <maria@ponstudios.se>:
>>> m=E5n 2011-02-28 klockan 11:10 -0500 skrev Josef Bacik:
>>>> On Mon, Feb 28, 2011 at 11:13:59AM +0100, Johannes Hirte wrote:
>>>> > On Monday 28 February 2011 02:46:05 Chris Mason wrote:
>>>> > > Excerpts from Mitch Harder's message of 2011-02-25 13:43:37 -0=
500:
>>>> > > > Some clarification on my previous message...
>>>> > > >
>>>> > > > After looking at my ftrace log more closely, I can see where=
 Btrfs is
>>>> > > > trying to release the allocated pages. =A0However, the calcu=
lation for
>>>> > > > the number of dirty_pages is equal to 1 when "copied =3D=3D =
0".
>>>> > > >
>>>> > > > So I'm seeing at least two problems:
>>>> > > > (1) =A0It keeps looping when "copied =3D=3D 0".
>>>> > > > (2) =A0One dirty page is not being released on every loop ev=
en though
>>>> > > > "copied =3D=3D 0" (at least this problem keeps it from being=
 an infinite
>>>> > > > loop by eventually exhausting reserveable space on the disk)=
=2E
>>>> > >
>>>> > > Hi everyone,
>>>> > >
>>>> > > There are actually tow bugs here. =A0First the one that Mitch =
hit, and a
>>>> > > second one that still results in bad file_write results with m=
y
>>>> > > debugging hunks (the first two hunks below) in place.
>>>> > >
>>>> > > My patch fixes Mitch's bug by checking for copied =3D=3D 0 aft=
er
>>>> > > btrfs_copy_from_user and going the correct delalloc accounting=
=2E =A0This
>>>> > > one looks solved, but you'll notice the patch is bigger.
>>>> > >
>>>> > > First, I add some random failures to btrfs_copy_from_user() by=
 failing
>>>> > > everyone once and a while. =A0This was much more reliable than=
 trying to
>>>> > > use memory pressure than making copy_from_user fail.
>>>> > >
>>>> > > If copy_from_user fails and we partially update a page, we end=
 up with a
>>>> > > page that may go away due to memory pressure. =A0But, btrfs_fi=
le_write
>>>> > > assumes that only the first and last page may have good data t=
hat needs
>>>> > > to be read off the disk.
>>>> > >
>>>> > > This patch ditches that code and puts it into prepare_pages in=
stead.
>>>> > > But I'm still having some errors during long stress.sh runs. =A0=
Ideas are
>>>> > > more than welcome, hopefully some other timezones will kick in=
 ideas
>>>> > > while I sleep.
>>>> >
>>>> > At least it doesn't fix the emerge-problem for me. The behavior =
is now the same
>>>> > as with 2.6.38-rc3. It needs a 'emerge --oneshot dev-libs/libgcr=
ypt' with no
>>>> > further interaction to get the emerge-process hang with a svn-pr=
ocess
>>>> > consuming 100% CPU. I can cancel the emerge-process with ctrl-c =
but the
>>>> > spawned svn-process stays and it needs a reboot to get rid of it=
=2E
>>>>
>>>> Can you cat /proc/$pid/wchan a few times so we can get an idea of =
where it's
>>>> looping? =A0Thanks,
>>>>
>>>> Josef
>>>
>>> It behaves the same way here with btrfs-unstable.
>>> The output of "cat /proc/$pid/wchan" is 0.
>>>
>>> // Maria
>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-bt=
rfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>>
>>>
>>
>> I've applied the patch at the head of this thread (with the jiffies
>> debugging commented out) and I'm attaching a ftrace using the
>> function_graph tracer when I'm stuck in the loop. =A0I've just snipp=
ed
>> out a couple of the loops (the full trace file is quite large, and
>> mostly repititious).
>>
>> I'm going to try to modify file.c with some trace_printk debugging t=
o
>> show the values of several of the relevant variables at various
>> stages.
>>
>> I'm going to try to exit the loop after 256 tries with an EFAULT so =
I
>> can stop the tracing at that point and capture a trace of the entry
>> into the problem (the ftrace ring buffer fills up too fast for me to
>> capture the entry point).
>>
>
> As promised, I'm put together a modified file.c with many trace_print=
k
> debugging statements to augment the ftrace.
>
> The trace is ~128K compressed (about 31,600 lines or 2.6MB
> uncompressed), so I'm putting it up on my local server instead of
> attaching. =A0Let me know if it would be more appropriate to send to =
the
> list as an attachment.
>
> http://dontpanic.dyndns.org/ftrace-btrfs-file-write-debug-v2.gz
>
> I preface all my trace_printk comments with "TPK:" to make skipping
> through the trace easier.
>
> The trace contains the trace of about 3 or 4 successful passes throug=
h
> the btrfs_file_aio_write() function to show what a successful trace
> looks like.
>
> The pass through the btrfs_file_aio_write() that breaks begins on lin=
e 1088.
>
> I let it loop through the while (iov_iter_count(&i) > 0) {} loop for
> 256 times when copied=3D=3D0 (otherwise it would loop infinitely). =A0=
Then
> exit out and stop the trace.
>
> For reference, here's a diff file for the debugging statements I've
> added to file.c:
>
> Let me know if you would like me to re-run this trial with different
> debugging lines.
>
> =A0fs/btrfs/file.c /usr/src/linux/fs/btrfs/file.c
> --- fs/btrfs/file.c =A0 =A0 2011-02-28 10:13:45.000000000 -0600
> +++ /usr/src/linux/fs/btrfs/file.c =A0 =A0 =A02011-02-28 13:07:11.000=
000000 -0600
> @@ -53,12 +53,14 @@
> =A0 =A0 =A0 =A0int offset =3D pos & (PAGE_CACHE_SIZE - 1);
> =A0 =A0 =A0 =A0int total_copied =3D 0;
>
> + =A0 =A0 =A0 /***************************
> =A0 =A0 =A0 =A0if ((jiffies % 10) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> =A0 =A0 =A0 =A0if ((jiffies % 25) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0write_bytes /=3D 2;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 **************************/
>
> =A0 =A0 =A0 =A0while (write_bytes > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t count =3D min_t(size_t,
> @@ -82,10 +84,13 @@
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Return to btrfs_file_aio_write to f=
ault page */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(copied =3D=3D 0)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: unli=
kely copied =3D=3D 0 in btrfs_copy_from_user
> (total_copied=3D%i)\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0total_copied);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(copied < PAGE_CACHE_SIZE =
- offset)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: unli=
kely copied < PAGE_CACHE_SIZE - offset in
> btrfs_copy_from_user\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset +=3D copied;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pg++;
> @@ -910,8 +915,13 @@
> =A0 =A0 =A0 =A0int will_write;
> =A0 =A0 =A0 =A0int buffered =3D 0;
> =A0 =A0 =A0 =A0int copied =3D 0;
> + =A0 =A0 =A0 int copied_problem =3D 0;
> + =A0 =A0 =A0 int copied_loop_count =3D 0;
> + =A0 =A0 =A0 int stop_ftrace =3D 0;
> =A0 =A0 =A0 =A0int dirty_pages =3D 0;
>
> + =A0 =A0 =A0 trace_printk("TPK: Entering btrfs_file_aio_write()\n");
> +
> =A0 =A0 =A0 =A0will_write =3D ((file->f_flags & O_DSYNC) || IS_SYNC(i=
node) ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(file->f_flags & O_DIRECT)=
);
>
> @@ -953,6 +963,7 @@
> =A0 =A0 =A0 =A0BTRFS_I(inode)->sequence++;
>
> =A0 =A0 =A0 =A0if (unlikely(file->f_flags & O_DIRECT)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: transferred to unlik=
ely(file->f_flags \& O_DIRECT)\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_written =3D generic_file_direct_wr=
ite(iocb, iov, &nr_segs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pos, ppos, count,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ocount);
> @@ -984,6 +995,8 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buffered =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pos +=3D num_written;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: end unlikely(file->f=
_flags \& O_DIRECT) with
> num_written=3D%i\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_written)=
;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0iov_iter_init(&i, iov, nr_segs, count, num_written);
> @@ -1003,6 +1016,8 @@
> =A0 =A0 =A0 =A0last_index =3D (pos + iov_iter_count(&i)) >> PAGE_CACH=
E_SHIFT;
>
> =A0 =A0 =A0 =A0while (iov_iter_count(&i) > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: start section while =
(iov_iter_count() > 0)\n");
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t offset =3D pos & (PAGE_CACHE_SI=
ZE - 1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t write_bytes =3D min(iov_iter_co=
unt(&i),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 nrptrs * (size_t)PAGE_CACHE_SIZE -
> @@ -1010,6 +1025,9 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t num_pages =3D (write_bytes + of=
fset +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: iov_iter_count()=3D%=
i || nr_segs=3D%lu || nrptrs=3D%i
> || offset=3D%lu || write_bytes=3D%lu || num_pages=3D%lu\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 iov_iter_count(&i), nr_segs, nrptrs, offset, w=
rite_bytes, num_pages);
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0WARN_ON(num_pages > nrptrs);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memset(pages, 0, sizeof(struct page *)=
 * nrptrs);
>
> @@ -1022,6 +1040,19 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(copied_problem)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied_loop_count++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: copi=
ed problem(%i)\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0copied_loop_count);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Give up if we've alr=
eady tried 256 times */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (copied_loop_count >=
 256) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 -EFAULT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stop_ft=
race =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_p=
rintk("TPK: copied loop count exceeded, returning EFAULT....\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ou=
t;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_delalloc_reserve_space(i=
node,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0num_pages << PAGE_CACHE_SHIFT);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> @@ -1045,6 +1076,10 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 PAGE_CACHE_SIZE - 1) >>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 PAGE_CACHE_SHIFT;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (copied =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 copied_problem =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (num_pages > dirty_pages) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (copied > 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic=
_inc(
> @@ -1080,11 +1115,19 @@
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_written +=3D copied;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cond_resched();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: end section while (i=
ov_iter_count() > 0)\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk(" copied=3D%i || dirty_pag=
es=3D%i || num_written=3D%i ||
> ending iov_iter_count=3D%i\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 copied, dirty_pages, num_written, iov_iter_cou=
nt(&i) );
> =A0 =A0 =A0 =A0}
> =A0out:
> + =A0 =A0 =A0 trace_printk("TPK: Reached: out:\n");
> +
> =A0 =A0 =A0 =A0mutex_unlock(&inode->i_mutex);
> - =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: ret,err had value %i=
 when out: was reached
> (num_written: %i)\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret, num_wri=
tten);
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0kfree(pages);
> =A0 =A0 =A0 =A0*ppos =3D pos;
> @@ -1140,6 +1183,19 @@
> =A0 =A0 =A0 =A0}
> =A0done:
> =A0 =A0 =A0 =A0current->backing_dev_info =3D NULL;
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: btrfs_file_aio_write=
 exiting with non-zero ret
> value (%i)\n", ret);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: Returning num_writte=
n (%i) ? num_written (%i) :
> err (%i) =3D %i\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_wri=
tten, num_written, err, num_written ? num_written : err);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_printk("TPK: btrfs_file_aio_write=
 exiting normally with (%i)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0num_written =
? num_written : err);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (unlikely(stop_ftrace)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tracing_off();
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0return num_written ? num_written : err;
> =A0}
>

I'm developing a hypothesis that something is going wrong when Btrfs
is trying to lock multiple pages.

Page faults are being encountered at the same spot, over and over
(BTW, I ran a memcheck to rule that possibility out).

If I scan through my traces, it looks like most calls to write are
submitted 1 block (4096 bytes) at a time, at the most (also many are <
4096 bytes).  The portion that is causing a problem is trying to write
12288 bytes (3k).  For some reason, the first 24 bytes are written,
and the remainder of the loop is spent on the 12264 that are
remaining.  But page faults are encountered on each loop, and no more
bytes are copied.

I modified file.c to cut back on the scope of the attempted write to
smaller chunks.

The following patch "fixes" my problem, and this build completes
without error.  I'm not submitting this patch as a solution.  It's
clearly papering over a deeper issue.  However, I think it gives
insight into the problem.

I wrote the patch to allow for sequentially smaller blocks if failures
continue.  But the block cleared once I limited the scope to 4096
bytes.  It never needed to try smaller data segments.

As hoped, limiting the scope of the write allowed the 12264 bytes to
be written in the next three subsequent loops after lowering the scope
of the write.

It was interesting to note that cutting the scope to 4096 didn't
guarantee that you were limiting the write to one block. There was
usually some overlap, and 2 dirty block needed to be written.  But I'm
still suspicious that there is a mismatch somewhere when trying to
lock multiple blocks.

Here's the debugging patch I constructed which actually allowed the
build to complete without error.  This was applied (for testing
purposes) on top of the previous debugging patch.  As noted earlier,
it never went lower than a 4096 byte window for write_bytes.

--- file.c.file-write-patch-v1	2011-02-28 13:06:37.000000000 -0600
+++ file.c	2011-02-28 19:23:21.000000000 -0600
@@ -908,6 +908,7 @@
 	ssize_t err =3D 0;
 	size_t count;
 	size_t ocount;
+	size_t write_bytes =3D 0;
 	int ret =3D 0;
 	int nrptrs;
 	unsigned long first_index;
@@ -963,7 +964,7 @@
 	BTRFS_I(inode)->sequence++;

 	if (unlikely(file->f_flags & O_DIRECT)) {
-		trace_printk("TPK: transferred to unlikely(file->f_flags \& O_DIRECT=
)\n");
+		trace_printk("TPK: transferred to unlikely(file->f_flags & O_DIRECT)=
\n");
 		num_written =3D generic_file_direct_write(iocb, iov, &nr_segs,
 							pos, ppos, count,
 							ocount);
@@ -995,7 +996,7 @@
 		 */
 		buffered =3D 1;
 		pos +=3D num_written;
-		trace_printk("TPK: end unlikely(file->f_flags \& O_DIRECT) with
num_written=3D%i\n",
+		trace_printk("TPK: end unlikely(file->f_flags & O_DIRECT) with
num_written=3D%i\n",
 			     num_written);
 	}

@@ -1019,9 +1020,20 @@
 		trace_printk("TPK: start section while (iov_iter_count() > 0)\n");

 		size_t offset =3D pos & (PAGE_CACHE_SIZE - 1);
-		size_t write_bytes =3D min(iov_iter_count(&i),
-					 nrptrs * (size_t)PAGE_CACHE_SIZE -
-					 offset);
+		write_bytes =3D min(iov_iter_count(&i),
+				  nrptrs * (size_t)PAGE_CACHE_SIZE -
+				  offset);
+		if (unlikely(copied_problem)) {
+			if (copied_loop_count > 128) {
+				write_bytes =3D min(write_bytes, 4096);
+			} else if (copied_loop_count > 160) {
+				write_bytes =3D min(write_bytes, 2048);
+			} else if (copied_loop_count > 192) {
+				write_bytes =3D min(write_bytes, 1024);
+			} else if (copied_loop_count > 224) {
+				write_bytes =3D min(write_bytes, 512);
+			}
+		}
 		size_t num_pages =3D (write_bytes + offset +
 				    PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
