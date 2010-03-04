From: James Cloos <cloos@jhcloos.com>
Subject: Re: 2.6.33 high cpu usage
Date: Thu, 04 Mar 2010 16:46:00 -0500
Message-ID: <m37hpriwun.fsf@lugabout.jhcloos.org>
References: <m3hboy3726.fsf@lugabout.jhcloos.org>
	<20100302195322.GA3201@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100302195322.GA3201@localhost.localdomain> (Josef Bacik's
	message of "Tue, 2 Mar 2010 14:53:23 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "J" =3D=3D Josef Bacik <josef@redhat.com> writes:

>> As you can see btrfs_find_space_cluster(), find_next_bit() and
>> find_next_zero_bit() use most of the sys cpu.  That patterns seems
>> to hold whenever I run perf top during such operations.

J> Ok well thats a bummer.  Would you mind trying this completely
J> untested and uncompiled patch :)?  I think we should probably not be
J> trying to use a bitmap unless theres quite a bit more free space in
J> it than what we need, since they can span 128mb, and instead of
J> cycling through the extent entries we should probably just search fo=
r
J> the next bitmap to make it simpler.

The patch did improve the CPU usage, at the expense of IO latency and
block/cache usage.

Just after booting, and with crond down so that nothing competed, I
tried a git pull in a not-too-stale clone of cairo; it took about 6=C2=BD
minutes of disk i/o before git-fetch actually grabbed anything across
the net; that filled the fs cache (ie, about =E2=85=93Gig usage).

Once that initial pain was over, everything I tried was much faster tha=
n
w/o the patch, until I restarted crond and let mail flow in.  With the
added paging pressure from uucico, uux, and all of postfix=E2=80=99s an=
d pgsql=E2=80=99s
processes the delays when operating on the btrfs fs were significant.

I do think, however, that they were still faster than w/o the patch.
But that is subjective.

The only dmesg differences were a single btrfs-transaction blocked for
more than 120s notice:

[  360.583097] INFO: task btrfs-transacti:2419 blocked for more than 12=
0 seconds.
[  360.583107] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
[  360.583117] btrfs-transac D d852d2e0     0  2419      2 0x00000000
[  360.583131]  d8510ee0 00000046 00000001 d852d2e0 c1022506 d8510ef8 d=
852d584 d852d2e0
[  360.583149]  da252000 dc7587a4 7fffffff d8510f3c c152761d d847265c d=
c7587a4 00000000
[  360.583166]  d8510f28 d8510f3c c11a66e8 00000000 d8510f3c c11d3d5f d=
c758800 dc7587a4
[  360.583184] Call Trace:
[  360.583209]  [<c1022506>] ? __dequeue_entity+0x26/0x50
[  360.583227]  [<c152761d>] schedule_timeout+0x14d/0x250
[  360.583244]  [<c11a66e8>] ? btrfs_run_delayed_refs+0xa8/0x220
[  360.583260]  [<c11d3d5f>] ? btrfs_run_ordered_operations+0x1bf/0x1f0
[  360.583275]  [<c11b76f0>] btrfs_commit_transaction+0x120/0x740
[  360.583290]  [<c104c950>] ? autoremove_wake_function+0x0/0x50
[  360.583305]  [<c11b21b3>] transaction_kthread+0x1b3/0x1e0
[  360.583317]  [<c1527133>] ? preempt_schedule+0x33/0x50
[  360.583328]  [<c11b2000>] ? transaction_kthread+0x0/0x1e0
[  360.583339]  [<c104c594>] kthread+0x74/0x80
[  360.583349]  [<c104c520>] ? kthread+0x0/0x80
[  360.583361]  [<c10032d6>] kernel_thread_helper+0x6/0x10

And this one line notice:

[  115.801909] device label bay0 devid 1 transid 5397 /dev/sdb2

which may have been at the point where I mounted /dev/sdb2 or may have
been during that first git-pull I mentioned above.  The 360s mark was
certainly during that git-pull.

There are also these notices in dmesg, but I see one of them in /var/lo=
g
from an earlier boot, w/o the patch, so they are only more frequent on
this boot, and therefore unlikely to be related.

[88411.762735] NOHZ: local_softirq_pending 100
[88981.762734] NOHZ: local_softirq_pending 100
[89046.762728] NOHZ: local_softirq_pending 100
[90970.827857] NOHZ: local_softirq_pending 100
[91012.053557] NOHZ: local_softirq_pending 100
[91615.113704] NOHZ: local_softirq_pending 100
[91673.078683] NOHZ: local_softirq_pending 100
[92107.399189] NOHZ: local_softirq_pending 100
[92440.915490] NOHZ: local_softirq_pending 100
[92447.485834] NOHZ: local_softirq_pending 100

All in all, the patch seems to be a progression.

The perf report of that first pull is below; top(1) showed i/o wait
rather than user or sys time during most of it:

# Samples: 11476
#
# Overhead    Command                    Shared Object  Symbol
# ........  .........  ...............................  ......
#
    28.08%  git-merge  [kernel]                         [k] btrfs_find_=
