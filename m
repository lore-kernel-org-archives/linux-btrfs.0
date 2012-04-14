From: Francesco Cepparo <francesco.cepparo@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1890!
Date: Sat, 14 Apr 2012 00:06:13 +0000
Message-ID: <CACfQV3jq3eGq2i4OneR4A3jcnSg_irMCmPFJHOwrpE_Dd0swkg@mail.gmail.com>
References: <CACfQV3hb92zrYUJ8to1mq8s1wzfdEoMBDi9b5VmfZ0AZ=UBkFA@mail.gmail.com>
	<20120411150158.GA5820@localhost.localdomain>
	<CACfQV3j_WGTB-+booc1bDMvs1i_Kjr_WAAmLKgUb9sUWe-+wPg@mail.gmail.com>
	<20120412180836.GJ1924@localhost.localdomain>
	<20120412181525.GU29506@shiny>
	<20120412182049.GK1924@localhost.localdomain>
	<CACfQV3j1X_08UJ_o-09thSUM-8SpBse9zB5eWWbuFSz5=7mWPw@mail.gmail.com>
	<20120413144529.GC1923@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120413144529.GC1923@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

That did it :) the kernel now fails the mounting gracefully as it did b=
efore. :)
Thanks!



On Fri, Apr 13, 2012 at 2:45 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Apr 12, 2012 at 09:56:30PM +0000, Francesco Cepparo wrote:
>> On Thu, Apr 12, 2012 at 6:20 PM, Josef Bacik <josef@redhat.com> wrot=
e:
>> > On Thu, Apr 12, 2012 at 02:15:25PM -0400, Chris Mason wrote:
>> >> On Thu, Apr 12, 2012 at 02:08:37PM -0400, Josef Bacik wrote:
>> >> > On Wed, Apr 11, 2012 at 11:59:43PM +0000, Francesco Cepparo wro=
te:
>> >> > > I tried your patch but unfortunately the kernel still gives m=
e the
>> >> > > same error message :(
>> >> >
>> >> > Weird, will you apply this patch on top of the one I sent you a=
nd send me the
>> >> > dmesg when it panics again? =A0Thanks,
>> >> >
>> >> > Josef
>> >> >
>> >> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> >> > index 2a3ddd2..51efb58 100644
>> >> > --- a/fs/btrfs/disk-io.c
>> >> > +++ b/fs/btrfs/disk-io.c
>> >> > @@ -652,6 +652,8 @@ static int btree_io_failed_hook(struct page=
 *page, int failed_mirror)
>> >> >
>> >> > =A0 =A0 eb =3D (struct extent_buffer *)page->private;
>> >> > =A0 =A0 set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
>> >> > + =A0 WARN_ON(!failed_mirror);
>> >> > + =A0 printk(KERN_ERR "io error, failed mirror %d\n");
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^
>> >>
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 , failed_mirror
>> >>
>> >
>> > pfft compiling debug patches before sending them out is for losers=
,
>> >
>> > Josef
>>
>> I applied your second patch on top of the first one but the dmesg
>> output stays the same.... before you ask, I'm sure I'm compiling the
>> kernel correctly, as putting the WARN_ON(!failed_mirror) inside the =
if
>> (!failed_mirror) on line 391 correctly prints the warnings... I'm no=
t
>> sure whether the warnings generated in that place are of any interes=
t
>> but showing them anyway can't hurt:
>>
>
> Oh hah I see what's happening, unapply the last patch I sent you (lea=
ve the
> first one in place) and apply this one, it should fix the problem. =A0=
Thanks,
>
> Josef
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 2a3ddd2..dc52f3f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -390,8 +390,7 @@ static int btree_read_extent_buffer_pages(struct =
btrfs_root *root,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!failed_mirror) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed =3D 1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "failed=
 mirror was %d\n", eb->failed_mirror);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failed_mirror =3D eb->f=
