From: Francesco Riosa <vivo75@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 13 Oct 2011 14:57:01 +0200
Message-ID: <CAD6zcDwMPOg=T5mPLZhSC6us-c_YLne1TfJog=taCSzdMtzqsQ@mail.gmail.com>
References: <201109101209.40759.Martin@lichtvoll.de>
	<CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
	<20111005061628.GA3702@shiny.elevennetworks.com>
	<CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
	<20111005145843.GA4770@shiny.elevennetworks.com>
	<CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
	<m239f550cp.fsf@firstfloor.org>
	<CAD6zcDxvXTZPOO-bXRfuMVWqOGbz8QdfHk=p0LT6Dequb9pmAg@mail.gmail.com>
	<4E8F119C.70006@redhat.com>
	<CAD6zcDyyQH0h34SO8724d07GXr+4=LqZga4NNDr8Zokk7eHNjA@mail.gmail.com>
	<20111012135323.GA2302@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Putney <jeffrey.putney@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111012135323.GA2302@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/12 Josef Bacik <josef@redhat.com>:
> On Tue, Oct 11, 2011 at 11:21:45PM +0200, Francesco Riosa wrote:
>> 2011/10/7 Josef Bacik <josef@redhat.com>:
>> > On 10/06/2011 04:56 PM, Francesco Riosa wrote:
>> >> 2011/10/6 Andi Kleen <andi@firstfloor.org>:
>> >>> Jeff Putney <jeffrey.putney@gmail.com> writes:
>> >>>>
>> >>>> http://en.wikipedia.org/wiki/Release_early,_release_often
>> >>>
>> >>> Well the other principle in free software you're forgetting
>> >>> is:
>> >>>
>> >>> "It will be released when it's ready"
>> >>>
>> >>> If you don't like Chris' ways to do releases you're free to writ=
e
>> >>> something on your own or pay someone to do so. Otherwise
>> >>> you just have to deal with his time frames, as shifty
>> >>> as they may be.
>> >>
>> >> I did a different thing, I've offered Chris money to help rescue =
an
>> >> hosed btrfs or to point to someone who could do, we ended in doin=
g
>> >> some tests (for free) but nothing else materialized.
>> >> While the time passed has diminished the value of the data to be
>> >> rescued I'm more on the "show us some code we can start from" tha=
n "it
>> >> will be released when ready" vagon.
>> >>
>> >
>> > If you still need that data, clone this repo
>> >
>> > git://github.com/josefbacik/btrfs-progs.git
>> >
>> > run make, and then run
>> >
>> > ./restore /dev/whatever /some/dir
>> >
>> > and it will try and suck all of your data off the disk and dump it=
 in
>> > that directory. =A0If you have snapshots it will skip them by defa=
ult, so
>> > if you have snapshots that have useful data in them you'll want to=
 use
>> > the -s option. =A0If you run into random errors that you think are
>> > recoverable, or if you don't care about the file that's being reco=
vered,
>> > you can run with -i which will ignore errors and keep trying to re=
cover
>> > your files. =A0Thanks,
>> >
>> > Josef
>> >
>>
>> I've tried, w/o luck
>>
>> explanation come from 2011-06-21 thread;
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/11435
>> the following refer to a copy of that system
>>
>> Label: space02 =A0uuid: f752def1-1abc-48c7-8ebb-47ba37b8ffa6
>> =A0 =A0 =A0 =A0 Total devices 7 FS bytes used 173.12GB
>> =A0 =A0 =A0 =A0 devid =A0 =A06 size 488.94GB used 60.25GB path /dev/=
sdd7
>> =A0 =A0 =A0 =A0 devid =A0 =A02 size 487.65GB used 58.76GB path /dev/=
sdd8
>> =A0 =A0 =A0 =A0 devid =A0 =A07 size 487.65GB used 0.00 path =A0 =A0/=
dev/sdf7
>> =A0 =A0 =A0 =A0 devid =A0 =A03 size 487.65GB used 60.26GB path /dev/=
sdf8
>> =A0 =A0 =A0 =A0 devid =A0 =A07 size 487.65GB used 1.50GB path =A0/de=
v/sdg7
>> =A0 =A0 =A0 =A0 devid =A0 =A05 size 488.94GB used 58.75GB path /dev/=
sdb7
>> =A0 =A0 =A0 =A0 devid =A0 =A04 size 487.65GB used 60.26GB path /dev/=
sdb8
>>
>> # ./restore /dev/sdd7 /tmp/restore
>> failed to read /dev/sr0
>> failed to read /dev/sr0
>> restore: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' fa=
iled.
>> Aborted
>>
>
> So this is kind of a problem since you have multiple disks. =A0We may=
be could get
> away with ignoring a failure, but the problem is if you have data on =
a disk
> where we couldn't read the chunk then the chances are we won't be abl=
e to map
> that file and read the data off. =A0That being said, theres no harm i=
n trying ;).
> Can you make btrfs_read_sys_array complain about failing, but not act=
ually BUG?
> See if that helps you. =A0Thanks,
>
> Josef
>