space_cluster
    22.39%  git-merge  [kernel]                         [k] find_next_b=
it
    10.49%        git  [kernel]                         [k] btrfs_find_=
space_cluster
     8.86%        git  [kernel]                         [k] find_next_b=
it
     8.58%  git-merge  [kernel]                         [k] find_next_z=
ero_bit
     3.57%        git  [kernel]                         [k] find_next_z=
ero_bit
     1.34%        git  libz.so.1.2.3                    [.] inflate_tab=
le
     1.25%        git  git                              [.] 0x000000000=
c01cf
     1.22%        git  libz.so.1.2.3                    [.] .L213
     0.76%        git  libz.so.1.2.3                    [.] inflate_fas=
t
     0.66%        git  libz.so.1.2.3                    [.] longest_mat=
ch
     0.64%  git-merge  libz.so.1.2.3                    [.] inflate_fas=
t
     0.55%        git  libz.so.1.2.3                    [.] adler32
     0.47%        git  libz.so.1.2.3                    [.] deflate_fas=
t
     0.45%        git  libz.so.1.2.3                    [.] compress_bl=
ock
     0.40%        git  libz.so.1.2.3                    [.] .L207
     0.30%        git  libz.so.1.2.3                    [.] .L208
     0.25%        git  [kernel]                         [k] get_page_fr=
om_freelist
     0.24%  git-merge  [kernel]                         [k] block_group=
_cache_tree_search
     0.20%  git-merge  libz.so.1.2.3                    [.] adler32
     0.20%        git  [kernel]                         [k] scsi_dispat=
ch_cmd
     0.18%        git  libz.so.1.2.3                    [.] fill_window
     0.17%  git-merge  git-merge                        [.] xdl_hash_re=
cord
     0.16%  git-merge  [kernel]                         [k] find_free_e=
xtent
     0.16%        git  libz.so.1.2.3                    [.] inflate
     0.14%  git-merge  [kernel]                         [k] test_range_=
bit
     0.14%  git-merge  [kernel]                         [k] find_extent=
_buffer
     0.14%        git  libc-2.11.so                     [.] _int_malloc
     0.13%  git-merge  [kernel]                         [k] generic_bin=
_search
     0.12%  git-merge  [kernel]                         [k] tree_search=
_offset
     0.12%  git-merge  [kernel]                         [k] scsi_dispat=
ch_cmd
     0.12%        git  libz.so.1.2.3                    [.] .L198
     0.11%  git-merge  [kernel]                         [k] read_extent=
_buffer
     0.10%  git-merge  git-merge                        [.] xdl_recmatc=
h
     0.10%  git-merge  [ehci_hcd]                       [k] 0x000000000=
03c25
     0.10%  git-merge  git-merge                        [.] xdl_prepare=
_ctx
     0.10%  git-merge  [kernel]                         [k] div64_u64
     0.09%  git-merge  [kernel]                         [k] btrfs_clear=
_path_blocking
     0.09%  git-merge  [kernel]                         [k] btrfs_searc=
h_slot
     0.09%  git-merge  [kernel]                         [k] btrfs_find_=
block_group
     0.08%  git-merge  git-merge                        [.] blk_SHA1_Bl=
ock
     0.08%  git-merge  [kernel]                         [k] get_page_fr=
om_freelist
     0.08%  git-merge  [kernel]                         [k] map_private=
_extent_buffer
     0.08%        git  libz.so.1.2.3                    [.] .L211
     0.08%        git  [kernel]                         [k] __do_softir=
q
     0.07%  git-merge  git-merge                        [.] xdl_prepare=
_env
     0.07%  git-merge  [kernel]                         [k] __do_softir=
q
     0.07%  git-merge  [kernel]                         [k] kmem_cache_=
alloc
     0.07%  git-merge  [kernel]                         [k] memmove
     0.07%        git  libz.so.1.2.3                    [.] pqdownheap
     0.07%        git  libz.so.1.2.3                    [.] .L212
     0.07%        git  [kernel]                         [k] generic_bin=
_search
     0.06%  git-merge  libc-2.11.so                     [.] __gconv_tra=
nsform_utf8_internal
     0.06%  git-merge  [kernel]                         [k] rb_next
     0.06%        git  libz.so.1.2.3                    [.] build_tree
     0.06%        git  libc-2.11.so                     [.] ____strtoul=
_l_internal
     0.06%        git  [kernel]                         [k] find_extent=
_buffer
     0.06%        git  [kernel]                         [k] div64_u64
     0.06%        git  [kernel]                         [k] do_page_fau=
lt
     0.05%  git-merge  [kernel]                         [k] alloc_exten=
t_buffer
     0.05%  git-merge  [kernel]                         [k] __lookup
     0.05%        git  [kernel]                         [k] kmem_cache_=
alloc
     0.05%        git  [kernel]                         [k] find_free_e=
xtent
     0.05%        git  [kernel]                         [k] test_range_=
bit
     0.05%        git  [kernel]                         [k] scsi_reques=
t_fn
     0.05%        git  [ehci_hcd]                       [k] 0x000000000=
