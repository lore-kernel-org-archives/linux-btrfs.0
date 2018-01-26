Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:35093 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751824AbeAZTja (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 14:39:30 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 11/26] libbtrfsutil: add btrfs_util_create_snapshot()
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1516991902.git.osandov@fb.com>
 <ffe3cf7d259065bbce8e54b7a5bae5528faca3d0.1516991902.git.osandov@fb.com>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <4c742933-cc46-d93f-da34-5914296f2c8a@libero.it>
Date: Fri, 26 Jan 2018 20:31:06 +0100
MIME-Version: 1.0
In-Reply-To: <ffe3cf7d259065bbce8e54b7a5bae5528faca3d0.1516991902.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/26/2018 07:40 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>


Hi,

this is a great work; only few comments:
1) I found not intuitive the naming of the function: i.e. you have 

btrfs_util_create_snapshot()
btrfs_util_f_create_snapshot()

To me it seems more clear to have

btrfs_util_create_snapshot()
btrfs_util_create_snapshot_f()

I think that it is better move the 'f' at the end: at the begin you have the library "btrfs_util", in the middle you have the library function 'create_snapshot', at the end there is the function variant ('f', because it uses a file descriptor).

This is my opinion, even tough there are both examples like you (stat/fstat/lstat) and like my one (capt_get_fd/cap_get_file)...


2) I find the prefix 'btrfs_util_' a bit verbose. Why not a simple 'btrfs_', even at the cost of a possible renaming of the conflicting function in the current btrfs code.

3) regarding the btrfs_util_create_snapshot() function, I think that it would be useful to add some more information:
a) if used recursive is NOT atomic
b) if used recursive, root capabilities are needed

The same for the other functions: mark with a 'root required' tag all the functions which require the root capabilities.

BR
G.Baroncelli



