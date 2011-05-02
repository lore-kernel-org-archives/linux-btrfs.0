From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [PATCH v3 1/3] btrfs: move btrfs_cmp_device_free_bytes to super.c
Date: Mon, 2 May 2011 17:16:15 +0800
Message-ID: <BANLkTimbA9vuLt6vpnZDLBwjKv52ui1x=g@mail.gmail.com>
References: <cover.1304325641.git.sensille@gmx.net>
	<f16608fbcf0191305c70471667f54d1a0313192f.1304325641.git.sensille@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f16608fbcf0191305c70471667f54d1a0313192f.1304325641.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 2 May 2011 16:47, Arne Jansen <sensille@gmx.net> wrote:
> this function won't be used here anymore, so move it super.c where it=
 is
> used for df-calculation
>
> Signed-off-by: Arne Jansen <sensille@gmx.net>
> ---
> =A0fs/btrfs/super.c =A0 | =A0 25 +++++++++++++++++++++++++
> =A0fs/btrfs/volumes.c | =A0 13 -------------
> =A0fs/btrfs/volumes.h | =A0 15 ---------------
> =A03 files changed, 25 insertions(+), 28 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 0ac712e..d8c9a49 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -913,6 +913,31 @@ static int btrfs_remount(struct super_block *sb,=
 int *flags, char *data)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +/* Used to sort the devices by max_avail(descending sort) */
> +int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *d=
ev_info2)
> +{
> + =A0 =A0 =A0 if (((struct btrfs_device_info *)dev_info1)->max_avail =
>
> + =A0 =A0 =A0 =A0 =A0 ((struct btrfs_device_info *)dev_info2)->max_av=
ail)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 else if (((struct btrfs_device_info *)dev_info1)->max_a=
vail <
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((struct btrfs_device_info *)dev_inf=
o2)->max_avail)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/*
> + * sort the devices by max_avail, in which max free extent size of e=
ach device
> + * is stored.(Descending Sort)
> + */
> +static inline void btrfs_descending_sort_devices(
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct btrfs_device_info *devices,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 size_t nr_devices)
> +{
> + =A0 =A0 =A0 sort(devices, nr_devices, sizeof(struct btrfs_device_in=
fo),
> + =A0 =A0 =A0 =A0 =A0 =A0btrfs_cmp_device_free_bytes, NULL);
> +}
> +
> =A0/*
> =A0* The helper to calc the free space on the devices that can be use=
d to store
> =A0* file data.
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8b9fb8c..a9f1fc2 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2282,19 +2282,6 @@ static noinline u64 chunk_bytes_by_type(u64 ty=
pe, u64 calc_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return calc_size * num_stripes;
> =A0}
>
> -/* Used to sort the devices by max_avail(descending sort) */
> -int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *d=
ev_info2)
> -{
> - =A0 =A0 =A0 if (((struct btrfs_device_info *)dev_info1)->max_avail =
>
> - =A0 =A0 =A0 =A0 =A0 ((struct btrfs_device_info *)dev_info2)->max_av=
ail)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> - =A0 =A0 =A0 else if (((struct btrfs_device_info *)dev_info1)->max_a=
vail <
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((struct btrfs_device_info *)dev_inf=
o2)->max_avail)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> -}
> -
> =A0static int __btrfs_calc_nstripes(struct btrfs_fs_devices *fs_devic=
es, u64 type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *=
num_stripes, int *min_stripes,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *=
sub_stripes)
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index cc2eada..b502f01 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -157,21 +157,6 @@ struct map_lookup {
> =A0 =A0 =A0 =A0struct btrfs_bio_stripe stripes[];
> =A0};
>
> -/* Used to sort the devices by max_avail(descending sort) */
> -int btrfs_cmp_device_free_bytes(const void *dev_info1, const void *d=
ev_info2);
> -
> -/*
> - * sort the devices by max_avail, in which max free extent size of e=
ach device
> - * is stored.(Descending Sort)
> - */
> -static inline void btrfs_descending_sort_devices(
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct btrfs_device_info *devices,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 size_t nr_devices)
> -{
> - =A0 =A0 =A0 sort(devices, nr_devices, sizeof(struct btrfs_device_in=
fo),
> - =A0 =A0 =A0 =A0 =A0 =A0btrfs_cmp_device_free_bytes, NULL);
> -}
> -
> =A0int btrfs_account_dev_extents_size(struct btrfs_device *device, u6=
4 start,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u=
64 end, u64 *length);
>

btrfs_cmp_device_free_bytes() can be marked static, since there are no
users outside the compilation unit.

Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