03c25
     0.04%  git-merge  git-merge                        [.] index_name_=
pos
     0.04%  git-merge  [kernel]                         [k] set_extent_=
bit
     0.04%  git-merge  [kernel]                         [k] btrfs_alloc=
_from_cluster
     0.04%  git-merge  [kernel]                         [k] __make_requ=
est
     0.04%  git-merge  [kernel]                         [k] __copy_from=
_user_ll
     0.04%        git  libz.so.1.2.3                    [.] .L210
     0.04%        git  libc-2.11.so                     [.] _IO_vfprint=
f_internal
     0.04%        git  libc-2.11.so                     [.] memcpy
     0.04%        git  [kernel]                         [k] set_extent_=
bit
     0.04%        git  [kernel]                         [k] read_extent=
_buffer
     0.04%        git  [kernel]                         [k] map_private=
_extent_buffer
     0.04%        git  [kernel]                         [k] ata_sff_int=
errupt
     0.03%  git-merge  [kernel]                         [k] inode_init_=
once
     0.03%  git-merge  [kernel]                         [k] verify_pare=
nt_transid
     0.03%  git-merge  [kernel]                         [k] map_extent_=
buffer
     0.03%  git-merge  [kernel]                         [k] rb_prev
     0.03%        git  libz.so.1.2.3                    [.] .L206
     0.03%        git  libc-2.11.so                     [.] __GI___libc=
_malloc
     0.03%        git  [kernel]                         [k] unmap_vmas
     0.03%        git  [kernel]                         [k] unlock_up
     0.03%        git  [kernel]                         [k] btrfs_searc=
h_slot
     0.03%        git  [kernel]                         [k] set_state_p=
rivate
     0.03%        git  [kernel]                         [k] btrfs_retur=
n_cluster_to_free_space
     0.03%  git-merge  libc-2.11.so                     [.] _int_malloc
     0.03%  git-merge  libc-2.11.so                     [.] __ubp_memch=
r
     0.03%  git-merge  git-merge                        [.] cache_name_=
compare
     0.03%  git-merge  [kernel]                         [k] __dentry_op=
en
     0.03%  git-merge  [kernel]                         [k] link_path_w=
alk
     0.03%  git-merge  [kernel]                         [k] find_inode
     0.03%  git-merge  [kernel]                         [k] __mark_inod=
e_dirty
     0.03%  git-merge  [kernel]                         [k] read_block_=
for_search
     0.03%  git-merge  [kernel]                         [k] btrfs_put_b=
lock_group
     0.03%  git-merge  [kernel]                         [k] btrfs_alloc=
_inode
     0.03%  git-merge  [kernel]                         [k] btrfs_iget
     0.03%  git-merge  [kernel]                         [k] btrfs_try_s=
pin_lock
     0.03%  git-merge  [kernel]                         [k] btrfs_retur=
n_cluster_to_free_space
     0.03%        git  libc-2.11.so                     [.] __GI_memset
     0.03%        git  ld-2.11.so                       [.] do_lookup_x
     0.03%        git  [kernel]                         [k] __set_page_=
dirty_nobuffers
     0.03%        git  [kernel]                         [k] map_extent_=
buffer
     0.03%        git  [kernel]                         [k] btrfs_try_s=
pin_lock
     0.03%        git  [kernel]                         [k] tree_search=
_offset
     0.03%        git  [kernel]                         [k] rb_next
     0.03%        git  [kernel]                         [k] sha_transfo=
rm
     0.03%        git  [kernel]                         [k] __atomic_no=
tifier_call_chain
     0.03%        git                          8109368  [.] 0x000000081=
09368
     0.02%   git-pull  [kernel]                         [k] do_wp_page
     0.02%  git-merge  libz.so.1.2.3                    [.] inflate_tab=
le
     0.02%  git-merge  libc-2.11.so                     [.] __calloc
     0.02%  git-merge  libc-2.11.so                     [.] _int_reallo=
c
     0.02%  git-merge  libc-2.11.so                     [.] __GI_strlen
     0.02%  git-merge  libc-2.11.so                     [.] _dl_mcount_=
wrapper_check
     0.02%  git-merge  git-merge                        [.] ie_match_st=
at
     0.02%  git-merge  git-merge                        [.] nth_packed_=
object_offset
     0.02%  git-merge  git-merge                        [.] xdl_recs_cm=
p
     0.02%  git-merge  bash                             [.] set_line_mb=
state
     0.02%  git-merge  bash                             [.] T.696
     0.02%  git-merge  [kernel]                         [k] __wake_up_b=
it
     0.02%  git-merge  [kernel]                         [k] add_to_page=
_cache_lru
     0.02%  git-merge  [kernel]                         [k] __kmalloc
     0.02%  git-merge  [kernel]                         [k] d_alloc
     0.02%  git-merge  [kernel]                         [k] btrfs_relea=
se_path
     0.02%  git-merge  [kernel]                         [k] bin_search
     0.02%  git-merge  [kernel]                         [k] unlock_up
     0.02%  git-merge  [kernel]                         [k] block_group=
