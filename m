From: Francesco Riosa <vivo75@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Tue, 11 Oct 2011 23:21:45 +0200
Message-ID: <CAD6zcDyyQH0h34SO8724d07GXr+4=LqZga4NNDr8Zokk7eHNjA@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<4E5FE9FC.9040705@cchtml.com>
	<20110901203442.GA17928@carfax.org.uk>
	<201109101209.40759.Martin@lichtvoll.de>
	<CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
	<20111005061628.GA3702@shiny.elevennetworks.com>
	<CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
	<20111005145843.GA4770@shiny.elevennetworks.com>
	<CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
	<m239f550cp.fsf@firstfloor.org>
	<CAD6zcDxvXTZPOO-bXRfuMVWqOGbz8QdfHk=p0LT6Dequb9pmAg@mail.gmail.com>
	<4E8F119C.70006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Putney <jeffrey.putney@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8F119C.70006@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/10/7 Josef Bacik <josef@redhat.com>:
> On 10/06/2011 04:56 PM, Francesco Riosa wrote:
>> 2011/10/6 Andi Kleen <andi@firstfloor.org>:
>>> Jeff Putney <jeffrey.putney@gmail.com> writes:
>>>>
>>>> http://en.wikipedia.org/wiki/Release_early,_release_often
>>>
>>> Well the other principle in free software you're forgetting
>>> is:
>>>
>>> "It will be released when it's ready"
>>>
>>> If you don't like Chris' ways to do releases you're free to write
>>> something on your own or pay someone to do so. Otherwise
>>> you just have to deal with his time frames, as shifty
>>> as they may be.
>>
>> I did a different thing, I've offered Chris money to help rescue an
>> hosed btrfs or to point to someone who could do, we ended in doing
>> some tests (for free) but nothing else materialized.
>> While the time passed has diminished the value of the data to be
>> rescued I'm more on the "show us some code we can start from" than "=
it
>> will be released when ready" vagon.
>>
>
> If you still need that data, clone this repo
>
> git://github.com/josefbacik/btrfs-progs.git
>
> run make, and then run
>
> ./restore /dev/whatever /some/dir
>
> and it will try and suck all of your data off the disk and dump it in
> that directory. =A0If you have snapshots it will skip them by default=
, so
> if you have snapshots that have useful data in them you'll want to us=
e
> the -s option. =A0If you run into random errors that you think are
> recoverable, or if you don't care about the file that's being recover=
ed,
> you can run with -i which will ignore errors and keep trying to recov=
er
> your files. =A0Thanks,
>
> Josef
>

I've tried, w/o luck

explanation come from 2011-06-21 thread;
http://thread.gmane.org/gmane.comp.file-systems.btrfs/11435
the following refer to a copy of that system

Label: space02  uuid: f752def1-1abc-48c7-8ebb-47ba37b8ffa6
        Total devices 7 FS bytes used 173.12GB
        devid    6 size 488.94GB used 60.25GB path /dev/sdd7
        devid    2 size 487.65GB used 58.76GB path /dev/sdd8
        devid    7 size 487.65GB used 0.00 path    /dev/sdf7
        devid    3 size 487.65GB used 60.26GB path /dev/sdf8
        devid    7 size 487.65GB used 1.50GB path  /dev/sdg7
        devid    5 size 488.94GB used 58.75GB path /dev/sdb7
        devid    4 size 487.65GB used 60.26GB path /dev/sdb8

# ./restore /dev/sdd7 /tmp/restore
failed to read /dev/sr0
failed to read /dev/sr0
restore: volumes.c:1367: btrfs_read_sys_array: Assertion `!(ret)' faile=
d.
Aborted

this is the output after filling volumes.c of printk at every function =
start,
there is also a btrfs_print_tree() call at the failing read_one_chunk()

please let me know if I can do anything

int btrfs_scan_one_device(int fd=3D3, *path=3D/dev/sdd8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D1, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D134816, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdc3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdc6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdc7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdc5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdc4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdc2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdc1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/md127, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdd, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdc, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdb, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdg, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sdf, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sde, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
failed to read /dev/sr0
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/md128, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram9, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram14, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram13, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram15, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram0, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram12, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram11, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram10, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/ram1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/sda, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop0, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D4, *path=3D/dev/loop1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D3, *path=3D/dev/sdd8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D139870728973573,
u64 super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D15306741171905079,
u64 super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdc3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdc6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdc7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdc5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdc4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdc2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdc1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/md127, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdd, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdc, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdb, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdg, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sdf, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sde, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D7, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
failed to read /dev/sr0
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/md128, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram9, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram8, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram14, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram13, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram15, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram0, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram12, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram11, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram10, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/loop6, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/ram1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/loop4, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/sda, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
static int device_list_add(const char *path, struct btrfs_super_block
*disk_super, u64 devid, struct btrfs_fs_devices **fs_devices_ret)
static struct btrfs_fs_devices *find_fsid(u8 *fsid)
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/loop7, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/loop5, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/loop0, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/loop3, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/loop2, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_scan_one_device(int fd=3D5, *path=3D/dev/loop1, struct
btrfs_fs_devices **fs_devices_ret, u64 *total_devs=3D2, u64
super_offset=3D65536)
int btrfs_open_devices(struct btrfs_fs_devices *fs_devices, int flags)
int btrfs_read_sys_array(struct btrfs_root *root)
static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *ke=
y,...
  leaf 65536 items 0 free space 3995 generation 604315930624 owner 2097=
9712
  fs uuid f752def1-1abc-48c7-8ebb-47ba37b8ffa6
  chunk uuid 5f424852-6653-5f4d-318e-0b0000000000
struct btrfs_device *btrfs_find_device(struct btrfs_root *root, u64 dev=
id,
static struct btrfs_device *__find_device(struct list_head *head, u64
devid, u8 *uuid
restore: volumes.c:1397: btrfs_read_sys_array: Assertion `!(ret)' faile=
d.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