I've tried replacing the "BUG_ON(ret);" to printk("FAILED!!! %d\n", ret=
);
the diff of the result is reported at the bottom.

diff -u5  btrfs-progs.log btrfs-progs2.log
--- btrfs-progs.log =A0 =A0 2011-10-11 23:01:56.985577874 +0200+++
btrfs-progs2.log =A0 =A02011-10-13 14:29:48.498033330 +0200@@ -115,11
+98,11 @@
=A0int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)=A0int btrfs_scan_one_device(int fd=3D4,
*path=3D/dev/loop0, struct btrfs_fs_devices **fs_devices_ret, u64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D4, *path=3D/dev/loop3, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D4, *path=3D/dev/loop2, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D4, *path=3D/dev/loop1, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)-int btrfs_scan_one_device(in=
t
fd=3D3, *path=3D/dev/sdd8, struct btrfs_fs_devices **fs_devices_ret, u6=
4
*total_devs=3D139870728973573, u64 super_offset=3D65536)

 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0+int
btrfs_scan_one_device(int fd=3D3, *path=3D/dev/sdd8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D139871521856773,
u64 super_offset=3D65536)

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0static int device_list_ad=
d(const char *path,
struct btrfs_super_block *disk_super, u64 devid, struct
btrfs_fs_devices **fs_devices_ret)=A0static struct btrfs_fs_devices
*find_fsid(u8 *fsid)=A0static struct btrfs_device *__find_device(struct
list_head *head, u64 devid, u8 *uuid=A0int btrfs_scan_one_device(int
fd=3D5, *path=3D/dev/sdb8, struct btrfs_fs_devices **fs_devices_ret, u6=
4
*total_devs=3D15306741171905079, u64 super_offset=3D65536)=A0static int
device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)@@
-222,11 +205,40 @@=A0int btrfs_scan_one_device(int fd=3D5,
*path=3D/dev/loop2, struct btrfs_fs_devices **fs_devices_ret, u64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D5, *path=3D/dev/loop1, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_open_devices(str=
uct
btrfs_fs_devices *fs_devices, int flags)=A0int
btrfs_read_sys_array(struct btrfs_root *root)=A0static int
read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,...-
leaf 65536 items 0 free space 3995 generation 604315930624 owner
20979712- =A0fs uuid f752def1-1abc-48c7-8ebb-47ba37b8ffa6- =A0chunk uui=
d
5f424852-6653-5f4d-318e-0b0000000000+--- btrfs_print_tree(root, leaf,
0);+leaf 65536 items 0 free space 3995 generation 604315930624 owner
20979712+fs uuid f752def1-1abc-48c7-8ebb-47ba37b8ffa6+chunk uuid
5f424852-6653-5f4d-318e-0b0000000000+struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,+static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid+FAILED!!! -5+static int read_one_chunk(struct btrfs_root *root,
struct btrfs_key *key,...+--- btrfs_print_tree(root, leaf, 0);+leaf
65536 items 0 free space 3995 generation 604315930624 owner
20979712+fs uuid f752def1-1abc-48c7-8ebb-47ba37b8ffa6+chunk uuid
5f424852-6653-5f4d-318e-0b0000000000+struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,+static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid+struct btrfs_device *btrfs_find_device(struct btrfs_root *root,
u64 devid,+static struct btrfs_device *__find_device(struct list_head
*head, u64 devid, u8 *uuid+struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,+static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid+struct btrfs_device *btrfs_find_device(struct btrfs_root *root,
u64 devid,+static struct btrfs_device *__find_device(struct list_head
*head, u64 devid, u8 *uuid+FAILED!!! -5+static int
read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,...+---
btrfs_print_tree(root, leaf, 0);+leaf 65536 items 0 free space 3995
generation 604315930624 owner 20979712+fs uuid
f752def1-1abc-48c7-8ebb-47ba37b8ffa6+chunk uuid
5f424852-6653-5f4d-318e-0b0000000000+struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,+static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid+struct btrfs_device *btrfs_find_device(struct btrfs_root *root,
u64 devid,+static struct btrfs_device *__find_device(struct list_head
*head, u64 devid, u8 *uuid=A0struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,=A0static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid-restore: volumes.c:1397: btrfs_read_sys_array: Assertion
`!(ret)' failed.+FAILED!!! -5+int btrfs_map_block(struct
btrfs_mapping_tree *map_tree, int rw,...+restore: volumes.c:988:
btrfs_map_block: Assertion `!(!ce)' failed.>hom>viv>tmp colordiff -u5
btrfs-progs.log btrfs-progs2.log--- btrfs-progs.log =A0 =A0 2011-10-11
23:01:56.985577874 +0200+++ btrfs-progs2.log =A0 =A02011-10-13
14:29:48.498033330 +0200@@ -1,22 +1,5 @@-Label: space02 =A0uuid:
f752def1-1abc-48c7-8ebb-47ba37b8ffa6- =A0 =A0 =A0 =A0Total devices 7 FS=
 bytes
used 173.12GB- =A0 =A0 =A0 =A0devid =A0 =A06 size 488.94GB used 60.25GB=
 path
/dev/sdd7- =A0 =A0 =A0 =A0devid =A0 =A02 size 487.65GB used 58.76GB pat=
h
/dev/sdd8- =A0 =A0 =A0 =A0devid =A0 =A07 size 487.65GB used 0.00 path
/dev/sdf7- =A0 =A0 =A0 =A0devid =A0 =A03 size 487.65GB used 60.26GB pat=
h
/dev/sdf8- =A0 =A0 =A0 =A0devid =A0 =A07 size 487.65GB used 1.50GB path
/dev/sdg7- =A0 =A0 =A0 =A0devid =A0 =A05 size 488.94GB used 58.75GB pat=
h
/dev/sdb7- =A0 =A0 =A0 =A0devid =A0 =A04 size 487.65GB used 60.26GB pat=
h
/dev/sdb8--# ./restore /dev/sdd7 /tmp/restore-failed to read
/dev/sr0-failed to read /dev/sr0-restore: volumes.c:1367:
btrfs_read_sys_array: Assertion `!(ret)' failed.-Aborted--=A0int
btrfs_scan_one_device(int fd=3D3, *path=3D/dev/sdd8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D1, u64
super_offset=3D65536)=A0static int device_list_add(const char *path,
struct btrfs_super_block *disk_super, u64 devid, struct
btrfs_fs_devices **fs_devices_ret)=A0static struct btrfs_fs_devices
*find_fsid(u8 *fsid)=A0int btrfs_scan_one_device(int fd=3D4,
*path=3D/dev/sdb8, struct btrfs_fs_devices **fs_devices_ret, u64
*total_devs=3D134816, u64 super_offset=3D65536)=A0static int
device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)@@
-115,11 +98,11 @@=A0int btrfs_scan_one_device(int fd=3D4,
*path=3D/dev/loop5, struct btrfs_fs_devices **fs_devices_ret, u64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D4, *path=3D/dev/loop0, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D4, *path=3D/dev/loop3, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D4, *path=3D/dev/loop2, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D4, *path=3D/dev/loop1, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)-int btrfs_scan_one_device(in=
t
fd=3D3, *path=3D/dev/sdd8, struct btrfs_fs_devices **fs_devices_ret, u6=
4
*total_devs=3D139870728973573, u64 super_offset=3D65536)

 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0+int
btrfs_scan_one_device(int fd=3D3, *path=3D/dev/sdd8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D139871521856773,
u64 super_offset=3D65536)

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0static int device_list_ad=
d(const char *path,
struct btrfs_super_block *disk_super, u64 devid, struct
btrfs_fs_devices **fs_devices_ret)=A0static struct btrfs_fs_devices
*find_fsid(u8 *fsid)=A0static struct btrfs_device *__find_device(struct
list_head *head, u64 devid, u8 *uuid=A0int btrfs_scan_one_device(int
fd=3D5, *path=3D/dev/sdb8, struct btrfs_fs_devices **fs_devices_ret, u6=
4
*total_devs=3D15306741171905079, u64 super_offset=3D65536)=A0static int
device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)@@
-222,11 +205,40 @@=A0int btrfs_scan_one_device(int fd=3D5,
*path=3D/dev/loop2, struct btrfs_fs_devices **fs_devices_ret, u64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_scan_one_device(=
int
fd=3D5, *path=3D/dev/loop1, struct btrfs_fs_devices **fs_devices_ret, u=
64
*total_devs=3D2, u64 super_offset=3D65536)=A0int btrfs_open_devices(str=
uct
btrfs_fs_devices *fs_devices, int flags)=A0int
btrfs_read_sys_array(struct btrfs_root *root)=A0static int
read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,...-
leaf 65536 items 0 free space 3995 generation 604315930624 owner
20979712- =A0fs uuid f752def1-1abc-48c7-8ebb-47ba37b8ffa6- =A0chunk uui=
d
5f424852-6653-5f4d-318e-0b0000000000+--- btrfs_print_tree(root, leaf,
0);+leaf 65536 items 0 free space 3995 generation 604315930624 owner
20979712+fs uuid f752def1-1abc-48c7-8ebb-47ba37b8ffa6+chunk uuid
5f424852-6653-5f4d-318e-0b0000000000+struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,+static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid+FAILED!!! -5+static int read_one_chunk(struct btrfs_root *root,
struct btrfs_key *key,...+--- btrfs_print_tree(root, leaf, 0);+leaf
65536 items 0 free space 3995 generation 604315930624 owner
20979712+fs uuid f752def1-1abc-48c7-8ebb-47ba37b8ffa6+chunk uuid
5f424852-6653-5f4d-318e-0b0000000000+struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,+static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid+struct btrfs_device *btrfs_find_device(struct btrfs_root *root,
u64 devid,+static struct btrfs_device *__find_device(struct list_head
*head, u64 devid, u8 *uuid+struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,+static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid+struct btrfs_device *btrfs_find_device(struct btrfs_root *root,
u64 devid,+static struct btrfs_device *__find_device(struct list_head
*head, u64 devid, u8 *uuid+FAILED!!! -5+static int
read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,...+---
btrfs_print_tree(root, leaf, 0);+leaf 65536 items 0 free space 3995
generation 604315930624 owner 20979712+fs uuid
f752def1-1abc-48c7-8ebb-47ba37b8ffa6+chunk uuid
5f424852-6653-5f4d-318e-0b0000000000+struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,+static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid+struct btrfs_device *btrfs_find_device(struct btrfs_root *root,
u64 devid,+static struct btrfs_device *__find_device(struct list_head
*head, u64 devid, u8 *uuid=A0struct btrfs_device
*btrfs_find_device(struct btrfs_root *root, u64 devid,=A0static struct
btrfs_device *__find_device(struct list_head *head, u64 devid, u8
*uuid-restore: volumes.c:1397: btrfs_read_sys_array: Assertion
`!(ret)' failed.+FAILED!!! -5+int btrfs_map_block(struct
btrfs_mapping_tree *map_tree, int rw,...+restore: volumes.c:988:
btrfs_map_block: Assertion `!(!ce)' failed.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