_cache_done
     0.02%  git-merge  [kernel]                         [k] run_one_del=
ayed_ref
     0.02%  git-merge  [kernel]                         [k] acls_after_=
inode_item
     0.02%  git-merge  [kernel]                         [k] btrfs_dir_d=
ata_len
     0.02%  git-merge  [kernel]                         [k] btrfs_item_=
offset
     0.02%  git-merge  [kernel]                         [k] insert_stat=
e
     0.02%  git-merge  [kernel]                         [k] unmap_exten=
t_buffer
     0.02%  git-merge  [kernel]                         [k] clear_exten=
t_bit
     0.02%  git-merge  [kernel]                         [k] memcmp_exte=
nt_buffer
     0.02%  git-merge  [kernel]                         [k] set_extent_=
buffer_dirty
     0.02%  git-merge  [kernel]                         [k] btrfs_clear=
_lock_blocking
     0.02%  git-merge  [kernel]                         [k] spin_unlock
     0.02%  git-merge  [kernel]                         [k] tree_insert
     0.02%  git-merge  [kernel]                         [k] scsi_reques=
t_fn
     0.02%        git  libz.so.1.2.3                    [.] send_tree
     0.02%        git  libz.so.1.2.3                    [.] inflateEnd
     0.02%        git  libz.so.1.2.3                    [.] .L201
     0.02%        git  libz.so.1.2.3                    [.] .L203
     0.02%        git  libz.so.1.2.3                    [.] .L190
     0.02%        git  libc-2.11.so                     [.] __i686.get_=
pc_thunk.bx
     0.02%        git  libc-2.11.so                     [.] _IO_getline=
_info
     0.02%        git  libc-2.11.so                     [.] _IO_getc
     0.02%        git  libc-2.11.so                     [.] _IO_default=
_xsputn_internal
     0.02%        git  libc-2.11.so                     [.] execvpe
     0.02%        git  libc-2.11.so                     [.] _dl_addr
     0.02%        git  [kernel]                         [k] T.1336
     0.02%        git  [kernel]                         [k] __rcu_read_=
unlock
     0.02%        git  [kernel]                         [k] release_pag=
es
     0.02%        git  [kernel]                         [k] do_wp_page
     0.02%        git  [kernel]                         [k] handle_mm_f=
ault
     0.02%        git  [kernel]                         [k] find_vma
     0.02%        git  [kernel]                         [k] inode_init_=
always
     0.02%        git  [kernel]                         [k] btrfs_clear=
_path_blocking
     0.02%        git  [kernel]                         [k] read_block_=
for_search
     0.02%        git  [kernel]                         [k] bin_search
     0.02%        git  [kernel]                         [k] __btrfs_cow=
_block
     0.02%        git  [kernel]                         [k] btrfs_alloc=
_free_block
     0.02%        git  [kernel]                         [k] __btrfs_end=
_transaction
     0.02%        git  [kernel]                         [k] __tree_sear=
ch
     0.02%        git  [kernel]                         [k] btrfs_set_d=
ir_data_len
     0.02%        git  [kernel]                         [k] radix_tree_=
lookup_slot
     0.02%        git  [kernel]                         [k] __lookup
     0.02%        git  [kernel]                         [k] rb_erase
     0.02%        git  [kernel]                         [k] rb_prev
     0.02%        git  [kernel]                         [k] memmove
     0.02%        git  [kernel]                         [k] copy_to_use=
r
     0.02%        git  [kernel]                         [k] conv_uni_to=
_pc
     0.01%      uname  libc-2.11.so                     [.] ptmalloc_in=
it
     0.01%      uname  [kernel]                         [k] sched_move_=
task
     0.01%         tr  libc-2.11.so                     [.] .L31
     0.01%         tr  [kernel]                         [k] __do_fault
     0.01%         tr  [kernel]                         [k] do_wp_page
     0.01%        sed  libc-2.11.so                     [.] __GI___libc=
_free
     0.01%        sed  libc-2.11.so                     [.] _getopt_int=
ernal_r
     0.01%        sed  ld-2.11.so                       [.] _dl_lookup_=
symbol_x
     0.01%        sed  ld-2.11.so                       [.] _dl_relocat=
e_object
     0.01%        sed  ld-2.11.so                       [.] _dl_check_m=
ap_versions
     0.01%        sed  ld-2.11.so                       [.] __i686.get_=
pc_thunk.bx
     0.01%        sed  [kernel]                         [k] handle_mm_f=
ault
     0.01%        sed  [kernel]                         [k] flush_old_e=
xec
     0.01%        sed  [kernel]                         [k] do_page_fau=
lt
     0.01%   git-pull  [kernel]                         [k] T.1336
     0.01%   git-pull  [kernel]                         [k] get_page_fr=
om_freelist
     0.01%   git-pull  [kernel]                         [k] generic_fil=
lattr
     0.01%   git-pull  [kernel]                         [k] acpi_pm_rea=
d
     0.01%  git-merge  libz.so.1.2.3                    [.] zcalloc
     0.01%  git-merge  libc-2.11.so                     [.] __i686.get_=
