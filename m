From: Chris Mason <chris.mason@Oracle.COM>
Subject: Re: [PATCH 4/4] btrfs-convert: split into convert/.
Date: Tue, 23 Mar 2010 15:06:28 -0400
Message-ID: <20100323190628.GI30249@think>
References: <20100320042746.GA17114@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100320042746.GA17114@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for doing all this work.  Which filesystems have you currently
wired up to the converter?

-chris

On Sat, Mar 20, 2010 at 12:27:46AM -0400, Sean Bartell wrote:
> No material changes are made.
> ---
>  Makefile                       |   10 +-
>  convert.c => convert/convert.c |  803 +---------------------------------------
>  convert/convert.h              |   76 ++++
>  convert/ext2.c                 |  791 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 873 insertions(+), 807 deletions(-)
>  rename convert.c => convert/convert.c (74%)
>  create mode 100644 convert/convert.h
>  create mode 100644 convert/ext2.c
> 
> diff --git a/Makefile b/Makefile
> index 755cc24..c31c219 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,6 +1,6 @@
>  CC=gcc
>  AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
> -CFLAGS = -g -Werror -Os
> +CFLAGS = -g -Werror -Os -I.
>  objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>  	  root-tree.o dir-item.o file-item.o inode-item.o \
>  	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
> @@ -29,7 +29,7 @@ endif
>  
>  .c.o:
>  	$(check) $<
> -	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
> +	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $< -o $@
>  
>  
>  all: version $(progs) manpages
> @@ -74,8 +74,8 @@ dir-test: $(objects) dir-test.o
>  quick-test: $(objects) quick-test.o
>  	gcc $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
>  
> -convert: $(objects) convert.o
> -	gcc $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lblkid $(LDFLAGS) $(LIBS)
> +convert: $(objects) $(patsubst %.c,%.o,$(wildcard convert/*.c))
> +	gcc $(CFLAGS) -o btrfs-convert $^ -lext2fs -lblkid $(LDFLAGS) $(LIBS)
>  
>  ioctl-test: $(objects) ioctl-test.o
>  	gcc $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
> @@ -87,7 +87,7 @@ install-man:
>  	cd man; make install
>  
>  clean :
> -	rm -f $(progs) cscope.out *.o .*.d btrfs-convert
> +	rm -f $(progs) cscope.out *.o .*.d btrfs-convert convert/*.o convert/.*.d
>  	cd man; make clean
>  
>  install: $(progs) install-man
> diff --git a/convert.c b/convert/convert.c
> similarity index 74%
> rename from convert.c
> rename to convert/convert.c
> index 6dfcb97..aaf3c56 100644
> --- a/convert.c
> +++ b/convert/convert.c
> @@ -24,117 +24,21 @@
>  #endif
>  #include <stdio.h>
>  #include <stdlib.h>
> -#include <sys/types.h>
> -#include <sys/stat.h>
> -#include <sys/acl.h>
>  #include <fcntl.h>
>  #include <unistd.h>
> -#include <uuid/uuid.h>
> -#include <linux/fs.h>
>  #include <blkid/blkid.h>
>  #include "kerncompat.h"
> +#include "convert.h"
>  #include "ctree.h"
>  #include "disk-io.h"
>  #include "volumes.h"
>  #include "transaction.h"
>  #include "crc32c.h"
>  #include "utils.h"
> -#include <ext2fs/ext2_fs.h>
> -#include <ext2fs/ext2fs.h>
> -#include <ext2fs/ext2_ext_attr.h>
>  
> -struct convert_fs {
> -	u64 total_bytes;
> -	u64 blocksize;
> -	const char *label;
> -
> -	/* Close the FS */
> -	int (*close)(struct convert_fs *fs);
> -	/* Mark free extents as dirty */
> -	int (*cache_free_extents)(struct convert_fs *fs,
> -				  struct extent_io_tree *tree);
> -	/* Copy everything over */
> -	int (*copy_inodes)(struct convert_fs *fs, struct btrfs_root *root,
> -			   int datacsum, int packing, int noxattr);
> -
> -	void *privdata;
> -};
> -
> -#define INO_OFFSET (BTRFS_FIRST_FREE_OBJECTID - EXT2_ROOT_INO)
>  #define STRIPE_LEN (64 * 1024)
>  #define ORIG_IMAGE_SUBVOL_OBJECTID BTRFS_FIRST_FREE_OBJECTID
>  
> -/*
> - * Open Ext2fs in readonly mode, read block allocation bitmap and
> - * inode bitmap into memory.
> - */
> -static int open_ext2fs(const char *name, ext2_filsys *ret_fs)
> -{
> -	errcode_t ret;
> -	ext2_filsys ext2_fs;
> -	ext2_ino_t ino;
> -	ret = ext2fs_open(name, 0, 0, 0, unix_io_manager, &ext2_fs);
> -	if (ret) {
> -		fprintf(stderr, "ext2fs_open: %s\n", error_message(ret));
> -		goto fail;
> -	}
> -	ret = ext2fs_read_inode_bitmap(ext2_fs);
> -	if (ret) {
> -		fprintf(stderr, "ext2fs_read_inode_bitmap: %s\n",
> -			error_message(ret));
> -		goto fail;
> -	}
> -	ret = ext2fs_read_block_bitmap(ext2_fs);
> -	if (ret) {
> -		fprintf(stderr, "ext2fs_read_block_bitmap: %s\n",
> -			error_message(ret));
> -		goto fail;
> -	}
> -	/*
> -	 * search each block group for a free inode. this set up
> -	 * uninit block/inode bitmaps appropriately.
> -	 */
> -	ino = 1;
> -	while (ino <= ext2_fs->super->s_inodes_count) {
> -		ext2_ino_t foo;
> -		ext2fs_new_inode(ext2_fs, ino, 0, NULL, &foo);
> -		ino += EXT2_INODES_PER_GROUP(ext2_fs->super);
> -	}
> -
> -	*ret_fs = ext2_fs;
> -	return 0;
> -fail:
> -	return -1;
> -}
> -
> -static int ext2_close(struct convert_fs *fs)
> -{
> -	ext2fs_close((ext2_filsys)fs->privdata);
> -	return 0;
> -}
> -
> -static int ext2_cache_free_extents(struct convert_fs *fs,
> -				   struct extent_io_tree *free_tree)
> -{
> -	ext2_filsys ext2_fs = fs->privdata;
> -	int ret = 0;
> -	blk_t block;
> -	u64 bytenr;
> -	u64 blocksize = ext2_fs->blocksize;
> -
> -	block = ext2_fs->super->s_first_data_block;
> -	for (; block < ext2_fs->super->s_blocks_count; block++) {
> -		if (ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block))
> -			continue;
> -		bytenr = block * blocksize;
> -		ret = set_extent_dirty(free_tree, bytenr,
> -				       bytenr + blocksize - 1, 0);
> -		BUG_ON(ret);
> -	}
> -
> -	return 0;
> -}
> -
>  /* mark btrfs-reserved blocks as used */
>  static void adjust_free_extents(struct convert_fs *fs,
>  				struct extent_io_tree *free_tree)
> @@ -267,113 +171,6 @@ struct btrfs_extent_ops extent_ops = {
>  	.free_extent = custom_free_extent,
>  };
>  
> -struct dir_iterate_data {
> -	struct btrfs_trans_handle *trans;
> -	struct btrfs_root *root;
> -	struct btrfs_inode_item *inode;
> -	u64 objectid;
> -	u64 index_cnt;
> -	u64 parent;
> -	int errcode;
> -};
> -
> -static u8 filetype_conversion_table[EXT2_FT_MAX] = {
> -	[EXT2_FT_UNKNOWN]	= BTRFS_FT_UNKNOWN,
> -	[EXT2_FT_REG_FILE]	= BTRFS_FT_REG_FILE,
> -	[EXT2_FT_DIR]		= BTRFS_FT_DIR,
> -	[EXT2_FT_CHRDEV]	= BTRFS_FT_CHRDEV,
> -	[EXT2_FT_BLKDEV]	= BTRFS_FT_BLKDEV,
> -	[EXT2_FT_FIFO]		= BTRFS_FT_FIFO,
> -	[EXT2_FT_SOCK]		= BTRFS_FT_SOCK,
> -	[EXT2_FT_SYMLINK]	= BTRFS_FT_SYMLINK,
> -};
> -
> -static int dir_iterate_proc(ext2_ino_t dir, int entry,
> -			    struct ext2_dir_entry *old,
> -			    int offset, int blocksize,
> -			    char *buf,void *priv_data)
> -{
> -	int ret;
> -	int file_type;
> -	u64 objectid;
> -        u64 inode_size;
> -	char dotdot[] = "..";
> -	struct btrfs_key location;
> -	struct ext2_dir_entry_2 *dirent = (struct ext2_dir_entry_2 *)old;
> -	struct dir_iterate_data *idata = (struct dir_iterate_data *)priv_data;
> -
> -	objectid = dirent->inode + INO_OFFSET;
> -	if (!strncmp(dirent->name, dotdot, dirent->name_len)) {
> -		if (dirent->name_len == 2) {
> -			BUG_ON(idata->parent != 0);
> -			idata->parent = objectid;
> -		}
> -		return 0;
> -	}
> -	if (dirent->inode < EXT2_GOOD_OLD_FIRST_INO)
> -		return 0;
> -
> -	location.objectid = objectid;
> -	location.offset = 0;
> -	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
> -
> -	file_type = dirent->file_type;
> -	BUG_ON(file_type > EXT2_FT_SYMLINK);
> -	ret = btrfs_insert_dir_item(idata->trans, idata->root,
> -				    dirent->name, dirent->name_len,
> -				    idata->objectid, &location,
> -				    filetype_conversion_table[file_type],
> -				    idata->index_cnt);
> -	if (ret)
> -		goto fail;
> -	ret = btrfs_insert_inode_ref(idata->trans, idata->root,
> -				     dirent->name, dirent->name_len,
> -				     objectid, idata->objectid,
> -				     idata->index_cnt);
> -	if (ret)
> -		goto fail;
> -	idata->index_cnt++;
> -	inode_size = btrfs_stack_inode_size(idata->inode) +
> -		     dirent->name_len * 2;
> -	btrfs_set_stack_inode_size(idata->inode, inode_size);
> -	return 0;
> -fail:
> -	idata->errcode = ret;
> -	return BLOCK_ABORT;
> -}
> -
> -static int create_dir_entries(struct btrfs_trans_handle *trans,
> -			      struct btrfs_root *root, u64 objectid,
> -			      struct btrfs_inode_item *btrfs_inode,
> -			      ext2_filsys ext2_fs, ext2_ino_t ext2_ino)
> -{
> -	int ret;
> -	errcode_t err;
> -	struct dir_iterate_data data = {
> -		.trans		= trans,
> -		.root		= root,
> -		.inode		= btrfs_inode,
> -		.objectid	= objectid,
> -		.index_cnt	= 2,
> -		.parent		= 0,
> -		.errcode	= 0,
> -	};
> -
> -	err = ext2fs_dir_iterate2(ext2_fs, ext2_ino, 0, NULL,
> -				  dir_iterate_proc, &data);
> -	if (err)
> -		goto error;
> -	ret = data.errcode;
> -	if (ret == 0 && data.parent == objectid) {
> -		ret = btrfs_insert_inode_ref(trans, root, "..", 2,
> -					     objectid, objectid, 0);
> -	}
> -	return ret;
> -error:
> -	fprintf(stderr, "ext2fs_dir_iterate2: %s\n", error_message(err));
> -	return -1;
> -}
> -
>  static int read_disk_extent(struct btrfs_root *root, u64 bytenr,
>  		            u64 num_bytes, char *buffer)
>  {
> @@ -524,22 +321,6 @@ fail:
>  	return ret;
>  }
>  
> -struct extent_iterate_data {
> -	struct btrfs_trans_handle *trans;
> -	struct btrfs_root *root;
> -	u64 *inode_nbytes;
> -	u64 objectid;
> -	int checksum, packing;
> -	u64 last_file_off;
> -	u64 total_size;
> -	enum {EXTENT_ITERATE_TYPE_NONE, EXTENT_ITERATE_TYPE_MEM,
> -	      EXTENT_ITERATE_TYPE_DISK} type;
> -	u64 size;
> -	u64 file_off; /* always aligned to sectorsize */
> -	char *data; /* for mem */
> -	u64 disk_off; /* for disk */
> -};
> -
>  static u64 extent_boundary(struct btrfs_root *root, u64 extent_start)
>  {
>  	int i;
> @@ -710,9 +491,6 @@ int finish_file_extents(struct extent_iterate_data *priv)
>  	return 0;
>  }
>  
> -int add_file_mem_extent(struct extent_iterate_data *priv, u64 file_off,
> -			u64 size, char *data);
> -
>  int add_file_disk_extent(struct extent_iterate_data *priv, u64 file_off,
>  			 u64 disk_off, u64 size)
>  {
> @@ -861,510 +639,6 @@ int add_file_mem_extent(struct extent_iterate_data *priv, u64 file_off,
>  	return 0;
>  }
>  
> -static int __block_iterate_proc(ext2_filsys fs, blk_t *blocknr,
> -			        e2_blkcnt_t blockcnt, blk_t ref_block,
> -			        int ref_offset, void *priv_data)
> -{
> -	struct extent_iterate_data *idata;
> -	idata = (struct extent_iterate_data *)priv_data;
> -	u64 blocksize = fs->blocksize;
> -	int ret = add_file_disk_extent(idata, blocksize * blockcnt,
> -				       blocksize * *blocknr, blocksize);
> -	if (ret)
> -		return BLOCK_ABORT;
> -	return 0;
> -}
> -
> -/*
> - * traverse file's data blocks, record these data blocks as file extents.
> - */
> -static int create_file_extents(struct btrfs_trans_handle *trans,
> -			       struct btrfs_root *root, u64 objectid,
> -			       struct btrfs_inode_item *btrfs_inode,
> -			       ext2_filsys ext2_fs, ext2_ino_t ext2_ino,
> -			       int datacsum, int packing)
> -{
> -	int ret;
> -	errcode_t err;
> -	u64 inode_nbytes = 0;
> -	u64 inode_size = btrfs_stack_inode_size(btrfs_inode);
> -	struct extent_iterate_data data;
> -	ret = start_file_extents(&data, trans, root, &inode_nbytes, objectid,
> -				 datacsum, packing, inode_size);
> -	if (ret)
> -		return ret;
> -	err = ext2fs_block_iterate2(ext2_fs, ext2_ino, BLOCK_FLAG_DATA_ONLY,
> -				    NULL, __block_iterate_proc, &data);
> -	if (err)
> -		goto error;
> -	ret = finish_file_extents(&data);
> -	if (ret)
> -		return ret;
> -	btrfs_set_stack_inode_nbytes(btrfs_inode, inode_nbytes);
> -	return 0;
> -error:
> -	fprintf(stderr, "ext2fs_block_iterate2: %s\n", error_message(err));
> -	return -1;
> -}
> -
> -static int create_symbol_link(struct btrfs_trans_handle *trans,
> -			      struct btrfs_root *root, u64 objectid,
> -			      struct btrfs_inode_item *btrfs_inode,
> -			      ext2_filsys ext2_fs, ext2_ino_t ext2_ino,
> -			      struct ext2_inode *ext2_inode)
> -{
> -	int ret;
> -	char *pathname;
> -	u64 inode_size = btrfs_stack_inode_size(btrfs_inode);
> -	if (ext2fs_inode_data_blocks(ext2_fs, ext2_inode)) {
> -		btrfs_set_stack_inode_size(btrfs_inode, inode_size + 1);
> -		ret = create_file_extents(trans, root, objectid, btrfs_inode,
> -					  ext2_fs, ext2_ino, 1, 1);
> -		btrfs_set_stack_inode_size(btrfs_inode, inode_size);
> -		return ret;
> -	}
> -
> -	pathname = (char *)&(ext2_inode->i_block[0]);
> -	BUG_ON(pathname[inode_size] != 0);
> -	ret = btrfs_insert_inline_extent(trans, root, objectid, 0,
> -					 pathname, inode_size + 1);
> -	btrfs_set_stack_inode_nbytes(btrfs_inode, inode_size + 1);
> -	return ret;
> -}
> -
> -/*
> - * Following xattr/acl related codes are based on codes in
> - * fs/ext3/xattr.c and fs/ext3/acl.c
> - */
> -#define EXT2_XATTR_BHDR(ptr) ((struct ext2_ext_attr_header *)(ptr))
> -#define EXT2_XATTR_BFIRST(ptr) \
> -	((struct ext2_ext_attr_entry *)(EXT2_XATTR_BHDR(ptr) + 1))
> -#define EXT2_XATTR_IHDR(inode) \
> -	((struct ext2_ext_attr_header *) ((void *)(inode) + \
> -		EXT2_GOOD_OLD_INODE_SIZE + (inode)->i_extra_isize))
> -#define EXT2_XATTR_IFIRST(inode) \
> -	((struct ext2_ext_attr_entry *) ((void *)EXT2_XATTR_IHDR(inode) + \
> -		sizeof(EXT2_XATTR_IHDR(inode)->h_magic)))
> -
> -static int ext2_xattr_check_names(struct ext2_ext_attr_entry *entry,
> -				  const void *end)
> -{
> -	struct ext2_ext_attr_entry *next;
> -
> -	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> -		next = EXT2_EXT_ATTR_NEXT(entry);
> -		if ((void *)next >= end)
> -			return -EIO;
> -		entry = next;
> -	}
> -	return 0;
> -}
> -
> -static int ext2_xattr_check_block(const char *buf, size_t size)
> -{
> -	int error;
> -	struct ext2_ext_attr_header *header = EXT2_XATTR_BHDR(buf);
> -
> -	if (header->h_magic != EXT2_EXT_ATTR_MAGIC ||
> -	    header->h_blocks != 1)
> -		return -EIO;
> -	error = ext2_xattr_check_names(EXT2_XATTR_BFIRST(buf), buf + size);
> -	return error;
> -}
> -
> -static int ext2_xattr_check_entry(struct ext2_ext_attr_entry *entry,
> -				  size_t size)
> -{
> -	size_t value_size = entry->e_value_size;
> -
> -	if (entry->e_value_block != 0 || value_size > size ||
> -	    entry->e_value_offs + value_size > size)
> -		return -EIO;
> -	return 0;
> -}
> -
> -#define EXT2_ACL_VERSION	0x0001
> -
> -typedef struct {
> -	__le16		e_tag;
> -	__le16		e_perm;
> -	__le32		e_id;
> -} ext2_acl_entry;
> -
> -typedef struct {
> -	__le16		e_tag;
> -	__le16		e_perm;
> -} ext2_acl_entry_short;
> -
> -typedef struct {
> -	__le32		a_version;
> -} ext2_acl_header;
> -
> -static inline int ext2_acl_count(size_t size)
> -{
> -	ssize_t s;
> -	size -= sizeof(ext2_acl_header);
> -	s = size - 4 * sizeof(ext2_acl_entry_short);
> -	if (s < 0) {
> -		if (size % sizeof(ext2_acl_entry_short))
> -			return -1;
> -		return size / sizeof(ext2_acl_entry_short);
> -	} else {
> -		if (s % sizeof(ext2_acl_entry))
> -			return -1;
> -		return s / sizeof(ext2_acl_entry) + 4;
> -	}
> -}
> -
> -#define ACL_EA_VERSION		0x0002
> -
> -typedef struct {
> -	__le16		e_tag;
> -	__le16		e_perm;
> -	__le32		e_id;
> -} acl_ea_entry;
> -
> -typedef struct {
> -	__le32		a_version;
> -	acl_ea_entry	a_entries[0];
> -} acl_ea_header;
> -
> -static inline size_t acl_ea_size(int count)
> -{
> -	return sizeof(acl_ea_header) + count * sizeof(acl_ea_entry);
> -}
> -
> -static int ext2_acl_to_xattr(void *dst, const void *src,
> -			     size_t dst_size, size_t src_size)
> -{
> -	int i, count;
> -	const void *end = src + src_size;
> -	acl_ea_header *ext_acl = (acl_ea_header *)dst;
> -	acl_ea_entry *dst_entry = ext_acl->a_entries;
> -	ext2_acl_entry *src_entry;
> -
> -	if (src_size < sizeof(ext2_acl_header))
> -		goto fail;
> -	if (((ext2_acl_header *)src)->a_version !=
> -	    cpu_to_le32(EXT2_ACL_VERSION))
> -		goto fail;
> -	src += sizeof(ext2_acl_header);
> -	count = ext2_acl_count(src_size);
> -	if (count <= 0)
> -		goto fail;
> -
> -	BUG_ON(dst_size < acl_ea_size(count));
> -	ext_acl->a_version = cpu_to_le32(ACL_EA_VERSION);
> -	for (i = 0; i < count; i++, dst_entry++) {
> -		src_entry = (ext2_acl_entry *)src;
> -		if (src + sizeof(ext2_acl_entry_short) > end)
> -			goto fail;
> -		dst_entry->e_tag = src_entry->e_tag;
> -		dst_entry->e_perm = src_entry->e_perm;
> -		switch (le16_to_cpu(src_entry->e_tag)) {
> -		case ACL_USER_OBJ:
> -		case ACL_GROUP_OBJ:
> -		case ACL_MASK:
> -		case ACL_OTHER:
> -			src += sizeof(ext2_acl_entry_short);
> -			dst_entry->e_id = cpu_to_le32(ACL_UNDEFINED_ID);
> -			break;
> -		case ACL_USER:
> -		case ACL_GROUP:
> -			src += sizeof(ext2_acl_entry);
> -			if (src > end)
> -				goto fail;
> -			dst_entry->e_id = src_entry->e_id;
> -			break;
> -		default:
> -			goto fail;
> -		}
> -	}
> -	if (src != end)
> -		goto fail;
> -	return 0;
> -fail:
> -	return -EINVAL;
> -}
> -
> -static char *xattr_prefix_table[] = {
> -	[1] =	"user.",
> -	[2] =	"system.posix_acl_access",
> -	[3] =	"system.posix_acl_default",
> -	[4] =	"trusted.",
> -	[6] =	"security.",
> -};
> -
> -static int copy_single_xattr(struct btrfs_trans_handle *trans,
> -			     struct btrfs_root *root, u64 objectid,
> -			     struct ext2_ext_attr_entry *entry,
> -			     const void *data, u32 datalen)
> -{
> -	int ret = 0;
> -	int name_len;
> -	int name_index;
> -	void *databuf = NULL;
> -	char namebuf[XATTR_NAME_MAX + 1];
> -
> -	name_index = entry->e_name_index;
> -	if (name_index >= ARRAY_SIZE(xattr_prefix_table) ||
> -	    xattr_prefix_table[name_index] == NULL)
> -		return -EOPNOTSUPP;
> -	name_len = strlen(xattr_prefix_table[name_index]) +
> -		   entry->e_name_len;
> -	if (name_len >= sizeof(namebuf))
> -		return -ERANGE;
> -
> -	if (name_index == 2 || name_index == 3) {
> -		size_t bufsize = acl_ea_size(ext2_acl_count(datalen));
> -		databuf = malloc(bufsize);
> -		if (!databuf)
> -		       return -ENOMEM;
> -		ret = ext2_acl_to_xattr(databuf, data, bufsize, datalen);
> -		if (ret)
> -			goto out;
> -		data = databuf;
> -		datalen = bufsize;
> -	}
> -	strcpy(namebuf, xattr_prefix_table[name_index]);
> -	strncat(namebuf, EXT2_EXT_ATTR_NAME(entry), entry->e_name_len);
> -	if (name_len + datalen > BTRFS_LEAF_DATA_SIZE(root) -
> -	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
> -		fprintf(stderr, "skip large xattr on inode %Lu name %.*s\n",
> -			objectid - INO_OFFSET, name_len, namebuf);
> -		goto out;
> -	}
> -	ret = btrfs_insert_xattr_item(trans, root, namebuf, name_len,
> -				      data, datalen, objectid);
> -out:
> -	if (databuf)
> -		free(databuf);
> -	return ret;
> -}
> -
> -static int copy_extended_attrs(struct btrfs_trans_handle *trans,
> -			       struct btrfs_root *root, u64 objectid,
> -			       struct btrfs_inode_item *btrfs_inode,
> -			       ext2_filsys ext2_fs, ext2_ino_t ext2_ino)
> -{
> -	int ret = 0;
> -	int inline_ea = 0;
> -	errcode_t err;
> -	u32 datalen;
> -	u32 block_size = ext2_fs->blocksize;
> -	u32 inode_size = EXT2_INODE_SIZE(ext2_fs->super);
> -	struct ext2_inode_large *ext2_inode;
> -	struct ext2_ext_attr_entry *entry;
> -	void *data;
> -	char *buffer = NULL;
> -	char inode_buf[EXT2_GOOD_OLD_INODE_SIZE];
> -
> -	if (inode_size <= EXT2_GOOD_OLD_INODE_SIZE) {
> -		ext2_inode = (struct ext2_inode_large *)inode_buf;
> -	} else {
> -		ext2_inode = (struct ext2_inode_large *)malloc(inode_size);
> -		if (!ext2_inode)
> -		       return -ENOMEM;
> -	}
> -	err = ext2fs_read_inode_full(ext2_fs, ext2_ino, (void *)ext2_inode,
> -				     inode_size);
> -	if (err) {
> -		fprintf(stderr, "ext2fs_read_inode_full: %s\n",
> -			error_message(err));
> -		ret = -1;
> -		goto out;
> -	}
> -
> -	if (ext2_ino > ext2_fs->super->s_first_ino &&
> -	    inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
> -		if (EXT2_GOOD_OLD_INODE_SIZE +
> -		    ext2_inode->i_extra_isize > inode_size) {
> -			ret = -EIO;
> -			goto out;
> -		}
> -		if (ext2_inode->i_extra_isize != 0 &&
> -		    EXT2_XATTR_IHDR(ext2_inode)->h_magic ==
> -		    EXT2_EXT_ATTR_MAGIC) {
> -			inline_ea = 1;
> -		}
> -	}
> -	if (inline_ea) {
> -		int total;
> -		void *end = (void *)ext2_inode + inode_size;
> -		entry = EXT2_XATTR_IFIRST(ext2_inode);
> -		total = end - (void *)entry;
> -		ret = ext2_xattr_check_names(entry, end);
> -		if (ret)
> -			goto out;
> -		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> -			ret = ext2_xattr_check_entry(entry, total);
> -			if (ret)
> -				goto out;
> -			data = (void *)EXT2_XATTR_IFIRST(ext2_inode) +
> -				entry->e_value_offs;
> -			datalen = entry->e_value_size;
> -			ret = copy_single_xattr(trans, root, objectid,
> -						entry, data, datalen);
> -			if (ret)
> -				goto out;
> -			entry = EXT2_EXT_ATTR_NEXT(entry);
> -		}
> -	}
> -
> -	if (ext2_inode->i_file_acl == 0)
> -		goto out;
> -
> -	buffer = malloc(block_size);
> -	if (!buffer) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> -	err = ext2fs_read_ext_attr(ext2_fs, ext2_inode->i_file_acl, buffer);
> -	if (err) {
> -		fprintf(stderr, "ext2fs_read_ext_attr: %s\n",
> -			error_message(err));
> -		ret = -1;
> -		goto out;
> -	}
> -	ret = ext2_xattr_check_block(buffer, block_size);
> -	if (ret)
> -		goto out;
> -
> -	entry = EXT2_XATTR_BFIRST(buffer);
> -	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> -		ret = ext2_xattr_check_entry(entry, block_size);
> -		if (ret)
> -			goto out;
> -		data = buffer + entry->e_value_offs;
> -		datalen = entry->e_value_size;
> -		ret = copy_single_xattr(trans, root, objectid,
> -					entry, data, datalen);
> -		if (ret)
> -			goto out;
> -		entry = EXT2_EXT_ATTR_NEXT(entry);
> -	}
> -out:
> -	if (buffer != NULL)
> -		free(buffer);
> -	if ((void *)ext2_inode != inode_buf)
> -		free(ext2_inode);
> -	return ret;
> -}
> -#define MINORBITS	20
> -#define MKDEV(ma, mi)	(((ma) << MINORBITS) | (mi))
> -
> -static inline dev_t old_decode_dev(u16 val)
> -{
> -	return MKDEV((val >> 8) & 255, val & 255);
> -}
> -
> -static inline dev_t new_decode_dev(u32 dev)
> -{
> -	unsigned major = (dev & 0xfff00) >> 8;
> -	unsigned minor = (dev & 0xff) | ((dev >> 12) & 0xfff00);
> -	return MKDEV(major, minor);
> -}
> -
> -static int copy_inode_item(struct btrfs_inode_item *dst,
> -			   struct ext2_inode *src, u32 blocksize)
> -{
> -	btrfs_set_stack_inode_generation(dst, 1);
> -	btrfs_set_stack_inode_size(dst, src->i_size);
> -	btrfs_set_stack_inode_nbytes(dst, 0);
> -	btrfs_set_stack_inode_block_group(dst, 0);
> -	btrfs_set_stack_inode_nlink(dst, src->i_links_count);
> -	btrfs_set_stack_inode_uid(dst, src->i_uid | (src->i_uid_high << 16));
> -	btrfs_set_stack_inode_gid(dst, src->i_gid | (src->i_gid_high << 16));
> -	btrfs_set_stack_inode_mode(dst, src->i_mode);
> -	btrfs_set_stack_inode_rdev(dst, 0);
> -	btrfs_set_stack_inode_flags(dst, 0);
> -	btrfs_set_stack_timespec_sec(&dst->atime, src->i_atime);
> -	btrfs_set_stack_timespec_nsec(&dst->atime, 0);
> -	btrfs_set_stack_timespec_sec(&dst->ctime, src->i_ctime);
> -	btrfs_set_stack_timespec_nsec(&dst->ctime, 0);
> -	btrfs_set_stack_timespec_sec(&dst->mtime, src->i_mtime);
> -	btrfs_set_stack_timespec_nsec(&dst->mtime, 0);
> -	btrfs_set_stack_timespec_sec(&dst->otime, 0);
> -	btrfs_set_stack_timespec_nsec(&dst->otime, 0);
> -
> -	if (S_ISDIR(src->i_mode)) {
> -		btrfs_set_stack_inode_size(dst, 0);
> -		btrfs_set_stack_inode_nlink(dst, 1);
> -	}
> -	if (S_ISREG(src->i_mode)) {
> -		btrfs_set_stack_inode_size(dst, (u64)src->i_size_high << 32 |
> -					   (u64)src->i_size);
> -	}
> -	if (!S_ISREG(src->i_mode) && !S_ISDIR(src->i_mode) &&
> -	    !S_ISLNK(src->i_mode)) {
> -		if (src->i_block[0]) {
> -			btrfs_set_stack_inode_rdev(dst,
> -				old_decode_dev(src->i_block[0]));
> -		} else {
> -			btrfs_set_stack_inode_rdev(dst,
> -				new_decode_dev(src->i_block[1]));
> -		}
> -	}
> -	return 0;
> -}
> -
> -/*
> - * copy a single inode. do all the required works, such as cloning
> - * inode item, creating file extents and creating directory entries.
> - */
> -static int copy_single_inode(struct btrfs_trans_handle *trans,
> -			     struct btrfs_root *root, u64 objectid,
> -			     ext2_filsys ext2_fs, ext2_ino_t ext2_ino,
> -			     struct ext2_inode *ext2_inode,
> -			     int datacsum, int packing, int noxattr)
> -{
> -	int ret;
> -	struct btrfs_key inode_key;
> -	struct btrfs_inode_item btrfs_inode;
> -
> -	if (ext2_inode->i_links_count == 0)
> -		return 0;
> -
> -	copy_inode_item(&btrfs_inode, ext2_inode, ext2_fs->blocksize);
> -	if (!datacsum && S_ISREG(ext2_inode->i_mode)) {
> -		u32 flags = btrfs_stack_inode_flags(&btrfs_inode) |
> -			    BTRFS_INODE_NODATASUM;
> -		btrfs_set_stack_inode_flags(&btrfs_inode, flags);
> -	}
> -
> -	switch (ext2_inode->i_mode & S_IFMT) {
> -	case S_IFREG:
> -		ret = create_file_extents(trans, root, objectid, &btrfs_inode,
> -					ext2_fs, ext2_ino, datacsum, packing);
> -		break;
> -	case S_IFDIR:
> -		ret = create_dir_entries(trans, root, objectid, &btrfs_inode,
> -					 ext2_fs, ext2_ino);
> -		break;
> -	case S_IFLNK:
> -		ret = create_symbol_link(trans, root, objectid, &btrfs_inode,
> -					 ext2_fs, ext2_ino, ext2_inode);
> -		break;
> -	default:
> -		ret = 0;
> -		break;
> -	}
> -	if (ret)
> -		return ret;
> -
> -	if (!noxattr) {
> -		ret = copy_extended_attrs(trans, root, objectid, &btrfs_inode,
> -					  ext2_fs, ext2_ino);
> -		if (ret)
> -			return ret;
> -	}
> -	inode_key.objectid = objectid;
> -	inode_key.offset = 0;
> -	btrfs_set_key_type(&inode_key, BTRFS_INODE_ITEM_KEY);
> -	ret = btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
> -	return ret;
> -}
> -
>  static int copy_disk_extent(struct btrfs_root *root, u64 dst_bytenr,
>  		            u64 src_bytenr, u32 num_bytes)
>  {
> @@ -1388,61 +662,6 @@ fail:
>  		ret = -1;
>  	return ret;
>  }
> -/*
> - * scan ext2's inode bitmap and copy all used inode.
> - */
> -static int ext2_copy_inodes(struct convert_fs *fs, struct btrfs_root *root,
> -			    int datacsum, int packing, int noxattr)
> -{
> -	ext2_filsys ext2_fs = fs->privdata;
> -	int ret;
> -	errcode_t err;
> -	ext2_inode_scan ext2_scan;
> -	struct ext2_inode ext2_inode;
> -	ext2_ino_t ext2_ino;
> -	u64 objectid;
> -	struct btrfs_trans_handle *trans;
> -
> -	trans = btrfs_start_transaction(root, 1);
> -	if (!trans)
> -		return -ENOMEM;
> -	err = ext2fs_open_inode_scan(ext2_fs, 0, &ext2_scan);
> -	if (err) {
> -		fprintf(stderr, "ext2fs_open_inode_scan: %s\n", error_message(err));
> -		return -1;
> -	}
> -	while (!(err = ext2fs_get_next_inode(ext2_scan, &ext2_ino,
> -					     &ext2_inode))) {
> -		/* no more inodes */
> -		if (ext2_ino == 0)
> -			break;
> -		/* skip special inode in ext2fs */
> -		if (ext2_ino < EXT2_GOOD_OLD_FIRST_INO &&
> -		    ext2_ino != EXT2_ROOT_INO)
> -			continue;
> -		objectid = ext2_ino + INO_OFFSET;
> -		ret = copy_single_inode(trans, root,
> -					objectid, ext2_fs, ext2_ino,
> -					&ext2_inode, datacsum, packing,
> -					noxattr);
> -		if (ret)
> -			return ret;
> -		if (trans->blocks_used >= 4096) {
> -			ret = btrfs_commit_transaction(trans, root);
> -			BUG_ON(ret);
> -			trans = btrfs_start_transaction(root, 1);
> -			BUG_ON(!trans);
> -		}
> -	}
> -	if (err) {
> -		fprintf(stderr, "ext2fs_get_next_inode: %s\n", error_message(err));
> -		return -1;
> -	}
> -	ret = btrfs_commit_transaction(trans, root);
> -	BUG_ON(ret);
> -
> -	return ret;
> -}
>  
>  /*
>   * Construct a range of the image file.
> @@ -2586,26 +1805,6 @@ static int copy_dirtiness(struct extent_io_tree *out,
>  	return 0;
>  }
>  
> -int ext2_open(struct convert_fs *fs, const char *name)
> -{
> -	int ret;
> -	ext2_filsys ext2_fs;
> -	ret = open_ext2fs(name, &ext2_fs);
> -	if (ret)
> -		return ret;
> -
> -	fs->privdata = ext2_fs;
> -	fs->blocksize = ext2_fs->blocksize;
> -	fs->label = ext2_fs->super->s_volume_name;
> -	fs->total_bytes = ext2_fs->super->s_blocks_count * fs->blocksize;
> -
> -	fs->cache_free_extents = ext2_cache_free_extents;
> -	fs->close = ext2_close;
> -	fs->copy_inodes = ext2_copy_inodes;
> -
> -	return 0;
> -}
> -
>  static int open_fs(struct convert_fs *fs, const char *devname)
>  {
>  	static struct {
> diff --git a/convert/convert.h b/convert/convert.h
> new file mode 100644
> index 0000000..4f31775
> --- /dev/null
> +++ b/convert/convert.h
> @@ -0,0 +1,76 @@
> +/*
> + * Copyright (C) 2007 Oracle.  All rights reserved.
> + * Copyright (C) 2010 Sean Bartell.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +#ifndef BTRFS_CONVERT_H
> +#define BTRFS_CONVERT_H
> +
> +#include "ctree.h"
> +#include "kerncompat.h"
> +#include "transaction.h"
> +
> +struct convert_fs {
> +	u64 total_bytes;
> +	u64 blocksize;
> +	const char *label;
> +
> +	/* Close the FS */
> +	int (*close)(struct convert_fs *fs);
> +	/* Mark free extents as dirty */
> +	int (*cache_free_extents)(struct convert_fs *fs,
> +				  struct extent_io_tree *tree);
> +	/* Copy everything over */
> +	int (*copy_inodes)(struct convert_fs *fs, struct btrfs_root *root,
> +			   int datacsum, int packing, int noxattr);
> +
> +	void *privdata;
> +};
> +
> +int ext2_open(struct convert_fs *fs, const char *name);
> +
> +struct extent_iterate_data {
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_root *root;
> +	u64 *inode_nbytes;
> +	u64 objectid;
> +	int checksum, packing;
> +	u64 last_file_off;
> +	u64 total_size;
> +	enum {EXTENT_ITERATE_TYPE_NONE, EXTENT_ITERATE_TYPE_MEM,
> +	      EXTENT_ITERATE_TYPE_DISK} type;
> +	u64 size;
> +	u64 file_off; /* always aligned to sectorsize */
> +	char *data; /* for mem */
> +	u64 disk_off; /* for disk */
> +};
> +
> +int start_file_extents(struct extent_iterate_data *priv,
> +		       struct btrfs_trans_handle *trans,
> +		       struct btrfs_root *root, u64 *inode_nbytes,
> +		       u64 objectid, int checksum, int packing,
> +		       u64 total_size);
> +int start_file_extents_range(struct extent_iterate_data *priv,
> +			     struct btrfs_trans_handle *trans,
> +			     struct btrfs_root *root, u64 *inode_nbytes,
> +			     u64 objectid, int checksum, u64 start, u64 end);
> +int finish_file_extents(struct extent_iterate_data *priv);
> +int add_file_mem_extent(struct extent_iterate_data *priv, u64 file_off,
> +			u64 size, char *data);
> +int add_file_disk_extent(struct extent_iterate_data *priv, u64 file_off,
> +			 u64 disk_off, u64 size);
> +
> +#endif
> diff --git a/convert/ext2.c b/convert/ext2.c
> new file mode 100644
> index 0000000..7584701
> --- /dev/null
> +++ b/convert/ext2.c
> @@ -0,0 +1,791 @@
> +/*
> + * Copyright (C) 2007 Oracle.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <sys/stat.h>
> +#include <sys/acl.h>
> +#include <linux/fs.h>
> +#include "kerncompat.h"
> +#include "convert.h"
> +#include "ctree.h"
> +#include "disk-io.h"
> +#include "transaction.h"
> +#include <ext2fs/ext2_fs.h>
> +#include <ext2fs/ext2fs.h>
> +#include <ext2fs/ext2_ext_attr.h>
> +
> +#define INO_OFFSET (BTRFS_FIRST_FREE_OBJECTID - EXT2_ROOT_INO)
> +
> +/*
> + * Open Ext2fs in readonly mode, read block allocation bitmap and
> + * inode bitmap into memory.
> + */
> +static int open_ext2fs(const char *name, ext2_filsys *ret_fs)
> +{
> +	errcode_t ret;
> +	ext2_filsys ext2_fs;
> +	ext2_ino_t ino;
> +	ret = ext2fs_open(name, 0, 0, 0, unix_io_manager, &ext2_fs);
> +	if (ret) {
> +		fprintf(stderr, "ext2fs_open: %s\n", error_message(ret));
> +		goto fail;
> +	}
> +	ret = ext2fs_read_inode_bitmap(ext2_fs);
> +	if (ret) {
> +		fprintf(stderr, "ext2fs_read_inode_bitmap: %s\n",
> +			error_message(ret));
> +		goto fail;
> +	}
> +	ret = ext2fs_read_block_bitmap(ext2_fs);
> +	if (ret) {
> +		fprintf(stderr, "ext2fs_read_block_bitmap: %s\n",
> +			error_message(ret));
> +		goto fail;
> +	}
> +	/*
> +	 * search each block group for a free inode. this set up
> +	 * uninit block/inode bitmaps appropriately.
> +	 */
> +	ino = 1;
> +	while (ino <= ext2_fs->super->s_inodes_count) {
> +		ext2_ino_t foo;
> +		ext2fs_new_inode(ext2_fs, ino, 0, NULL, &foo);
> +		ino += EXT2_INODES_PER_GROUP(ext2_fs->super);
> +	}
> +
> +	*ret_fs = ext2_fs;
> +	return 0;
> +fail:
> +	return -1;
> +}
> +
> +static int ext2_close(struct convert_fs *fs)
> +{
> +	ext2fs_close((ext2_filsys)fs->privdata);
> +	return 0;
> +}
> +
> +static int ext2_cache_free_extents(struct convert_fs *fs,
> +				   struct extent_io_tree *free_tree)
> +{
> +	ext2_filsys ext2_fs = fs->privdata;
> +	int ret = 0;
> +	blk_t block;
> +	u64 bytenr;
> +	u64 blocksize = ext2_fs->blocksize;
> +
> +	block = ext2_fs->super->s_first_data_block;
> +	for (; block < ext2_fs->super->s_blocks_count; block++) {
> +		if (ext2fs_fast_test_block_bitmap(ext2_fs->block_map, block))
> +			continue;
> +		bytenr = block * blocksize;
> +		ret = set_extent_dirty(free_tree, bytenr,
> +				       bytenr + blocksize - 1, 0);
> +		BUG_ON(ret);
> +	}
> +
> +	return 0;
> +}
> +
> +struct dir_iterate_data {
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_root *root;
> +	struct btrfs_inode_item *inode;
> +	u64 objectid;
> +	u64 index_cnt;
> +	u64 parent;
> +	int errcode;
> +};
> +
> +static u8 filetype_conversion_table[EXT2_FT_MAX] = {
> +	[EXT2_FT_UNKNOWN]	= BTRFS_FT_UNKNOWN,
> +	[EXT2_FT_REG_FILE]	= BTRFS_FT_REG_FILE,
> +	[EXT2_FT_DIR]		= BTRFS_FT_DIR,
> +	[EXT2_FT_CHRDEV]	= BTRFS_FT_CHRDEV,
> +	[EXT2_FT_BLKDEV]	= BTRFS_FT_BLKDEV,
> +	[EXT2_FT_FIFO]		= BTRFS_FT_FIFO,
> +	[EXT2_FT_SOCK]		= BTRFS_FT_SOCK,
> +	[EXT2_FT_SYMLINK]	= BTRFS_FT_SYMLINK,
> +};
> +
> +static int dir_iterate_proc(ext2_ino_t dir, int entry,
> +			    struct ext2_dir_entry *old,
> +			    int offset, int blocksize,
> +			    char *buf,void *priv_data)
> +{
> +	int ret;
> +	int file_type;
> +	u64 objectid;
> +        u64 inode_size;
> +	char dotdot[] = "..";
> +	struct btrfs_key location;
> +	struct ext2_dir_entry_2 *dirent = (struct ext2_dir_entry_2 *)old;
> +	struct dir_iterate_data *idata = (struct dir_iterate_data *)priv_data;
> +
> +	objectid = dirent->inode + INO_OFFSET;
> +	if (!strncmp(dirent->name, dotdot, dirent->name_len)) {
> +		if (dirent->name_len == 2) {
> +			BUG_ON(idata->parent != 0);
> +			idata->parent = objectid;
> +		}
> +		return 0;
> +	}
> +	if (dirent->inode < EXT2_GOOD_OLD_FIRST_INO)
> +		return 0;
> +
> +	location.objectid = objectid;
> +	location.offset = 0;
> +	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
> +
> +	file_type = dirent->file_type;
> +	BUG_ON(file_type > EXT2_FT_SYMLINK);
> +	ret = btrfs_insert_dir_item(idata->trans, idata->root,
> +				    dirent->name, dirent->name_len,
> +				    idata->objectid, &location,
> +				    filetype_conversion_table[file_type],
> +				    idata->index_cnt);
> +	if (ret)
> +		goto fail;
> +	ret = btrfs_insert_inode_ref(idata->trans, idata->root,
> +				     dirent->name, dirent->name_len,
> +				     objectid, idata->objectid,
> +				     idata->index_cnt);
> +	if (ret)
> +		goto fail;
> +	idata->index_cnt++;
> +	inode_size = btrfs_stack_inode_size(idata->inode) +
> +		     dirent->name_len * 2;
> +	btrfs_set_stack_inode_size(idata->inode, inode_size);
> +	return 0;
> +fail:
> +	idata->errcode = ret;
> +	return BLOCK_ABORT;
> +}
> +
> +static int create_dir_entries(struct btrfs_trans_handle *trans,
> +			      struct btrfs_root *root, u64 objectid,
> +			      struct btrfs_inode_item *btrfs_inode,
> +			      ext2_filsys ext2_fs, ext2_ino_t ext2_ino)
> +{
> +	int ret;
> +	errcode_t err;
> +	struct dir_iterate_data data = {
> +		.trans		= trans,
> +		.root		= root,
> +		.inode		= btrfs_inode,
> +		.objectid	= objectid,
> +		.index_cnt	= 2,
> +		.parent		= 0,
> +		.errcode	= 0,
> +	};
> +
> +	err = ext2fs_dir_iterate2(ext2_fs, ext2_ino, 0, NULL,
> +				  dir_iterate_proc, &data);
> +	if (err)
> +		goto error;
> +	ret = data.errcode;
> +	if (ret == 0 && data.parent == objectid) {
> +		ret = btrfs_insert_inode_ref(trans, root, "..", 2,
> +					     objectid, objectid, 0);
> +	}
> +	return ret;
> +error:
> +	fprintf(stderr, "ext2fs_dir_iterate2: %s\n", error_message(err));
> +	return -1;
> +}
> +
> +static int __block_iterate_proc(ext2_filsys fs, blk_t *blocknr,
> +			        e2_blkcnt_t blockcnt, blk_t ref_block,
> +			        int ref_offset, void *priv_data)
> +{
> +	struct extent_iterate_data *idata;
> +	idata = (struct extent_iterate_data *)priv_data;
> +	u64 blocksize = fs->blocksize;
> +	int ret = add_file_disk_extent(idata, blocksize * blockcnt,
> +				       blocksize * *blocknr, blocksize);
> +	if (ret)
> +		return BLOCK_ABORT;
> +	return 0;
> +}
> +
> +/*
> + * traverse file's data blocks, record these data blocks as file extents.
> + */
> +static int create_file_extents(struct btrfs_trans_handle *trans,
> +			       struct btrfs_root *root, u64 objectid,
> +			       struct btrfs_inode_item *btrfs_inode,
> +			       ext2_filsys ext2_fs, ext2_ino_t ext2_ino,
> +			       int datacsum, int packing)
> +{
> +	int ret;
> +	errcode_t err;
> +	u64 inode_nbytes = 0;
> +	u64 inode_size = btrfs_stack_inode_size(btrfs_inode);
> +	struct extent_iterate_data data;
> +	ret = start_file_extents(&data, trans, root, &inode_nbytes, objectid,
> +				 datacsum, packing, inode_size);
> +	if (ret)
> +		return ret;
> +	err = ext2fs_block_iterate2(ext2_fs, ext2_ino, BLOCK_FLAG_DATA_ONLY,
> +				    NULL, __block_iterate_proc, &data);
> +	if (err)
> +		goto error;
> +	ret = finish_file_extents(&data);
> +	if (ret)
> +		return ret;
> +	btrfs_set_stack_inode_nbytes(btrfs_inode, inode_nbytes);
> +	return 0;
> +error:
> +	fprintf(stderr, "ext2fs_block_iterate2: %s\n", error_message(err));
> +	return -1;
> +}
> +
> +static int create_symbol_link(struct btrfs_trans_handle *trans,
> +			      struct btrfs_root *root, u64 objectid,
> +			      struct btrfs_inode_item *btrfs_inode,
> +			      ext2_filsys ext2_fs, ext2_ino_t ext2_ino,
> +			      struct ext2_inode *ext2_inode)
> +{
> +	int ret;
> +	char *pathname;
> +	u64 inode_size = btrfs_stack_inode_size(btrfs_inode);
> +	if (ext2fs_inode_data_blocks(ext2_fs, ext2_inode)) {
> +		btrfs_set_stack_inode_size(btrfs_inode, inode_size + 1);
> +		ret = create_file_extents(trans, root, objectid, btrfs_inode,
> +					  ext2_fs, ext2_ino, 1, 1);
> +		btrfs_set_stack_inode_size(btrfs_inode, inode_size);
> +		return ret;
> +	}
> +
> +	pathname = (char *)&(ext2_inode->i_block[0]);
> +	BUG_ON(pathname[inode_size] != 0);
> +	ret = btrfs_insert_inline_extent(trans, root, objectid, 0,
> +					 pathname, inode_size + 1);
> +	btrfs_set_stack_inode_nbytes(btrfs_inode, inode_size + 1);
> +	return ret;
> +}
> +
> +/*
> + * Following xattr/acl related codes are based on codes in
> + * fs/ext3/xattr.c and fs/ext3/acl.c
> + */
> +#define EXT2_XATTR_BHDR(ptr) ((struct ext2_ext_attr_header *)(ptr))
> +#define EXT2_XATTR_BFIRST(ptr) \
> +	((struct ext2_ext_attr_entry *)(EXT2_XATTR_BHDR(ptr) + 1))
> +#define EXT2_XATTR_IHDR(inode) \
> +	((struct ext2_ext_attr_header *) ((void *)(inode) + \
> +		EXT2_GOOD_OLD_INODE_SIZE + (inode)->i_extra_isize))
> +#define EXT2_XATTR_IFIRST(inode) \
> +	((struct ext2_ext_attr_entry *) ((void *)EXT2_XATTR_IHDR(inode) + \
> +		sizeof(EXT2_XATTR_IHDR(inode)->h_magic)))
> +
> +static int ext2_xattr_check_names(struct ext2_ext_attr_entry *entry,
> +				  const void *end)
> +{
> +	struct ext2_ext_attr_entry *next;
> +
> +	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> +		next = EXT2_EXT_ATTR_NEXT(entry);
> +		if ((void *)next >= end)
> +			return -EIO;
> +		entry = next;
> +	}
> +	return 0;
> +}
> +
> +static int ext2_xattr_check_block(const char *buf, size_t size)
> +{
> +	int error;
> +	struct ext2_ext_attr_header *header = EXT2_XATTR_BHDR(buf);
> +
> +	if (header->h_magic != EXT2_EXT_ATTR_MAGIC ||
> +	    header->h_blocks != 1)
> +		return -EIO;
> +	error = ext2_xattr_check_names(EXT2_XATTR_BFIRST(buf), buf + size);
> +	return error;
> +}
> +
> +static int ext2_xattr_check_entry(struct ext2_ext_attr_entry *entry,
> +				  size_t size)
> +{
> +	size_t value_size = entry->e_value_size;
> +
> +	if (entry->e_value_block != 0 || value_size > size ||
> +	    entry->e_value_offs + value_size > size)
> +		return -EIO;
> +	return 0;
> +}
> +
> +#define EXT2_ACL_VERSION	0x0001
> +
> +typedef struct {
> +	__le16		e_tag;
> +	__le16		e_perm;
> +	__le32		e_id;
> +} ext2_acl_entry;
> +
> +typedef struct {
> +	__le16		e_tag;
> +	__le16		e_perm;
> +} ext2_acl_entry_short;
> +
> +typedef struct {
> +	__le32		a_version;
> +} ext2_acl_header;
> +
> +static inline int ext2_acl_count(size_t size)
> +{
> +	ssize_t s;
> +	size -= sizeof(ext2_acl_header);
> +	s = size - 4 * sizeof(ext2_acl_entry_short);
> +	if (s < 0) {
> +		if (size % sizeof(ext2_acl_entry_short))
> +			return -1;
> +		return size / sizeof(ext2_acl_entry_short);
> +	} else {
> +		if (s % sizeof(ext2_acl_entry))
> +			return -1;
> +		return s / sizeof(ext2_acl_entry) + 4;
> +	}
> +}
> +
> +#define ACL_EA_VERSION		0x0002
> +
> +typedef struct {
> +	__le16		e_tag;
> +	__le16		e_perm;
> +	__le32		e_id;
> +} acl_ea_entry;
> +
> +typedef struct {
> +	__le32		a_version;
> +	acl_ea_entry	a_entries[0];
> +} acl_ea_header;
> +
> +static inline size_t acl_ea_size(int count)
> +{
> +	return sizeof(acl_ea_header) + count * sizeof(acl_ea_entry);
> +}
> +
> +static int ext2_acl_to_xattr(void *dst, const void *src,
> +			     size_t dst_size, size_t src_size)
> +{
> +	int i, count;
> +	const void *end = src + src_size;
> +	acl_ea_header *ext_acl = (acl_ea_header *)dst;
> +	acl_ea_entry *dst_entry = ext_acl->a_entries;
> +	ext2_acl_entry *src_entry;
> +
> +	if (src_size < sizeof(ext2_acl_header))
> +		goto fail;
> +	if (((ext2_acl_header *)src)->a_version !=
> +	    cpu_to_le32(EXT2_ACL_VERSION))
> +		goto fail;
> +	src += sizeof(ext2_acl_header);
> +	count = ext2_acl_count(src_size);
> +	if (count <= 0)
> +		goto fail;
> +
> +	BUG_ON(dst_size < acl_ea_size(count));
> +	ext_acl->a_version = cpu_to_le32(ACL_EA_VERSION);
> +	for (i = 0; i < count; i++, dst_entry++) {
> +		src_entry = (ext2_acl_entry *)src;
> +		if (src + sizeof(ext2_acl_entry_short) > end)
> +			goto fail;
> +		dst_entry->e_tag = src_entry->e_tag;
> +		dst_entry->e_perm = src_entry->e_perm;
> +		switch (le16_to_cpu(src_entry->e_tag)) {
> +		case ACL_USER_OBJ:
> +		case ACL_GROUP_OBJ:
> +		case ACL_MASK:
> +		case ACL_OTHER:
> +			src += sizeof(ext2_acl_entry_short);
> +			dst_entry->e_id = cpu_to_le32(ACL_UNDEFINED_ID);
> +			break;
> +		case ACL_USER:
> +		case ACL_GROUP:
> +			src += sizeof(ext2_acl_entry);
> +			if (src > end)
> +				goto fail;
> +			dst_entry->e_id = src_entry->e_id;
> +			break;
> +		default:
> +			goto fail;
> +		}
> +	}
> +	if (src != end)
> +		goto fail;
> +	return 0;
> +fail:
> +	return -EINVAL;
> +}
> +
> +static char *xattr_prefix_table[] = {
> +	[1] =	"user.",
> +	[2] =	"system.posix_acl_access",
> +	[3] =	"system.posix_acl_default",
> +	[4] =	"trusted.",
> +	[6] =	"security.",
> +};
> +
> +static int copy_single_xattr(struct btrfs_trans_handle *trans,
> +			     struct btrfs_root *root, u64 objectid,
> +			     struct ext2_ext_attr_entry *entry,
> +			     const void *data, u32 datalen)
> +{
> +	int ret = 0;
> +	int name_len;
> +	int name_index;
> +	void *databuf = NULL;
> +	char namebuf[XATTR_NAME_MAX + 1];
> +
> +	name_index = entry->e_name_index;
> +	if (name_index >= ARRAY_SIZE(xattr_prefix_table) ||
> +	    xattr_prefix_table[name_index] == NULL)
> +		return -EOPNOTSUPP;
> +	name_len = strlen(xattr_prefix_table[name_index]) +
> +		   entry->e_name_len;
> +	if (name_len >= sizeof(namebuf))
> +		return -ERANGE;
> +
> +	if (name_index == 2 || name_index == 3) {
> +		size_t bufsize = acl_ea_size(ext2_acl_count(datalen));
> +		databuf = malloc(bufsize);
> +		if (!databuf)
> +		       return -ENOMEM;
> +		ret = ext2_acl_to_xattr(databuf, data, bufsize, datalen);
> +		if (ret)
> +			goto out;
> +		data = databuf;
> +		datalen = bufsize;
> +	}
> +	strcpy(namebuf, xattr_prefix_table[name_index]);
> +	strncat(namebuf, EXT2_EXT_ATTR_NAME(entry), entry->e_name_len);
> +	if (name_len + datalen > BTRFS_LEAF_DATA_SIZE(root) -
> +	    sizeof(struct btrfs_item) - sizeof(struct btrfs_dir_item)) {
> +		fprintf(stderr, "skip large xattr on inode %Lu name %.*s\n",
> +			objectid - INO_OFFSET, name_len, namebuf);
> +		goto out;
> +	}
> +	ret = btrfs_insert_xattr_item(trans, root, namebuf, name_len,
> +				      data, datalen, objectid);
> +out:
> +	if (databuf)
> +		free(databuf);
> +	return ret;
> +}
> +
> +static int copy_extended_attrs(struct btrfs_trans_handle *trans,
> +			       struct btrfs_root *root, u64 objectid,
> +			       struct btrfs_inode_item *btrfs_inode,
> +			       ext2_filsys ext2_fs, ext2_ino_t ext2_ino)
> +{
> +	int ret = 0;
> +	int inline_ea = 0;
> +	errcode_t err;
> +	u32 datalen;
> +	u32 block_size = ext2_fs->blocksize;
> +	u32 inode_size = EXT2_INODE_SIZE(ext2_fs->super);
> +	struct ext2_inode_large *ext2_inode;
> +	struct ext2_ext_attr_entry *entry;
> +	void *data;
> +	char *buffer = NULL;
> +	char inode_buf[EXT2_GOOD_OLD_INODE_SIZE];
> +
> +	if (inode_size <= EXT2_GOOD_OLD_INODE_SIZE) {
> +		ext2_inode = (struct ext2_inode_large *)inode_buf;
> +	} else {
> +		ext2_inode = (struct ext2_inode_large *)malloc(inode_size);
> +		if (!ext2_inode)
> +		       return -ENOMEM;
> +	}
> +	err = ext2fs_read_inode_full(ext2_fs, ext2_ino, (void *)ext2_inode,
> +				     inode_size);
> +	if (err) {
> +		fprintf(stderr, "ext2fs_read_inode_full: %s\n",
> +			error_message(err));
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	if (ext2_ino > ext2_fs->super->s_first_ino &&
> +	    inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
> +		if (EXT2_GOOD_OLD_INODE_SIZE +
> +		    ext2_inode->i_extra_isize > inode_size) {
> +			ret = -EIO;
> +			goto out;
> +		}
> +		if (ext2_inode->i_extra_isize != 0 &&
> +		    EXT2_XATTR_IHDR(ext2_inode)->h_magic ==
> +		    EXT2_EXT_ATTR_MAGIC) {
> +			inline_ea = 1;
> +		}
> +	}
> +	if (inline_ea) {
> +		int total;
> +		void *end = (void *)ext2_inode + inode_size;
> +		entry = EXT2_XATTR_IFIRST(ext2_inode);
> +		total = end - (void *)entry;
> +		ret = ext2_xattr_check_names(entry, end);
> +		if (ret)
> +			goto out;
> +		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> +			ret = ext2_xattr_check_entry(entry, total);
> +			if (ret)
> +				goto out;
> +			data = (void *)EXT2_XATTR_IFIRST(ext2_inode) +
> +				entry->e_value_offs;
> +			datalen = entry->e_value_size;
> +			ret = copy_single_xattr(trans, root, objectid,
> +						entry, data, datalen);
> +			if (ret)
> +				goto out;
> +			entry = EXT2_EXT_ATTR_NEXT(entry);
> +		}
> +	}
> +
> +	if (ext2_inode->i_file_acl == 0)
> +		goto out;
> +
> +	buffer = malloc(block_size);
> +	if (!buffer) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	err = ext2fs_read_ext_attr(ext2_fs, ext2_inode->i_file_acl, buffer);
> +	if (err) {
> +		fprintf(stderr, "ext2fs_read_ext_attr: %s\n",
> +			error_message(err));
> +		ret = -1;
> +		goto out;
> +	}
> +	ret = ext2_xattr_check_block(buffer, block_size);
> +	if (ret)
> +		goto out;
> +
> +	entry = EXT2_XATTR_BFIRST(buffer);
> +	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
> +		ret = ext2_xattr_check_entry(entry, block_size);
> +		if (ret)
> +			goto out;
> +		data = buffer + entry->e_value_offs;
> +		datalen = entry->e_value_size;
> +		ret = copy_single_xattr(trans, root, objectid,
> +					entry, data, datalen);
> +		if (ret)
> +			goto out;
> +		entry = EXT2_EXT_ATTR_NEXT(entry);
> +	}
> +out:
> +	if (buffer != NULL)
> +		free(buffer);
> +	if ((void *)ext2_inode != inode_buf)
> +		free(ext2_inode);
> +	return ret;
> +}
> +#define MINORBITS	20
> +#define MKDEV(ma, mi)	(((ma) << MINORBITS) | (mi))
> +
> +static inline dev_t old_decode_dev(u16 val)
> +{
> +	return MKDEV((val >> 8) & 255, val & 255);
> +}
> +
> +static inline dev_t new_decode_dev(u32 dev)
> +{
> +	unsigned major = (dev & 0xfff00) >> 8;
> +	unsigned minor = (dev & 0xff) | ((dev >> 12) & 0xfff00);
> +	return MKDEV(major, minor);
> +}
> +
> +static int copy_inode_item(struct btrfs_inode_item *dst,
> +			   struct ext2_inode *src, u32 blocksize)
> +{
> +	btrfs_set_stack_inode_generation(dst, 1);
> +	btrfs_set_stack_inode_size(dst, src->i_size);
> +	btrfs_set_stack_inode_nbytes(dst, 0);
> +	btrfs_set_stack_inode_block_group(dst, 0);
> +	btrfs_set_stack_inode_nlink(dst, src->i_links_count);
> +	btrfs_set_stack_inode_uid(dst, src->i_uid | (src->i_uid_high << 16));
> +	btrfs_set_stack_inode_gid(dst, src->i_gid | (src->i_gid_high << 16));
> +	btrfs_set_stack_inode_mode(dst, src->i_mode);
> +	btrfs_set_stack_inode_rdev(dst, 0);
> +	btrfs_set_stack_inode_flags(dst, 0);
> +	btrfs_set_stack_timespec_sec(&dst->atime, src->i_atime);
> +	btrfs_set_stack_timespec_nsec(&dst->atime, 0);
> +	btrfs_set_stack_timespec_sec(&dst->ctime, src->i_ctime);
> +	btrfs_set_stack_timespec_nsec(&dst->ctime, 0);
> +	btrfs_set_stack_timespec_sec(&dst->mtime, src->i_mtime);
> +	btrfs_set_stack_timespec_nsec(&dst->mtime, 0);
> +	btrfs_set_stack_timespec_sec(&dst->otime, 0);
> +	btrfs_set_stack_timespec_nsec(&dst->otime, 0);
> +
> +	if (S_ISDIR(src->i_mode)) {
> +		btrfs_set_stack_inode_size(dst, 0);
> +		btrfs_set_stack_inode_nlink(dst, 1);
> +	}
> +	if (S_ISREG(src->i_mode)) {
> +		btrfs_set_stack_inode_size(dst, (u64)src->i_size_high << 32 |
> +					   (u64)src->i_size);
> +	}
> +	if (!S_ISREG(src->i_mode) && !S_ISDIR(src->i_mode) &&
> +	    !S_ISLNK(src->i_mode)) {
> +		if (src->i_block[0]) {
> +			btrfs_set_stack_inode_rdev(dst,
> +				old_decode_dev(src->i_block[0]));
> +		} else {
> +			btrfs_set_stack_inode_rdev(dst,
> +				new_decode_dev(src->i_block[1]));
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * copy a single inode. do all the required works, such as cloning
> + * inode item, creating file extents and creating directory entries.
> + */
> +static int copy_single_inode(struct btrfs_trans_handle *trans,
> +			     struct btrfs_root *root, u64 objectid,
> +			     ext2_filsys ext2_fs, ext2_ino_t ext2_ino,
> +			     struct ext2_inode *ext2_inode,
> +			     int datacsum, int packing, int noxattr)
> +{
> +	int ret;
> +	struct btrfs_key inode_key;
> +	struct btrfs_inode_item btrfs_inode;
> +
> +	if (ext2_inode->i_links_count == 0)
> +		return 0;
> +
> +	copy_inode_item(&btrfs_inode, ext2_inode, ext2_fs->blocksize);
> +	if (!datacsum && S_ISREG(ext2_inode->i_mode)) {
> +		u32 flags = btrfs_stack_inode_flags(&btrfs_inode) |
> +			    BTRFS_INODE_NODATASUM;
> +		btrfs_set_stack_inode_flags(&btrfs_inode, flags);
> +	}
> +
> +	switch (ext2_inode->i_mode & S_IFMT) {
> +	case S_IFREG:
> +		ret = create_file_extents(trans, root, objectid, &btrfs_inode,
> +					ext2_fs, ext2_ino, datacsum, packing);
> +		break;
> +	case S_IFDIR:
> +		ret = create_dir_entries(trans, root, objectid, &btrfs_inode,
> +					 ext2_fs, ext2_ino);
> +		break;
> +	case S_IFLNK:
> +		ret = create_symbol_link(trans, root, objectid, &btrfs_inode,
> +					 ext2_fs, ext2_ino, ext2_inode);
> +		break;
> +	default:
> +		ret = 0;
> +		break;
> +	}
> +	if (ret)
> +		return ret;
> +
> +	if (!noxattr) {
> +		ret = copy_extended_attrs(trans, root, objectid, &btrfs_inode,
> +					  ext2_fs, ext2_ino);
> +		if (ret)
> +			return ret;
> +	}
> +	inode_key.objectid = objectid;
> +	inode_key.offset = 0;
> +	btrfs_set_key_type(&inode_key, BTRFS_INODE_ITEM_KEY);
> +	ret = btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
> +	return ret;
> +}
> +
> +/*
> + * scan ext2's inode bitmap and copy all used inode.
> + */
> +static int ext2_copy_inodes(struct convert_fs *fs, struct btrfs_root *root,
> +			    int datacsum, int packing, int noxattr)
> +{
> +	ext2_filsys ext2_fs = fs->privdata;
> +	int ret;
> +	errcode_t err;
> +	ext2_inode_scan ext2_scan;
> +	struct ext2_inode ext2_inode;
> +	ext2_ino_t ext2_ino;
> +	u64 objectid;
> +	struct btrfs_trans_handle *trans;
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	if (!trans)
> +		return -ENOMEM;
> +	err = ext2fs_open_inode_scan(ext2_fs, 0, &ext2_scan);
> +	if (err) {
> +		fprintf(stderr, "ext2fs_open_inode_scan: %s\n", error_message(err));
> +		return -1;
> +	}
> +	while (!(err = ext2fs_get_next_inode(ext2_scan, &ext2_ino,
> +					     &ext2_inode))) {
> +		/* no more inodes */
> +		if (ext2_ino == 0)
> +			break;
> +		/* skip special inode in ext2fs */
> +		if (ext2_ino < EXT2_GOOD_OLD_FIRST_INO &&
> +		    ext2_ino != EXT2_ROOT_INO)
> +			continue;
> +		objectid = ext2_ino + INO_OFFSET;
> +		ret = copy_single_inode(trans, root,
> +					objectid, ext2_fs, ext2_ino,
> +					&ext2_inode, datacsum, packing,
> +					noxattr);
> +		if (ret)
> +			return ret;
> +		if (trans->blocks_used >= 4096) {
> +			ret = btrfs_commit_transaction(trans, root);
> +			BUG_ON(ret);
> +			trans = btrfs_start_transaction(root, 1);
> +			BUG_ON(!trans);
> +		}
> +	}
> +	if (err) {
> +		fprintf(stderr, "ext2fs_get_next_inode: %s\n", error_message(err));
> +		return -1;
> +	}
> +	ret = btrfs_commit_transaction(trans, root);
> +	BUG_ON(ret);
> +
> +	return ret;
> +}
> +
> +int ext2_open(struct convert_fs *fs, const char *name)
> +{
> +	int ret;
> +	ext2_filsys ext2_fs;
> +	ret = open_ext2fs(name, &ext2_fs);
> +	if (ret)
> +		return ret;
> +
> +	fs->privdata = ext2_fs;
> +	fs->blocksize = ext2_fs->blocksize;
> +	fs->label = ext2_fs->super->s_volume_name;
> +	fs->total_bytes = ext2_fs->super->s_blocks_count * fs->blocksize;
> +
> +	fs->cache_free_extents = ext2_cache_free_extents;
> +	fs->close = ext2_close;
> +	fs->copy_inodes = ext2_copy_inodes;
> +
> +	return 0;
> +}
> -- 
> 1.6.4.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
