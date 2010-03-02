From: James Cloos <cloos@jhcloos.com>
Subject: 2.6.33 high cpu usage
Date: Tue, 02 Mar 2010 13:35:21 -0500
Message-ID: <m3hboy3726.fsf@lugabout.jhcloos.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=

With the ATI bug I was hitting earlier fixed, only my btrfs partition
continues to show high cpu usage for some operations.

Rsync, git pull, git checkout and svn up are typicall operations which
trigger the high cpu usage.

As an example, this perf report is from using git checkout to change to
a new branch; the change needed to checkout 208 files out of about 1600
total files.  du(1) reports that the checkout is about 14 megs; the
alternates for that tree have about 60 megs of git packs.

As you can see btrfs_find_space_cluster(), find_next_bit() and
find_next_zero_bit() use most of the sys cpu.  That patterns seems to
hold whenever I run perf top during such operations.

Box is x86_32, pentium3m.


--=-=-=
Content-Disposition: inline; filename=mesh.report
Content-Description: perf report of git checkout --track ...

# Samples: 11372
#
# Overhead  Command       Shared Object  Symbol
# ........  .......  ..................  ......
#
    42.75%      git  [kernel]            [k] btrfs_find_space_cluster
    34.59%      git  [kernel]            [k] find_next_bit
    14.01%      git  [kernel]            [k] find_next_zero_bit
     0.76%      git  libz.so.1.2.3       [.] inflate_fast
     0.42%      git  [kernel]            [k] find_extent_buffer
     0.34%      git  [kernel]            [k] find_free_extent
     0.28%      git  git                 [.] blk_SHA1_Block
     0.26%      git  libz.so.1.2.3       [.] adler32
     0.26%      git  [kernel]            [k] test_range_bit
     0.23%      git  [kernel]            [k] scsi_dispatch_cmd
     0.22%      git  [kernel]            [k] div64_u64
     0.21%      git  [kernel]            [k] generic_bin_search
     0.20%      git  [kernel]            [k] __do_softirq
     0.16%      git  [kernel]            [k] get_page_from_freelist
     0.16%      git  [ehci_hcd]          [k] 0x00000000003c25
     0.15%      git  [kernel]            [k] read_extent_buffer
     0.14%      git  [kernel]            [k] btrfs_return_cluster_to_free_space
     0.12%      git  [kernel]            [k] btrfs_search_slot
     0.12%      git  [kernel]            [k] map_private_extent_buffer
     0.11%      git  [kernel]            [k] btrfs_clear_path_blocking
     0.11%      git  [kernel]            [k] set_extent_bit
     0.11%      git  [kernel]            [k] tree_search_offset
     0.11%      git  [kernel]            [k] __copy_from_user_ll
     0.11%      git  git                 [.] patch_delta
     0.08%      git  [kernel]            [k] kmem_cache_alloc
     0.08%      git  [kernel]            [k] btrfs_alloc_from_cluster
     0.08%      git  [kernel]            [k] memmove
     0.07%      git  [kernel]            [k] __queue_work
     0.07%      git  [kernel]            [k] __extent_read_full_page
     0.07%      git  [kernel]            [k] alloc_extent_buffer
     0.07%      git  [kernel]            [k] scsi_request_fn
     0.06%      git  libz.so.1.2.3       [.] inflate_table
     0.06%      git  [kernel]            [k] btrfs_unlock_up_safe
     0.06%      git  [kernel]            [k] memcpy_extent_buffer
     0.06%      git  [kernel]            [k] tree_insert
     0.06%      git  [kernel]            [k] __make_request
     0.05%      git  [kernel]            [k] block_group_cache_tree_search
     0.05%      git  [kernel]            [k] verify_parent_transid
     0.05%      git  [kernel]            [k] map_extent_buffer
     0.04%      git  [kernel]            [k] btrfs_header_nritems
     0.04%      git  [kernel]            [k] btrfs_tree_unlock
     0.04%      git  [kernel]            [k] do_page_fault
     0.04%      git  libz.so.1.2.3       [.] .L207
     0.04%      git  libz.so.1.2.3       [.] .L213
     0.04%      git  git                 [.] cache_name_compare
     0.04%      git  [kernel]            [k] __rcu_process_callbacks
     0.04%      git  [kernel]            [k] __set_page_dirty_nobuffers
     0.04%      git  [kernel]            [k] kmem_cache_alloc_notrace
     0.04%      git  [kernel]            [k] bin_search
     0.04%      git  [kernel]            [k] unlock_up
     0.04%      git  [kernel]            [k] btrfs_reserve_extent
     0.04%      git  [kernel]            [k] btrfs_item_offset
     0.04%      git  [kernel]            [k] unmap_extent_buffer
     0.04%      git  [kernel]            [k] radix_tree_lookup_slot
     0.04%      git  [kernel]            [k] __lookup
     0.04%      git  [kernel]            [k] rb_erase
     0.04%      git  [kernel]            [k] tcp_transmit_skb
     0.03%      git  libc-2.11.so        [.] _int_malloc
     0.03%      git  git                 [.] make_traverse_path
     0.03%      git  [kernel]            [k] __wake_up_bit
     0.03%      git  [kernel]            [k] handle_IRQ_event
     0.03%      git  [kernel]            [k] filemap_fault
     0.03%      git  [kernel]            [k] __remove_mapping
     0.03%      git  [kernel]            [k] __d_lookup
     0.03%      git  [kernel]            [k] btrfs_release_path
     0.03%      git  [kernel]            [k] btrfs_lock_root_node
     0.03%      git  [kernel]            [k] btrfs_put_block_group
     0.03%      git  [kernel]            [k] __btrfs_free_extent
     0.03%      git  [kernel]            [k] btrfs_mark_buffer_dirty
     0.03%      git  [kernel]            [k] inode_tree_add
     0.03%      git  [kernel]            [k] __tree_search
     0.03%      git  [kernel]            [k] btrfs_key_blockptr
     0.03%      git  [kernel]            [k] try_release_extent_buffer
     0.03%      git  [kernel]            [k] btrfs_tree_lock
     0.03%      git  [kernel]            [k] spin_unlock
     0.03%      git  [kernel]            [k] find_ref_head
     0.03%      git  [kernel]            [k] rb_next
     0.02%      git  libc-2.11.so        [.] _IO_vfprintf_internal
     0.02%      git  libc-2.11.so        [.] _IO_default_xsputn_internal
     0.02%      git  git                 [.] git_checkattr
     0.02%      git  git                 [.] df_name_compare
     0.02%      git  git                 [.] write_index
     0.02%      git  git                 [.] unpack_callback
     0.02%      git  git                 [.] twoway_merge
     0.02%      git  [vdso]              [.] 0x000000ffffe425
     0.02%      git  [kernel]            [k] check_for_new_grace_period
     0.02%      git  [kernel]            [k] __rcu_read_unlock
     0.02%      git  [kernel]            [k] unlock_page
     0.02%      git  [kernel]            [k] add_to_page_cache_locked
     0.02%      git  [kernel]            [k] release_pages
     0.02%      git  [kernel]            [k] unmap_vmas
     0.02%      git  [kernel]            [k] find_vma
     0.02%      git  [kernel]            [k] kfree
     0.02%      git  [kernel]            [k] fd_install
     0.02%      git  [kernel]            [k] pipe_read
     0.02%      git  [kernel]            [k] do_lookup
     0.02%      git  [kernel]            [k] link_path_walk
     0.02%      git  [kernel]            [k] dput
     0.02%      git  [kernel]            [k] inode_init_always
     0.02%      git  [kernel]            [k] find_inode
     0.02%      git  [kernel]            [k] __btrfs_cow_block
     0.02%      git  [kernel]            [k] btrfs_reduce_alloc_profile
     0.02%      git  [kernel]            [k] lookup_inline_extent_backref
     0.02%      git  [kernel]            [k] btree_read_extent_buffer_pages
     0.02%      git  [kernel]            [k] btrfs_inode_sequence
     0.02%      git  [kernel]            [k] free_extent_buffer
     0.02%      git  [kernel]            [k] merge_state
     0.02%      git  [kernel]            [k] insert_state
     0.02%      git  [kernel]            [k] clear_extent_bit
     0.02%      git  [kernel]            [k] write_extent_buffer
     0.02%      git  [kernel]            [k] btrfs_clear_lock_blocking
     0.02%      git  [kernel]            [k] security_inode_alloc
     0.02%      git  [kernel]            [k] chksum_update
     0.02%      git  [kernel]            [k] generic_make_request
     0.02%      git  [kernel]            [k] get_request
     0.02%      git  [kernel]            [k] yenta_interrupt
     0.02%      git  [kernel]            [k] acpi_pm_read
     0.01%      git  libz.so.1.2.3       [.] .L212
     0.01%      git  libz.so.1.2.3       [.] .L211
     0.01%      git  libc-2.11.so        [.] __GI_getenv
     0.01%      git  libc-2.11.so        [.] _itoa_word
     0.01%      git  libc-2.11.so        [.] __GI_fflush
     0.01%      git  libc-2.11.so        [.] __fopen_internal
     0.01%      git  libc-2.11.so        [.] __calloc
     0.01%      git  libc-2.11.so        [.] __GI_strlen
     0.01%      git  ld-2.11.so          [.] _dl_relocate_object
     0.01%      git  git                 [.] convert_to_working_tree
     0.01%      git  git                 [.] checkout_entry
     0.01%      git  git                 [.] add_name_hash
     0.01%      git  git                 [.] display
     0.01%      git  git                 [.] verify_path
     0.01%      git  git                 [.] ce_write
     0.01%      git  git                 [.] read_index_from
     0.01%      git  git                 [.] add_entry
     0.01%      git  git                 [.] git_inflate
     0.01%      git  [kernel]            [k] ptregs_execve
     0.01%      git  [kernel]            [k] run_timer_softirq
     0.01%      git  [kernel]            [k] mod_timer
     0.01%      git  [kernel]            [k] wake_up_bit
     0.01%      git  [kernel]            [k] prepare_to_wait
     0.01%      git  [kernel]            [k] __rcu_read_lock
     0.01%      git  [kernel]            [k] rcu_start_gp
     0.01%      git  [kernel]            [k] rcu_process_callbacks
     0.01%      git  [kernel]            [k] mempool_alloc
     0.01%      git  [kernel]            [k] __alloc_pages_nodemask
     0.01%      git  [kernel]            [k] free_hot_cold_page
     0.01%      git  [kernel]            [k] activate_page
     0.01%      git  [kernel]            [k] mark_page_accessed
     0.01%      git  [kernel]            [k] ____pagevec_lru_add
     0.01%      git  [kernel]            [k] __lru_cache_add
     0.01%      git  [kernel]            [k] lru_add_drain
     0.01%      git  [kernel]            [k] put_page
     0.01%      git  [kernel]            [k] invalidate_mapping_pages
     0.01%      git  [kernel]            [k] page_add_new_anon_rmap
     0.01%      git  [kernel]            [k] generic_fillattr
     0.01%      git  [kernel]            [k] cp_new_stat64
     0.01%      git  [kernel]            [k] path_init
     0.01%      git  [kernel]            [k] path_put
     0.01%      git  [kernel]            [k] path_to_nameidata
     0.01%      git  [kernel]            [k] path_walk
     0.01%      git  [kernel]            [k] do_unlinkat
     0.01%      git  [kernel]            [k] _d_rehash
     0.01%      git  [kernel]            [k] d_alloc
     0.01%      git  [kernel]            [k] hash
     0.01%      git  [kernel]            [k] iput
     0.01%      git  [kernel]            [k] inode_init_once
     0.01%      git  [kernel]            [k] clear_inode
     0.01%      git  [kernel]            [k] ifind
     0.01%      git  [kernel]            [k] bio_alloc_bioset
     0.01%      git  [kernel]            [k] locks_remove_posix
     0.01%      git  [kernel]            [k] dtSearch
     0.01%      git  [kernel]            [k] metapage_get_blocks
     0.01%      git  [kernel]            [k] check_block
     0.01%      git  [kernel]            [k] btrfs_set_path_blocking
     0.01%      git  [kernel]            [k] btrfs_alloc_path
     0.01%      git  [kernel]            [k] read_block_for_search
     0.01%      git  [kernel]            [k] update_ref_for_cow
     0.01%      git  [kernel]            [k] read_node_slot
     0.01%      git  [kernel]            [k] btrfs_leaf_free_space
     0.01%      git  [kernel]            [k] btrfs_insert_empty_items
     0.01%      git  [kernel]            [k] pin_down_bytes
     0.01%      git  [kernel]            [k] update_block_group
     0.01%      git  [kernel]            [k] run_one_delayed_ref
     0.01%      git  [kernel]            [k] btrfs_free_extent
     0.01%      git  [kernel]            [k] btrfs_find_block_group
     0.01%      git  [kernel]            [k] btrfs_lookup_dir_index_item
     0.01%      git  [kernel]            [k] btrfs_lookup_inode
     0.01%      git  [kernel]            [k] btrfs_find_tree_block
     0.01%      git  [kernel]            [k] btrfs_set_buffer_uptodate
     0.01%      git  [kernel]            [k] btrfs_find_create_tree_block
     0.01%      git  [kernel]            [k] btrfs_buffer_uptodate
     0.01%      git  [kernel]            [k] clean_tree_block
     0.01%      git  [kernel]            [k] wait_current_trans
     0.01%      git  [kernel]            [k] __btrfs_end_transaction
     0.01%      git  [kernel]            [k] start_transaction
     0.01%      git  [kernel]            [k] btrfs_set_page_dirty
     0.01%      git  [kernel]            [k] init_btrfs_i
     0.01%      git  [kernel]            [k] btrfs_merge_bio_hook
     0.01%      git  [kernel]            [k] btrfs_get_extent
     0.01%      git  [kernel]            [k] btrfs_add_link
     0.01%      git  [kernel]            [k] btrfs_delete_inode
     0.01%      git  [kernel]            [k] btrfs_clear_bit_hook
     0.01%      git  [kernel]            [k] lookup_extent_mapping
     0.01%      git  [kernel]            [k] btrfs_file_extent_num_bytes
     0.01%      git  [kernel]            [k] btrfs_dir_name_len
     0.01%      git  [kernel]            [k] btrfs_dir_data_len
     0.01%      git  [kernel]            [k] btrfs_key_generation
     0.01%      git  [kernel]            [k] btrfs_timespec_nsec
     0.01%      git  [kernel]            [k] btrfs_timespec_sec
     0.01%      git  [kernel]            [k] btrfs_inode_mode
     0.01%      git  [kernel]            [k] btrfs_inode_nbytes
     0.01%      git  [kernel]            [k] btrfs_set_item_size
     0.01%      git  [kernel]            [k] btrfs_set_item_offset
     0.01%      git  [kernel]            [k] btrfs_set_extent_flags
     0.01%      git  [kernel]            [k] btrfs_set_timespec_sec
     0.01%      git  [kernel]            [k] btrfs_set_inode_block_group
     0.01%      git  [kernel]            [k] extent_io_tree_init
     0.01%      git  [kernel]            [k] set_page_extent_mapped
     0.01%      git  [kernel]            [k] free_extent_state
     0.01%      git  [kernel]            [k] split_state
     0.01%      git  [kernel]            [k] spin_unlock
     0.01%      git  [kernel]            [k] memset_extent_buffer
     0.01%      git  [kernel]            [k] memcmp_extent_buffer
     0.01%      git  [kernel]            [k] extent_buffer_uptodate
     0.01%      git  [kernel]            [k] set_extent_buffer_uptodate
     0.01%      git  [kernel]            [k] __btrfs_map_block
     0.01%      git  [kernel]            [k] btrfs_map_bio
     0.01%      git  [kernel]            [k] bitmap_clear_bits
     0.01%      git  [kernel]            [k] btrfs_find_space_for_alloc
     0.01%      git  [kernel]            [k] btrfs_find_ref_cluster
     0.01%      git  [kernel]            [k] add_delayed_tree_ref
     0.01%      git  [kernel]            [k] cap_d_instantiate
     0.01%      git  [kernel]            [k] blk_rq_init
     0.01%      git  [kernel]            [k] radix_tree_lookup
     0.01%      git  [kernel]            [k] rb_insert_color
     0.01%      git  [kernel]            [k] rb_prev
     0.01%      git  [kernel]            [k] sha_transform
     0.01%      git  [kernel]            [k] strncpy_from_user
     0.01%      git  [kernel]            [k] copy_to_user
     0.01%      git  [kernel]            [k] tty_write
     0.01%      git  [kernel]            [k] __scsi_release_buffers
     0.01%      git  [kernel]            [k] scsi_io_completion
     0.01%      git  [kernel]            [k] ata_sff_interrupt
     0.01%      git  [kernel]            [k] mdio_ctrl_hw
     0.01%      git  [kernel]            [k] sock_alloc_send_pskb
     0.01%      git  [kernel]            [k] tcp_event_data_recv
     0.01%      git  [kernel]            [k] __tcp_select_window
     0.01%      git  [kernel]            [k] tcp_v4_send_check
     0.01%      git  [kernel]            [k] tcp_v4_rcv
     0.01%      git  [kernel]            [k] _cond_resched
     0.01%      git  [kernel]            [k] mutex_trylock
#
# (For a higher level overview, try: perf report --sort comm,dso)
#

--=-=-=


-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6

--=-=-=--