pc_thunk.bx
     0.01%  git-merge  libc-2.11.so                     [.] __gconv_fin=
d_transform
     0.01%  git-merge  libc-2.11.so                     [.] _IO_doalloc=
buf_internal
     0.01%  git-merge  libc-2.11.so                     [.] __GI___libc=
_free
     0.01%  git-merge  libc-2.11.so                     [.] __GI___libc=
_malloc
     0.01%  git-merge  libc-2.11.so                     [.] __GI_mbrtow=
c
     0.01%  git-merge  libc-2.11.so                     [.] __GI___lxst=
at64
     0.01%  git-merge  ld-2.11.so                       [.] do_lookup_x
     0.01%  git-merge  ld-2.11.so                       [.] strcmp
     0.01%  git-merge  git-merge                        [.] git_merge_c=
onfig
     0.01%  git-merge  git-merge                        [.] git_checkat=
tr
     0.01%  git-merge  git-merge                        [.] write_entry
     0.01%  git-merge  git-merge                        [.] is_bare_rep=
ository
     0.01%  git-merge  git-merge                        [.] patch_delta
     0.01%  git-merge  git-merge                        [.] df_name_com=
pare
     0.01%  git-merge  git-merge                        [.] write_index
     0.01%  git-merge  git-merge                        [.] add_index_e=
ntry
     0.01%  git-merge  git-merge                        [.] prepare_pac=
ked_git
     0.01%  git-merge  git-merge                        [.] cache_or_un=
pack_entry
     0.01%  git-merge  git-merge                        [.] traverse_tr=
ees
     0.01%  git-merge  git-merge                        [.] twoway_merg=
e
     0.01%  git-merge  git-merge                        [.] xmmap
     0.01%  git-merge  git-merge                        [.] xmalloc
     0.01%  git-merge  git-merge                        [.] xdi_diff
     0.01%  git-merge  git-merge                        [.] xdl_change_=
compact
     0.01%  git-merge  git-merge                        [.] xdl_guess_l=
ines
     0.01%  git-merge  bash                             [.] T.558
     0.01%  git-merge  bash                             [.] make_env_ar=
ray_from_var_list
     0.01%  git-merge  bash                             [.] buffered_ge=
tchar
     0.01%  git-merge  bash                             [.] parse_and_e=
xecute
     0.01%  git-merge  [kernel]                         [k] sysenter_pa=
st_esp
     0.01%  git-merge  [kernel]                         [k] acquire_con=
sole_sem
     0.01%  git-merge  [kernel]                         [k] sys_wait4
     0.01%  git-merge  [kernel]                         [k] finish_wait
     0.01%  git-merge  [kernel]                         [k] add_wait_qu=
eue
     0.01%  git-merge  [kernel]                         [k] down_read_t=
rylock
     0.01%  git-merge  [kernel]                         [k] up_read
     0.01%  git-merge  [kernel]                         [k] __call_rcu
     0.01%  git-merge  [kernel]                         [k] __rcu_read_=
unlock
     0.01%  git-merge  [kernel]                         [k] find_get_pa=
ge
     0.01%  git-merge  [kernel]                         [k] unlock_page
     0.01%  git-merge  [kernel]                         [k] __alloc_pag=
es_nodemask
     0.01%  git-merge  [kernel]                         [k] free_hot_co=
ld_page
     0.01%  git-merge  [kernel]                         [k] __pagevec_f=
ree
     0.01%  git-merge  [kernel]                         [k] __set_page_=
dirty_nobuffers
     0.01%  git-merge  [kernel]                         [k] ____pagevec=
_lru_add
     0.01%  git-merge  [kernel]                         [k] lru_add_dra=
in
     0.01%  git-merge  [kernel]                         [k] next_zones_=
zonelist
     0.01%  git-merge  [kernel]                         [k] unmap_vmas
     0.01%  git-merge  [kernel]                         [k] do_wp_page
     0.01%  git-merge  [kernel]                         [k] find_vma
     0.01%  git-merge  [kernel]                         [k] unmap_regio=
n
     0.01%  git-merge  [kernel]                         [k] blk_queue_b=
ounce
     0.01%  git-merge  [kernel]                         [k] slab_buffer=
_size
     0.01%  git-merge  [kernel]                         [k] kfree
     0.01%  git-merge  [kernel]                         [k] get_empty_f=
ilp
     0.01%  git-merge  [kernel]                         [k] create_writ=
e_pipe
     0.01%  git-merge  [kernel]                         [k] path_init
     0.01%  git-merge  [kernel]                         [k] getname
     0.01%  git-merge  [kernel]                         [k] _d_rehash
     0.01%  git-merge  [kernel]                         [k] d_instantia=
te
     0.01%  git-merge  [kernel]                         [k] __d_lookup
     0.01%  git-merge  [kernel]                         [k] dput
     0.01%  git-merge  [kernel]                         [k] inode_init_=
always
     0.01%  git-merge  [kernel]                         [k] mntput_no_e=
