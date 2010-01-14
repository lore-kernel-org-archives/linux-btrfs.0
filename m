From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Bug in btrfs_rename (kernel BUG at fs/btrfs/inode.c:5595!)
Date: Fri, 15 Jan 2010 04:20:19 +0800
Message-ID: <3d0408631001141220m5941ad58t91d01fb918daf8ab@mail.gmail.com>
References: <4B4E1A5D.1070203@gmail.com>
	 <20100113201317.GC2774@dhcp231-156.rdu.redhat.com>
	 <4B4E290F.9010100@gmail.com>
	 <20100114170323.GA2190@localhost.localdomain>
	 <20100114190004.GB2190@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tomas Carnecky <tomas.carnecky@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100114190004.GB2190@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 15, 2010 at 3:00 AM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Jan 14, 2010 at 12:03:23PM -0500, Josef Bacik wrote:
>> On Wed, Jan 13, 2010 at 09:11:59PM +0100, Tomas Carnecky wrote:
>> > =A0On 1/13/10 9:13 PM, Josef Bacik wrote:
>> >> On Wed, Jan 13, 2010 at 08:09:17PM +0100, Tomas Carnecky wrote:
>> >>> =A0 I was running v2.6.33-rc2-187-g08d869a and everything was ok=
=2E Today I
>> >>> decided to update the kernel (to v2.6.33-rc4) and a minute or tw=
o after
>> >>> logging into the gnome desktop this kernel bug appeared in dmesg=
=2E I then
>> >>> went back to the old kernel but the bug didn't disappear, not ev=
en after
>> >>> running btrfsck on the filesystem.
>> >>>
>> >> Ok will you please run with this patch? =A0It shouldn't panic you=
r box, since it
>> >> seems ret is -EEXIST. =A0Just watch your logs for
>> >>
>> >> OH NO, ORPHAN ENTRY ALREADY EXISTS FOR<number>
>> >>
>> >> and then look up and find all occurances of
>> >>
>> >> Btrfs: orphan add<number>
>> >>
>> >> with the stack trace and send it back to me so I can verify that =
nothing heinous
>> >> is happening. =A0I assume we're just racing with unlink/rename so=
 all that needs
>> >> to be done is to take that BUG_ON out, but it would be nice to kn=
ow for sure.
>> >
>>
>> Ok will you try this patch? =A0I've not built it, so sorry if it doe=
sn't compile
>> :). =A0Look for the "OH NO" messages again. =A0If they show up then =
the problem is
>> still there, if they go away the problem is fixed. =A0I tried to rep=
roduce this
>> locally but I can't seem to do it, so you are my only hope :).
>>
>> By the way, this replaces the last patch I sent you, so unapply the =
previous
>> patch and apply this one instead. =A0Thanks,
>>
>
> Ok here's the final version of the patch I'm going to post. =A0This r=
eplaces the
> other patches that I sent you, so un-apply the last one you applied a=
nd apply
> this one instead. =A0Run this for a day and let me know if you have a=
ny problems.
> If no problems I'll go ahead and post it. =A0Thanks,
>
> Josef
>
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 5440bab..24cbf6b 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3305,24 +3305,7 @@ static int btrfs_setattr_size(struct inode *in=
ode, struct iattr *attr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0send_sig(SIGXFSZ, curr=
ent, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EFBIG;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 ret =3D btrfs_reserve_metadata_space(root, 1);
> - =A0 =A0 =A0 if (ret)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> -
> - =A0 =A0 =A0 trans =3D btrfs_start_transaction(root, 1);
> - =A0 =A0 =A0 btrfs_set_trans_block_group(trans, inode);
> -
> - =A0 =A0 =A0 ret =3D btrfs_orphan_add(trans, inode);
> - =A0 =A0 =A0 BUG_ON(ret);
> -
> - =A0 =A0 =A0 nr =3D trans->blocks_used;
> - =A0 =A0 =A0 btrfs_end_transaction(trans, root);
> - =A0 =A0 =A0 btrfs_unreserve_metadata_space(root, 1);
> - =A0 =A0 =A0 btrfs_btree_balance_dirty(root, nr);
>
> - =A0 =A0 =A0 if (attr->ia_size > inode->i_size) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_cont_expand(inode, attr-=
>ia_size);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_truncate(inode);
> @@ -3337,14 +3320,26 @@ static int btrfs_setattr_size(struct inode *i=
node, struct iattr *attr)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D btrfs_update_inode(trans, root=
, inode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(ret);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (inode->i_nlink > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_orphan_de=
l(trans, inode);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(ret);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr =3D trans->blocks_used;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_end_transaction(trans, root);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_btree_balance_dirty(root, nr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> + =A0 =A0 =A0 } else if (attr->ia_size < i_size_read(inode)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_reserve_metadata_space(ro=
ot, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 trans =3D btrfs_start_transaction(root,=
 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_set_trans_block_group(trans, inod=
e);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D btrfs_orphan_add(trans, inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(ret);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nr =3D trans->blocks_used;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_end_transaction(trans, root);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_unreserve_metadata_space(root, 1)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_btree_balance_dirty(root, nr);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/*
> @@ -3355,10 +3350,6 @@ static int btrfs_setattr_size(struct inode *in=
ode, struct iattr *attr)
> =A0 =A0 =A0 =A0if (attr->ia_size =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BTRFS_I(inode)->ordered_data_close =3D=
 1;
>
> - =A0 =A0 =A0 /* we don't support swapfiles, so vmtruncate shouldn't =
fail */
> - =A0 =A0 =A0 ret =3D vmtruncate(inode, attr->ia_size);
> - =A0 =A0 =A0 BUG_ON(ret);
> -
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -3376,7 +3367,6 @@ static int btrfs_setattr(struct dentry *dentry,=
 struct iattr *attr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 attr->ia_valid &=3D ~ATTR_SIZE;
>
> =A0 =A0 =A0 =A0if (attr->ia_valid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D inode_setattr(inode, attr);
> --

It looks like a ENOSPC related problem, btrfs_truncate doesn't remove t=
he orphan
item if it fails to finish its operation. so I don't think this patch
fixes the problem

Regards
Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
