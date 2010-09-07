From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: [2.6.35-rc6 patch] direct I/O submission fixes v2
Date: Tue, 7 Sep 2010 15:18:28 +0100
Message-ID: <AANLkTi=AKr3PORx7e3_fC9yStsZh1GCG7YDJ++LegZ-m@mail.gmail.com>
References: <AANLkTinvEBT26BaxR3Z1ZZXmzuvq91pMQSd1PbqYTyJM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinvEBT26BaxR3Z1ZZXmzuvq91pMQSd1PbqYTyJM@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On 25 July 2010 15:42, Josef Bacik <josef@redhat.com> wrote:
> On Sat, Jul 24, 2010 at 12:01:59AM +0100, Daniel J Blueman wrote:
>> Hi Chris,
>>
>> This fixes some issues relating to direct I/O submission, however a
>> further patch will be needed to handle the case where allocation of
>> 'dip' fails, which is always dereferenced when finding the ordered
>> extent.
>>
>
> Hi,
>
> There's an easier way to do this. =A0This patch should fix the proble=
m,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3232945..7259ef9 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -5815,7 +5815,7 @@ free_ordered:
> =A0 =A0 =A0 =A0if (write) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_ordered_extent *ordered;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ordered =3D btrfs_lookup_ordered_exten=
t(inode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dip->logical_offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_offset);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!test_bit(BTRFS_ORDERED_PREALLOC, =
&ordered->flags) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!test_bit(BTRFS_ORDERED_NOCOW,=
 &ordered->flags))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_free_reserved_ex=
tent(root, ordered->start,
>

Good move!

With your patch applied, mine (now not priority) then becomes:

=46ix leak of 'dip' on error path and double assignment.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1bff92a..bd7f940 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5652,15 +5652,15 @@ static void btrfs_submit_direct(int rw, struct
bio *bio, struct inode *inode,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -ENOMEM;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto free_ordered;
=A0 =A0 =A0 =A0}
- =A0 =A0 =A0 dip->csums =3D NULL;

=A0 =A0 =A0 =A0if (!skip_sum) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dip->csums =3D kmalloc(sizeof(u32) * bio=
->bi_vcnt, GFP_NOFS);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!dip->csums) {
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -ENOMEM;
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto free_ordered;
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_err;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
- =A0 =A0 =A0 }
+ =A0 =A0 =A0 } else
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 dip->csums =3D NULL;

=A0 =A0 =A0 =A0dip->private =3D bio->bi_private;
=A0 =A0 =A0 =A0dip->inode =3D inode;


I didn't see Josef and my patches at
http://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-unstable.git
yet.

They still appear relevant; let me know if you'd like it rediffed
against your tree.

Thanks,
  Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
