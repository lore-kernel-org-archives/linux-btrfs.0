From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH] Btrfs: fix chunk allocate size calculation
Date: Tue, 6 Apr 2010 15:54:27 +0800
Message-ID: <g2o3d0408631004060054t652c69d2n1b150e7f57fce625@mail.gmail.com>
References: <20100317204556.GA4409@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100317204556.GA4409@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 18, 2010 at 4:45 AM, Josef Bacik <josef@redhat.com> wrote:
> If the amount of free space left in a device is less than what we thi=
nk should
> be the minimum size, just ignore the minimum size and use the amount =
we have. =A0I
> ran into this running tests on a 600mb volume, the chunk allocator wo=
uldn't let
> me allocate the last 52mb of the disk for data because we want to hav=
e at least
> 64mb chunks for data. =A0This patch fixes that problem. =A0Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 9df8e3f..1c5b5ba 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2244,8 +2244,10 @@ again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do_div(calc_size, stripe_len);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0calc_size *=3D stripe_len;
> =A0 =A0 =A0 =A0}
> +
> =A0 =A0 =A0 =A0/* we don't want tiny stripes */
> - =A0 =A0 =A0 calc_size =3D max_t(u64, min_stripe_size, calc_size);
> + =A0 =A0 =A0 if (!looped)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_size =3D max_t(u64, min_stripe_siz=
e, calc_size);
>
> =A0 =A0 =A0 =A0do_div(calc_size, stripe_len);
> =A0 =A0 =A0 =A0calc_size *=3D stripe_len;

I encountered an Oops caused by 'calc_size =3D=3D 0'. It's likely intro=
duced
by this change. (calc_size can be zero after calling do_div)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
