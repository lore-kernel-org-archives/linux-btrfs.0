Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:48409 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750935AbeCRFLz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Mar 2018 01:11:55 -0400
Date: Sun, 18 Mar 2018 13:11:38 +0800
From: kbuild test robot <lkp@intel.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: kbuild-all@01.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] btrfs: Add unprivileged version of ino_lookup
 ioctl
Message-ID: <201803181320.828T4fCN%fengguang.wu@intel.com>
References: <64abe7b1-002d-33fd-f842-30bf72373327@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <64abe7b1-002d-33fd-f842-30bf72373327@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Tomohiro,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v4.16-rc5 next-20180316]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Misono-Tomohiro/btrfs-Add-three-new-unprivileged-ioctls-to-allow-normal-users-to-call-sub-list-show-etc/20180318-101013
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   fs/btrfs/ioctl.c:1561:9: sparse: incompatible types in comparison expression (different address spaces)
>> fs/btrfs/ioctl.c:2414:17: sparse: restricted __le64 degrades to integer
   fs/btrfs/ioctl.c:2538:21: sparse: incorrect type in assignment (different address spaces) @@    expected struct btrfs_ioctl_get_subvol_info_args [noderef] <asn:1>*subvol_info @@    got sn:1>*subvol_info @@
   fs/btrfs/ioctl.c:2538:21:    expected struct btrfs_ioctl_get_subvol_info_args [noderef] <asn:1>*subvol_info
   fs/btrfs/ioctl.c:2538:21:    got void *
   fs/btrfs/ioctl.c:2575:9: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *to @@    got unsigned char [noderef] <avoid *to @@
   fs/btrfs/ioctl.c:2575:9:    expected void *to
   fs/btrfs/ioctl.c:2575:9:    got unsigned char [noderef] <asn:1>*<noident>
   fs/btrfs/ioctl.c:2576:9: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *to @@    got unsigned char [noderef] <avoid *to @@
   fs/btrfs/ioctl.c:2576:9:    expected void *to
   fs/btrfs/ioctl.c:2576:9:    got unsigned char [noderef] <asn:1>*<noident>
   fs/btrfs/ioctl.c:2578:9: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *to @@    got unsigned char [noderef] <avoid *to @@
   fs/btrfs/ioctl.c:2578:9:    expected void *to
   fs/btrfs/ioctl.c:2578:9:    got unsigned char [noderef] <asn:1>*<noident>
   fs/btrfs/ioctl.c:2618:39: sparse: incorrect type in argument 2 (different address spaces) @@    expected void *dst @@    got char [noderef] <avoid *dst @@
   fs/btrfs/ioctl.c:2618:39:    expected void *dst
   fs/btrfs/ioctl.c:2618:39:    got char [noderef] <asn:1>*<noident>
   fs/btrfs/ioctl.c:2621:32: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const *from @@    got struct btrfs_ioctl_get_subvol_info_args [nodervoid const *from @@
   fs/btrfs/ioctl.c:2621:32:    expected void const *from
   fs/btrfs/ioctl.c:2621:32:    got struct btrfs_ioctl_get_subvol_info_args [noderef] <asn:1>*subvol_info
   fs/btrfs/ioctl.c:2625:16: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const *<noident> @@    got struct btrfs_ioctl_get_subvol_info_args [nodervoid const *<noident> @@
   fs/btrfs/ioctl.c:2625:16:    expected void const *<noident>
   fs/btrfs/ioctl.c:2625:16:    got struct btrfs_ioctl_get_subvol_info_args [noderef] <asn:1>*subvol_info
   fs/btrfs/ioctl.c:2653:18: sparse: incorrect type in assignment (different address spaces) @@    expected struct btrfs_ioctl_get_subvol_rootref_args [noderef] <asn:1>*rootrefs @@    got sn:1>*rootrefs @@
   fs/btrfs/ioctl.c:2653:18:    expected struct btrfs_ioctl_get_subvol_rootref_args [noderef] <asn:1>*rootrefs
   fs/btrfs/ioctl.c:2653:18:    got void *
   fs/btrfs/ioctl.c:2709:40: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const *from @@    got struct btrfs_ioctl_get_subvol_rootref_args [nodervoid const *from @@
   fs/btrfs/ioctl.c:2709:40:    expected void const *from
   fs/btrfs/ioctl.c:2709:40:    got struct btrfs_ioctl_get_subvol_rootref_args [noderef] <asn:1>*rootrefs
   fs/btrfs/ioctl.c:2714:15: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const *<noident> @@    got struct btrfs_ioctl_get_subvol_rootref_args [nodervoid const *<noident> @@
   fs/btrfs/ioctl.c:2714:15:    expected void const *<noident>
   fs/btrfs/ioctl.c:2714:15:    got struct btrfs_ioctl_get_subvol_rootref_args [noderef] <asn:1>*rootrefs
   fs/btrfs/ioctl.c:3208:24: sparse: incompatible types in comparison expression (different address spaces)
   fs/btrfs/ioctl.c:2570:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2572:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2573:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2581:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2582:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2583:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2585:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2586:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2587:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2589:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2590:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2591:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2593:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2594:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2595:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2607:29: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2609:17: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2612:17: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2665:22: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2690:33: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2696:42: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2697:42: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2708:17: sparse: dereference of noderef expression

vim +2414 fs/btrfs/ioctl.c

  2269	
  2270	static noinline int btrfs_search_path_in_tree_user(struct inode *inode,
  2271					struct btrfs_ioctl_ino_lookup_user_args *args)
  2272	{
  2273		struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
  2274		struct super_block *sb = inode->i_sb;
  2275		struct btrfs_key upper_limit = BTRFS_I(inode)->location;
  2276		u64 treeid = BTRFS_I(inode)->root->root_key.objectid;
  2277		u64 dirid = args->dirid;
  2278	
  2279		unsigned long item_off;
  2280		unsigned long item_len;
  2281		struct btrfs_inode_ref *iref;
  2282		struct btrfs_root_ref rref;
  2283		struct btrfs_root *root;
  2284		struct btrfs_path *path;
  2285		struct btrfs_key key, key2;
  2286		struct extent_buffer *l;
  2287		struct inode *temp_inode;
  2288		char *ptr;
  2289		int slot;
  2290		int len;
  2291		int total_len = 0;
  2292		int ret = -1;
  2293	
  2294		path = btrfs_alloc_path();
  2295		if (!path)
  2296			return -ENOMEM;
  2297	
  2298		/*
  2299		 * If the bottom subvolume does not exist directly under upper_limit,
  2300		 * construct the path in bottomup way.
  2301		 */
  2302		if (dirid != upper_limit.objectid) {
  2303			ptr = &args->path[BTRFS_INO_LOOKUP_USER_PATH_MAX - 1];
  2304	
  2305			key.objectid = treeid;
  2306			key.type = BTRFS_ROOT_ITEM_KEY;
  2307			key.offset = (u64)-1;
  2308			root = btrfs_read_fs_root_no_name(fs_info, &key);
  2309			if (IS_ERR(root)) {
  2310				ret = -ENOENT;
  2311				goto out;
  2312			}
  2313	
  2314			key.objectid = dirid;
  2315			key.type = BTRFS_INODE_REF_KEY;
  2316			key.offset = (u64)-1;
  2317			while (1) {
  2318				ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
  2319				if (ret < 0) {
  2320					goto out;
  2321				} else if (ret > 0) {
  2322					ret = btrfs_previous_item(root, path, dirid,
  2323								  BTRFS_INODE_REF_KEY);
  2324					if (ret < 0) {
  2325						goto out;
  2326					} else if (ret > 0) {
  2327						ret = -ENOENT;
  2328						goto out;
  2329					}
  2330				}
  2331	
  2332				l = path->nodes[0];
  2333				slot = path->slots[0];
  2334				btrfs_item_key_to_cpu(l, &key, slot);
  2335	
  2336				iref = btrfs_item_ptr(l, slot, struct btrfs_inode_ref);
  2337				len = btrfs_inode_ref_name_len(l, iref);
  2338				ptr -= len + 1;
  2339				total_len += len + 1;
  2340				if (ptr < args->path) {
  2341					ret = -ENAMETOOLONG;
  2342					goto out;
  2343				}
  2344	
  2345				*(ptr + len) = '/';
  2346				read_extent_buffer(l, ptr,
  2347				    (unsigned long)(iref + 1), len);
  2348	
  2349				/* Check the read+exec permission of this directory */
  2350				ret = btrfs_previous_item(root, path, dirid,
  2351							  BTRFS_INODE_ITEM_KEY);
  2352				if (ret < 0) {
  2353					goto out;
  2354				} else if (ret > 0) {
  2355					ret = -ENOENT;
  2356					goto out;
  2357				}
  2358	
  2359				l = path->nodes[0];
  2360				slot = path->slots[0];
  2361				btrfs_item_key_to_cpu(l, &key2, slot);
  2362				if (key2.objectid != dirid) {
  2363					ret = -ENOENT;
  2364					goto out;
  2365				}
  2366	
  2367				temp_inode = btrfs_iget(sb, &key2, root, NULL);
  2368				ret = inode_permission(temp_inode, MAY_READ | MAY_EXEC);
  2369				iput(temp_inode);
  2370				if (ret) {
  2371					ret = -EACCES;
  2372					goto out;
  2373				}
  2374	
  2375				if (key.offset == upper_limit.objectid)
  2376					break;
  2377				if (key.objectid == BTRFS_FIRST_FREE_OBJECTID) {
  2378					ret = -EACCES;
  2379					goto out;
  2380				}
  2381	
  2382				btrfs_release_path(path);
  2383				key.objectid = key.offset;
  2384				key.offset = (u64)-1;
  2385				dirid = key.objectid;
  2386			}
  2387	
  2388			memmove(args->path, ptr, total_len);
  2389			args->path[total_len] = '\0';
  2390			btrfs_release_path(path);
  2391		}
  2392	
  2393		/* get the bottom subolume's name from ROOT_REF */
  2394		root = fs_info->tree_root;
  2395		key.objectid = treeid;
  2396		key.type = BTRFS_ROOT_REF_KEY;
  2397		key.offset = args->subvolid;
  2398		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
  2399		if (ret < 0) {
  2400			goto out;
  2401		} else if (ret > 0) {
  2402			ret = -ENOENT;
  2403			goto out;
  2404		}
  2405	
  2406		l = path->nodes[0];
  2407		slot = path->slots[0];
  2408		btrfs_item_key_to_cpu(l, &key, slot);
  2409	
  2410		item_off = btrfs_item_ptr_offset(l, slot);
  2411		item_len = btrfs_item_size_nr(l, slot);
  2412		/* check if dirid in ROOT_REF corresponds to passed dirid */
  2413		read_extent_buffer(l, &rref, item_off, sizeof(struct btrfs_root_ref));
> 2414		if (rref.dirid != args->dirid) {
  2415			ret = -EINVAL;
  2416			goto out;
  2417		}
  2418	
  2419		/* copy subvolume's name */
  2420		item_off += sizeof(struct btrfs_root_ref);
  2421		item_len -= sizeof(struct btrfs_root_ref);
  2422		read_extent_buffer(l, args->name, item_off, item_len);
  2423		args->name[item_len] = '\0';
  2424	
  2425	out:
  2426		btrfs_free_path(path);
  2427		return ret;
  2428	}
  2429	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