xpire
     0.01%  git-merge  [kernel]                         [k] locks_remov=
e_flock
     0.01%  git-merge  [kernel]                         [k] check_block
     0.01%  git-merge  [kernel]                         [k] btrfs_unloc=
k_up_safe
     0.01%  git-merge  [kernel]                         [k] btrfs_alloc=
_path
     0.01%  git-merge  [kernel]                         [k] btrfs_root_=
node
     0.01%  git-merge  [kernel]                         [k] btrfs_lock_=
root_node
     0.01%  git-merge  [kernel]                         [k] btrfs_heade=
r_nritems
     0.01%  git-merge  [kernel]                         [k] __btrfs_cow=
_block
     0.01%  git-merge  [kernel]                         [k] btrfs_del_i=
tems
     0.01%  git-merge  [kernel]                         [k] select_dela=
yed_ref
     0.01%  git-merge  [kernel]                         [k] pin_down_by=
tes
     0.01%  git-merge  [kernel]                         [k] __btrfs_fre=
e_extent
     0.01%  git-merge  [kernel]                         [k] run_cluster=
ed_refs
     0.01%  git-merge  [kernel]                         [k] check_ref_c=
leanup
     0.01%  git-merge  [kernel]                         [k] btrfs_reser=
ve_metadata_for_delalloc
     0.01%  git-merge  [kernel]                         [k] btrfs_looku=
p_dir_item
     0.01%  git-merge  [kernel]                         [k] btrfs_del_c=
sums
     0.01%  git-merge  [kernel]                         [k] btrfs_looku=
p_inode
     0.01%  git-merge  [kernel]                         [k] find_name_i=
n_backref
     0.01%  git-merge  [kernel]                         [k] btrfs_mark_=
buffer_dirty
     0.01%  git-merge  [kernel]                         [k] btrfs_trunc=
ate_inode_items
     0.01%  git-merge  [kernel]                         [k] inode_tree_=
add
     0.01%  git-merge  [kernel]                         [k] __tree_sear=
ch
     0.01%  git-merge  [kernel]                         [k] btrfs_item_=
size
     0.01%  git-merge  [kernel]                         [k] btrfs_times=
pec_sec
     0.01%  git-merge  [kernel]                         [k] btrfs_inode=
_gid
     0.01%  git-merge  [kernel]                         [k] btrfs_inode=
_uid
     0.01%  git-merge  [kernel]                         [k] btrfs_inode=
_generation
     0.01%  git-merge  [kernel]                         [k] btrfs_set_d=
ir_type
     0.01%  git-merge  [kernel]                         [k] btrfs_set_i=
tem_offset
     0.01%  git-merge  [kernel]                         [k] btrfs_set_i=
node_transid
     0.01%  git-merge  [kernel]                         [k] lock_extent
     0.01%  git-merge  [kernel]                         [k] memmove_ext=
ent_buffer
     0.01%  git-merge  [kernel]                         [k] write_exten=
t_buffer
     0.01%  git-merge  [kernel]                         [k] read_extent=
_buffer_pages
     0.01%  git-merge  [kernel]                         [k] __btrfs_map=
_block
     0.01%  git-merge  [kernel]                         [k] btrfs_map_b=
io
     0.01%  git-merge  [kernel]                         [k] btrfs_tree_=
lock
     0.01%  git-merge  [kernel]                         [k] btrfs_find_=
ref_cluster
     0.01%  git-merge  [kernel]                         [k] security_in=
ode_alloc
     0.01%  git-merge  [kernel]                         [k] security_in=
ode_permission
     0.01%  git-merge  [kernel]                         [k] blk_recount=
_segments
     0.01%  git-merge  [kernel]                         [k] _atomic_dec=
_and_lock
     0.01%  git-merge  [kernel]                         [k] prio_tree_r=
emove
     0.01%  git-merge  [kernel]                         [k] radix_tree_=
lookup_slot
     0.01%  git-merge  [kernel]                         [k] __rb_rotate=
_left
     0.01%  git-merge  [kernel]                         [k] __rb_rotate=
_right
     0.01%  git-merge  [kernel]                         [k] rb_insert_c=
olor
     0.01%  git-merge  [kernel]                         [k] rb_erase
     0.01%  git-merge  [kernel]                         [k] __copy_to_u=
ser_ll
     0.01%  git-merge  [kernel]                         [k] copy_to_use=
r
     0.01%  git-merge  [kernel]                         [k] get_random_=
int
     0.01%  git-merge  [kernel]                         [k] do_con_writ=
e
     0.01%  git-merge  [kernel]                         [k] ata_sff_int=
errupt
     0.01%  git-merge  [kernel]                         [k] mdio_ctrl_h=
w
     0.01%  git-merge  [kernel]                         [k] acpi_pm_rea=
d
     0.01%  git-merge  [kernel]                         [k] _cond_resch=
ed
     0.01%  git-merge  [kernel]                         [k] do_page_fau=
lt
     0.01%        git  libz.so.1.2.3                    [.] deflateRese=
