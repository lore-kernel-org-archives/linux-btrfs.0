Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:3975 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750789AbeCREqs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Mar 2018 00:46:48 -0400
Date: Sun, 18 Mar 2018 12:46:02 +0800
From: kbuild test robot <lkp@intel.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: kbuild-all@01.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] btrfs: Add unprivileged ioctl which returns
 subvolume's ROOT_REF
Message-ID: <201803181246.X9lPKysH%fengguang.wu@intel.com>
References: <fa0372b3-6fe7-9ce3-f073-9ad8dbe9ff95@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fa0372b3-6fe7-9ce3-f073-9ad8dbe9ff95@jp.fujitsu.com>
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
   fs/btrfs/ioctl.c:2336:21: sparse: incorrect type in assignment (different address spaces) @@    expected struct btrfs_ioctl_get_subvol_info_args [noderef] <asn:1>*subvol_info @@    got sn:1>*subvol_info @@
   fs/btrfs/ioctl.c:2336:21:    expected struct btrfs_ioctl_get_subvol_info_args [noderef] <asn:1>*subvol_info
   fs/btrfs/ioctl.c:2336:21:    got void *
   fs/btrfs/ioctl.c:2373:9: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *to @@    got unsigned char [noderef] <avoid *to @@
   fs/btrfs/ioctl.c:2373:9:    expected void *to
   fs/btrfs/ioctl.c:2373:9:    got unsigned char [noderef] <asn:1>*<noident>
   fs/btrfs/ioctl.c:2374:9: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *to @@    got unsigned char [noderef] <avoid *to @@
   fs/btrfs/ioctl.c:2374:9:    expected void *to
   fs/btrfs/ioctl.c:2374:9:    got unsigned char [noderef] <asn:1>*<noident>
   fs/btrfs/ioctl.c:2376:9: sparse: incorrect type in argument 1 (different address spaces) @@    expected void *to @@    got unsigned char [noderef] <avoid *to @@
   fs/btrfs/ioctl.c:2376:9:    expected void *to
   fs/btrfs/ioctl.c:2376:9:    got unsigned char [noderef] <asn:1>*<noident>
   fs/btrfs/ioctl.c:2416:39: sparse: incorrect type in argument 2 (different address spaces) @@    expected void *dst @@    got char [noderef] <avoid *dst @@
   fs/btrfs/ioctl.c:2416:39:    expected void *dst
   fs/btrfs/ioctl.c:2416:39:    got char [noderef] <asn:1>*<noident>
   fs/btrfs/ioctl.c:2419:32: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const *from @@    got struct btrfs_ioctl_get_subvol_info_args [nodervoid const *from @@
   fs/btrfs/ioctl.c:2419:32:    expected void const *from
   fs/btrfs/ioctl.c:2419:32:    got struct btrfs_ioctl_get_subvol_info_args [noderef] <asn:1>*subvol_info
   fs/btrfs/ioctl.c:2423:16: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const *<noident> @@    got struct btrfs_ioctl_get_subvol_info_args [nodervoid const *<noident> @@
   fs/btrfs/ioctl.c:2423:16:    expected void const *<noident>
   fs/btrfs/ioctl.c:2423:16:    got struct btrfs_ioctl_get_subvol_info_args [noderef] <asn:1>*subvol_info
>> fs/btrfs/ioctl.c:2451:18: sparse: incorrect type in assignment (different address spaces) @@    expected struct btrfs_ioctl_get_subvol_rootref_args [noderef] <asn:1>*rootrefs @@    got sn:1>*rootrefs @@
   fs/btrfs/ioctl.c:2451:18:    expected struct btrfs_ioctl_get_subvol_rootref_args [noderef] <asn:1>*rootrefs
   fs/btrfs/ioctl.c:2451:18:    got void *
>> fs/btrfs/ioctl.c:2507:40: sparse: incorrect type in argument 2 (different address spaces) @@    expected void const *from @@    got struct btrfs_ioctl_get_subvol_rootref_args [nodervoid const *from @@
   fs/btrfs/ioctl.c:2507:40:    expected void const *from
   fs/btrfs/ioctl.c:2507:40:    got struct btrfs_ioctl_get_subvol_rootref_args [noderef] <asn:1>*rootrefs
>> fs/btrfs/ioctl.c:2512:15: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const *<noident> @@    got struct btrfs_ioctl_get_subvol_rootref_args [nodervoid const *<noident> @@
   fs/btrfs/ioctl.c:2512:15:    expected void const *<noident>
   fs/btrfs/ioctl.c:2512:15:    got struct btrfs_ioctl_get_subvol_rootref_args [noderef] <asn:1>*rootrefs
   fs/btrfs/ioctl.c:3006:24: sparse: incompatible types in comparison expression (different address spaces)
   fs/btrfs/ioctl.c:2368:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2370:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2371:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2379:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2380:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2381:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2383:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2384:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2385:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2387:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2388:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2389:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2391:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2392:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2393:9: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2405:29: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2407:17: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2410:17: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2463:22: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2488:33: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2494:42: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2495:42: sparse: dereference of noderef expression
   fs/btrfs/ioctl.c:2506:17: sparse: dereference of noderef expression

vim +2451 fs/btrfs/ioctl.c

  2311	
  2312	/* Get the subvolume information in BTRFS_ROOT_ITEM and BTRFS_ROOT_BACKREF */
  2313	static noinline int btrfs_ioctl_get_subvol_info(struct file *file,
  2314						   void __user *argp)
  2315	{
  2316		struct btrfs_ioctl_get_subvol_info_args __user *subvol_info;
  2317		struct btrfs_root *root;
  2318		struct btrfs_path *path;
  2319		struct btrfs_key key;
  2320	
  2321		struct btrfs_root_item root_item;
  2322		struct btrfs_root_ref *rref;
  2323		struct extent_buffer *l;
  2324		int slot;
  2325	
  2326		unsigned long item_off;
  2327		unsigned long item_len;
  2328	
  2329		struct inode *inode;
  2330		int ret;
  2331	
  2332		path = btrfs_alloc_path();
  2333		if (!path)
  2334			return -ENOMEM;
  2335	
  2336		subvol_info = kzalloc(sizeof(*subvol_info), GFP_KERNEL);
  2337		if (!subvol_info) {
  2338			btrfs_free_path(path);
  2339			return -ENOMEM;
  2340		}
  2341		inode = file_inode(file);
  2342	
  2343		root = BTRFS_I(inode)->root->fs_info->tree_root;
  2344		key.objectid = BTRFS_I(inode)->root->root_key.objectid;
  2345		key.type = BTRFS_ROOT_ITEM_KEY;
  2346		key.offset = 0;
  2347		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
  2348		if (ret < 0) {
  2349			goto out;
  2350		} else if (ret > 0) {
  2351			/* If the subvolume is a snapshot, offset is not zero */
  2352			u64 objectid = key.objectid;
  2353	
  2354			btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
  2355			if (key.objectid != objectid ||
  2356			    key.type != BTRFS_ROOT_ITEM_KEY) {
  2357				ret = -ENOENT;
  2358				goto out;
  2359			}
  2360		}
  2361	
  2362		l = path->nodes[0];
  2363		slot = path->slots[0];
  2364		item_off = btrfs_item_ptr_offset(l, slot);
  2365		item_len = btrfs_item_size_nr(l, slot);
  2366		read_extent_buffer(l, &root_item, item_off, item_len);
  2367	
  2368		subvol_info->id = key.objectid;
  2369	
  2370		subvol_info->generation = btrfs_root_generation(&root_item);
  2371		subvol_info->flags = btrfs_root_flags(&root_item);
  2372	
  2373		memcpy(subvol_info->uuid, root_item.uuid, BTRFS_UUID_SIZE);
  2374		memcpy(subvol_info->parent_uuid, root_item.parent_uuid,
  2375							    BTRFS_UUID_SIZE);
  2376		memcpy(subvol_info->received_uuid, root_item.received_uuid,
  2377							    BTRFS_UUID_SIZE);
  2378	
  2379		subvol_info->ctransid = btrfs_root_ctransid(&root_item);
  2380		subvol_info->ctime.sec = btrfs_stack_timespec_sec(&root_item.ctime);
  2381		subvol_info->ctime.nsec = btrfs_stack_timespec_nsec(&root_item.ctime);
  2382	
  2383		subvol_info->otransid = btrfs_root_otransid(&root_item);
  2384		subvol_info->otime.sec = btrfs_stack_timespec_sec(&root_item.otime);
  2385		subvol_info->otime.nsec = btrfs_stack_timespec_nsec(&root_item.otime);
  2386	
  2387		subvol_info->stransid = btrfs_root_stransid(&root_item);
  2388		subvol_info->stime.sec = btrfs_stack_timespec_sec(&root_item.stime);
  2389		subvol_info->stime.nsec = btrfs_stack_timespec_nsec(&root_item.stime);
  2390	
  2391		subvol_info->rtransid = btrfs_root_rtransid(&root_item);
  2392		subvol_info->rtime.sec = btrfs_stack_timespec_sec(&root_item.rtime);
  2393		subvol_info->rtime.nsec = btrfs_stack_timespec_nsec(&root_item.rtime);
  2394	
  2395		btrfs_release_path(path);
  2396		key.type = BTRFS_ROOT_BACKREF_KEY;
  2397		key.offset = 0;
  2398		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
  2399		if (ret < 0)
  2400			goto out;
  2401	
  2402		l = path->nodes[0];
  2403		slot = path->slots[0];
  2404		btrfs_item_key_to_cpu(l, &key, slot);
  2405		if (key.objectid == subvol_info->id &&
  2406				key.type == BTRFS_ROOT_BACKREF_KEY){
  2407			subvol_info->parent_id = key.offset;
  2408	
  2409			rref = btrfs_item_ptr(l, slot, struct btrfs_root_ref);
  2410			subvol_info->dirid = btrfs_root_ref_dirid(l, rref);
  2411	
  2412			item_off = btrfs_item_ptr_offset(l, slot)
  2413					+ sizeof(struct btrfs_root_ref);
  2414			item_len = btrfs_item_size_nr(l, slot)
  2415					- sizeof(struct btrfs_root_ref);
> 2416			read_extent_buffer(l, subvol_info->name, item_off, item_len);
  2417		}
  2418	
> 2419		if (copy_to_user(argp, subvol_info, sizeof(*subvol_info)))
  2420			ret = -EFAULT;
  2421	
  2422	out:
> 2423		kzfree(subvol_info);
  2424		btrfs_free_path(path);
  2425		return ret;
  2426	}
  2427	
  2428	/* Returns ROOT_REF information of the subvolume contining this inode. */
  2429	static noinline int btrfs_ioctl_get_subvol_rootref(struct file *file,
  2430						   void __user *argp)
  2431	{
  2432		struct btrfs_ioctl_get_subvol_rootref_args __user *rootrefs;
  2433		struct btrfs_root_ref *rref;
  2434		struct btrfs_root *root;
  2435		struct btrfs_path *path;
  2436		struct btrfs_key key;
  2437	
  2438		struct extent_buffer *l;
  2439		int slot;
  2440	
  2441		struct inode *inode;
  2442		int i, nritems;
  2443		int ret;
  2444		u64 objectid;
  2445		u8 found;
  2446	
  2447		path = btrfs_alloc_path();
  2448		if (!path)
  2449			return -ENOMEM;
  2450	
> 2451		rootrefs = memdup_user(argp, sizeof(*rootrefs));
  2452		if (!rootrefs) {
  2453			btrfs_free_path(path);
  2454			return -ENOMEM;
  2455		}
  2456	
  2457		inode = file_inode(file);
  2458		root = BTRFS_I(inode)->root->fs_info->tree_root;
  2459		objectid = BTRFS_I(inode)->root->root_key.objectid;
  2460	
  2461		key.objectid = objectid;
  2462		key.type = BTRFS_ROOT_REF_KEY;
  2463		key.offset = rootrefs->min_id;
  2464		found = 0;
  2465		while (1) {
  2466			ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
  2467			if (ret < 0)
  2468				goto out;
  2469	
  2470			l = path->nodes[0];
  2471			slot = path->slots[0];
  2472			nritems = btrfs_header_nritems(l);
  2473			if (nritems - slot == 0) {
  2474				ret = 0;
  2475				goto out;
  2476			}
  2477	
  2478			for (i = slot; i < nritems; i++) {
  2479				btrfs_item_key_to_cpu(l, &key, i);
  2480				if (key.objectid != objectid ||
  2481						key.type != BTRFS_ROOT_REF_KEY) {
  2482					ret = 0;
  2483					goto out;
  2484				}
  2485	
  2486				if (found == BTRFS_MAX_ROOTREF_BUFFER_NUM) {
  2487					/* update min_id for next search */
  2488					rootrefs->min_id = key.offset;
  2489					ret = -EOVERFLOW;
  2490					goto out;
  2491				}
  2492	
  2493				rref = btrfs_item_ptr(l, i, struct btrfs_root_ref);
  2494				rootrefs->rootref[found].subvolid = key.offset;
  2495				rootrefs->rootref[found].dirid =
  2496						  btrfs_root_ref_dirid(l, rref);
  2497				found++;
  2498			}
  2499	
  2500			btrfs_release_path(path);
  2501			key.offset++;
  2502		}
  2503	
  2504	out:
  2505		if (!ret || ret == -EOVERFLOW) {
  2506			rootrefs->num_items = found;
> 2507			if (copy_to_user(argp, rootrefs, sizeof(*rootrefs)))
  2508				ret = -EFAULT;
  2509		}
  2510	
  2511		btrfs_free_path(path);
> 2512		kfree(rootrefs);
  2513	
  2514		return ret;
  2515	}
  2516	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