ailed_mirror;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failed_mirror =3D eb->r=
ead_mirror;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mirror_num++;
> @@ -564,7 +563,7 @@ struct extent_buffer *find_eb_for_page(struct ext=
ent_io_tree *tree,
> =A0}
>
> =A0static int btree_readpage_end_io_hook(struct page *page, u64 start=
, u64 end,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct e=
xtent_state *state)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct e=
xtent_state *state, int mirror)
> =A0{
> =A0 =A0 =A0 =A0struct extent_io_tree *tree;
> =A0 =A0 =A0 =A0u64 found_start;
> @@ -589,6 +588,7 @@ static int btree_readpage_end_io_hook(struct page=
 *page, u64 start, u64 end,
> =A0 =A0 =A0 =A0if (!reads_done)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err;
>
> + =A0 =A0 =A0 eb->read_mirror =3D mirror;
> =A0 =A0 =A0 =A0if (test_bit(EXTENT_BUFFER_IOERR, &eb->bflags)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err;
> @@ -652,7 +652,6 @@ static int btree_io_failed_hook(struct page *page=
, int failed_mirror)
>
> =A0 =A0 =A0 =A0eb =3D (struct extent_buffer *)page->private;
> =A0 =A0 =A0 =A0set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
> - =A0 =A0 =A0 eb->failed_mirror =3D failed_mirror;
> =A0 =A0 =A0 =A0if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->b=
flags))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btree_readahead_hook(root, eb, eb->sta=
rt, -EIO);
> =A0 =A0 =A0 =A0return -EIO; =A0 =A0/* we fixed nothing */
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0c3ec00..7c501d3 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2297,7 +2297,7 @@ static void end_bio_extent_readpage(struct bio =
*bio, int err)
> =A0 =A0 =A0 =A0u64 start;
> =A0 =A0 =A0 =A0u64 end;
> =A0 =A0 =A0 =A0int whole_page;
> - =A0 =A0 =A0 int failed_mirror;
> + =A0 =A0 =A0 int mirror;
> =A0 =A0 =A0 =A0int ret;
>
> =A0 =A0 =A0 =A0if (err)
> @@ -2336,20 +2336,18 @@ static void end_bio_extent_readpage(struct bi=
o *bio, int err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&tree->lock);
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mirror =3D (int)(unsigned long)bio->bi_=
bdev;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (uptodate && tree->ops && tree->ops=
->readpage_end_io_hook) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D tree->ops->rea=
dpage_end_io_hook(page, start, end,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 state, mirror);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uptoda=
te =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clean_=
io_failure(start, page);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!uptodate)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failed_mirror =3D (int)=
(unsigned long)bio->bi_bdev;
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!uptodate && tree->ops && tree->op=
s->readpage_io_failed_hook) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D tree->ops->read=
page_io_failed_hook(page, failed_mirror);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D tree->ops->read=
page_io_failed_hook(page, mirror);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!ret && !err &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0test_bit(BIO_U=
PTODATE, &bio->bi_flags))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uptoda=
te =3D 1;
> @@ -2364,8 +2362,7 @@ static void end_bio_extent_readpage(struct bio =
*bio, int err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * can't handle the er=
ror it will return -EIO and we
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * remain responsible =
for that page.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D bio_readpage_er=
ror(bio, page, start, end,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 failed_mirror, NULL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D bio_readpage_er=
ror(bio, page, start, end, mirror, NULL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uptoda=
te =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0test_bit(BIO_UPTODATE, &bio->bi_flags);
> @@ -4458,7 +4455,7 @@ int read_extent_buffer_pages(struct extent_io_t=
ree *tree,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
> - =A0 =A0 =A0 eb->failed_mirror =3D 0;
> + =A0 =A0 =A0 eb->read_mirror =3D 0;
> =A0 =A0 =A0 =A0atomic_set(&eb->io_pages, num_reads);
> =A0 =A0 =A0 =A0for (i =3D start_i; i < num_pages; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page =3D extent_buffer_page(eb, i);
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index faf10eb..b516c3b 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -79,7 +79,7 @@ struct extent_io_ops {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0u64 start, u64 end,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 struct extent_state *state);
> =A0 =A0 =A0 =A0int (*readpage_end_io_hook)(struct page *page, u64 sta=
rt, u64 end,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 struct extent_state *state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 struct extent_state *state, int mirror);
> =A0 =A0 =A0 =A0int (*writepage_end_io_hook)(struct page *page, u64 st=
art, u64 end,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0struct extent_state *state, int uptodate);
> =A0 =A0 =A0 =A0void (*set_bit_hook)(struct inode *inode, struct exten=
t_state *state,
> @@ -135,7 +135,7 @@ struct extent_buffer {
> =A0 =A0 =A0 =A0spinlock_t refs_lock;
> =A0 =A0 =A0 =A0atomic_t refs;
> =A0 =A0 =A0 =A0atomic_t io_pages;
> - =A0 =A0 =A0 int failed_mirror;
> + =A0 =A0 =A0 int read_mirror;
> =A0 =A0 =A0 =A0struct list_head leak_list;
> =A0 =A0 =A0 =A0struct rcu_head rcu_head;
> =A0 =A0 =A0 =A0pid_t lock_owner;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 261021c..77c2b03 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1947,7 +1947,7 @@ static int btrfs_writepage_end_io_hook(struct p=
age *page, u64 start, u64 end,
> =A0* extent_io.c will try to find good copies for us.
> =A0*/
> =A0static int btrfs_readpage_end_io_hook(struct page *page, u64 start=
, u64 end,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct e=
xtent_state *state)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct e=
xtent_state *state, int mirror)
> =A0{
> =A0 =A0 =A0 =A0size_t offset =3D start - ((u64)page->index << PAGE_CA=
CHE_SHIFT);
> =A0 =A0 =A0 =A0struct inode *inode =3D page->mapping->host;
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