t
     0.01%        git  libz.so.1.2.3                    [.] init_block
     0.01%        git  libz.so.1.2.3                    [.] inflateInit=
2_
     0.01%        git  libz.so.1.2.3                    [.] .L560
     0.01%        git  libz.so.1.2.3                    [.] .L202
     0.01%        git  libz.so.1.2.3                    [.] .L209
     0.01%        git  libz.so.1.2.3                    [.] .L204
     0.01%        git  libpthread-2.11.so               [.] __write_noc=
ancel
     0.01%        git  libpthread-2.11.so               [.] __recvfrom
     0.01%        git  libc-2.11.so                     [.] __gconv_tra=
nsform_utf8_internal
     0.01%        git  libc-2.11.so                     [.] _IO_no_init
     0.01%        git  libc-2.11.so                     [.] __GI___libc=
_free
     0.01%        git  libc-2.11.so                     [.] __GI_strcmp
     0.01%        git  libc-2.11.so                     [.] __GI_strrch=
r
     0.01%        git  libc-2.11.so                     [.] __strchrnul
     0.01%        git  libc-2.11.so                     [.] inet_pton4
     0.01%        git  ld-2.11.so                       [.] _dl_map_obj=
ect_from_fd
     0.01%        git  ld-2.11.so                       [.] _dl_cache_l=
ibcmp
     0.01%        git  ld-2.11.so                       [.] check_match=
=2E8476
     0.01%        git  ld-2.11.so                       [.] _dl_lookup_=
symbol_x
     0.01%        git  [kernel]                         [k] do_signal
     0.01%        git  [kernel]                         [k] mcount
     0.01%        git  [kernel]                         [k] do_set_thre=
ad_area
     0.01%        git  [kernel]                         [k] sched_move_=
task
     0.01%        git  [kernel]                         [k] copy_proces=
s
     0.01%        git  [kernel]                         [k] __wake_up_b=
it
     0.01%        git  [kernel]                         [k] prepare_cre=
ds
     0.01%        git  [kernel]                         [k] futex_wait
     0.01%        git  [kernel]                         [k] handle_IRQ_=
event
     0.01%        git  [kernel]                         [k] __rcu_read_=
lock
     0.01%        git  [kernel]                         [k] unlock_page
     0.01%        git  [kernel]                         [k] find_get_pa=
ges_tag
     0.01%        git  [kernel]                         [k] filemap_fau=
lt
     0.01%        git  [kernel]                         [k] zone_waterm=
ark_ok
     0.01%        git  [kernel]                         [k] __alloc_pag=
es_nodemask
     0.01%        git  [kernel]                         [k] free_hot_co=
ld_page
     0.01%        git  [kernel]                         [k] ____pagevec=
_lru_add
     0.01%        git  [kernel]                         [k] __lru_cache=
_add
     0.01%        git  [kernel]                         [k] put_page
     0.01%        git  [kernel]                         [k] invalidate_=
inode_page
     0.01%        git  [kernel]                         [k] __do_fault
     0.01%        git  [kernel]                         [k] vma_wants_w=
ritenotify
     0.01%        git  [kernel]                         [k] __vm_enough=
_memory
     0.01%        git  [kernel]                         [k] vma_adjust
     0.01%        git  [kernel]                         [k] do_brk
     0.01%        git  [kernel]                         [k] sys_brk
     0.01%        git  [kernel]                         [k] do_mmap_pgo=
ff
     0.01%        git  [kernel]                         [k] cache_alloc=
_refill
     0.01%        git  [kernel]                         [k] kmem_cache_=
alloc_notrace
     0.01%        git  [kernel]                         [k] vfs_read
     0.01%        git  [kernel]                         [k] drop_file_w=
rite_access
     0.01%        git  [kernel]                         [k] open_exec
     0.01%        git  [kernel]                         [k] vfs_mkdir
     0.01%        git  [kernel]                         [k] path_walk
     0.01%        git  [kernel]                         [k] do_filp_ope=
n
     0.01%        git  [kernel]                         [k] dput
     0.01%        git  [kernel]                         [k] wake_up_ino=
de
     0.01%        git  [kernel]                         [k] inode_init_=
once
     0.01%        git  [kernel]                         [k] __bio_add_p=
age
     0.01%        git  [kernel]                         [k] do_mpage_re=
adpage
     0.01%        git  [kernel]                         [k] __fsnotify_=
parent
     0.01%        git  [kernel]                         [k] elf_map
     0.01%        git  [kernel]                         [k] load_elf_bi=
nary
     0.01%        git  [kernel]                         [k] dtSearch
     0.01%        git  [kernel]                         [k] btrfs_unloc=
k_up_safe
     0.01%        git  [kernel]                         [k] btrfs_heade=
r_nritems
     0.01%        git  [kernel]                         [k] btrfs_del_i=
tems
     0.01%        git  [kernel]                         [k] block_group=
_cache_done
     0.01%        git  [kernel]                         [k] check_force=
_delalloc
     0.01%        git  [kernel]                         [k] select_dela=
yed_ref
     0.01%        git  [kernel]                         [k] btrfs_init_=
