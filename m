Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55736 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751712AbeBAJU7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 04:20:59 -0500
Subject: Re: [PATCH v2 3/3] btrfs-progs: check: Cleanup all checkpatch error
 and warning
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20180201064541.14603-1-wqu@suse.com>
 <20180201064541.14603-4-wqu@suse.com>
 <f3b822be-78c7-a603-417a-24007304aa03@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a6b96b66-a72f-5c7e-3854-f7ad3fd764c8@gmx.com>
Date: Thu, 1 Feb 2018 17:20:44 +0800
MIME-Version: 1.0
In-Reply-To: <f3b822be-78c7-a603-417a-24007304aa03@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dwQU3NmixW71aNSivygr1nOGPT3d6vEAa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dwQU3NmixW71aNSivygr1nOGPT3d6vEAa
Content-Type: multipart/mixed; boundary="lr7TG7yLcMoQgtkrX7lHIS1BFW8iN9K0Q";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org, dsterba@suse.cz
Message-ID: <a6b96b66-a72f-5c7e-3854-f7ad3fd764c8@gmx.com>
Subject: Re: [PATCH v2 3/3] btrfs-progs: check: Cleanup all checkpatch error
 and warning
References: <20180201064541.14603-1-wqu@suse.com>
 <20180201064541.14603-4-wqu@suse.com>
 <f3b822be-78c7-a603-417a-24007304aa03@suse.com>
In-Reply-To: <f3b822be-78c7-a603-417a-24007304aa03@suse.com>

--lr7TG7yLcMoQgtkrX7lHIS1BFW8iN9K0Q
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8801=E6=97=A5 16:36, Nikolay Borisov wrote:
>=20
>=20
> On  1.02.2018 08:45, Qu Wenruo wrote:
>> Since we're moving tons of codes, it's a good idea to fix all errors a=
nd
>> warnings from checkpatch.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Having this patch separate for review is fine, but in the end I think i=
t
> will be best if it's squashed in the commit that moves stuff around so
> we don't introduce needless noise.

Yes, that's the normal case.

However what makes it special here is the first patch, which are moving
tons of codes around (+4000 -4000).

Squashing them into 1st is completely fine, but I'm pretty paranoid here
and will try my best to avoid any unnecessary modification to avoid
regression.

So the fixup is in this separate patch.
(Not to mention a lot of them are from the old original mode, nothing to
do with lowmem separation)

