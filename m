Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44599 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbcGOAgO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jul 2016 20:36:14 -0400
Date: Thu, 14 Jul 2016 17:40:12 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: New btrfs sub command: btrfs inspect physical-find
Message-ID: <20160715004012.GB16232@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <7c20be09-1ac2-1d1f-f545-e2d56578a77b@libero.it>
 <20160714230500.GA16232@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160714230500.GA16232@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 14, 2016 at 04:05:00PM -0700, Liu Bo wrote:
> On Tue, Jul 12, 2016 at 11:40:13PM +0200, Goffredo Baroncelli wrote:
> > Hi All,
> > 
> > the enclosed patch adds a new btrfs sub command: "btrfs inspect physical-find". The aim of this new command is to show the physical placement on the disk of a file. Currently it handles all the profiles (single, dup, raid1/10/5/6). 
> > I develop this command in order to show some bug in btrfs RAID5 profile (see next email).
> > 
> > You can pull the code from:
> > 
> >  	https://github.com/kreijack/btrfs-progs.git
> > 
> > branch
> > 
> > 	insp-phy
> 
> The tool looks similar to the existing 'btrfs-map-logical', yes,
> btrfs-map-logical has some problems on raid56, and a quick glance shows
> that it's due to that btrfs_num_copies() can only return 2 copies for
> raid5 and 3 copies for raid6.

I was wrong about btrfs_num_copies(), for raid56 it returns certain
value to control which stripe __btrfs_map_block() needs to be return.
Thus, btrfs-map-logical doesn't work for raid56 since everytime it will
return the required-offset data stripe and the parity stripe.

Thanks,

-liubo

