From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Thu, 9 Feb 2012 14:29:31 -0600
Message-ID: <CAKcLGm8CUGx4j66JbTc2gVZRmScrXjTd9yP=TMJ7Q+s1-0OLAA@mail.gmail.com>
References: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
	<CAKcLGm-ps-B9jZ8Xyxy0BduDcgzEtwsy0FzFhmV1GWZ_MP8q2g@mail.gmail.com>
	<4F332C05.1080808@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F332C05.1080808@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 8, 2012 at 8:14 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrote=
:
> On 02/09/2012 05:01 AM, Mitch Harder wrote:
>> On Wed, Jan 18, 2012 at 10:13 AM, Mitch Harder
>> <mitch.harder@sabayonlinux.org> wrote:
>>> I have a Btrfs partition that is reliably reproducing premature ENO=
SPC
>>> when restoring the disk from a tar file, but it is only happening w=
ith
>>> zlib compression (lzo or no compression proceeds normally).
>>>
>>> I've had the same issue at least back through the 3.1 kernel series=
,
>>> and I've been having intermittent issues even further back.
>>>
>>> I am currently using a 3.2.1 kernel merged with Chris' latest
>>> integration branch.
>>>
>>> I've performed about 12 trials trying to explore various combinatio=
ns
>>> of compress, compress-force, compress[-force]=3D[zlib,lzo] and
>>> autodefrag.
>>>
>>> If I use no compression, or if I explicitly declare lzo compression=
, I
>>> don't receive the premature ENOSPC when untarring my restoration
>>> archive to the empty partition.
>>>
>>> If I don't specify compression (zlib is the default) or specify zli=
b,
>>> I get consistent premature ENOSPC errors regardless of other
>>> combinations.
>>>
>>> I apologize if this is already general knowledge, but I couldn't se=
e
>>> where this has been posted to the list before.
>>>
>>> As time allows, I will try to capture exactly where this ENOSPC is
>>> being issued in btrfs by inserting WARN_ON's in my local version
>>> where-ever ENOSPC is set.
>>
>> Some follow-up...
>>
>> I've injected some debugging code to isolate when the ENOSPC is bein=
g
>> generated when using zlib compression.
>>
>> When using zlib, I'm getting intermittent ENOSPC in the
>> may_commit_transaction() function in extent-tree.c at this point:
>>
>> =A0 =A0 =A0 if (delayed_rsv->size < bytes) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&delayed_rsv->lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSPC;
>> =A0 =A0 =A0 }
>>
>> The typical values for (delayed_rsv->size < bytes) have been:
>> delayed_rsv->size ( =3D 0x60000) < bytes ( =3D 0x78000)
>>
>> This typically occurs when unzipping a section of my backup that
>> contains lots of small files that are probably being mostly in-lined=
=2E
>>
>> I don't see errors in this section when using lzo or no compression.
>
> Hi Mitch,
>
> Would you like to try this patch?
>
> thanks,
> liubo
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 8603ee4..d83b15e 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3483,28 +3483,34 @@ static int may_commit_transaction(struct btrf=
s_root *root,
> =A0 =A0 =A0 =A0if (force)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto commit;
>
> - =A0 =A0 =A0 /* See if there is enough pinned space to make this res=
ervation */
> - =A0 =A0 =A0 spin_lock(&space_info->lock);
> - =A0 =A0 =A0 if (space_info->bytes_pinned >=3D bytes) {
> + =A0 =A0 =A0 if (space_info !=3D delayed_rsv->space_info) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* For DATA:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* See if there is enough pinned spac=
e to make this reservation
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&space_info->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (space_info->bytes_pinned < bytes) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&space_info=
->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSPC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&space_info->lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto commit;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 spin_unlock(&space_info->lock);
> -
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* See if there is some space in the delayed insertio=
n reservation for
> - =A0 =A0 =A0 =A0* this reservation.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 if (space_info !=3D delayed_rsv->space_info)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSPC;
> -
> - =A0 =A0 =A0 spin_lock(&delayed_rsv->lock);
> - =A0 =A0 =A0 if (delayed_rsv->size < bytes) {
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* For METADATA:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* See if there is enough space(pinne=
d and delayed insertion)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* to make this reservation
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&space_info->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&delayed_rsv->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (space_info->bytes_pinned + delayed_=
rsv->size < bytes) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&delayed_rs=
v->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&space_info=
->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSPC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&delayed_rsv->lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSPC;
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 spin_unlock(&delayed_rsv->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&space_info->lock);
>
> + =A0 =A0 =A0 }
> =A0commit:
> =A0 =A0 =A0 =A0trans =3D btrfs_join_transaction(root);
> =A0 =A0 =A0 =A0if (IS_ERR(trans))
> --
> 1.6.5.2
>
>

Thanks for looking at this, but I'm still getting ENOSPC errors at the
same point after applying this patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
