From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH v2] btrfs: fix oops on failure path
Date: Mon, 27 Jun 2011 17:27:46 -0500
Message-ID: <BANLkTimsLicbrvVf=YaBodR7J46V2VEDgg@mail.gmail.com>
References: <BANLkTimrzmLdgg6NN_vU-Q6Euh1sE8SNNg@mail.gmail.com>
	<20110623103109.GN12709@twin.jikos.cz>
	<BANLkTindeWYaCu3ppdHK9sgOMRcFoAU+sw@mail.gmail.com>
	<20110623163640.GO12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Daniel J Blueman <daniel.blueman@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110623163640.GO12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2011 at 11:36 AM, David Sterba <dave@jikos.cz> wrote:
> On Thu, Jun 23, 2011 at 11:01:01PM +0800, Daniel J Blueman wrote:
>> On 23 June 2011 18:31, David Sterba <dave@jikos.cz> wrote:
>> (how does one follow up an email in git send-email with the message =
id?)
>
> git-send-email --in-reply-to=3D<identifier>
>
> (if it does not ask for it) and paste identifier from mail header
> In-Reply-To:
>
>> If lookup_extent_backref fails, path->nodes[0] reasonably could be
>> null along with other callers of btrfs_print_leaf, so ensure we have=
 a
>> valid extent buffer before dereferencing.
>
> ack.
>
>
> thanks,
> david
>
>>
>> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>>
>> diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
>> index fb2605d..f38e452 100644
>> --- a/fs/btrfs/print-tree.c
>> +++ b/fs/btrfs/print-tree.c
>> @@ -158,8 +158,7 @@ static void print_extent_ref_v0(struct
>> extent_buffer *eb, int slot)
>> =A0void btrfs_print_leaf(struct btrfs_root *root, struct extent_buff=
er *l)
>> =A0{
>> =A0 =A0 =A0 int i;
>> - =A0 =A0 u32 type;
>> - =A0 =A0 u32 nr =3D btrfs_header_nritems(l);
>> + =A0 =A0 u32 type, nr;
>> =A0 =A0 =A0 struct btrfs_item *item;
>> =A0 =A0 =A0 struct btrfs_root_item *ri;
>> =A0 =A0 =A0 struct btrfs_dir_item *di;
>> @@ -172,6 +171,11 @@ void btrfs_print_leaf(struct btrfs_root *root,
>> struct extent_buffer *l)
>> =A0 =A0 =A0 struct btrfs_key key;
>> =A0 =A0 =A0 struct btrfs_key found_key;
>>
>> + =A0 =A0 if (!l)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return;
>> +
>> + =A0 =A0 nr =3D btrfs_header_nritems(l);
>> +
>> =A0 =A0 =A0 printk(KERN_INFO "leaf %llu total ptrs %d free space %d\=
n",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long)btrfs_header_bytenr(=
l), nr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_leaf_free_space(root, l));
>> --
>> Daniel J Blueman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I've also run into a corruption with spots where path->nodes[0] has a
value of NULL.

But, I'm getting the error showing up elsewhere when I try to mount
the partition:

[ 6168.790849] device fsid 7c35237f-d72a-4d65-bd01-b853d853c17a devid
1 transid 507394 /dev/sdb6
[ 6168.832825] attempt to access beyond end of device
[ 6168.832831] sdb6: rw=3D0, want=3D20033720, limit=3D20016927
[ 6168.832843] Failed to read block groups: -5
[ 6168.833663] btrfs: open_ctree failed

In my case, I need to handle the corruption earlier in order to
properly handle the error.

Btrfs-progs also has troubles handling this corruption (debugging
btrfsck was how I discovered I was running into path->nodes[0] =3D=3D
NULL).

=46or reference, I'm using a 2.6.39.1 kernel with Chris' latest
'for-linus' branch merged in.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