> 
> Thanks,
> 
> -liubo
> 
> > 
> > The syntax of this new command is simple:
> > 
> > # btrfs inspect physical-find <filename> [<offset>]
> > 
> > where:
> >   <filename> is the file to inspect
> >   <offset> is the offset of the file to inspect (default 0)
> > 
> > Below some examples:
> > 
> > ** Single
> > 
> > $ sudo mkfs.btrfs -f -d single -m single /dev/loop0
> > $ sudo mount /dev/loop0 mnt/
> > $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
> > mnt/out.txt: 0
> >         devid 1, /dev/loop0 : 12582912 LINEAR
> > $ dd 2>/dev/null if=/dev/loop0 skip=12582912 bs=1 count=5; echo
> > adaaa
> > 
> > ** Dup
> > 
> > The command shows both the copies
> > 
> > $ sudo mkfs.btrfs -f -d single -m single /dev/loop0
> > $ sudo mount /dev/loop0 mnt/
> > $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
> > mnt/out.txt: 0
> >         devid 1, /dev/loop0 : 71303168 DUP
> >         devid 1, /dev/loop0 : 104857600 DUP
> > $ dd 2>/dev/null if=/dev/loop0 skip=104857600 bs=1 count=5 ; echo
> > adaaa
> > 
> > 
> > ** Raid1
> > 
> > The command shows both the copies
> > 
> > $ sudo mkfs.btrfs -f -d raid1 -m raid1 /dev/loop0 /dev/loop1
> > $ sudo mount /dev/loop0 mnt/
> > $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt mnt/out.txt: 0
> >         devid 2, /dev/loop1 : 61865984 RAID1
> >         devid 1, /dev/loop0 : 81788928 RAID1
> > $ dd 2>/dev/null if=/dev/loop0 skip=81788928 bs=1 count=5; echo
> > adaaa
> > 
> > 
> > ** Raid10
> > 
> > The command show both the copies; if you set an offset to the next disk-stripe, you can see the next pair of disk-stripe
> > 
> > $ sudo mkfs.btrfs -f -d raid10 -m raid10 /dev/loop[0123]
> > $ sudo mount /dev/loop0 mnt/
> > $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt mnt/out.txt: 0
> >         devid 4, /dev/loop3 : 61931520 RAID10
> >         devid 3, /dev/loop2 : 61931520 RAID10
> > $ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5; echo
> > adaaa
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt 65536
> > mnt/out.txt: 65536
> >         devid 2, /dev/loop1 : 61931520 RAID10
> >         devid 1, /dev/loop0 : 81854464 RAID10
> > $ dd 2>/dev/null if=/dev/loop0 skip=81854464 bs=1 count=5; echo
> > bdbbb
> > 
> > 
> > ** Raid5
> > 
> > Depending by the offset, you can see which disk-stripe is used.
> > 
> > $ sudo mkfs.btrfs -f -d raid5 -m raid5 /dev/loop[012]
> > $ sudo mount /dev/loop0 mnt/
> > $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
> > mnt/out.txt: 0
> >         devid 2, /dev/loop1 : 61931520 DATA
> >         devid 1, /dev/loop0 : 81854464 OTHER
> >         devid 3, /dev/loop2 : 61931520 PARITY
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt 65536mnt/out.txt: 65536
> >         devid 2, /dev/loop1 : 61931520 OTHER
> >         devid 1, /dev/loop0 : 81854464 DATA
> >         devid 3, /dev/loop2 : 61931520 PARITY
> > $ dd 2>/dev/null if=/dev/loop1 skip=61931520 bs=1 count=5; echo
> > adaaa
> > $ dd 2>/dev/null if=/dev/loop0 skip=81854464 bs=1 count=5; echo
> > bdbbb
> > $ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5 | xxd
> > 00000000: 0300 0303 03                             .....
> > 
> > The parity is computed as: parity=disk1^disk2. So "adaa" ^ "bdbb" == "\x03\x00\x03\x03
> > 
> > ** Raid6
> > $ sudo mkfs.btrfs -f -mraid6 -draid6 /dev/loop[0-4]^C
> > $ sudo mount /dev/loop0 mnt/
> > $ python -c "print 'ad'+'a'*65534+'bd'+'b'*65533" | sudo tee mnt/out.txt >/dev/null
> > $ sudo ../btrfs-progs/btrfs inspect physical-find mnt/out.txt
> > mnt/out.txt: 0
> >         devid 3, /dev/loop2 : 61931520 DATA
> >         devid 2, /dev/loop1 : 61931520 OTHER
> >         devid 1, /dev/loop0 : 81854464 PARITY
> >         devid 4, /dev/loop3 : 61931520 PARITY
> > 
> > $ dd 2>/dev/null if=/dev/loop2 skip=61931520 bs=1 count=5 ; echo
> > adaaa
> > 
> > --
> > 
> > diff --git a/cmds-inspect.c b/cmds-inspect.c
> > index dd7b9dd..a604c2b 100644
> > --- a/cmds-inspect.c
> > +++ b/cmds-inspect.c
> > @@ -22,6 +22,11 @@
> >  #include <errno.h>
> >  #include <getopt.h>
> >  #include <limits.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <linux/fs.h>
> > +#include <linux/fiemap.h>
> >  
> >  #include "kerncompat.h"
> >  #include "ioctl.h"
> > @@ -623,6 +628,450 @@ out:
> >         return !!ret;
> >  }
> >  
> > +
> > +static const char* const cmd_inspect_physical_find_usage[] = {
> > +       "btrfs inspect-internal physical-find [options] <path> [<path>...]",
> > +       "Show the physical address of each blocks",
> > +        "-m   the output is machine readable",
> > +       NULL
> > +};
> > +
> > +static void dump_stripes(int ndisks, struct btrfs_ioctl_dev_info_args *disks,
> > +                         struct btrfs_chunk *chunk, u64 logical_start) {
> > +        struct btrfs_stripe *stripes;
> > +        stripes = &chunk->stripe;
> > +
> > +        if ((chunk->type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 ) {
> > +                /* LINEAR: each chunk has (should have) only one disk */
> > +                int j;
> > +                char *dname = "<NOT FOUND>";
> > +
> > +                assert(chunk->num_stripes == 1);
> > +
> > +                u64 phy_start = stripes[0].offset +
> > +                        +logical_start;
> > +                for (j = 0 ; j < ndisks ; j++)
> > +                    if (stripes[0].devid == disks[j].devid) {
> > +                        dname = (char*)disks[j].path;
> > +                        break;
> > +                    }
> > +                printf("\tdevid %llu, %s : %llu LINEAR\n",
> > +                        stripes[0].devid, dname, phy_start);
> > +        } else if (chunk->type & BTRFS_BLOCK_GROUP_RAID0) {
> > +                /*
> > +                 * RAID0: each chunk is composed by more disks;
> > +                 * each stripe_len bytes are in a different disk:
> > +                 *
> > +                 *  file: ABC...NMOP....
> > +                 *
> > +                 *      disk1   disk2    disk3  .... disksN
> > +                 *
> > +                 *        A      B         C    ....    N
> > +                 *        M      O         P    ....
> > +                 *
> > +                 */
> > +                u64 disks_number = chunk->num_stripes;
> > +                u64 disk_stripe_size = chunk->stripe_len;
> > +                u64 stripe_capacity ;
> > +                u64 stripe_nr;
> > +                u64 disk_stripe_start;
> > +                int sidx;
> > +                int j;
> > +                char *dname = "<NOT FOUND>";
> > +
> > +                stripe_capacity = disks_number * disk_stripe_size;
> > +                stripe_nr = logical_start / stripe_capacity;
> > +                disk_stripe_start = logical_start % disk_stripe_size;
> > +
> > +                sidx = (logical_start / disk_stripe_size) % disks_number;
> > +
> > +                u64 phy_start = stripes[sidx].offset +
> > +                        stripe_nr * disk_stripe_size +
> > +                        disk_stripe_start;
> > +
> > +                for (j = 0 ; j < ndisks ; j++)
> > +                    if (stripes[sidx].devid == disks[j].devid) {
> > +                        dname = (char*)disks[j].path;
> > +                        break;
> > +                    }
> > +                printf("\tdevid %llu, %s : %llu RAID0\n",
> > +                        stripes[sidx].devid, dname, phy_start);
> > +
> > +        } else if (chunk->type & BTRFS_BLOCK_GROUP_RAID1) {
> > +                /*
> > +                 * RAID0: each chunk is composed by more disks;
> > +                 * each stripe_len bytes are in a different disk:
> > +                 *
> > +                 *  file: ABC...
> > +                 *
> > +                 *      disk1   disk2   disk3  ....
> > +                 *
> > +                 *        A       A
> > +                 *        B       B
> > +                 *        C       C
> > +                 *
> > +                 */
> > +                int sidx;
> > +                for (sidx = 0; sidx < chunk->num_stripes; sidx++) {
> > +                        int j;
> > +                        char *dname = "<NOT FOUND>";
> > +                        u64 phy_start = stripes[sidx].offset +
> > +                                +logical_start;
> > +
> > +                        for (j = 0 ; j < ndisks ; j++)
> > +                            if (stripes[sidx].devid == disks[j].devid) {
> > +                                dname = (char*)disks[j].path;
> > +                                break;
> > +                            }
> > +                        printf("\tdevid %llu, %s : %llu RAID1\n",
> > +                                stripes[sidx].devid, dname, phy_start);
> > +                }
> > +        } else if (chunk->type & BTRFS_BLOCK_GROUP_DUP) {
> > +                /*
> > +                 * DUP: each chunk has 'num_stripes' disk_stripe. Heach
> > +                 * disk_stripe has its own copy of data
> > +                 *
> > +                 *  file: ABCD....
> > +                 *
> > +                 *      disk1   disk2   disk3
> > +                 *
> > +                 *        A
> > +                 *        B
> > +                 *        C
> > +                 *      [...]
> > +                 *        A
> > +                 *        B
> > +                 *        C
> > +                 *
> > +                 *
> > +                 * NOTE: the difference between DUP and RAID1 is that
> > +                 * in RAID1 each disk_stripe is in a different disk, in DUP
> > +                 * each disk chunk is in the same disk
> > +                 */
> > +                int sidx;
> > +                /* TBD: check what happens with the stripes */
> > +                for (sidx = 0; sidx < chunk->num_stripes; sidx++) {
> > +                        int j;
> > +                        char *dname = "<NOT FOUND>";
> > +                        u64 phy_start = stripes[sidx].offset +
> > +                                +logical_start;
> > +
> > +                        for (j = 0 ; j < ndisks ; j++)
> > +                            if (stripes[sidx].devid == disks[j].devid) {
> > +                                dname = (char*)disks[j].path;
> > +                                break;
> > +                            }
> > +                        printf("\tdevid %llu, %s : %llu DUP\n",
> > +                                stripes[sidx].devid, dname, phy_start);
> > +                }
> > +        } else if (chunk->type & BTRFS_BLOCK_GROUP_RAID10) {
> > +                /*
> > +                 * RAID10: each chunk is composed by more disks;
> > +                 * each stripe_len bytes are in a different disk:
> > +                 *
> > +                 *  file: ABCD....
> > +                 *
> > +                 *      disk1   disk2   disk3   disk4
> > +                 *
> > +                 *        A      A         B      B
> > +                 *        C      C         D      D
> > +                 *
> > +                 *
> > +                 */
> > +                int i;
> > +                u64 disks_number = chunk->num_stripes;
> > +                u64 disk_stripe_size = chunk->stripe_len;
> > +                u64 stripe_capacity ;
> > +                u64 stripe_nr;
> > +                u64 stripe_start;
> > +                u64 disk_stripe_start;
> > +
> > +                stripe_capacity = disks_number * disk_stripe_size / chunk->sub_stripes;
> > +                stripe_nr = logical_start / stripe_capacity;
> > +                stripe_start = logical_start % stripe_capacity;
> > +                disk_stripe_start = logical_start % disk_stripe_size;
> > +
> > +                for (i = 0; i < chunk->sub_stripes; i++) {
> > +                        int j;
> > +                        char *dname = "<NOT FOUND>";
> > +                        int sidx = (i +
> > +                            stripe_start/disk_stripe_size*chunk->sub_stripes) %
> > +                            disks_number;
> > +
> > +                        u64 phy_start = stripes[sidx].offset +
> > +                                +stripe_nr*disk_stripe_size + disk_stripe_start;
> > +
> > +                        for (j = 0 ; j < ndisks ; j++)
> > +                            if (stripes[sidx].devid == disks[j].devid) {
> > +                                dname = (char*)disks[j].path;
> > +                                break;
> > +                            }
> > +                        printf("\tdevid %llu, %s : %llu RAID10\n",
> > +                                stripes[sidx].devid, dname, phy_start);
> > +                }
> > +        } else if (chunk->type & BTRFS_BLOCK_GROUP_RAID5 ||
> > +                        chunk->type & BTRFS_BLOCK_GROUP_RAID6 ) {
> > +                /*
> > +                 * RAID5: each chunk is spread on a different disk; however one
> > +                 * disk is used for parity
> > +                 *
> > +                 *  file: ABCDEFGHIJK....
> > +                 *
> > +                 *      disk1  disk2  disk3  disk4  disk5
> > +                 *
> > +                 *        A      B      C      D      P
> > +                 *        P      D      E      F      G
> > +                 *        H      P      I      J      K
> > +                 *
> > +                 *   Note: P == parity
> > +                 *
> > +                 * RAID6: each chunk is spread on a different disk; however two
> > +                 * disks are used for parity
> > +                 *
> > +                 *  file: ABCDEFGHI...
> > +                 *
> > +                 *      disk1  disk2  disk3  disk4  disk5
> > +                 *
> > +                 *        A      B      C      P      Q
> > +                 *        Q      D      E      F      P
> > +                 *        P      Q      G      H      I
> > +                 *
> > +                 *   Note: P,Q == parity
> > +                 *
> > +                 */
> > +                int parities_nr = 1;
> > +                u64 disks_number = chunk->num_stripes;
> > +                u64 disk_stripe_size = chunk->stripe_len;
> > +                u64 stripe_capacity ;
> > +                u64 stripe_nr;
> > +                u64 stripe_start;
> > +                u64 pos = 0;
> > +                u64 disk_stripe_start;
> > +                int sidx;
> > +
> > +                if (chunk->type & BTRFS_BLOCK_GROUP_RAID6)
> > +                         parities_nr = 2;
> > +
> > +                stripe_capacity = (disks_number - parities_nr) *
> > +                                                disk_stripe_size;
> > +                stripe_nr = logical_start / stripe_capacity;
> > +                stripe_start = logical_start % stripe_capacity;
> > +                disk_stripe_start = logical_start % disk_stripe_size;
> > +
> > +                for (sidx = 0; sidx < disks_number ; sidx++) {
> > +                        int j;
> > +                        char *dname = "<NOT FOUND>";
> > +                        u64 stripe_index = (sidx + stripe_nr) % disks_number;
> > +                        u64 phy_start = stripes[stripe_index].offset + /* chunk start */
> > +                                + stripe_nr*disk_stripe_size +  /* stripe start */
> > +                                + disk_stripe_start;
> > +
> > +                        for (j = 0 ; j < ndisks ; j++)
> > +                            if (stripes[stripe_index].devid == disks[j].devid) {
> > +                                dname = (char*)disks[j].path;
> > +                                break;
> > +                            }
> > +
> > +                        if (sidx >= (disks_number - parities_nr)) {
> > +                                printf("\tdevid %llu, %s : %llu PARITY\n",
> > +                                        stripes[stripe_index].devid, dname,
> > +                                        phy_start);
> > +                                continue;
> > +                        }
> > +
> > +                        if (stripe_start >= pos && stripe_start < (pos+disk_stripe_size)) {
> > +                                printf("\tdevid %llu, %s : %llu DATA\n",
> > +                                        stripes[stripe_index].devid,
> > +                                        dname, phy_start);
> > +                        } else {
> > +                                printf("\tdevid %llu, %s : %llu OTHER\n",
> > +                                        stripes[stripe_index].devid,
> > +                                        dname, phy_start);
> > +                        }
> > +
> > +                        pos += disk_stripe_size;
> > +                }
> > +                assert(pos == stripe_capacity);
> > +        } else {
> > +                error("Unknown chunk type = 0x%016llx\n", chunk->type);
> > +                return;
> > +        }
> > +
> > +}
> > +
> > +static int dump_extent(char *fname, int fd, u64 logical_start) {
> > +
> > +       struct btrfs_ioctl_search_args args;
> > +       struct btrfs_ioctl_search_key *sk = &args.key;
> > +       struct btrfs_ioctl_search_header sh;
> > +       unsigned long off = 0;
> > +       int i;
> > +       int e;
> > +        struct btrfs_ioctl_dev_info_args *disks = NULL;
> > +        struct btrfs_ioctl_fs_info_args fi_args = {0};
> > +
> > +        e = get_fs_info(fname, &fi_args, &disks);
> > +        if ( e< 0) {
> > +            error("Cannot get info for the filesystem: may be it is not a btrfs filesystem ?\n");
> > +            free(disks);
> > +            return -1;
> > +        }
> > +
> > +        memset(&args, 0, sizeof(args));
> > +       sk->tree_id = BTRFS_CHUNK_TREE_OBJECTID;
> > +       sk->min_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> > +       sk->max_objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> > +       sk->min_type = BTRFS_CHUNK_ITEM_KEY;
> > +       sk->max_type = BTRFS_CHUNK_ITEM_KEY;
> > +       sk->max_offset = (u64)-1;
> > +        sk->min_offset = 0;
> > +       sk->max_transid = (u64)-1;
> > +
> > +        while (1) {
> > +                int ret;
> > +
> > +               sk->nr_items = 1;
> > +               ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
> > +               e = errno;
> > +               if (ret < 0) {
> > +                       error("cannot perform the search: %s", strerror(e));
> > +                        free(disks);
> > +                       return -1;
> > +               }
> > +               if (sk->nr_items == 0)
> > +                       break;
> > +
> > +               off = 0;
> > +               for (i = 0; i < sk->nr_items; i++) {
> > +                       struct btrfs_chunk *item;
> > +
> > +                       memcpy(&sh, args.buf + off, sizeof(sh));
> > +                       off += sizeof(sh);
> > +                       item = (struct btrfs_chunk*)(args.buf + off);
> > +                       off += sh.len;
> > +
> > +                        if (logical_start >= sh.offset &&
> > +                                logical_start <= sh.offset+item->length) {
> > +                                        dump_stripes(fi_args.num_devices, disks,
> > +                                                     item,
> > +                                                     logical_start-sh.offset);
> > +                                free(disks);
> > +                                return 0;
> > +                        }
> > +
> > +
> > +                       sk->min_objectid = sh.objectid;
> > +                       sk->min_type = sh.type;
> > +                       sk->min_offset = sh.offset;
> > +               }
> > +
> > +               if (sk->min_offset < (u64)-1)
> > +                       sk->min_offset++;
> > +               else
> > +                       break;
> > +       }
> > +
> > +       free(disks);
> > +       return 0;
> > +}
> > +
> > +/*
> > + * Inline extents are skipped because they do not take data space,
> > + * delalloc and unknown are skipped because we do not know how much
> > + * space they will use yet.
> > + */
> > +#define SKIP_FLAGS      (FIEMAP_EXTENT_UNKNOWN|FIEMAP_EXTENT_DELALLOC| \
> > +                        FIEMAP_EXTENT_DATA_INLINE)
> > +static int cmd_inspect_physical_find(int argc, char **argv)
> > +{
> > +        int ret = 0;
> > +        u64 logical = 0ull;
> > +        int fd;
> > +        int last = 0;
> > +        char buf[16384];
> > +        char *fname;
> > +        int found = 0;
> > +        struct fiemap *fiemap = (struct fiemap*)buf;
> > +        struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
> > +        const int count = (sizeof(buf) - sizeof(*fiemap)) /
> > +                        sizeof(struct fiemap_extent);
> > +
> > +        int minargc = 1;
> > +
> > +        memset(fiemap, 0, sizeof(struct fiemap));
> > +
> > +       if (check_argc_min(argc - minargc, 1) ||
> > +            check_argc_max(argc - minargc, 2) )
> > +               usage(cmd_inspect_physical_find_usage);
> > +
> > +        if (argc - minargc == 2)
> > +                logical = strtoull(argv[minargc+1], NULL, 0);
> > +        fname = argv[minargc];
> > +
> > +        printf("%s: %llu\n", fname, logical);
> > +
> > +        fd = open(fname, O_RDONLY);
> > +        if (fd < 0) {
> > +                error("Can't open '%s' for reading\n", fname);
> > +                ret = -errno;
> > +                goto out;
> > +        }
> > +
> > +        do {
> > +
> > +                int rc;
> > +                int j;
> > +
> > +                fiemap->fm_length = ~0ULL;
> > +                fiemap->fm_extent_count = count;
> > +                fiemap->fm_flags = FIEMAP_FLAG_SYNC;
> > +                rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
> > +                if (rc < 0) {
> > +                        error("Can't do ioctl()\n");
> > +                        close(fd);
> > +                        ret = -errno;
> > +                        goto out;
> > +                }
> > +
> > +                for (j = 0; j < fiemap->fm_mapped_extents; j++) {
> > +                        u32 flags = fm_ext[j].fe_flags;
> > +
> > +                        fiemap->fm_start = (fm_ext[j].fe_logical +
> > +                                fm_ext[j].fe_length);
> > +
> > +                        if (flags & FIEMAP_EXTENT_LAST)
> > +                                last = 1;
> > +
> > +                        if (flags & SKIP_FLAGS)
> > +                                continue;
> > +
> > +                        if (logical > fm_ext[j].fe_logical +
> > +                            fm_ext[j].fe_length)
> > +                                continue;
> > +
> > +                        found = 1;
> > +                        
> > +                        rc = dump_extent(fname, fd,
> > +                                         fm_ext[j].fe_physical + logical -
> > +                                         fm_ext[j].fe_logical);
> > +                        if (rc < 0)
> > +                                ret = -errno;
> > +                        last = 1;
> > +                        break;
> > +                }
> > +        } while (last == 0);
> > +
> > +        close(fd);
> > +        
> > +        if (!found) {
> > +            error("Can't find the extent: the file is too short, or the file is stored in a leaf.\n");
> > +            ret = 10;
> > +        }
> > +
> > +out:
> > +        return ret;
> > +}
> > +
> >  static const char inspect_cmd_group_info[] =
> >  "query various internal information";
> >  
> > @@ -644,6 +1093,8 @@ const struct cmd_group inspect_cmd_group = {
> >                                 cmd_inspect_dump_super_usage, NULL, 0 },
> >                 { "tree-stats", cmd_inspect_tree_stats,
> >                                 cmd_inspect_tree_stats_usage, NULL, 0 },
> > +               { "physical-find", cmd_inspect_physical_find,
> > +                               cmd_inspect_physical_find_usage, NULL, 0 },
> >                 NULL_CMD_STRUCT
> >         }
> >  };
> > 
> > 
> > 
> > 
> > -- 
> > gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> > Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> > 
> > -- 
> > gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> > Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