Thanks,
Qu
>=20
>> ---
>>  check/lowmem.c |  65 +++++++++------
>>  check/main.c   | 253 +++++++++++++++++++++++++++++-------------------=
---------
>>  2 files changed, 165 insertions(+), 153 deletions(-)
>>
>> diff --git a/check/lowmem.c b/check/lowmem.c
>> index a3bda97fdea8..3e7fe148bc56 100644
>> --- a/check/lowmem.c
>> +++ b/check/lowmem.c
>> @@ -322,7 +322,8 @@ static int repair_tree_block_ref(struct btrfs_tran=
s_handle *trans,
>>  			goto out;
>> =20
>>  		eb =3D path.nodes[0];
>> -		ei =3D btrfs_item_ptr(eb, path.slots[0], struct btrfs_extent_item);=

>> +		ei =3D btrfs_item_ptr(eb, path.slots[0],
>> +				    struct btrfs_extent_item);
>> =20
>>  		btrfs_set_extent_refs(eb, ei, 0);
>>  		btrfs_set_extent_generation(eb, ei, generation);
>> @@ -730,7 +731,9 @@ begin:
>>  		need_research =3D 0;
>>  		btrfs_release_path(path);
>>  		ret =3D btrfs_search_slot(NULL, root, ref_key, path, 0, 0);
>> -		/* the item was deleted, let path point to the last checked item */=

>> +		/*
>> +		 * the item was deleted, let path point to the last checked item
>> +		 */
>>  		if (ret > 0) {
>>  			if (path->slots[0] =3D=3D 0)
>>  				btrfs_prev_leaf(root, path);
>> @@ -1486,7 +1489,8 @@ static int check_file_extent(struct btrfs_root *=
root, struct btrfs_key *fkey,
>>  		search_start =3D disk_bytenr;
>>  		search_len =3D disk_num_bytes;
>>  	}
>> -	ret =3D count_csum_range(root->fs_info, search_start, search_len, &c=
sum_found);
>> +	ret =3D count_csum_range(root->fs_info, search_start, search_len,
>> +			       &csum_found);
>>  	if (csum_found > 0 && nodatasum) {
>>  		err |=3D ODD_CSUM_ITEM;
>>  		error("root %llu EXTENT_DATA[%llu %llu] nodatasum shouldn't have da=
tasum",
>> @@ -1497,7 +1501,8 @@ static int check_file_extent(struct btrfs_root *=
root, struct btrfs_key *fkey,
>>  		error("root %llu EXTENT_DATA[%llu %llu] csum missing, have: %llu, e=
xpected: %llu",
>>  		      root->objectid, fkey->objectid, fkey->offset,
>>  		      csum_found, search_len);
>> -	} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC && csum_fou=
nd > 0) {
>> +	} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &&
>> +		   csum_found > 0) {
>>  		err |=3D ODD_CSUM_ITEM;
>>  		error("root %llu EXTENT_DATA[%llu %llu] prealloc shouldn't have csu=
m, but has: %llu",
>>  		      root->objectid, fkey->objectid, fkey->offset, csum_found);
>> @@ -1561,7 +1566,8 @@ loop:
>>  	}
>> =20
>>  special_case:
>> -	di =3D btrfs_item_ptr(path.nodes[0], path.slots[0], struct btrfs_dir=
_item);
>> +	di =3D btrfs_item_ptr(path.nodes[0], path.slots[0],
>> +			    struct btrfs_dir_item);
>>  	cur =3D 0;
>>  	total =3D btrfs_item_size_nr(path.nodes[0], path.slots[0]);
>> =20
>> @@ -1913,7 +1919,8 @@ static int check_inode_item(struct btrfs_root *r=
oot, struct btrfs_path *path,
>>  	nodatasum =3D btrfs_inode_flags(node, ii) & BTRFS_INODE_NODATASUM;
>> =20
>>  	while (1) {
>> -		btrfs_item_key_to_cpu(path->nodes[0], &last_key, path->slots[0]);
>> +		btrfs_item_key_to_cpu(path->nodes[0], &last_key,
>> +				      path->slots[0]);
>>  		ret =3D btrfs_next_item(root, path);
>>  		if (ret < 0) {
>>  			/* out will fill 'err' rusing current statistics */
>> @@ -2360,7 +2367,7 @@ static int check_tree_block_ref(struct btrfs_roo=
t *root,
>>  				 * Check if the backref points to valid
>>  				 * referencer
>>  				 */
>> -				found_ref =3D !check_tree_block_ref( root, NULL,
>> +				found_ref =3D !check_tree_block_ref(root, NULL,
>>  						offset, level + 1, owner,
>>  						NULL);
>>  			}
>> @@ -2500,7 +2507,8 @@ static int repair_extent_data_item(struct btrfs_=
trans_handle *trans,
>>  		if (ret)
>>  			goto out;
>>  		eb =3D path.nodes[0];
>> -		ei =3D btrfs_item_ptr(eb, path.slots[0], struct btrfs_extent_item);=

>> +		ei =3D btrfs_item_ptr(eb, path.slots[0],
>> +				    struct btrfs_extent_item);
>> =20
>>  		btrfs_set_extent_refs(eb, ei, 0);
>>  		btrfs_set_extent_generation(eb, ei, generation);
>> @@ -2657,7 +2665,8 @@ static int check_extent_data_item(struct btrfs_r=
oot *root,
>>  		}
>>  		if (type =3D=3D BTRFS_EXTENT_DATA_REF_KEY) {
>>  			ref_root =3D btrfs_extent_data_ref_root(leaf, dref);
>> -			ref_objectid =3D btrfs_extent_data_ref_objectid(leaf, dref);
>> +			ref_objectid =3D btrfs_extent_data_ref_objectid(leaf,
>> +								      dref);
>>  			ref_offset =3D btrfs_extent_data_ref_offset(leaf, dref);
>> =20
>>  			if (ref_objectid =3D=3D fi_key.objectid &&
>> @@ -2820,8 +2829,8 @@ static int check_block_group_item(struct btrfs_f=
s_info *fs_info,
>>  			if (!(bg_flags & BTRFS_BLOCK_GROUP_DATA)) {
>>  				error(
>>  			"bad extent[%llu, %llu) type mismatch with chunk",
>> -					extent_key.objectid,
>> -					extent_key.objectid + extent_key.offset);
>> +				      extent_key.objectid,
>> +				      extent_key.objectid + extent_key.offset);
>>  				err |=3D CHUNK_TYPE_MISMATCH;
>>  			}
>>  		} else if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
>> @@ -3175,7 +3184,8 @@ static int check_extent_data_backref(struct btrf=
s_fs_info *fs_info,
>>  		    btrfs_header_owner(leaf) !=3D root_id)
>>  			goto next;
>>  		btrfs_item_key_to_cpu(leaf, &key, slot);
>> -		if (key.objectid !=3D objectid || key.type !=3D BTRFS_EXTENT_DATA_K=
EY)
>> +		if (key.objectid !=3D objectid || key.type !=3D
>> +		    BTRFS_EXTENT_DATA_KEY)
>>  			break;
>>  		fi =3D btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
>>  		/*
>> @@ -3205,7 +3215,8 @@ out:
>>  	if (found_count !=3D count) {
>>  		error(
>>  "extent[%llu, %llu] referencer count mismatch (root: %llu, owner: %ll=
u, offset: %llu) wanted: %u, have: %u",
>> -			bytenr, len, root_id, objectid, offset, count, found_count);
>> +			bytenr, len, root_id, objectid, offset, count,
>> +			found_count);
>>  		return REFERENCER_MISSING;
>>  	}
>>  	return 0;
>> @@ -3975,13 +3986,12 @@ static int walk_down_tree(struct btrfs_trans_h=
andle *trans,
>>  					       nrefs, account_file_data);
>>  			err |=3D ret;
>>  			break;
>> -		} else {
>> -			if (check || !check_all) {
>> -				ret =3D btrfs_check_node(root, NULL, cur);
>> -				if (ret !=3D BTRFS_TREE_BLOCK_CLEAN) {
>> -					err |=3D -EIO;
>> -					break;
>> -				}
>> +		}
>> +		if (check || !check_all) {
>> +			ret =3D btrfs_check_node(root, NULL, cur);
>> +			if (ret !=3D BTRFS_TREE_BLOCK_CLEAN) {
>> +				err |=3D -EIO;
>> +				break;
>>  			}
>>  		}
>> =20
>> @@ -4001,7 +4011,8 @@ static int walk_down_tree(struct btrfs_trans_han=
dle *trans,
>>  			continue;
>>  		}
>> =20
>> -		next =3D btrfs_find_tree_block(fs_info, bytenr, fs_info->nodesize);=

>> +		next =3D btrfs_find_tree_block(fs_info, bytenr,
>> +					     fs_info->nodesize);
>>  		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
>>  			free_extent_buffer(next);
>>  			reada_walk_down(root, cur, path->slots[*level]);
>> @@ -4022,7 +4033,7 @@ static int walk_down_tree(struct btrfs_trans_han=
dle *trans,
>> =20
>>  		ret =3D check_child_node(cur, path->slots[*level], next);
>>  		err |=3D ret;
>> -		if (ret < 0)=20
>> +		if (ret < 0)
>>  			break;
>> =20
>>  		if (btrfs_is_leaf(next))
>> @@ -4041,7 +4052,8 @@ static int walk_down_tree(struct btrfs_trans_han=
dle *trans,
>>  		path->slots[*level] =3D 0;
>>  		account_file_data =3D 0;
>> =20
>> -		update_nodes_refs(root, (u64)-1, next, nrefs, *level, check_all);
>> +		update_nodes_refs(root, (u64)-1, next, nrefs, *level,
>> +				  check_all);
>>  	}
>>  	return err;
>>  }
>> @@ -4058,11 +4070,10 @@ static int walk_up_tree(struct btrfs_root *roo=
t, struct btrfs_path *path,
>>  			path->slots[i]++;
>>  			*level =3D i;
>>  			return 0;
>> -		} else {
>> -			free_extent_buffer(path->nodes[*level]);
>> -			path->nodes[*level] =3D NULL;
>> -			*level =3D i + 1;
>>  		}
>> +		free_extent_buffer(path->nodes[*level]);
>> +		path->nodes[*level] =3D NULL;
>> +		*level =3D i + 1;
>>  	}
>>  	return 1;
>>  }
>> diff --git a/check/main.c b/check/main.c
>> index aec3881fc043..f6874cd86543 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -1720,14 +1720,13 @@ static int walk_up_tree(struct btrfs_root *roo=
t, struct btrfs_path *path,
>>  			path->slots[i]++;
>>  			*level =3D i;
>>  			return 0;
>> -		} else {
>> -			free_extent_buffer(path->nodes[*level]);
>> -			path->nodes[*level] =3D NULL;
>> -			BUG_ON(*level > wc->active_node);
>> -			if (*level =3D=3D wc->active_node)
>> -				leave_shared_node(root, wc, *level);
>> -			*level =3D i + 1;
>>  		}
>> +		free_extent_buffer(path->nodes[*level]);
>> +		path->nodes[*level] =3D NULL;
>> +		BUG_ON(*level > wc->active_node);
>> +		if (*level =3D=3D wc->active_node)
>> +			leave_shared_node(root, wc, *level);
>> +		*level =3D i + 1;
>>  	}
>>  	return 1;
>>  }
>> @@ -3488,22 +3487,21 @@ static int all_backpointers_checked(struct ext=
ent_record *rec, int print_errs)
>>  				goto out;
>>  			if (back->is_data) {
>>  				dback =3D to_data_backref(back);
>> -				fprintf(stderr, "Data backref %llu %s %llu"
>> -					" owner %llu offset %llu num_refs %lu"
>> -					" not found in extent tree\n",
>> +				fprintf(stderr,
>> +"Data backref %llu %s %llu owner %llu offset %llu num_refs %lu not fo=
und in extent tree\n",
>>  					(unsigned long long)rec->start,
>>  					back->full_backref ?
>>  					"parent" : "root",
>>  					back->full_backref ?
>> -					(unsigned long long)dback->parent:
>> +					(unsigned long long)dback->parent :
>>  					(unsigned long long)dback->root,
>>  					(unsigned long long)dback->owner,
>>  					(unsigned long long)dback->offset,
>>  					(unsigned long)dback->num_refs);
>>  			} else {
>>  				tback =3D to_tree_backref(back);
>> -				fprintf(stderr, "Tree backref %llu parent %llu"
>> -					" root %llu not found in extent tree\n",
>> +				fprintf(stderr,
>> +"Tree backref %llu parent %llu root %llu not found in extent tree\n",=

>>  					(unsigned long long)rec->start,
>>  					(unsigned long long)tback->parent,
>>  					(unsigned long long)tback->root);
>> @@ -3514,7 +3512,8 @@ static int all_backpointers_checked(struct exten=
t_record *rec, int print_errs)
>>  			if (!print_errs)
>>  				goto out;
>>  			tback =3D to_tree_backref(back);
>> -			fprintf(stderr, "Backref %llu %s %llu not referenced back %p\n",
>> +			fprintf(stderr,
>> +				"Backref %llu %s %llu not referenced back %p\n",
>>  				(unsigned long long)rec->start,
>>  				back->full_backref ? "parent" : "root",
>>  				back->full_backref ?
>> @@ -3527,26 +3526,25 @@ static int all_backpointers_checked(struct ext=
ent_record *rec, int print_errs)
>>  				err =3D 1;
>>  				if (!print_errs)
>>  					goto out;
>> -				fprintf(stderr, "Incorrect local backref count"
>> -					" on %llu %s %llu owner %llu"
>> -					" offset %llu found %u wanted %u back %p\n",
>> +				fprintf(stderr,
>> +"Incorrect local backref count on %llu %s %llu owner %llu offset %llu=
 found %u wanted %u back %p\n",
>>  					(unsigned long long)rec->start,
>>  					back->full_backref ?
>>  					"parent" : "root",
>>  					back->full_backref ?
>> -					(unsigned long long)dback->parent:
>> +					(unsigned long long)dback->parent :
>>  					(unsigned long long)dback->root,
>>  					(unsigned long long)dback->owner,
>>  					(unsigned long long)dback->offset,
>> -					dback->found_ref, dback->num_refs, back);
>> +					dback->found_ref, dback->num_refs,
>> +					back);
>>  			}
>>  			if (dback->disk_bytenr !=3D rec->start) {
>>  				err =3D 1;
>>  				if (!print_errs)
>>  					goto out;
>> -				fprintf(stderr, "Backref disk bytenr does not"
>> -					" match extent record, bytenr=3D%llu, "
>> -					"ref bytenr=3D%llu\n",
>> +				fprintf(stderr,
>> +"Backref disk bytenr does not match extent record, bytenr=3D%llu, ref=
 bytenr=3D%llu\n",
>>  					(unsigned long long)rec->start,
>>  					(unsigned long long)dback->disk_bytenr);
>>  			}
>> @@ -3555,9 +3553,8 @@ static int all_backpointers_checked(struct exten=
t_record *rec, int print_errs)
>>  				err =3D 1;
>>  				if (!print_errs)
>>  					goto out;
>> -				fprintf(stderr, "Backref bytes do not match "
>> -					"extent backref, bytenr=3D%llu, ref "
>> -					"bytes=3D%llu, backref bytes=3D%llu\n",
>> +				fprintf(stderr,
>> +"Backref bytes do not match extent backref, bytenr=3D%llu, ref bytes=3D=
%llu, backref bytes=3D%llu\n",
>>  					(unsigned long long)rec->start,
>>  					(unsigned long long)rec->nr,
>>  					(unsigned long long)dback->bytes);
>> @@ -3574,8 +3571,8 @@ static int all_backpointers_checked(struct exten=
t_record *rec, int print_errs)
>>  		err =3D 1;
>>  		if (!print_errs)
>>  			goto out;
>> -		fprintf(stderr, "Incorrect global backref count "
>> -			"on %llu found %llu wanted %llu\n",
>> +		fprintf(stderr,
>> +"Incorrect global backref count on %llu found %llu wanted %llu\n",
>>  			(unsigned long long)rec->start,
>>  			(unsigned long long)found,
>>  			(unsigned long long)rec->refs);
>> @@ -3745,6 +3742,7 @@ static int swap_values(struct btrfs_root *root, =
struct btrfs_path *path,
>>  				    sizeof(struct btrfs_key_ptr));
>>  		if (slot =3D=3D 0) {
>>  			struct btrfs_disk_key key;
>> +
>>  			btrfs_node_key(buf, &key, 0);
>>  			btrfs_fixup_low_keys(root, path, &key,
>>  					     btrfs_header_level(buf) + 1);
>> @@ -3877,8 +3875,8 @@ again:
>>  				ret =3D delete_bogus_item(root, path, buf, i);
>>  				if (!ret)
>>  					goto again;
>> -				fprintf(stderr, "item is off the end of the "
>> -					"leaf, can't fix\n");
>> +				fprintf(stderr,
>> +				"item is off the end of the leaf, can't fix\n");
>>  				ret =3D -EIO;
>>  				break;
>>  			}
>> @@ -4066,7 +4064,7 @@ static struct tree_backref *find_tree_backref(st=
ruct extent_record *rec,
>>  	struct extent_backref *node;
>>  	struct tree_backref *back;
>> =20
>> -	while(cur !=3D &rec->backrefs) {
>> +	while (cur !=3D &rec->backrefs) {
>>  		node =3D to_extent_backref(cur);
>>  		cur =3D cur->next;
>>  		if (node->is_data)
>> @@ -4118,7 +4116,7 @@ static struct data_backref *find_data_backref(st=
ruct extent_record *rec,
>>  	struct extent_backref *node;
>>  	struct data_backref *back;
>> =20
>> -	while(cur !=3D &rec->backrefs) {
>> +	while (cur !=3D &rec->backrefs) {
>>  		node =3D to_extent_backref(cur);
>>  		cur =3D cur->next;
>>  		if (!node->is_data)
>> @@ -4344,12 +4342,13 @@ static int add_extent_rec(struct cache_tree *e=
xtent_cache,
>> =20
>>  		if (tmpl->extent_item_refs && !dup) {
>>  			if (rec->extent_item_refs) {
>> -				fprintf(stderr, "block %llu rec "
>> -					"extent_item_refs %llu, passed %llu\n",
>> +				fprintf(stderr,
>> +			"block %llu rec extent_item_refs %llu, passed %llu\n",
>>  					(unsigned long long)tmpl->start,
>>  					(unsigned long long)
>>  							rec->extent_item_refs,
>> -					(unsigned long long)tmpl->extent_item_refs);
>> +					(unsigned long long)
>> +							tmpl->extent_item_refs);
>>  			}
>>  			rec->extent_item_refs =3D tmpl->extent_item_refs;
>>  		}
>> @@ -4433,8 +4432,8 @@ static int add_tree_backref(struct cache_tree *e=
xtent_cache, u64 bytenr,
>> =20
>>  	if (found_ref) {
>>  		if (back->node.found_ref) {
>> -			fprintf(stderr, "Extent back ref already exists "
>> -				"for %llu parent %llu root %llu \n",
>> +			fprintf(stderr,
>> +	"Extent back ref already exists for %llu parent %llu root %llu\n",
>>  				(unsigned long long)bytenr,
>>  				(unsigned long long)parent,
>>  				(unsigned long long)root);
>> @@ -4442,8 +4441,8 @@ static int add_tree_backref(struct cache_tree *e=
xtent_cache, u64 bytenr,
>>  		back->node.found_ref =3D 1;
>>  	} else {
>>  		if (back->node.found_extent_tree) {
>> -			fprintf(stderr, "Extent back ref already exists "
>> -				"for %llu parent %llu root %llu \n",
>> +			fprintf(stderr,
>> +	"Extent back ref already exists for %llu parent %llu root %llu\n",
>>  				(unsigned long long)bytenr,
>>  				(unsigned long long)parent,
>>  				(unsigned long long)root);
>> @@ -4530,9 +4529,8 @@ static int add_data_backref(struct cache_tree *e=
xtent_cache, u64 bytenr,
>>  		rec->owner_ref_checked =3D 1;
>>  	} else {
>>  		if (back->node.found_extent_tree) {
>> -			fprintf(stderr, "Extent back ref already exists "
>> -				"for %llu parent %llu root %llu "
>> -				"owner %llu offset %llu num_refs %lu\n",
>> +			fprintf(stderr,
>> +"Extent back ref already exists for %llu parent %llu root %llu owner =
%llu offset %llu num_refs %lu\n",
>>  				(unsigned long long)bytenr,
>>  				(unsigned long long)parent,
>>  				(unsigned long long)root,
>> @@ -4555,6 +4553,7 @@ static int add_pending(struct cache_tree *pendin=
g,
>>  		       struct cache_tree *seen, u64 bytenr, u32 size)
>>  {
>>  	int ret;
>> +
>>  	ret =3D add_cache_extent(seen, bytenr, size);
>>  	if (ret)
>>  		return ret;
>> @@ -4588,17 +4587,17 @@ static int pick_next_pending(struct cache_tree=
 *pending,
>>  		cache =3D search_cache_extent(nodes, 0);
>> =20
>>  	if (!cache) {
>> -		 cache =3D search_cache_extent(pending, 0);
>> -		 if (!cache)
>> -			 return 0;
>> -		 ret =3D 0;
>> -		 do {
>> -			 bits[ret].start =3D cache->start;
>> -			 bits[ret].size =3D cache->size;
>> -			 cache =3D next_cache_extent(cache);
>> -			 ret++;
>> -		 } while (cache && ret < bits_nr);
>> -		 return ret;
>> +		cache =3D search_cache_extent(pending, 0);
>> +		if (!cache)
>> +			return 0;
>> +		ret =3D 0;
>> +		do {
>> +			bits[ret].start =3D cache->start;
>> +			bits[ret].size =3D cache->size;
>> +			cache =3D next_cache_extent(cache);
>> +			ret++;
>> +		} while (cache && ret < bits_nr);
>> +		return ret;
>>  	}
>> =20
>>  	ret =3D 0;
>> @@ -4612,8 +4611,9 @@ static int pick_next_pending(struct cache_tree *=
pending,
>>  	if (bits_nr - ret > 8) {
>>  		u64 lookup =3D bits[0].start + bits[0].size;
>>  		struct cache_extent *next;
>> +
>>  		next =3D search_cache_extent(pending, lookup);
>> -		while(next) {
>> +		while (next) {
>>  			if (next->start - lookup > 32768)
>>  				break;
>>  			bits[ret].start =3D next->start;
>> @@ -5004,6 +5004,7 @@ static int process_extent_item(struct btrfs_root=
 *root,
>>  	if (item_size < sizeof(*ei)) {
>>  #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
>>  		struct btrfs_extent_item_v0 *ei0;
>> +
>>  		if (item_size !=3D sizeof(*ei0)) {
>>  			error(
>>  	"invalid extent item format: ITEM[%llu %u %llu] leaf: %llu slot: %d"=
,
>> @@ -5356,8 +5357,8 @@ static int check_space_cache(struct btrfs_root *=
root)
>> =20
>>  static int check_extent_csums(struct btrfs_root *root, u64 bytenr,
>>  			u64 num_bytes, unsigned long leaf_offset,
>> -			struct extent_buffer *eb) {
>> -
>> +			struct extent_buffer *eb)
>> +{
>>  	struct btrfs_fs_info *fs_info =3D root->fs_info;
>>  	u64 offset =3D 0;
>>  	u16 csum_size =3D btrfs_super_csum_size(fs_info->super_copy);
>> @@ -5646,7 +5647,8 @@ skip_csum_check:
>>  }
>> =20
>>  static int is_dropped_key(struct btrfs_key *key,
>> -			  struct btrfs_key *drop_key) {
>> +			  struct btrfs_key *drop_key)
>> +{
>>  	if (key->objectid < drop_key->objectid)
>>  		return 1;
>>  	else if (key->objectid =3D=3D drop_key->objectid) {
>> @@ -5823,7 +5825,7 @@ static int run_next_block(struct btrfs_root *roo=
t,
>>  		return 1;
>> =20
>>  	if (!reada_bits) {
>> -		for(i =3D 0; i < nritems; i++) {
>> +		for (i =3D 0; i < nritems; i++) {
>>  			ret =3D add_cache_extent(reada, bits[i].start,
>>  					       bits[i].size);
>>  			if (ret =3D=3D -EEXIST)
>> @@ -5933,6 +5935,7 @@ static int run_next_block(struct btrfs_root *roo=
t,
>>  		btree_space_waste +=3D btrfs_leaf_free_space(root, buf);
>>  		for (i =3D 0; i < nritems; i++) {
>>  			struct btrfs_file_extent_item *fi;
>> +
>>  			btrfs_item_key_to_cpu(buf, &key, i);
>>  			/*
>>  			 * Check key type against the leaf owner.
>> @@ -6007,6 +6010,7 @@ static int run_next_block(struct btrfs_root *roo=
t,
>>  			}
>>  			if (key.type =3D=3D BTRFS_EXTENT_DATA_REF_KEY) {
>>  				struct btrfs_extent_data_ref *ref;
>> +
>>  				ref =3D btrfs_item_ptr(buf, i,
>>  						struct btrfs_extent_data_ref);
>>  				add_data_backref(extent_cache,
>> @@ -6021,6 +6025,7 @@ static int run_next_block(struct btrfs_root *roo=
t,
>>  			}
>>  			if (key.type =3D=3D BTRFS_SHARED_DATA_REF_KEY) {
>>  				struct btrfs_shared_data_ref *ref;
>> +
>>  				ref =3D btrfs_item_ptr(buf, i,
>>  						struct btrfs_shared_data_ref);
>>  				add_data_backref(extent_cache,
>> @@ -6058,9 +6063,9 @@ static int run_next_block(struct btrfs_root *roo=
t,
>> =20
>>  			data_bytes_allocated +=3D
>>  				btrfs_file_extent_disk_num_bytes(buf, fi);
>> -			if (data_bytes_allocated < root->fs_info->sectorsize) {
>> +			if (data_bytes_allocated < root->fs_info->sectorsize)
>>  				abort();
>> -			}
>> +
>>  			data_bytes_referenced +=3D
>>  				btrfs_file_extent_num_bytes(buf, fi);
>>  			add_data_backref(extent_cache,
>> @@ -6093,7 +6098,8 @@ static int run_next_block(struct btrfs_root *roo=
t,
>> =20
>>  			memset(&tmpl, 0, sizeof(tmpl));
>>  			btrfs_cpu_key_to_disk(&tmpl.parent_key, &key);
>> -			tmpl.parent_generation =3D btrfs_node_ptr_generation(buf, i);
>> +			tmpl.parent_generation =3D
>> +				btrfs_node_ptr_generation(buf, i);
>>  			tmpl.start =3D ptr;
>>  			tmpl.nr =3D size;
>>  			tmpl.refs =3D 1;
>> @@ -6112,11 +6118,10 @@ static int run_next_block(struct btrfs_root *r=
oot,
>>  				continue;
>>  			}
>> =20
>> -			if (level > 1) {
>> +			if (level > 1)
>>  				add_pending(nodes, seen, ptr, size);
>> -			} else {
>> +			else
>>  				add_pending(pending, seen, ptr, size);
>> -			}
>>  		}
>>  		btree_space_waste +=3D (BTRFS_NODEPTRS_PER_BLOCK(fs_info) -
>>  				      nritems) * sizeof(struct btrfs_key_ptr);
>> @@ -6188,6 +6193,7 @@ static int free_extent_hook(struct btrfs_trans_h=
andle *trans,
>>  	rec =3D container_of(cache, struct extent_record, cache);
>>  	if (is_data) {
>>  		struct data_backref *back;
>> +
>>  		back =3D find_data_backref(rec, parent, root_objectid, owner,
>>  					 offset, 1, bytenr, num_bytes);
>>  		if (!back)
>> @@ -6213,6 +6219,7 @@ static int free_extent_hook(struct btrfs_trans_h=
andle *trans,
>>  		}
>>  	} else {
>>  		struct tree_backref *back;
>> +
>>  		back =3D find_tree_backref(rec, parent, root_objectid);
>>  		if (!back)
>>  			goto out;
>> @@ -6252,7 +6259,7 @@ static int delete_extent_records(struct btrfs_tr=
ans_handle *trans,
>>  	key.type =3D (u8)-1;
>>  	key.offset =3D (u64)-1;
>> =20
>> -	while(1) {
>> +	while (1) {
>>  		ret =3D btrfs_search_slot(trans, root->fs_info->extent_root,
>>  					&key, path, 0, 1);
>>  		if (ret < 0)
>> @@ -6365,7 +6372,7 @@ static int record_extent(struct btrfs_trans_hand=
le *trans,
>>  			btrfs_set_extent_flags(leaf, ei,
>>  					       BTRFS_EXTENT_FLAG_DATA);
>>  		} else {
>> -			struct btrfs_disk_key copy_key;;
>> +			struct btrfs_disk_key copy_key;
>> =20
>>  			bi =3D (struct btrfs_tree_block_info *)(ei + 1);
>>  			memset_extent_buffer(leaf, 0, (unsigned long)bi,
>> @@ -6379,8 +6386,8 @@ static int record_extent(struct btrfs_trans_hand=
le *trans,
>>  			btrfs_set_tree_block_level(leaf, bi, rec->info_level);
>>  			btrfs_set_tree_block_key(leaf, bi, &copy_key);
>> =20
>> -			btrfs_set_extent_flags(leaf, ei,
>> -					       BTRFS_EXTENT_FLAG_TREE_BLOCK | flags);
>> +			btrfs_set_extent_flags(leaf, ei, flags |
>> +					       BTRFS_EXTENT_FLAG_TREE_BLOCK);
>>  		}
>> =20
>>  		btrfs_mark_buffer_dirty(leaf);
>> @@ -6418,18 +6425,14 @@ static int record_extent(struct btrfs_trans_ha=
ndle *trans,
>>  			if (ret)
>>  				break;
>>  		}
>> -		fprintf(stderr, "adding new data backref"
>> -				" on %llu %s %llu owner %llu"
>> -				" offset %llu found %d\n",
>> -				(unsigned long long)rec->start,
>> -				back->full_backref ?
>> -				"parent" : "root",
>> -				back->full_backref ?
>> -				(unsigned long long)parent :
>> -				(unsigned long long)dback->root,
>> -				(unsigned long long)dback->owner,
>> -				(unsigned long long)dback->offset,
>> -				dback->found_ref);
>> +		fprintf(stderr,
>> +"adding new data backref on %llu %s %llu owner %llu offset %llu found=
 %d\n",
>> +			(unsigned long long)rec->start,
>> +			back->full_backref ? "parent" : "root",
>> +			back->full_backref ? (unsigned long long)parent :
>> +					     (unsigned long long)dback->root,
>> +			(unsigned long long)dback->owner,
>> +			(unsigned long long)dback->offset, dback->found_ref);
>>  	} else {
>>  		u64 parent;
>>  		struct tree_backref *tback;
>> @@ -6443,8 +6446,8 @@ static int record_extent(struct btrfs_trans_hand=
le *trans,
>>  		ret =3D btrfs_inc_extent_ref(trans, info->extent_root,
>>  					   rec->start, rec->max_size,
>>  					   parent, tback->root, 0, 0);
>> -		fprintf(stderr, "adding new tree backref on "
>> -			"start %llu len %llu parent %llu root %llu\n",
>> +		fprintf(stderr,
>> +"adding new tree backref on start %llu len %llu parent %llu root %llu=
\n",
>>  			rec->start, rec->max_size, parent, tback->root);
>>  	}
>>  fail:
>> @@ -6587,9 +6590,9 @@ static int repair_ref(struct btrfs_fs_info *info=
, struct btrfs_path *path,
>>  		goto out;
>>  	}
>>  	if (ret > 0) {
>> -		fprintf(stderr, "Well that's odd, we just found this key "
>> -			"[%Lu, %u, %Lu]\n", key.objectid, key.type,
>> -			key.offset);
>> +		fprintf(stderr,
>> +		"Well that's odd, we just found this key [%Lu, %u, %Lu]\n",
>> +			key.objectid, key.type, key.offset);
>>  		ret =3D -EINVAL;
>>  		goto out;
>>  	}
>> @@ -6599,10 +6602,8 @@ static int repair_ref(struct btrfs_fs_info *inf=
o, struct btrfs_path *path,
>> =20
>>  	if (btrfs_file_extent_compression(leaf, fi) &&
>>  	    dback->disk_bytenr !=3D entry->bytenr) {
>> -		fprintf(stderr, "Ref doesn't match the record start and is "
>> -			"compressed, please take a btrfs-image of this file "
>> -			"system and send it to a btrfs developer so they can "
>> -			"complete this functionality for bytenr %Lu\n",
>> +		fprintf(stderr,
>> +"Ref doesn't match the record start and is compressed, please take a =
btrfs-image of this file system and send it to a btrfs developer so they =
can complete this functionality for bytenr %Lu\n",
>>  			dback->disk_bytenr);
>>  		ret =3D -EINVAL;
>>  		goto out;
>> @@ -6618,9 +6619,8 @@ static int repair_ref(struct btrfs_fs_info *info=
, struct btrfs_path *path,
>>  		if (dback->disk_bytenr + offset +
>>  		    btrfs_file_extent_num_bytes(leaf, fi) >
>>  		    entry->bytenr + entry->bytes) {
>> -			fprintf(stderr, "Ref is past the entry end, please "
>> -				"take a btrfs-image of this file system and "
>> -				"send it to a btrfs developer, ref %Lu\n",
>> +			fprintf(stderr,
>> +"Ref is past the entry end, please take a btrfs-image of this file sy=
stem and send it to a btrfs developer, ref %Lu\n",
>>  				dback->disk_bytenr);
>>  			ret =3D -EINVAL;
>>  			goto out;
>> @@ -6633,9 +6633,8 @@ static int repair_ref(struct btrfs_fs_info *info=
, struct btrfs_path *path,
>> =20
>>  		offset =3D btrfs_file_extent_offset(leaf, fi);
>>  		if (dback->disk_bytenr + offset < entry->bytenr) {
>> -			fprintf(stderr, "Ref is before the entry start, please"
>> -				" take a btrfs-image of this file system and "
>> -				"send it to a btrfs developer, ref %Lu\n",
>> +			fprintf(stderr,
>> +"Ref is before the entry start, please take a btrfs-image of this fil=
e system and send it to a btrfs developer, ref %Lu\n",
>>  				dback->disk_bytenr);
>>  			ret =3D -EINVAL;
>>  			goto out;
>> @@ -6741,8 +6740,9 @@ static int verify_backrefs(struct btrfs_fs_info =
*info, struct btrfs_path *path,
>>  	if (nr_entries <=3D 1 && !mismatch)
>>  		goto out;
>> =20
>> -	fprintf(stderr, "attempting to repair backref discrepency for bytenr=
 "
>> -		"%Lu\n", rec->start);
>> +	fprintf(stderr,
>> +		"attempting to repair backref discrepency for bytenr %Lu\n",
>> +		rec->start);
>> =20
>>  	/*
>>  	 * First we want to see if the backrefs can agree amongst themselves=
 who
>> @@ -6758,9 +6758,8 @@ static int verify_backrefs(struct btrfs_fs_info =
*info, struct btrfs_path *path,
>>  	if (!best) {
>>  		entry =3D find_entry(&entries, rec->start, rec->nr);
>>  		if (!entry && (!broken_entries || !rec->found_rec)) {
>> -			fprintf(stderr, "Backrefs don't agree with each other "
>> -				"and extent record doesn't agree with anybody,"
>> -				" so we can't fix bytenr %Lu bytes %Lu\n",
>> +			fprintf(stderr,
>> +"Backrefs don't agree with each other and extent record doesn't agree=
 with anybody, so we can't fix bytenr %Lu bytes %Lu\n",
>>  				rec->start, rec->nr);
>>  			ret =3D -EINVAL;
>>  			goto out;
>> @@ -6783,10 +6782,9 @@ static int verify_backrefs(struct btrfs_fs_info=
 *info, struct btrfs_path *path,
>>  		entry->count++;
>>  		best =3D find_most_right_entry(&entries);
>>  		if (!best) {
>> -			fprintf(stderr, "Backrefs and extent record evenly "
>> -				"split on who is right, this is going to "
>> -				"require user input to fix bytenr %Lu bytes "
>> -				"%Lu\n", rec->start, rec->nr);
>> +			fprintf(stderr,
>> +"Backrefs and extent record evenly split on who is right, this is goi=
ng to require user input to fix bytenr %Lu bytes %Lu\n",
>> +				rec->start, rec->nr);
>>  			ret =3D -EINVAL;
>>  			goto out;
>>  		}
>> @@ -6798,10 +6796,8 @@ static int verify_backrefs(struct btrfs_fs_info=
 *info, struct btrfs_path *path,
>>  	 * deal with it properly here yet, so just bail out of that's the ca=
se.
>>  	 */
>>  	if (best->bytenr !=3D rec->start) {
>> -		fprintf(stderr, "Extent start and backref starts don't match, "
>> -			"please use btrfs-image on this file system and send "
>> -			"it to a btrfs developer so they can make fsck fix "
>> -			"this particular case.  bytenr is %Lu, bytes is %Lu\n",
>> +		fprintf(stderr,
>> +"Extent start and backref starts don't match, please use btrfs-image =
on this file system and send it to a btrfs developer so they can make fsc=
k fix this particular case.  bytenr is %Lu, bytes is %Lu\n",
>>  			rec->start, rec->nr);
>>  		ret =3D -EINVAL;
>>  		goto out;
>> @@ -6951,10 +6947,8 @@ static int delete_duplicate_records(struct btrf=
s_root *root,
>>  			continue;
>> =20
>>  		if (tmp->start + tmp->nr < good->start + good->nr) {
>> -			fprintf(stderr, "Ok we have overlapping extents that "
>> -				"aren't completely covered by each other, this "
>> -				"is going to require more careful thought.  "
>> -				"The extents are [%Lu-%Lu] and [%Lu-%Lu]\n",
>> +			fprintf(stderr,
>> +"Ok we have overlapping extents that aren't completely covered by eac=
h other, this is going to require more careful thought. The extents are [=
%Lu-%Lu] and [%Lu-%Lu]\n",
>>  				tmp->start, tmp->nr, good->start, good->nr);
>>  			abort();
>>  		}
>> @@ -6986,9 +6980,9 @@ static int delete_duplicate_records(struct btrfs=
_root *root,
>> =20
>>  		/* Shouldn't happen but just in case */
>>  		if (tmp->metadata) {
>> -			fprintf(stderr, "Well this shouldn't happen, extent "
>> -				"record overlaps but is metadata? "
>> -				"[%Lu, %Lu]\n", tmp->start, tmp->nr);
>> +			fprintf(stderr,
>> +"Well this shouldn't happen, extent record overlaps but is metadata? =
[%Lu, %Lu]\n",
>> +				tmp->start, tmp->nr);
>>  			abort();
>>  		}
>> =20
>> @@ -7090,6 +7084,7 @@ static int find_possible_backrefs(struct btrfs_f=
s_info *info,
>>  		cache =3D lookup_cache_extent(extent_cache, bytenr, 1);
>>  		if (cache) {
>>  			struct extent_record *tmp;
>> +
>>  			tmp =3D container_of(cache, struct extent_record, cache);
>> =20
>>  			/*
>> @@ -7271,7 +7266,8 @@ static int fixup_extent_refs(struct btrfs_fs_inf=
o *info,
>>  			continue;
>> =20
>>  		rec->bad_full_backref =3D 0;
>> -		ret =3D record_extent(trans, info, &path, rec, back, allocated, fla=
gs);
>> +		ret =3D record_extent(trans, info, &path, rec, back, allocated,
>> +				    flags);
>>  		allocated =3D 1;
>> =20
>>  		if (ret)
>> @@ -7280,6 +7276,7 @@ static int fixup_extent_refs(struct btrfs_fs_inf=
o *info,
>>  out:
>>  	if (trans) {
>>  		int err =3D btrfs_commit_transaction(trans, info->extent_root);
>> +
>>  		if (!ret)
>>  			ret =3D err;
>>  	}
>> @@ -7401,8 +7398,8 @@ again:
>>  			goto del_ptr;
>>  	}
>>  	/*
>> -	 * we couldn't find the bad block.  TODO, search all the nodes for p=
ointers
>> -	 * to this block
>> +	 * we couldn't find the bad block.
>> +	 * TODO: search all the nodes for pointers to this block
>>  	 */
>>  	if (eb =3D=3D info->extent_root->node) {
>>  		ret =3D -ENOENT;
>> @@ -7437,7 +7434,8 @@ static int prune_corrupt_blocks(struct btrfs_fs_=
info *info)
>>  			if (IS_ERR(trans))
>>  				return PTR_ERR(trans);
>>  		}
>> -		corrupt =3D container_of(cache, struct btrfs_corrupt_block, cache);=

>> +		corrupt =3D container_of(cache, struct btrfs_corrupt_block,
>> +				       cache);
>>  		prune_one_block(trans, info, corrupt);
>>  		remove_cache_extent(info->corrupt_blocks, cache);
>>  	}
>> @@ -7463,7 +7461,7 @@ static int check_extent_refs(struct btrfs_root *=
root,
>>  		 * extents in the FS
>>  		 */
>>  		cache =3D search_cache_extent(extent_cache, 0);
>> -		while(cache) {
>> +		while (cache) {
>>  			rec =3D container_of(cache, struct extent_record, cache);
>>  			set_extent_dirty(root->fs_info->excluded_extents,
>>  					 rec->start,
>> @@ -7473,7 +7471,7 @@ static int check_extent_refs(struct btrfs_root *=
root,
>> =20
>>  		/* pin down all the corrupted blocks too */
>>  		cache =3D search_cache_extent(root->fs_info->corrupt_blocks, 0);
>> -		while(cache) {
>> +		while (cache) {
>>  			set_extent_dirty(root->fs_info->excluded_extents,
>>  					 cache->start,
>>  					 cache->start + cache->size - 1);
>> @@ -7518,7 +7516,7 @@ static int check_extent_refs(struct btrfs_root *=
root,
>>  	if (had_dups)
>>  		return -EAGAIN;
>> =20
>> -	while(1) {
>> +	while (1) {
>>  		int cur_err =3D 0;
>>  		int fix =3D 0;
>> =20
>> @@ -7527,8 +7525,9 @@ static int check_extent_refs(struct btrfs_root *=
root,
>>  			break;
>>  		rec =3D container_of(cache, struct extent_record, cache);
>>  		if (rec->num_duplicates) {
>> -			fprintf(stderr, "extent item %llu has multiple extent "
>> -				"items\n", (unsigned long long)rec->start);
>> +			fprintf(stderr,
>> +				"extent item %llu has multiple extent items\n",
>> +				(unsigned long long)rec->start);
>>  			cur_err =3D 1;
>>  		}
>> =20
>> @@ -7561,7 +7560,8 @@ static int check_extent_refs(struct btrfs_root *=
root,
>>  		}
>> =20
>>  		if (repair && fix) {
>> -			ret =3D fixup_extent_refs(root->fs_info, extent_cache, rec);
>> +			ret =3D fixup_extent_refs(root->fs_info, extent_cache,
>> +						rec);
>>  			if (ret)
>>  				goto repair_abort;
>>  		}
>> @@ -7943,8 +7943,8 @@ static int add_root_item_to_list(struct list_hea=
d *head,
>>  				  u8 level, u8 drop_level,
>>  				  struct btrfs_key *drop_key)
>>  {
>> -
>>  	struct root_item_record *ri_rec;
>> +
>>  	ri_rec =3D malloc(sizeof(*ri_rec));
>>  	if (!ri_rec)
>>  		return -ENOMEM;
>> @@ -7992,6 +7992,7 @@ static int deal_root_from_list(struct list_head =
*list,
>>  	while (!list_empty(list)) {
>>  		struct root_item_record *rec;
>>  		struct extent_buffer *buf;
>> +
>>  		rec =3D list_entry(list->next,
>>  				 struct root_item_record, list);
>>  		last =3D 0;
>> @@ -8123,7 +8124,7 @@ again:
>>  	ret =3D btrfs_search_slot(NULL, fs_info->tree_root, &key, &path, 0, =
0);
>>  	if (ret < 0)
>>  		goto out;
>> -	while(1) {
>> +	while (1) {
>>  		leaf =3D path.nodes[0];
>>  		slot =3D path.slots[0];
>>  		if (slot >=3D btrfs_header_nritems(path.nodes[0])) {
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--lr7TG7yLcMoQgtkrX7lHIS1BFW8iN9K0Q--

--dwQU3NmixW71aNSivygr1nOGPT3d6vEAa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpy2+wXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qjxzQf+KcnKMUkJsgFFfMcDWBgXapxi
7C70x6onediROKCewX8U1rpZSqJhA5Ac/DoNWQaLL5Kusw9lh/Gn4pAoMCegNxaG
tpkIY+hlJ312ODV3Kf/VtPc4qHn8p53kA2s9nCQm9Q48OH0ViEEpW3aRcsjXXPHQ
DvbLXDIFjhYpKPoNBwVxFGUly/h0Nat092s0oIjbbJ+4FufPI49eXjfMzXm4jTIK
p/OwOTl6BUhrk8jPjOrcKPMR+Jdi+p4fA1zt6QgS+/jfDCdOD6Mxu4ZI7ylYCNsG
ohIqJfnNwxLGlNNq2jXdiwDA0jTUQO6EZKFootRv5DzB1FQx89P71KGqDt2ByQ==
=yPVz
-----END PGP SIGNATURE-----

--dwQU3NmixW71aNSivygr1nOGPT3d6vEAa--
