From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Tue, 1 Mar 2011 08:54:24 -0600
Message-ID: <AANLkTimkhbA8Lq=eS704+RVt=FeQoeFwy1JgdkHPsrxy@mail.gmail.com>
References: <1298857223-sup-5612@think>
	<201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
	<20110228161056.GA2769@localhost.localdomain>
	<1298911556.11118.8.camel@mainframe>
	<AANLkTin_Hjr3StjWUGrwCHBzhk_kwj-G2WqxZM6=CqN2@mail.gmail.com>
	<AANLkTikex7g4+dc9qiPdL_xRk5SoFxE3TCfN7dg3kaR2@mail.gmail.com>
	<1865303E0DED764181A9D882DEF65FB68662A5EA63@shsmsx502.ccr.corp.intel.com>
	<1865303E0DED764181A9D882DEF65FB68662A5EA7B@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-1?Q?Maria_Wikstr=F6m?= <maria@ponstudios.se>,
	Josef Bacik <josef@redhat.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB68662A5EA7B@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 1, 2011 at 5:56 AM, Zhong, Xin <xin.zhong@intel.com> wrote:
> Hi Mitch,
>
> I suspect there's a lock contention between flush-btrfs (lock_dellall=
oc_pages) and btrfs_file_aio_write. However I can not recreate it local=
ly. Could you please try below patch? Thanks!
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c index 65338a1..b9d0929=
 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1007,17 +1007,16 @@ static ssize_t btrfs_file_aio_write(struct ki=
ocb *iocb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_delalloc_reserve_space(in=
ode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 num_pages << PAGE_CACHE_SHIFT);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D prepare_pages(root, file, page=
s, num_pages,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
pos, first_index, last_index,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
write_bytes);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_delalloc_release_=
space(inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_delalloc_reserve_space(in=
ode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0num_pages << PAGE_CACHE_SHIFT);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_drop_pages(pages,=
 num_pages);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
>

Thanks.

I've tested this patch, but the build is still failing at the same
point as before.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
