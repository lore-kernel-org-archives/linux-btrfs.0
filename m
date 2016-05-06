Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37805 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbcEFJVT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 May 2016 05:21:19 -0400
Subject: Re: [RFC PATCH 1/1] btrfs: Encryption: Add btrfs encryption support
To: bo.li.liu@oracle.com
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <1456848492-4814-2-git-send-email-anand.jain@oracle.com>
 <20160310021959.GC15791@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <572C620D.3050003@oracle.com>
Date: Fri, 6 May 2016 17:21:17 +0800
MIME-Version: 1.0
In-Reply-To: <20160310021959.GC15791@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks for the review comments Liu bo. I am looking into the comments.

Anand


On 03/10/2016 10:19 AM, Liu Bo wrote:
> On Wed, Mar 02, 2016 at 12:08:10AM +0800, Anand Jain wrote:
>> ***
>> *** Warning: Experimental code.
>> ***
>>
>> Adds encryption support. The branch is based on v4.5-rc6.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/Makefile      |   2 +-
>>   fs/btrfs/btrfs_inode.h |   2 +
>>   fs/btrfs/compression.c |  53 ++++-
>>   fs/btrfs/compression.h |   1 +
>>   fs/btrfs/ctree.h       |  11 +-
>>   fs/btrfs/encrypt.c     | 544 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/encrypt.h     |  21 ++
>>   fs/btrfs/inode.c       |  37 +++-
>>   fs/btrfs/ioctl.c       |   7 +
>>   fs/btrfs/props.c       | 140 ++++++++++++-
>>   fs/btrfs/super.c       |   5 +-
>>   11 files changed, 812 insertions(+), 11 deletions(-)
>>   create mode 100644 fs/btrfs/encrypt.c
>>   create mode 100644 fs/btrfs/encrypt.h
>>
>> diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
>> index 128ce17a80b0..2765778c5898 100644
>> --- a/fs/btrfs/Makefile
>> +++ b/fs/btrfs/Makefile
>> @@ -9,7 +9,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
>>   	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
>>   	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
>>   	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
>> -	   uuid-tree.o props.o hash.o free-space-tree.o
>> +	   uuid-tree.o props.o hash.o free-space-tree.o encrypt.o
>>
>>   btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
>>   btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
>> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
>> index 61205e3bbefa..4f09572b4922 100644
>> --- a/fs/btrfs/btrfs_inode.h
>> +++ b/fs/btrfs/btrfs_inode.h
>> @@ -197,6 +197,8 @@ struct btrfs_inode {
>>   	long delayed_iput_count;
>>
>>   	struct inode vfs_inode;
>> +
>> +	unsigned char key_payload[16];
>>   };
>>
>>   extern unsigned char btrfs_filetype_table[];
>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>> index 3346cd8f9910..d59c366f4200 100644
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -41,6 +41,7 @@
>>   #include "compression.h"
>>   #include "extent_io.h"
>>   #include "extent_map.h"
>> +#include "encrypt.h"
>>
>>   struct compressed_bio {
>>   	/* number of bios pending for this compressed extent */
>> @@ -182,7 +183,7 @@ static void end_compressed_bio_read(struct bio *bio)
>>   				      cb->orig_bio->bi_vcnt,
>>   				      cb->compressed_len);
>>   csum_failed:
>> -	if (ret)
>> +	if (ret && ret != -ENOKEY)
>>   		cb->errors = 1;
>>
>>   	/* release the compressed pages */
>> @@ -751,6 +752,7 @@ static struct {
>>   static const struct btrfs_compress_op * const btrfs_compress_op[] = {
>>   	&btrfs_zlib_compress,
>>   	&btrfs_lzo_compress,
>> +	&btrfs_encrypt_ops,
>>   };
>>
>>   void __init btrfs_init_compress(void)
>> @@ -780,6 +782,10 @@ static struct list_head *find_workspace(int type)
>>   	atomic_t *alloc_ws		= &btrfs_comp_ws[idx].alloc_ws;
>>   	wait_queue_head_t *ws_wait	= &btrfs_comp_ws[idx].ws_wait;
>>   	int *num_ws			= &btrfs_comp_ws[idx].num_ws;
>> +
>> +	if (type == BTRFS_ENCRYPT_AES)
>> +		return NULL;
>> +
>>   again:
>>   	spin_lock(ws_lock);
>>   	if (!list_empty(idle_ws)) {
>> @@ -824,6 +830,9 @@ static void free_workspace(int type, struct list_head *workspace)
>>   	wait_queue_head_t *ws_wait	= &btrfs_comp_ws[idx].ws_wait;
>>   	int *num_ws			= &btrfs_comp_ws[idx].num_ws;
>>
>> +	if (!workspace)
>> +		return;
>> +
>>   	spin_lock(ws_lock);
>>   	if (*num_ws < num_online_cpus()) {
>>   		list_add(workspace, idle_ws);
>> @@ -862,6 +871,38 @@ static void free_workspaces(void)
>>   	}
>>   }
>>
>> +void print_data_encode_status(struct inode *inode, int direction,
>> +					char *prefix, int type, int ret)
>> +{
>> +#ifdef CONFIG_BTRFS_DEBUG
>> +	char what[10];
>> +
>> +	if (type == BTRFS_ENCRYPT_AES) {
>> +		if (!direction)
>> +			strcpy(what, "Encrypt");
>> +		else
>> +			strcpy(what, "Decrypt");
>> +	} else {
>> +		if (!direction)
>> +			strcpy(what, "Compress");
>> +		else
>> +			strcpy(what, "Uncpress");
>> +	}
>> +
>> +	switch (ret) {
>> +	case 0:
>> +		pr_debug("%s %s: success     : inode %lu\n",what, prefix, inode->i_ino);
>> +		return;
>> +	case -ENOKEY:
>> +		pr_debug("%s %s: Failed NOKEY: inode %lu\n",what, prefix, inode->i_ino);
>> +		return;
>> +	default:
>> +		pr_debug("%s %s: Failed %d   : inode %lu\n",what, prefix, ret, inode->i_ino);
>> +	}
>> +#else
>> +#endif
>> +}
>> +
>>   /*
>>    * given an address space and start/len, compress the bytes.
>>    *
>> @@ -894,7 +935,7 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
>>   	int ret;
>>
>>   	workspace = find_workspace(type);
>> -	if (IS_ERR(workspace))
>> +	if (workspace && IS_ERR(workspace))
>>   		return PTR_ERR(workspace);
>>
>>   	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
>> @@ -903,6 +944,8 @@ int btrfs_compress_pages(int type, struct address_space *mapping,
>>   						      total_in, total_out,
>>   						      max_out);
>>   	free_workspace(type, workspace);
>> +
>> +	print_data_encode_status(mapping->host, 0, "    ", type, ret);
>>   	return ret;
>>   }
>>
>> @@ -930,13 +973,14 @@ static int btrfs_decompress_biovec(int type, struct page **pages_in,
>>   	int ret;
>>
>>   	workspace = find_workspace(type);
>> -	if (IS_ERR(workspace))
>> +	if (workspace && IS_ERR(workspace))
>>   		return PTR_ERR(workspace);
>>
>>   	ret = btrfs_compress_op[type-1]->decompress_biovec(workspace, pages_in,
>>   							 disk_start,
>>   							 bvec, vcnt, srclen);
>>   	free_workspace(type, workspace);
>> +	print_data_encode_status(bvec->bv_page->mapping->host, 1, "bio ", type, ret);
>>   	return ret;
>>   }
>>
>> @@ -952,7 +996,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
>>   	int ret;
>>
>>   	workspace = find_workspace(type);
>> -	if (IS_ERR(workspace))
>> +	if (workspace && IS_ERR(workspace))
>>   		return PTR_ERR(workspace);
>>
>>   	ret = btrfs_compress_op[type-1]->decompress(workspace, data_in,
>> @@ -960,6 +1004,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
>>   						  srclen, destlen);
>>
>>   	free_workspace(type, workspace);
>> +	print_data_encode_status(dest_page->mapping->host, 1, "page", type, ret);
>>   	return ret;
>>   }
>>
>> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
>> index 13a4dc0436c9..78e8f38dbf60 100644
>> --- a/fs/btrfs/compression.h
>> +++ b/fs/btrfs/compression.h
>> @@ -79,5 +79,6 @@ struct btrfs_compress_op {
>>
>>   extern const struct btrfs_compress_op btrfs_zlib_compress;
>>   extern const struct btrfs_compress_op btrfs_lzo_compress;
>> +extern const struct btrfs_compress_op btrfs_encrypt_ops;
>>
>>   #endif
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index bfe4a337fb4d..f30a92bf9c54 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -719,8 +719,9 @@ enum btrfs_compression_type {
>>   	BTRFS_COMPRESS_NONE  = 0,
>>   	BTRFS_COMPRESS_ZLIB  = 1,
>>   	BTRFS_COMPRESS_LZO   = 2,
>> -	BTRFS_COMPRESS_TYPES = 2,
>> -	BTRFS_COMPRESS_LAST  = 3,
>> +	BTRFS_ENCRYPT_AES    = 3,
>> +	BTRFS_COMPRESS_TYPES = 3,
>> +	BTRFS_COMPRESS_LAST  = 4,
>>   };
>>
>>   struct btrfs_inode_item {
>> @@ -771,6 +772,7 @@ struct btrfs_dir_item {
>>    * still visible as a directory
>>    */
>>   #define BTRFS_ROOT_SUBVOL_DEAD		(1ULL << 48)
>> +#define BTRFS_ROOT_SUBVOL_ENCRYPT	(1ULL << 49)
>>
>>   struct btrfs_root_item {
>>   	struct btrfs_inode_item inode;
>> @@ -814,7 +816,9 @@ struct btrfs_root_item {
>>   	struct btrfs_timespec otime;
>>   	struct btrfs_timespec stime;
>>   	struct btrfs_timespec rtime;
>> -	__le64 reserved[8]; /* for future */
>> +	char encrypt_algo[16];
>> +	char encrypt_keytag[16];
>> +	__le64 reserved[4]; /* for future */
>>   } __attribute__ ((__packed__));
>>
>>   /*
>> @@ -2344,6 +2348,7 @@ do {                                                                   \
>>   #define BTRFS_INODE_NOATIME		(1 << 9)
>>   #define BTRFS_INODE_DIRSYNC		(1 << 10)
>>   #define BTRFS_INODE_COMPRESS		(1 << 11)
>> +#define BTRFS_INODE_ENCRYPT		(1 << 12)
>>
>>   #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
>>
>> diff --git a/fs/btrfs/encrypt.c b/fs/btrfs/encrypt.c
>> new file mode 100644
>> index 000000000000..a6838cccc507
>> --- /dev/null
>> +++ b/fs/btrfs/encrypt.c
>> @@ -0,0 +1,544 @@
>> +/*
>> + * Copyright (C) 2016 Oracle.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public
>> + * License along with this program; if not, write to the
>> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>> + * Boston, MA 021110-1307, USA.
>> + */
>> +#include <linux/string.h>
>> +#include <linux/crypto.h>
>> +#include <linux/scatterlist.h>
>> +#include <linux/random.h>
>> +#include <linux/pagemap.h>
>> +#include <keys/user-type.h>
>> +#include "compression.h"
>> +#include <linux/slab.h>
>> +#include <linux/keyctl.h>
>> +#include <linux/key-type.h>
>> +#include <linux/cred.h>
>> +#include <keys/user-type.h>
>> +#include "ctree.h"
>> +#include "btrfs_inode.h"
>> +#include "props.h"
>> +
>> +static const struct btrfs_encrypt_algorithm {
>> +	const char *name;
>> +	size_t	keylen;
>> +} btrfs_encrypt_algorithm_supported[] = {
>> +	{"aes", 16}
>> +};
>> +
>> +/*
>> + * Returns cipher alg key size if the encryption type is found
>> + * otherwise 0
>> + */
>> +size_t btrfs_check_encrypt_type(char *type)
>> +{
>> +	int i;
>> +	for (i = 0; i < ARRAY_SIZE(btrfs_encrypt_algorithm_supported); i++)
>> +		if (!strcmp(btrfs_encrypt_algorithm_supported[i].name, type))
>> +			return btrfs_encrypt_algorithm_supported[i].keylen;
>> +
>> +	return 0;
>> +}
>> +
>> +/* key management*/
>> +static int btrfs_request_key(char *key_tag, void *key_data)
>> +{
>> +	int ret;
>> +	const struct user_key_payload *payload;
>> +	struct key *btrfs_key = NULL;
>> +
>> +	ret = 0;
>> +	btrfs_key = request_key(&key_type_user, key_tag, NULL);
>> +	if (IS_ERR(btrfs_key)) {
>> +		ret = PTR_ERR(btrfs_key);
>> +		btrfs_key = NULL;
>> +		return ret;
>> +	}
>> +
>> +	/*
>> +	 * caller just need key not payload so return
>> +	 */
>> +	if (!key_data)
>> +		return 0;
>> +
>> +	ret = key_validate(btrfs_key);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	rcu_read_lock(); // TODO: check down_write key->sem ?
>> +	payload = user_key_payload(btrfs_key);
>> +	if (IS_ERR_OR_NULL(payload)) {
>> +		ret = PTR_ERR(payload);
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * As of now we just hard code as we just use ASE now
>> +	 */
>> +	if (payload->datalen != 16)
>> +		ret = -EINVAL;
>> +	else
>> +		memcpy(key_data, payload->data, 16);
>> +
>> +out:
>> +	rcu_read_unlock();
>> +	key_put(btrfs_key);
>> +
>> +	return ret;
>> +}
>> +
>> +static int btrfs_get_key_data_from_inode(struct inode *inode, unsigned char *keydata)
>> +{
>> +	int ret;
>> +	char keytag[15];
>> +	struct btrfs_inode *binode;
>> +	struct btrfs_root_item *ri;
>> +
>> +	binode = BTRFS_I(inode);
>> +	ri = &(binode->root->root_item);
>> +	strncpy(keytag, ri->encrypt_keytag, 14);
>> +	keytag[14] = '\0';
>> +
>> +	ret = btrfs_request_key(keytag, keydata);
>> +	return ret;
>> +}
>> +
>> +int btrfs_update_key_data_to_binode(struct inode *inode)
>> +{
>> +	int ret;
>> +	unsigned char keydata[16];
>> +	struct btrfs_inode *binode;
>> +
>> +	ret = btrfs_get_key_data_from_inode(inode, keydata);
>> +	if (ret)
>> +		return ret;
>> +
>> +	binode = BTRFS_I(inode);
>> +	memcpy(binode->key_payload, keydata, 16);
>> +
>> +	return ret;
>> +}
>> +
>> +int btrfs_get_keytag(struct address_space *mapping, char *keytag, struct inode **inode)
>> +{
>> +	struct btrfs_inode *binode;
>> +	struct btrfs_root_item *ri;
>> +
>> +	if (!mapping)
>> +		return -EINVAL;
>> +
>> +	if (!(mapping->host))
>> +		return -EINVAL;
>> +
>> +	binode = BTRFS_I(mapping->host);
>> +	ri = &(binode->root->root_item);
>> +
>> +	strncpy(keytag, ri->encrypt_keytag, 14);
>> +	keytag[14] = '\0';
>> +	if (inode)
>> +		*inode = &binode->vfs_inode;
>> +
>> +	return 0;
>> +}
>> +
>> +/* Encrypt and decrypt */
>> +struct workspace {
>> +	struct list_head list;
>> +};
>> +
>> +struct btrfs_crypt_result {
>> +	struct completion completion;
>> +	int err;
>> +};
>> +
>> +struct btrfs_ablkcipher_def {
>> +	struct scatterlist sg;
>> +	struct crypto_ablkcipher *tfm;
>> +	struct ablkcipher_request *req;
>> +	struct btrfs_crypt_result result;
>> +};
>> +
>> +int btrfs_do_blkcipher(int enc, char *data, size_t len)
>> +{
>
> This function is not used anywhere.
>
>> +	int ret = -EFAULT;
>> +	struct scatterlist sg;
>> +	unsigned int ivsize = 0;
>> +	char *cipher = "cbc(aes)";
>> +	struct blkcipher_desc desc;
>> +	struct crypto_blkcipher *blkcipher = NULL;
>> +	char *charkey =
>> +		"\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef";
>> +	char *chariv =
>> +		"\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef";
>> +
>> +	blkcipher = crypto_alloc_blkcipher(cipher, 0, 0);
>> +	if (IS_ERR(blkcipher)) {
>> +		printk("could not allocate blkcipher handle for %s\n", cipher);
>> +		return -PTR_ERR(blkcipher);
>> +	}
>> +
>> +	if (crypto_blkcipher_setkey(blkcipher, charkey, 16)) {
>> +		printk("key could not be set\n");
>> +		ret = -EAGAIN;
>> +		goto out;
>> +	}
>> +
>> +	ivsize = crypto_blkcipher_ivsize(blkcipher);
>> +	if (ivsize) {
>> +		if (ivsize != strlen(chariv)) {
>> +			printk("length differs from expected length\n");
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +		crypto_blkcipher_set_iv(blkcipher, chariv, ivsize);
>> +	}
>> +
>> +	desc.flags = 0;
>> +	desc.tfm = blkcipher;
>> +	sg_init_one(&sg, data, len);
>> +
>> +	if (enc) {
>> +		/* encrypt data in place */
>> +		ret = crypto_blkcipher_encrypt(&desc, &sg, &sg, len);
>> +	} else {
>> +		/* decrypt data in place */
>> +		ret = crypto_blkcipher_decrypt(&desc, &sg, &sg, len);
>> +	}
>> +
>> +	return ret;
>> +
>> +out:
>> +	crypto_free_blkcipher(blkcipher);
>> +	return ret;
>> +}
>> +
>> +static void btrfs_ablkcipher_cb(struct crypto_async_request *req, int error)
>> +{
>> +	struct btrfs_crypt_result *result;
>> +
>> +	if (error == -EINPROGRESS) {
>> +		pr_info("Encryption callback reports error\n");
>> +		return;
>> +	}
>> +
>> +	result = req->data;
>> +	result->err = error;
>> +	complete(&result->completion);
>> +	pr_info("Encryption finished successfully\n");
>> +}
>> +
>> +static unsigned int btrfs_ablkcipher_encdec(struct btrfs_ablkcipher_def *ablk, int enc)
>> +{
>> +	int rc = 0;
>> +
>> +	if (enc)
>> +		rc = crypto_ablkcipher_encrypt(ablk->req);
>> +	else
>> +		rc = crypto_ablkcipher_decrypt(ablk->req);
>> +
>> +	switch (rc) {
>> +	case 0:
>> +		break;
>> +	case -EINPROGRESS:
>> +	case -EBUSY:
>> +		rc = wait_for_completion_interruptible(
>> +			&ablk->result.completion);
>> +		if (!rc && !ablk->result.err) {
>> +			reinit_completion(&ablk->result.completion);
>> +			break;
>> +		}
>> +	default:
>> +		pr_info("ablkcipher encrypt returned with %d result %d\n",
>> +		       rc, ablk->result.err);
>> +		break;
>> +	}
>> +	init_completion(&ablk->result.completion);
>> +
>> +	return rc;
>> +}
>> +
>> +void btrfs_cipher_get_ivdata(char **ivdata, unsigned int ivsize, unsigned int *ivdata_size)
>> +{
>> +	/* fixme */
>> +	if (0) {
>> +		*ivdata = kmalloc(ivsize, GFP_KERNEL);
>> +		get_random_bytes(ivdata, ivsize);
>> +		*ivdata_size = ivsize;
>> +	} else {
>> +		*ivdata = kstrdup(
>> +			"\x12\x34\x56\x78\x90\xab\xcd\xef\x12\x34\x56\x78\x90\xab\xcd\xef",
>> +			GFP_NOFS);
>> +		*ivdata_size = strlen(*ivdata);
>> +	}
>> +}
>> +
>> +static int btrfs_do_ablkcipher(int endec, struct page *page, unsigned long len,
>> +							struct inode *inode)
>> +{
>> +	int ret = -EFAULT;
>> +	unsigned char key_data[16];
>> +	char *ivdata = NULL;
>> +	unsigned int key_size;
>> +	unsigned int ivsize = 0;
>> +	unsigned int ivdata_size;
>> +	unsigned int ablksize = 0;
>> +	struct btrfs_ablkcipher_def ablk_akin;
>> +	struct ablkcipher_request *req = NULL;
>> +	struct crypto_ablkcipher *ablkcipher = NULL;
>> +
>> +	ret = 0;
>> +
>> +	if (!inode) {
>> +		BUG_ON("Need inode\n");
>> +		return -EINVAL;
>> +	}
>> +	/* get key from the inode */
>> +	ret = btrfs_get_key_data_from_inode(inode, key_data);
>> +
>> +	key_size = 16; //todo: defines, but review for suitable cipher
>> +
>> +	ablkcipher = crypto_alloc_ablkcipher("cts(cbc(aes))", 0, 0);
>> +	if (IS_ERR(ablkcipher)) {
>> +		pr_info("could not allocate ablkcipher handle\n");
>> +		return PTR_ERR(ablkcipher);
>> +	}
>> +
>> +	ablksize = crypto_ablkcipher_blocksize(ablkcipher);
>> +	/* we can't cipher a block less the ciper block size */
>> +	if (len < ablksize || len > PAGE_CACHE_SIZE) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	ivsize = crypto_ablkcipher_ivsize(ablkcipher);
>> +	if (ivsize) {
>> +		btrfs_cipher_get_ivdata(&ivdata, ivsize, &ivdata_size);
>> +		if (ivsize != ivdata_size) {
>> +			BUG_ON("IV length differs from expected length\n");
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +	} else {
>> +		BUG_ON("This cipher doesn't need ivdata, but are we ready ?\n");
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	req = ablkcipher_request_alloc(ablkcipher, GFP_KERNEL);
>> +	if (IS_ERR(req)) {
>> +		pr_info("could not allocate request queue\n");
>> +		ret = PTR_ERR(req);
>> +		goto out;
>> +	}
>> +
>> +	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>> +					btrfs_ablkcipher_cb, &ablk_akin.result);
>> +
>> +	if (crypto_ablkcipher_setkey(ablkcipher, key_data, key_size)) {
>> +		printk("key could not be set\n");
>> +		ret = -EAGAIN;
>> +		goto out;
>> +	}
>> +
>> +	ablk_akin.tfm = ablkcipher;
>> +	ablk_akin.req = req;
>> +
>> +	sg_init_table(&ablk_akin.sg, 1);
>> +	sg_set_page(&ablk_akin.sg, page, len, 0);
>> +	ablkcipher_request_set_crypt(req, &ablk_akin.sg, &ablk_akin.sg, len, ivdata);
>
> Are you sure it is OK to use the same page for src and dst scatterlist?
>
> I don't think it's supposed to be used this way.
>
>> +
>> +	init_completion(&ablk_akin.result.completion);
>> +
>> +	ret = btrfs_ablkcipher_encdec(&ablk_akin, endec);
>> +
>> +out:
>> +	if (ablkcipher)
>> +		crypto_free_ablkcipher(ablkcipher);
>
> req->base.tfm still points to a field in ablkcipher.
>
>> +	if (req)
>> +		ablkcipher_request_free(req);
>> +
>> +	kfree(ivdata);
>> +
>> +	return ret;
>> +}
>> +
>> +static int btrfs_encrypt_pages(struct list_head *na_ws, struct address_space *mapping,
>> +			u64 start, unsigned long len, struct page **pages,
>> +			unsigned long nr_pages, unsigned long *na_out_pages,
>> +			unsigned long *na_total_in, unsigned long *na_total_out,
>> +			unsigned long na_max_out)
>> +{
>> +	int ret;
>> +	struct page *in_page;
>> +	struct page *out_page;
>> +	char *in;
>> +	char *out;
>> +	unsigned long bytes_left = len;
>> +	unsigned long cur_page_len;
>> +	unsigned long cur_page;
>> +	struct inode *inode;
>> +
>> +	*na_total_in = 0;
>> +	*na_out_pages = 0;
>> +
>> +	if (!mapping && !mapping->host) {
>> +		WARN_ON("Need mapped pages\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	inode = mapping->host;
>> +
>> +	for (cur_page = 0; cur_page < nr_pages; cur_page++) {
>> +
>> +		WARN_ON(!bytes_left);
>> +
>> +		in_page = find_get_page(mapping, start >> PAGE_CACHE_SHIFT);
>> +		out_page = alloc_page(GFP_NOFS| __GFP_HIGHMEM);
>> +		cur_page_len = min(bytes_left, PAGE_CACHE_SIZE);
>> +
>> +		in = kmap(in_page);
>> +		out = kmap(out_page);
>> +		memcpy(out, in, cur_page_len);
>> +		kunmap(out_page);
>> +		kunmap(in_page);
>> +
>> +		ret = btrfs_do_ablkcipher(1, out_page, cur_page_len, inode);
>> +		if (ret) {
>> +			__free_page(out_page);
>> +			return ret;
>> +		}
>> +
>> +		pages[cur_page] = out_page;
>> +		*na_out_pages = *na_out_pages + 1;
>> +		*na_total_in = *na_total_in + cur_page_len;
>> +
>> +		start += cur_page_len;
>> +		bytes_left = bytes_left - cur_page_len;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static int btrfs_decrypt_pages(struct list_head *na_ws, unsigned char *in, struct page *out_page,
>> +				unsigned long na_start_byte, size_t in_size, size_t out_size)
>> +{
>> +	int ret;
>> +	char *out_addr;
>> +	char keytag[24];
>> +	struct address_space *mapping;
>> +	struct inode *inode;
>> +
>> +	if (!out_page)
>> +		return -EINVAL;
>> +
>> +	if (in_size > PAGE_CACHE_SIZE)
>> +		return -EINVAL;
>> +
>> +	memset(keytag, '\0', 24);
>> +
>> +	mapping = out_page->mapping;
>> +	if (!mapping && !mapping->host) {
>> +		WARN_ON("Need mapped pages\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	inode = mapping->host;
>> +
>> +	out_addr = kmap(out_page);
>> +	memcpy(out_addr, in, in_size);
>> +	kunmap(out_page);
>> +
>> +	ret = btrfs_do_ablkcipher(0, out_page, in_size, inode);
>> +
>> +	return ret;
>> +}
>> +
>> +static int btrfs_decrypt_pages_bio(struct list_head *na_ws, struct page **in_pages,
>> +					u64 in_start_offset, struct bio_vec *out_pages_bio,
>> +					int bi_vcnt, size_t in_len)
>> +{
>> +	char *in;
>> +	char *out;
>> +	int ret = 0;
>> +	struct page *in_page;
>> +	struct page *out_page;
>> +	unsigned long cur_page_n;
>> +	unsigned long bytes_left;
>> +	unsigned long in_nr_pages;
>> +	unsigned long cur_page_len;
>> +	unsigned long processed_len = 0;
>> +	struct address_space *mapping;
>> +	struct inode *inode;
>> +
>> +	if (na_ws)
>> +		return -EINVAL;
>> +
>> +	out_page = out_pages_bio[0].bv_page;
>> +	mapping = out_page->mapping;
>> +	if (!mapping && !mapping->host) {
>> +		WARN_ON("Need mapped page\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	inode = mapping->host;
>> +
>> +	in_nr_pages = DIV_ROUND_UP(in_len, PAGE_CACHE_SIZE);
>> +	bytes_left = in_len;
>> +	WARN_ON(in_nr_pages != bi_vcnt);
>> +
>> +	for (cur_page_n = 0; cur_page_n < in_nr_pages; cur_page_n++) {
>> +		WARN_ON(!bytes_left);
>> +
>> +		in_page = in_pages[cur_page_n];
>> +		out_page = out_pages_bio[cur_page_n].bv_page;
>> +
>> +		cur_page_len = min(bytes_left, PAGE_CACHE_SIZE);
>> +
>> +		in = kmap(in_page);
>> +		out = kmap(out_page);
>> +		memcpy(out, in, cur_page_len);
>> +		kunmap(out_page);
>> +		kunmap(in_page);
>> +
>> +		ret = btrfs_do_ablkcipher(0, out_page, cur_page_len, inode);
>> +
>> +		if (ret && ret != -ENOKEY)
>> +			goto error_out;
>> +
>> +		if (cur_page_len < PAGE_CACHE_SIZE) {
>> +			out = kmap(out_page);
>> +			memset(out + cur_page_len, 0, PAGE_CACHE_SIZE - cur_page_len);
>> +			kunmap(out_page);
>> +		}
>> +
>> +		bytes_left = bytes_left - cur_page_len;
>> +		processed_len = processed_len + cur_page_len;
>> +
>> +		//flush_dcache_page(out_page);
>> +	}
>> +	WARN_ON(processed_len != in_len);
>> +	WARN_ON(bytes_left);
>> +
>> +error_out:
>> +	return ret;
>> +}
>> +
>> +const struct btrfs_compress_op btrfs_encrypt_ops = {
>> +	.alloc_workspace	= NULL,
>> +	.free_workspace		= NULL,
>> +	.compress_pages		= btrfs_encrypt_pages,
>> +	.decompress_biovec	= btrfs_decrypt_pages_bio,
>> +	.decompress		= btrfs_decrypt_pages,
>> +};
>> diff --git a/fs/btrfs/encrypt.h b/fs/btrfs/encrypt.h
>> new file mode 100644
>> index 000000000000..36a7067e98b1
>> --- /dev/null
>> +++ b/fs/btrfs/encrypt.h
>> @@ -0,0 +1,21 @@
>> +/*
>> + * Copyright (C) 2016 Oracle.  All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public
>> + * License v2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public
>> + * License along with this program; if not, write to the
>> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
>> + * Boston, MA 021110-1307, USA.
>> + */
>> +
>> +
>> +size_t btrfs_check_encrypt_type(char *encryption_type);
>> +int btrfs_update_key_data_to_binode(struct inode *inode);
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 151b7c71b868..b27a89d89753 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -60,6 +60,7 @@
>>   #include "hash.h"
>>   #include "props.h"
>>   #include "qgroup.h"
>> +#include "encrypt.h"
>>
>>   struct btrfs_iget_args {
>>   	struct btrfs_key *location;
>> @@ -206,6 +207,8 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
>>   		}
>>   		btrfs_set_file_extent_compression(leaf, ei,
>>   						  compress_type);
>> +		if (compress_type == BTRFS_ENCRYPT_AES)
>> +			btrfs_set_file_extent_encryption(leaf, ei, 1);
>
> Looks like decrypt is not yet used in read_page path, I only see btrfs_set_file_extent_encryption.
>
>>   	} else {
>>   		page = find_get_page(inode->i_mapping,
>>   				     start >> PAGE_CACHE_SHIFT);
>> @@ -581,7 +584,7 @@ cont:
>>   		 * win, compare the page count read with the blocks on disk
>>   		 */
>>   		total_in = ALIGN(total_in, PAGE_CACHE_SIZE);
>> -		if (total_compressed >= total_in) {
>> +		if (total_compressed >= total_in && compress_type != BTRFS_ENCRYPT_AES) {
>>   			will_compress = 0;
>>   		} else {
>>   			num_bytes = total_in;
>> @@ -6704,6 +6707,8 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>>   	max_size = min_t(unsigned long, PAGE_CACHE_SIZE, max_size);
>>   	ret = btrfs_decompress(compress_type, tmp, page,
>>   			       extent_offset, inline_size, max_size);
>> +	if (ret && ret == -ENOKEY)
>> +		ret = 0;
>>   	kfree(tmp);
>>   	return ret;
>>   }
>> @@ -9271,6 +9276,20 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
>>   	u64 root_objectid;
>>   	int ret;
>>   	u64 old_ino = btrfs_ino(old_inode);
>> +	u64 root_flags;
>> +	u64 dest_flags;
>> +
>> +	/*
>> +	 * As of now block an encrypted file/dir to move across
>> +	 * subvol which potentially has different key.
>> +	 */
>> +	root_flags = btrfs_root_flags(&root->root_item);
>> +	dest_flags = btrfs_root_flags(&dest->root_item);
>> +	if (root != dest &&
>> +		((root_flags & BTRFS_ROOT_SUBVOL_ENCRYPT) ||
>> +		(dest_flags & BTRFS_ROOT_SUBVOL_ENCRYPT))) {
>> +		return -EOPNOTSUPP;
>> +	}
>>
>>   	if (btrfs_ino(new_dir) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
>>   		return -EPERM;
>> @@ -9931,6 +9950,22 @@ static int btrfs_permission(struct inode *inode, int mask)
>>   		if (BTRFS_I(inode)->flags & BTRFS_INODE_READONLY)
>>   			return -EACCES;
>>   	}
>> +
>> +	/*
>> +	 * Get the required key as we encrypt only file data, this
>> +	 * this applies only files as of now.
>
> Double 'this'.
>
>> +	 */
>> +	if (S_ISREG(mode)) {
>> +		int ret = 0;
>> +		u64 root_flags;
>> +		root_flags = btrfs_root_flags(&root->root_item);
>> +		if (root_flags & BTRFS_ROOT_SUBVOL_ENCRYPT) {
>> +			ret = btrfs_update_key_data_to_binode(inode);
>> +			if (ret)
>> +				return -ENOKEY;
>> +		}
>> +	}
>> +
>>   	return generic_permission(inode, mask);
>>   }
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 48aee9846329..3a0f40e4a713 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -2139,8 +2139,15 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
>>   	int ret;
>>   	size_t buf_size;
>>
>> +#if 0
>> +	/*
>> +	 * Todo: Workaround as of now instead of introduing a new ioctl,
>> +	 * so that non root user can find info about the subvol
>> +	 * they own/create. This must be fixed in final.
>> +	 */
>>   	if (!capable(CAP_SYS_ADMIN))
>>   		return -EPERM;
>> +#endif
>>
>>   	uargs = (struct btrfs_ioctl_search_args __user *)argp;
>>
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
>> index f9e60231f685..d40ace5f5492 100644
>> --- a/fs/btrfs/props.c
>> +++ b/fs/btrfs/props.c
>> @@ -22,10 +22,16 @@
>>   #include "hash.h"
>>   #include "transaction.h"
>>   #include "xattr.h"
>> +#include "encrypt.h"
>>
>>   #define BTRFS_PROP_HANDLERS_HT_BITS 8
>>   static DEFINE_HASHTABLE(prop_handlers_ht, BTRFS_PROP_HANDLERS_HT_BITS);
>>
>> +#define BTRFS_PROP_INHERIT_NONE		(1U << 0)
>> +#define BTRFS_PROP_INHERIT_FOR_DIR	(1U << 1)
>> +#define BTRFS_PROP_INHERIT_FOR_CLONE	(1U << 2)
>> +#define BTRFS_PROP_INHERIT_FOR_SUBVOL	(1U << 3)
>> +
>>   struct prop_handler {
>>   	struct hlist_node node;
>>   	const char *xattr_name;
>> @@ -41,13 +47,28 @@ static int prop_compression_apply(struct inode *inode,
>>   				  size_t len);
>>   static const char *prop_compression_extract(struct inode *inode);
>>
>> +static int prop_encrypt_validate(const char *value, size_t len);
>> +static int prop_encrypt_apply(struct inode *inode,
>> +				  const char *value, size_t len);
>> +static const char *prop_encrypt_extract(struct inode *inode);
>> +
>>   static struct prop_handler prop_handlers[] = {
>>   	{
>>   		.xattr_name = XATTR_BTRFS_PREFIX "compression",
>>   		.validate = prop_compression_validate,
>>   		.apply = prop_compression_apply,
>>   		.extract = prop_compression_extract,
>> -		.inheritable = 1
>> +		.inheritable = BTRFS_PROP_INHERIT_FOR_DIR| \
>> +				BTRFS_PROP_INHERIT_FOR_CLONE| \
>> +				BTRFS_PROP_INHERIT_FOR_SUBVOL,
>> +	},
>> +	{
>> +		.xattr_name = XATTR_BTRFS_PREFIX "encrypt",
>> +		.validate = prop_encrypt_validate,
>> +		.apply = prop_encrypt_apply,
>> +		.extract = prop_encrypt_extract,
>> +		.inheritable = BTRFS_PROP_INHERIT_FOR_DIR| \
>> +				BTRFS_PROP_INHERIT_FOR_CLONE,
>>   	},
>>   };
>>
>> @@ -315,6 +336,13 @@ static int inherit_props(struct btrfs_trans_handle *trans,
>>   		if (!h->inheritable)
>>   			continue;
>>
>> +		//is_subvolume_inode(); ?
>> +		if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
>> +			if (!strcmp(h->xattr_name, "btrfs.encrypt")) {
>> +				continue;
>> +			}
>> +		}
>> +
>>   		value = h->extract(parent);
>>   		if (!value)
>>   			continue;
>> @@ -425,4 +453,114 @@ static const char *prop_compression_extract(struct inode *inode)
>>   	return NULL;
>>   }
>>
>> +static int btrfs_create_encrypt_key_tuplet(char *algo, char *tag, char *val_out)
>> +{
>> +	return snprintf(val_out, 32, "%s@%s", algo, tag);
>> +}
>> +
>> +static int btrfs_split_key_tuplet(const char *val, size_t len,
>> +					char *keyalgo, char *keytag)
>> +{
>> +	char *tmp;
>> +	char *tmp1;
>> +	char *tmp2;
>> +
>> +	tmp1 = tmp = kstrdup(val, GFP_NOFS);
>> +	tmp[len] = '\0';
>> +	tmp2 = strsep(&tmp, "@");
>> +	if (!tmp2) {
>> +		kfree(tmp1);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (strlen(tmp2) > 16 || strlen(tmp) > 16) {
>> +		kfree(tmp1);
>
> tmp2 needs to be freed too.
>
>> +		return -EINVAL;
>> +	}
>> +	strcpy(keyalgo, tmp2);
>> +	strcpy(keytag, tmp);
>
> tmp1 and tmp2 need to be freed.
>
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * The required foramt in the value is <encrypt_algo>@<key_tag>
>> + * eg: btrfs.encrypt="aes@btrfs:61e0d004"
>> + */
>> +static int prop_encrypt_validate(const char *value, size_t len)
>> +{
>> +	int ret;
>> +	char keytag[16];
>> +	char keyalgo[16];
>> +	size_t keylen;
>> +
>> +	if (!len)
>> +		return 0;
>> +
>> +	ret = btrfs_split_key_tuplet(value, len, keyalgo, keytag);
>> +	if (ret)
>> +		return ret;
>>
>> +	keylen = btrfs_check_encrypt_type(keyalgo);
>> +	if (!keylen)
>> +		return -ENOTSUPP;
>> +
>> +	return ret;
>> +}
>> +
>> +static int prop_encrypt_apply(struct inode *inode,
>> +				const char *value, size_t len)
>> +{
>> +	int ret;
>> +	u64 root_flags;
>> +	char keytag[16];
>> +	char keyalgo[16];
>> +	struct btrfs_root_item *root_item;
>> +
>> +	root_item = &(BTRFS_I(inode)->root->root_item);
>> +
>> +	if (len == 0) {
>> +		BTRFS_I(inode)->flags &= ~BTRFS_INODE_ENCRYPT;
>> +		BTRFS_I(inode)->force_compress = 0;
>> +
>> +		if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
>> +			root_flags = btrfs_root_flags(root_item);
>> +			btrfs_set_root_flags(root_item, root_flags | ~BTRFS_ROOT_SUBVOL_ENCRYPT);
>> +			memset(root_item->encrypt_algo, '\0', 16);
>> +			memset(root_item->encrypt_keytag, '\0', 16);
>> +		}
>> +		return 0;
>> +	}
>> +
>> +	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
>> +	BTRFS_I(inode)->force_compress = BTRFS_ENCRYPT_AES;
>> +
>> +	ret = btrfs_split_key_tuplet(value, len, keyalgo, keytag);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* do it only for the subvol or snapshot */
>> +	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID) {
>> +		root_flags = btrfs_root_flags(root_item);
>> +		btrfs_set_root_flags(root_item, root_flags | BTRFS_ROOT_SUBVOL_ENCRYPT);
>> +		/* TODO: this is not right, fix it */
>> +		strncpy(root_item->encrypt_algo, keyalgo, 16);
>> +		strncpy(root_item->encrypt_keytag, keytag, 16);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const char *prop_encrypt_extract(struct inode *inode)
>> +{
>> +	int ret;
>> +	char val[32];
>> +	struct btrfs_root_item *ri;
>> +
>> +	ri = &(BTRFS_I(inode)->root->root_item);
>> +
>> +	ret = btrfs_create_encrypt_key_tuplet(ri->encrypt_algo,
>> +					ri->encrypt_keytag, val);
>> +
>> +	return kstrdup(val, GFP_NOFS);
>
> A pointer is returned here, but in
>
> 	value = h->extract();
>
> value is not be freed by the caller.
>
> Thanks,
>
> -liubo
>
>> +}
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index d41e09fe8e38..400225890f5f 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -59,10 +59,10 @@
>>   #include "free-space-cache.h"
>>   #include "backref.h"
>>   #include "tests/btrfs-tests.h"
>> -
>>   #include "qgroup.h"
>>   #define CREATE_TRACE_POINTS
>>   #include <trace/events/btrfs.h>
>> +#include "encrypt.h"
>>
>>   static const struct super_operations btrfs_super_ops;
>>   static struct file_system_type btrfs_fs_type;
>> @@ -92,6 +92,9 @@ const char *btrfs_decode_error(int errno)
>>   	case -ENOENT:
>>   		errstr = "No such entry";
>>   		break;
>> +	case -ENOKEY:
>> +		errstr = "Required key not available";
>> +		break;
>>   	}
>>
>>   	return errstr;
>> --
>> 2.7.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