> 
> Thanks to subvolume iterators, we can also implement recursive snapshot
> fairly easily.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  libbtrfsutil/btrfsutil.h                    |  55 +++++++++
>  libbtrfsutil/python/btrfsutilpy.h           |   1 +
>  libbtrfsutil/python/module.c                |  11 ++
>  libbtrfsutil/python/subvolume.c             |  49 ++++++++
>  libbtrfsutil/python/tests/test_qgroup.py    |  10 ++
>  libbtrfsutil/python/tests/test_subvolume.py |  55 +++++++++
>  libbtrfsutil/subvolume.c                    | 166 ++++++++++++++++++++++++++++
>  7 files changed, 347 insertions(+)
> 
> diff --git a/libbtrfsutil/btrfsutil.h b/libbtrfsutil/btrfsutil.h
> index 3f78a34d..829f72b2 100644
> --- a/libbtrfsutil/btrfsutil.h
> +++ b/libbtrfsutil/btrfsutil.h
> @@ -332,6 +332,61 @@ enum btrfs_util_error btrfs_util_f_create_subvolume(int parent_fd,
>  						    uint64_t *async_transid,
>  						    struct btrfs_util_qgroup_inherit *qgroup_inherit);
>  
> +/**
> + * BTRFS_UTIL_CREATE_SNAPSHOT_RECURSIVE - Also snapshot subvolumes beneath the
> + * source subvolume onto the same location on the new snapshot. Note that this
> + * modifies the newly-created snapshot, so it cannot be combined with
> + * %BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY.
> + */
> +#define BTRFS_UTIL_CREATE_SNAPSHOT_RECURSIVE (1 << 0)
> +/**
> + * BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY - Create a read-only snapshot.
> + */
> +#define BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY (1 << 1)
> +#define BTRFS_UTIL_CREATE_SNAPSHOT_MASK ((1 << 2) - 1)
> +
> +/**
> + * btrfs_util_create_snapshot() - Create a new snapshot from a source subvolume
> + * path.
> + * @source: Path of the existing subvolume to snapshot.
> + * @path: Where to create the snapshot.
> + * @flags: Bitmask of BTRFS_UTIL_CREATE_SNAPSHOT_* flags.
> + * @async_transid: See btrfs_util_create_subvolume(). If
> + * %BTRFS_UTIL_CREATE_SNAPSHOT_RECURSIVE was in @flags, then this will contain
> + * the largest transaction ID of all created subvolumes.
> + * @qgroup_inherit: See btrfs_util_create_subvolume().
> + *
> + * Return: %BTRFS_UTIL_OK on success, non-zero error code on failure.
> + */
> +enum btrfs_util_error btrfs_util_create_snapshot(const char *source,
> +						 const char *path, int flags,
> +						 uint64_t *async_transid,
> +						 struct btrfs_util_qgroup_inherit *qgroup_inherit);
> +
> +/**
> + * btrfs_util_f_create_snapshot() - See btrfs_util_create_snapshot().
> + */
> +enum btrfs_util_error btrfs_util_f_create_snapshot(int fd, const char *path,
> +						   int flags,
> +						   uint64_t *async_transid,
> +						   struct btrfs_util_qgroup_inherit *qgroup_inherit);
> +
> +/**
> + * btrfs_util_f2_create_snapshot() - Create a new snapshot from a source
> + * subvolume file descriptor and a target parent file descriptor and name.
> + * @fd: File descriptor of the existing subvolume to snapshot.
> + * @parent_fd: File descriptor of the parent directory where the snapshot should
> + * be created.
> + * @name: Name of the snapshot to create.
> + * @flags: See btrfs_util_create_snapshot().
> + * @async_transid: See btrfs_util_create_snapshot().
> + * @qgroup_inherit: See btrfs_util_create_snapshot().
> + */
> +enum btrfs_util_error btrfs_util_f2_create_snapshot(int fd, int parent_fd,
> +						    const char *name, int flags,
> +						    uint64_t *async_transid,
> +						    struct btrfs_util_qgroup_inherit *qgroup_inherit);
> +
>  struct btrfs_util_subvolume_iterator;
>  
>  /**
> diff --git a/libbtrfsutil/python/btrfsutilpy.h b/libbtrfsutil/python/btrfsutilpy.h
> index a9c15219..d552e416 100644
> --- a/libbtrfsutil/python/btrfsutilpy.h
> +++ b/libbtrfsutil/python/btrfsutilpy.h
> @@ -70,6 +70,7 @@ PyObject *set_subvolume_read_only(PyObject *self, PyObject *args, PyObject *kwds
>  PyObject *get_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
>  PyObject *set_default_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
>  PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds);
> +PyObject *create_snapshot(PyObject *self, PyObject *args, PyObject *kwds);
>  
>  void add_module_constants(PyObject *m);
>  
> diff --git a/libbtrfsutil/python/module.c b/libbtrfsutil/python/module.c
> index daf0747f..d8f797cb 100644
> --- a/libbtrfsutil/python/module.c
> +++ b/libbtrfsutil/python/module.c
> @@ -195,6 +195,17 @@ static PyMethodDef btrfsutil_methods[] = {
>  	 "path -- string, bytes, or path-like object\n"
>  	 "async -- create the subvolume without waiting for it to commit to\n"
>  	 "disk and return the transaction ID"},
> +	{"create_snapshot", (PyCFunction)create_snapshot,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "create_snapshot(source, path, recursive=False, read_only=False, async=False)\n\n"
> +	 "Create a new snapshot.\n\n"
> +	 "Arguments:\n"
> +	 "source -- string, bytes, path-like object, or open file descriptor\n"
> +	 "path -- string, bytes, or path-like object\n"
> +	 "recursive -- also snapshot child subvolumes\n"
> +	 "read_only -- create a read-only snapshot\n"
> +	 "async -- create the subvolume without waiting for it to commit to\n"
> +	 "disk and return the transaction ID"},
>  	{},
>  };
>  
> diff --git a/libbtrfsutil/python/subvolume.c b/libbtrfsutil/python/subvolume.c
> index 23163176..763a06d9 100644
> --- a/libbtrfsutil/python/subvolume.c
> +++ b/libbtrfsutil/python/subvolume.c
> @@ -347,6 +347,55 @@ PyObject *create_subvolume(PyObject *self, PyObject *args, PyObject *kwds)
>  		Py_RETURN_NONE;
>  }
>  
> +PyObject *create_snapshot(PyObject *self, PyObject *args, PyObject *kwds)
> +{
> +	static char *keywords[] = {
> +		"source", "path", "recursive", "read_only", "async",
> +		"qgroup_inherit", NULL,
> +	};
> +	struct path_arg src = {.allow_fd = true}, dst = {.allow_fd = false};
> +	enum btrfs_util_error err;
> +	int recursive = 0, read_only = 0, async = 0;
> +	int flags = 0;
> +	QgroupInherit *inherit = NULL;
> +	uint64_t transid;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args, kwds, "O&O&|pppO!:create_snapshot",
> +					 keywords, &path_converter, &src,
> +					 &path_converter, &dst, &recursive,
> +					 &read_only, &async,
> +					 &QgroupInherit_type, &inherit))
> +		return NULL;
> +
> +	if (recursive)
> +		flags |= BTRFS_UTIL_CREATE_SNAPSHOT_RECURSIVE;
> +	if (read_only)
> +		flags |= BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY;
> +
> +	if (src.path) {
> +		err = btrfs_util_create_snapshot(src.path, dst.path, flags,
> +						 async ? &transid : NULL,
> +						 inherit ? inherit->inherit : NULL);
> +	} else {
> +		err = btrfs_util_f_create_snapshot(src.fd, dst.path, flags,
> +						   async ? &transid : NULL,
> +						   inherit ? inherit->inherit : NULL);
> +	}
> +	if (err) {
> +		SetFromBtrfsUtilErrorWithPaths(err, &src, &dst);
> +		path_cleanup(&src);
> +		path_cleanup(&dst);
> +		return NULL;
> +	}
> +
> +	path_cleanup(&src);
> +	path_cleanup(&dst);
> +	if (async)
> +		return PyLong_FromUnsignedLongLong(transid);
> +	else
> +		Py_RETURN_NONE;
> +}
> +
>  typedef struct {
>  	PyObject_HEAD
>  	struct btrfs_util_subvolume_iterator *iter;
> diff --git a/libbtrfsutil/python/tests/test_qgroup.py b/libbtrfsutil/python/tests/test_qgroup.py
> index 19e6b05a..74fc46b6 100644
> --- a/libbtrfsutil/python/tests/test_qgroup.py
> +++ b/libbtrfsutil/python/tests/test_qgroup.py
> @@ -31,6 +31,16 @@ class TestQgroup(BtrfsTestCase):
>  
>          btrfsutil.create_subvolume(subvol, qgroup_inherit=inherit)
>  
> +    def test_snapshot_inherit(self):
> +        subvol = os.path.join(self.mountpoint, 'subvol')
> +        snapshot = os.path.join(self.mountpoint, 'snapshot')
> +
> +        inherit = btrfsutil.QgroupInherit()
> +        inherit.add_group(5)
> +
> +        btrfsutil.create_subvolume(subvol)
> +        btrfsutil.create_snapshot(subvol, snapshot, qgroup_inherit=inherit)
> +
>  
>  class TestQgroupInherit(unittest.TestCase):
>      def test_new(self):
> diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
> index b43beca7..2951154e 100644
> --- a/libbtrfsutil/python/tests/test_subvolume.py
> +++ b/libbtrfsutil/python/tests/test_subvolume.py
> @@ -129,6 +129,13 @@ class TestSubvolume(BtrfsTestCase):
>          self.assertEqual(info.stime, 0)
>          self.assertEqual(info.rtime, 0)
>  
> +        subvol_uuid = info.uuid
> +        snapshot = os.path.join(self.mountpoint, 'snapshot')
> +        btrfsutil.create_snapshot(subvol, snapshot)
> +
> +        info = btrfsutil.subvolume_info(snapshot)
> +        self.assertEqual(info.parent_uuid, subvol_uuid)
> +
>          # TODO: test received_uuid, stransid, rtransid, stime, and rtime
>  
>          for arg in self.path_or_fd(self.mountpoint):
> @@ -215,6 +222,54 @@ class TestSubvolume(BtrfsTestCase):
>          self.assertTrue(os.WIFEXITED(wstatus))
>          self.assertEqual(os.WEXITSTATUS(wstatus), 0)
>  
> +    def test_create_snapshot(self):
> +        subvol = os.path.join(self.mountpoint, 'subvol')
> +
> +        btrfsutil.create_subvolume(subvol)
> +        os.mkdir(os.path.join(subvol, 'dir'))
> +
> +        for i, arg in enumerate(self.path_or_fd(subvol)):
> +            with self.subTest(type=type(arg)):
> +                snapshots_dir = os.path.join(self.mountpoint, 'snapshots{}'.format(i))
> +                os.mkdir(snapshots_dir)
> +                snapshot = os.path.join(snapshots_dir, 'snapshot')
> +
> +                btrfsutil.create_snapshot(subvol, snapshot + '1')
> +                self.assertTrue(btrfsutil.is_subvolume(snapshot + '1'))
> +                self.assertTrue(os.path.exists(os.path.join(snapshot + '1', 'dir')))
> +
> +                btrfsutil.create_snapshot(subvol, (snapshot + '2').encode())
> +                self.assertTrue(btrfsutil.is_subvolume(snapshot + '2'))
> +                self.assertTrue(os.path.exists(os.path.join(snapshot + '2', 'dir')))
> +
> +                if HAVE_PATH_LIKE:
> +                    btrfsutil.create_snapshot(subvol, PurePath(snapshot + '3'))
> +                    self.assertTrue(btrfsutil.is_subvolume(snapshot + '3'))
> +                    self.assertTrue(os.path.exists(os.path.join(snapshot + '3', 'dir')))
> +
> +        nested_subvol = os.path.join(subvol, 'nested')
> +        more_nested_subvol = os.path.join(nested_subvol, 'more_nested')
> +        btrfsutil.create_subvolume(nested_subvol)
> +        btrfsutil.create_subvolume(more_nested_subvol)
> +        os.mkdir(os.path.join(more_nested_subvol, 'nested_dir'))
> +
> +        snapshot = os.path.join(self.mountpoint, 'snapshot')
> +
> +        btrfsutil.create_snapshot(subvol, snapshot + '1')
> +        # Dummy subvolume.
> +        self.assertEqual(os.stat(os.path.join(snapshot + '1', 'nested')).st_ino, 2)
> +        self.assertFalse(os.path.exists(os.path.join(snapshot + '1', 'nested', 'more_nested')))
> +
> +        btrfsutil.create_snapshot(subvol, snapshot + '2', recursive=True)
> +        self.assertTrue(os.path.exists(os.path.join(snapshot + '2', 'nested/more_nested/nested_dir')))
> +
> +        transid = btrfsutil.create_snapshot(subvol, snapshot + '3', recursive=True, async=True)
> +        self.assertTrue(os.path.exists(os.path.join(snapshot + '3', 'nested/more_nested/nested_dir')))
> +        self.assertGreater(transid, 0)
> +
> +        btrfsutil.create_snapshot(subvol, snapshot + '4', read_only=True)
> +        self.assertTrue(btrfsutil.get_subvolume_read_only(snapshot + '4'))
> +
>      def test_subvolume_iterator(self):
>          pwd = os.getcwd()
>          try:
> diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
> index 2fb4e59f..27f64657 100644
> --- a/libbtrfsutil/subvolume.c
> +++ b/libbtrfsutil/subvolume.c
> @@ -856,6 +856,172 @@ out_iter:
>  	return err;
>  }
>  
> +static enum btrfs_util_error snapshot_subvolume_children(int fd, int parent_fd,
> +							 const char *name,
> +							 uint64_t *async_transid)
> +{
> +	struct btrfs_util_subvolume_iterator *iter;
> +	enum btrfs_util_error err;
> +	int dstfd;
> +
> +	dstfd = openat(parent_fd, name, O_RDONLY);
> +	if (dstfd == -1)
> +		return BTRFS_UTIL_ERROR_OPEN_FAILED;
> +
> +	err = btrfs_util_f_create_subvolume_iterator(fd, 0, 0, &iter);
> +	if (err)
> +		goto out;
> +
> +	for (;;) {
> +		char child_name[BTRFS_SUBVOL_NAME_MAX + 1];
> +		char *child_path;
> +		int child_fd, new_parent_fd;
> +		uint64_t tmp_transid;
> +
> +		err = btrfs_util_subvolume_iterator_next(iter, &child_path,
> +							 NULL);
> +		if (err) {
> +			if (err == BTRFS_UTIL_ERROR_STOP_ITERATION)
> +				err = BTRFS_UTIL_OK;
> +			break;
> +		}
> +
> +		/* Remove the placeholder directory. */
> +		if (unlinkat(dstfd, child_path, AT_REMOVEDIR) == -1) {
> +			free(child_path);
> +			err = BTRFS_UTIL_ERROR_RMDIR_FAILED;
> +			break;
> +		}
> +
> +		child_fd = openat(fd, child_path, O_RDONLY);
> +		if (child_fd == -1) {
> +			free(child_path);
> +			err = BTRFS_UTIL_ERROR_OPEN_FAILED;
> +			break;
> +		}
> +
> +		err = openat_parent_and_name(dstfd, child_path, child_name,
> +					     sizeof(child_name),
> +					     &new_parent_fd);
> +		free(child_path);
> +		if (err) {
> +			SAVE_ERRNO_AND_CLOSE(child_fd);
> +			break;
> +		}
> +
> +		err = btrfs_util_f2_create_snapshot(child_fd, new_parent_fd,
> +						    child_name, 0,
> +						    async_transid ? &tmp_transid : NULL,
> +						    NULL);
> +		SAVE_ERRNO_AND_CLOSE(child_fd);
> +		SAVE_ERRNO_AND_CLOSE(new_parent_fd);
> +		if (err)
> +			break;
> +		if (async_transid && tmp_transid > *async_transid)
> +			*async_transid = tmp_transid;
> +	}
> +
> +	btrfs_util_destroy_subvolume_iterator(iter);
> +out:
> +	SAVE_ERRNO_AND_CLOSE(dstfd);
> +	return err;
> +}
> +
> +__attribute__((visibility("default")))
> +enum btrfs_util_error btrfs_util_create_snapshot(const char *source,
> +						 const char *path, int flags,
> +						 uint64_t *async_transid,
> +						 struct btrfs_util_qgroup_inherit *qgroup_inherit)
> +{
> +	enum btrfs_util_error err;
> +	int fd;
> +
> +	fd = open(source, O_RDONLY);
> +	if (fd == -1)
> +		return BTRFS_UTIL_ERROR_OPEN_FAILED;
> +
> +	err = btrfs_util_f_create_snapshot(fd, path, flags, async_transid,
> +					   qgroup_inherit);
> +	SAVE_ERRNO_AND_CLOSE(fd);
> +	return err;
> +}
> +
> +__attribute__((visibility("default")))
> +enum btrfs_util_error btrfs_util_f_create_snapshot(int fd, const char *path,
> +						   int flags,
> +						   uint64_t *async_transid,
> +						   struct btrfs_util_qgroup_inherit *qgroup_inherit)
> +{
> +	char name[BTRFS_SUBVOL_NAME_MAX + 1];
> +	enum btrfs_util_error err;
> +	int parent_fd;
> +
> +	err = openat_parent_and_name(AT_FDCWD, path, name, sizeof(name),
> +				     &parent_fd);
> +	if (err)
> +		return err;
> +
> +	err = btrfs_util_f2_create_snapshot(fd, parent_fd, name, flags,
> +					    async_transid, qgroup_inherit);
> +	SAVE_ERRNO_AND_CLOSE(parent_fd);
> +	return err;
> +}
> +
> +__attribute__((visibility("default")))
> +enum btrfs_util_error btrfs_util_f2_create_snapshot(int fd, int parent_fd,
> +						    const char *name, int flags,
> +						    uint64_t *async_transid,
> +						    struct btrfs_util_qgroup_inherit *qgroup_inherit)
> +{
> +	struct btrfs_ioctl_vol_args_v2 args = {.fd = fd};
> +	enum btrfs_util_error err;
> +	size_t len;
> +	int ret;
> +
> +	if ((flags & ~BTRFS_UTIL_CREATE_SNAPSHOT_MASK) ||
> +	    ((flags & BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY) &&
> +	     (flags & BTRFS_UTIL_CREATE_SNAPSHOT_RECURSIVE))) {
> +		errno = EINVAL;
> +		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
> +	}
> +
> +	if (flags & BTRFS_UTIL_CREATE_SNAPSHOT_READ_ONLY)
> +		args.flags |= BTRFS_SUBVOL_RDONLY;
> +	if (async_transid)
> +		args.flags |= BTRFS_SUBVOL_CREATE_ASYNC;
> +	if (qgroup_inherit) {
> +		args.flags |= BTRFS_SUBVOL_QGROUP_INHERIT;
> +		args.qgroup_inherit = (struct btrfs_qgroup_inherit *)qgroup_inherit;
> +		args.size = (sizeof(*args.qgroup_inherit) +
> +			     args.qgroup_inherit->num_qgroups *
> +			     sizeof(args.qgroup_inherit->qgroups[0]));
> +	}
> +
> +	len = strlen(name);
> +	if (len >= sizeof(args.name)) {
> +		errno = ENAMETOOLONG;
> +		return BTRFS_UTIL_ERROR_INVALID_ARGUMENT;
> +	}
> +	memcpy(args.name, name, len);
> +	args.name[len] = '\0';
> +
> +	ret = ioctl(parent_fd, BTRFS_IOC_SNAP_CREATE_V2, &args);
> +	if (ret == -1)
> +		return BTRFS_UTIL_ERROR_SUBVOL_CREATE_FAILED;
> +
> +	if (async_transid)
> +		*async_transid = args.transid;
> +
> +	if (flags & BTRFS_UTIL_CREATE_SNAPSHOT_RECURSIVE) {
> +		err = snapshot_subvolume_children(fd, parent_fd, name,
> +						  async_transid);
> +		if (err)
> +			return err;
> +	}
> +
> +	return BTRFS_UTIL_OK;
> +}
> +
>  __attribute__((visibility("default")))
>  void btrfs_util_destroy_subvolume_iterator(struct btrfs_util_subvolume_iterator *iter)
>  {
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