new_buffer
     0.01%        git  [kernel]                         [k] lookup_inli=
ne_extent_backref
     0.01%        git  [kernel]                         [k] pin_down_by=
tes
     0.01%        git  [kernel]                         [k] update_bloc=
k_group
     0.01%        git  [kernel]                         [k] btrfs_set_b=
uffer_uptodate
     0.01%        git  [kernel]                         [k] verify_pare=
nt_transid
     0.01%        git  [kernel]                         [k] btrfs_buffe=
r_uptodate
     0.01%        git  [kernel]                         [k] btrfs_set_e=
xtent_delalloc
     0.01%        git  [kernel]                         [k] btrfs_merge=
_bio_hook
     0.01%        git  [kernel]                         [k] btrfs_add_l=
ink
     0.01%        git  [kernel]                         [k] btrfs_set_b=
it_hook
     0.01%        git  [kernel]                         [k] btrfs_unlin=
k
     0.01%        git  [kernel]                         [k] dirty_and_r=
elease_pages
     0.01%        git  [kernel]                         [k] btrfs_file_=
write
     0.01%        git  [kernel]                         [k] lookup_exte=
nt_mapping
     0.01%        git  [kernel]                         [k] btrfs_file_=
extent_compression
     0.01%        git  [kernel]                         [k] btrfs_dir_n=
ame_len
     0.01%        git  [kernel]                         [k] btrfs_item_=
offset
     0.01%        git  [kernel]                         [k] btrfs_exten=
t_flags
     0.01%        git  [kernel]                         [k] btrfs_set_i=
tem_offset
     0.01%        git  [kernel]                         [k] btrfs_set_e=
xtent_refs
     0.01%        git  [kernel]                         [k] btrfs_set_i=
node_flags
     0.01%        git  [kernel]                         [k] btrfs_set_i=
node_rdev
     0.01%        git  [kernel]                         [k] btrfs_set_i=
node_nlink
     0.01%        git  [kernel]                         [k] btrfs_set_i=
node_transid
     0.01%        git  [kernel]                         [k] btrfs_find_=
ordered_sum
     0.01%        git  [kernel]                         [k] free_extent=
_buffer
     0.01%        git  [kernel]                         [k] alloc_exten=
t_state
     0.01%        git  [kernel]                         [k] set_extent_=
uptodate
     0.01%        git  [kernel]                         [k] lock_extent=
_bits
     0.01%        git  [kernel]                         [k] lock_extent
     0.01%        git  [kernel]                         [k] set_extent_=
buffer_dirty
     0.01%        git  [kernel]                         [k] clear_exten=
t_buffer_dirty
     0.01%        git  [kernel]                         [k] btrfs_map_b=
lock
     0.01%        git  [kernel]                         [k] btrfs_queue=
_worker
     0.01%        git  [kernel]                         [k] btrfs_clear=
_lock_blocking
     0.01%        git  [kernel]                         [k] btrfs_set_l=
ock_blocking
     0.01%        git  [kernel]                         [k] btrfs_tree_=
unlock
     0.01%        git  [kernel]                         [k] spin_unlock
     0.01%        git  [kernel]                         [k] add_delayed=
_tree_ref
     0.01%        git  [kernel]                         [k] security_in=
ode_permission
     0.01%        git  [kernel]                         [k] cap_inode_a=
lloc_security
     0.01%        git  [kernel]                         [k] shash_updat=
e_unaligned
     0.01%        git  [kernel]                         [k] chksum_upda=
te
     0.01%        git  [kernel]                         [k] get_request
     0.01%        git  [kernel]                         [k] __make_requ=
est
     0.01%        git  [kernel]                         [k] blk_recount=
_segments
     0.01%        git  [kernel]                         [k] rb_insert_c=
olor
     0.01%        git  [kernel]                         [k] strncmp
     0.01%        git  [kernel]                         [k] strnlen_use=
r
     0.01%        git  [kernel]                         [k] __copy_from=
_user_ll
     0.01%        git  [kernel]                         [k] get_random_=
bytes
     0.01%        git  [kernel]                         [k] process_ech=
oes
     0.01%        git  [kernel]                         [k] do_con_writ=
e
     0.01%        git  [kernel]                         [k] scsi_softir=
q_done
     0.01%        git  [kernel]                         [k] acpi_pm_rea=
d
     0.01%        git  [kernel]                         [k] skb_clone
     0.01%        git  [kernel]                         [k] ip_route_in=
put
     0.01%        git  [kernel]                         [k] tcp_sendmsg
     0.01%        git  [kernel]                         [k] preempt_sch=
edule
     0.01%        git  [kernel]                         [k] rwsem_down_=
failed_common
     0.01%   basename  libc-2.11.so                     [.] __gconv_tra=
nsform_utf8_internal
     0.01%   basename  [kernel]                         [k] bprm_mm_ini=
t
     0.01%   basename  [kernel]                         [k] radix_tree_=
lookup_slot
#
# (For a higher level overview, try: perf report --sort comm,dso)
#

-JimC
--=20
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
