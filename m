Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:59300 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2IKRcO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 13:32:14 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Tue, 11 Sep 2012 11:32:13 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 8AE70C40006
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 11:32:07 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q8BHVn7E224378
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 11:31:55 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q8BHWx9U003011
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2012 11:32:59 -0600
Message-ID: <504F756B.4020901@linux.vnet.ibm.com>
Date: Tue, 11 Sep 2012 10:31:23 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: cmm@linux.vnet.ibm.com
Subject: DIO Write Regression on Preallocated Extents
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I was doing some fragmentation tests on preallocated extents on Josef's 
btrfs-next branch (commit 8fe3b6) with the O_DIRECT flag enabled and 
noticed some strange behavior. Writing to a preallocated extent 
currently triggers a WARN_ON on in the kernel, triggers a csum error for 
what appears to be each block, and causes the remaining preallocated 
(and not written-to) area to read 1's.

The issue seems to have appeared in commit 8d37ef "Btrfs: improve fsync 
by filtering extents that we want" but the issues started earlier in 
16ecb6 "Btrfs: turbo charge fsync". Prior to 16ecb6, direct I/O on 
preallocated extents was not generating false data, after 16ecb6 direct 
I/O was not writing -any- data, and after 8d37ef direct I/O was 
generating false data.

The tests were done using a simple program I wrote (below) which 
preallocates a 128k file and performs a 4096-byte write.

Steps to reproduce:

mkfs.btrfs /dev/sdb
mount -t btrfs /dev/sdb /mnt/btrfs
cd /mnt/btrfs
gcc -o main <../main.c>
./main single direct
od -A x -t x2 testfile

It seems that the issue in part occurs in unpin_extent_cache:

     WARN_ON(!em || em->start != start);

printk() shows that the function expects the extent_map for the write 
performed but instead receives the extent_map for the entire 
preallocated extent. The extent_map is then marked as read:

     if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
         prealloc = true;
         clear_bit(EXTENT_FLAG_PREALLOC, &em->flags);
     }

which also causes fragmentation issues from further writes. I am not 
sure where the 1's are generated, though; using dd to check the on-disk 
contents shows that the data is uninitialized.

I don't currently have a patch for this, but thought it was important 
enough to bring up. Below are the od output, the main.c code I used to 
produce this error, and the kernel message. Let me know if you have any 
questions.

Regards,
Wade


od output:
------------------------------
000000 0101 0101 0101 0101 0101 0101 0101 0101
*
07a000 ffff ffff ffff ffff ffff ffff ffff ffff
*
07b000 0101 0101 0101 0101 0101 0101 0101 0101
*
0f4240


main.c:
------------------------------
#define _GNU_SOURCE

#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define FILE_LENGTH 1000000
#define FILE_NAME "testfile"
#define BLOCK_SIZE 4096


// Modes for running the program.
enum mode {
     // Write once to the middle of the file.
     SINGLE_WRITE,
     // Write twice to the middle of the file.
     DOUBLE_WRITE,
     // Write twice, sequentially, to the middle of the file.
     BUDDY_WRITE,
     // Write once at the 1/2 and 3/4 markers in the file.
     // Obviously, the non-sequentiality is opposite of the "buddy write".
     ENEMY_WRITE,
     // Write once at the 1/2 and 1/4 markers in the file.
     NEMESIS_WRITE
};


void print_usage() {
     fprintf(stderr, "<binary file> <single|double|buddy|enemy|nemesis> 
<buffered|direct|buffered-sync|direct-sync>\n\n");
     exit(EXIT_FAILURE);
}


int main(int argc, char* argv[]) {
     int fd;
     int open_flags;
     int temp;
     int mode;
     int i;
     uint8_t* buffer;

     // Validate parameters.
     if (argc < 3) {
         fprintf(stderr, "Expected at two arguments.\n");
         print_usage();
     }

     // Parse first argument.
     if (strcmp(argv[1], "single") == 0) {
         mode = SINGLE_WRITE;
     }
     else if (strcmp(argv[1], "double") == 0) {
         mode = DOUBLE_WRITE;
     }
     else if (strcmp(argv[1], "buddy") == 0) {
         mode = BUDDY_WRITE;
     }
     else if (strcmp(argv[1], "enemy") == 0) {
         mode = ENEMY_WRITE;
     }
     else if (strcmp(argv[1], "nemesis") == 0) {
         mode = NEMESIS_WRITE;
     }
     else {
         fprintf(stderr, "Unable to parse write mode '%s'.\n", argv[1]);
         print_usage();
     }

     // Parse second argument.
     open_flags |= O_RDWR | O_CREAT;
     if (strcmp(argv[2], "buffered") == 0) {
         ; // Do nothing.
     }
     else if (strcmp(argv[2], "direct") == 0) {
         open_flags |= O_DIRECT;
     }
     else if (strcmp(argv[2], "buffered-sync") == 0) {
         open_flags |= O_SYNC;
     }
     else if (strcmp(argv[2], "direct-sync") == 0) {
         open_flags |= O_DIRECT | O_SYNC;
     }
     else {
         fprintf(stderr, "Unable to parse: %s.\n", argv[2]);
         print_usage();
     }

     // Initialize the buffer.
     if (posix_memalign((void**)&buffer, 4096, BLOCK_SIZE) != 0) {
         perror("posix_memalign() FAILED.");
     }
     memset(buffer, 255, sizeof(uint8_t) * BLOCK_SIZE);

     // Remove any old file.
     temp = unlink(FILE_NAME);
     if (temp != 0 && errno != ENOENT) {
         perror("Unable to remove old file.");
     }

     // Create and open the file.
     fd = open(FILE_NAME, open_flags, 0777);
     if (fd == -1) {
         perror("Unable to open file.");
     }

     // Pre-allocate space for the file.
     if (fallocate(fd, 0, 0, FILE_LENGTH) == -1) {
         perror("Unable to allocate space for file.");
     }

     // Seek to the middle of the file.
     if (lseek(fd, (FILE_LENGTH/2) - ((FILE_LENGTH/2) % BLOCK_SIZE), 
SEEK_SET) == -1) {
         perror("Unable to seek to middle of file.");
     }

     // Write to the middle of the file.
     if (write(fd, buffer, BLOCK_SIZE) < BLOCK_SIZE) {
         perror("Not all content written to disk.");
     }

     // Do a buddy, double, or enemy write if applicable.
     if (mode == BUDDY_WRITE) {
         // Buddeh write.
         if (write(fd, buffer, BLOCK_SIZE) < BLOCK_SIZE) {
             perror("Computer does not want to be my friend.");
         }
     }
     else if (mode == DOUBLE_WRITE) {
         // Muck with buffer contents.
         for (i = 0; i < BLOCK_SIZE; i++) {
             buffer[i] += i;
         }

         // Move back.
         if (lseek(fd, -BLOCK_SIZE, SEEK_CUR) == -1) {
             perror("Unable to move back in file.");
         }

         // Double write.
         if (write(fd, buffer, BLOCK_SIZE) < BLOCK_SIZE) {
             perror("Unable to double-write.");
         }
     }
     else if (mode == ENEMY_WRITE) {
         // Move a quarter further into the file.
         if (lseek(fd, (FILE_LENGTH/4) - ((FILE_LENGTH/4) % BLOCK_SIZE), 
SEEK_CUR) == -1) {
             perror("Unable to perform enemy seek.");
         }

         // Enemy write.
         if (write(fd, buffer, BLOCK_SIZE) < BLOCK_SIZE) {
             perror("Evil writing plans have been FOILED AGAIN!");
         }
     }
     else if (mode == NEMESIS_WRITE) {
         // Move a quarter back into the file.
         if (lseek(fd, (FILE_LENGTH/4) - ((FILE_LENGTH/4) % BLOCK_SIZE), 
SEEK_SET) == -1) {
             perror("Unable to perform nemesis seek.");
         }

         // Nemesis write.
         if (write(fd, buffer, BLOCK_SIZE) < BLOCK_SIZE) {
             perror("Nemesis write phailed.\n");
         }
     }

     // Flush contents to disk.
     if (fsync(fd) == -1) {
         perror("Unable to flush contents to disk.");
     }

     // Close the file.
     if (close(fd) == -1) {
         perror("Unable to close file.");
     }

     // Exit successfully.
     exit(EXIT_SUCCESS);
}


Kernel Message:
------------------------------
[  126.041359] Btrfs loaded
[  126.087911] device fsid 857c1198-4429-4422-8ef3-ad453650f141 devid 1 
transid 4 /dev/sdb
[  126.211396] btrfs: disk space caching is enabled
[  133.171808] ------------[ cut here ]------------
[  133.171864] WARNING: at fs/btrfs/extent_map.c:258 
unpin_extent_cache+0x53/0xfa [btrfs]()
[  133.171869] Hardware name: KVM
[  133.171871] Modules linked in: btrfs zlib_deflate libcrc32c [last 
unloaded: btrfs]
[  133.171888] Pid: 5107, comm: btrfs-endio-wri Not tainted 3.6.0-rc3+ #33
[  133.171891] Call Trace:
[  133.171907]  [<ffffffff8103144b>] warn_slowpath_common+0x80/0x98
[  133.171915]  [<ffffffff81031478>] warn_slowpath_null+0x15/0x17
[  133.171951]  [<ffffffffa01ae725>] unpin_extent_cache+0x53/0xfa [btrfs]
[  133.171990]  [<ffffffffa01a47bf>] btrfs_finish_ordered_io+0x1e9/0x30d 
[btrfs]
[  133.171999]  [<ffffffff8103eebb>] ? del_timer_sync+0x3c/0x49
[  133.172043]  [<ffffffffa01a48f3>] finish_ordered_fn+0x10/0x12 [btrfs]
[  133.172179]  [<ffffffffa01bf12f>] worker_loop+0xaa/0x36b [btrfs]
[  133.172235]  [<ffffffffa01bf085>] ? btrfs_queue_worker+0x15b/0x15b 
[btrfs]
[  133.172280]  [<ffffffffa01bf085>] ? btrfs_queue_worker+0x15b/0x15b 
[btrfs]
[  133.172304]  [<ffffffff8104d1a0>] kthread+0x6a/0x72
[  133.172330]  [<ffffffff8153eff4>] kernel_thread_helper+0x4/0x10
[  133.172353]  [<ffffffff8104d136>] ? 
kthread_freezable_should_stop+0x46/0x46
[  133.172370]  [<ffffffff8153eff0>] ? gs_change+0xb/0xb
[  133.172376] ---[ end trace b2a0a5d7740db515 ]---
[  136.140871] btrfs no csum found for inode 257 start 0
[  136.140880] btrfs no csum found for inode 257 start 4096
[  136.140884] btrfs no csum found for inode 257 start 8192
[  136.140888] btrfs no csum found for inode 257 start 12288
[  136.154769] btrfs csum failed ino 257 off 0 csum 1816078486 private 0
[  136.154803] btrfs csum failed ino 257 off 4096 csum 2566472073 private 0
[  136.154838] btrfs csum failed ino 257 off 8192 csum 2566472073 private 0
[  136.154873] btrfs csum failed ino 257 off 12288 csum 2566472073 
private 0
[  136.155565] btrfs no csum found for inode 257 start 16384
[  136.155573] btrfs no csum found for inode 257 start 20480
[  136.155577] btrfs no csum found for inode 257 start 24576
[  136.155581] btrfs no csum found for inode 257 start 28672
[  136.155586] btrfs no csum found for inode 257 start 32768
[  136.155590] btrfs no csum found for inode 257 start 36864
[  136.155594] btrfs no csum found for inode 257 start 40960
[  136.155599] btrfs no csum found for inode 257 start 45056
[  136.155603] btrfs no csum found for inode 257 start 49152
[  136.155607] btrfs no csum found for inode 257 start 53248
[  136.155612] btrfs no csum found for inode 257 start 57344
[  136.155616] btrfs no csum found for inode 257 start 61440
[  136.155621] btrfs no csum found for inode 257 start 65536
[  136.155625] btrfs no csum found for inode 257 start 69632
[  136.155629] btrfs no csum found for inode 257 start 73728
[  136.155634] btrfs no csum found for inode 257 start 77824
[  136.156988] btrfs no csum found for inode 257 start 81920
[  136.156994] btrfs no csum found for inode 257 start 86016
[  136.156999] btrfs no csum found for inode 257 start 90112
[  136.157004] btrfs no csum found for inode 257 start 94208
[  136.157059] btrfs no csum found for inode 257 start 98304
[  136.157064] btrfs no csum found for inode 257 start 102400
[  136.157068] btrfs no csum found for inode 257 start 106496
[  136.157073] btrfs no csum found for inode 257 start 110592
[  136.157077] btrfs no csum found for inode 257 start 114688
[  136.157082] btrfs no csum found for inode 257 start 118784
[  136.157086] btrfs no csum found for inode 257 start 122880
[  136.157091] btrfs no csum found for inode 257 start 126976
[  136.157095] btrfs no csum found for inode 257 start 131072
[  136.157100] btrfs no csum found for inode 257 start 135168
[  136.157104] btrfs no csum found for inode 257 start 139264
[  136.157109] btrfs no csum found for inode 257 start 143360
[  136.157113] btrfs no csum found for inode 257 start 147456
[  136.157118] btrfs no csum found for inode 257 start 151552
[  136.157122] btrfs no csum found for inode 257 start 155648
[  136.157127] btrfs no csum found for inode 257 start 159744
[  136.157131] btrfs no csum found for inode 257 start 163840
[  136.157136] btrfs no csum found for inode 257 start 167936
[  136.157140] btrfs no csum found for inode 257 start 172032
[  136.157144] btrfs no csum found for inode 257 start 176128
[  136.157149] btrfs no csum found for inode 257 start 180224
[  136.157154] btrfs no csum found for inode 257 start 184320
[  136.157158] btrfs no csum found for inode 257 start 188416
[  136.157162] btrfs no csum found for inode 257 start 192512
[  136.157167] btrfs no csum found for inode 257 start 196608
[  136.157172] btrfs no csum found for inode 257 start 200704
[  136.157176] btrfs no csum found for inode 257 start 204800
[  136.157180] btrfs no csum found for inode 257 start 208896
[  136.157185] btrfs no csum found for inode 257 start 212992
[  136.157190] btrfs no csum found for inode 257 start 217088
[  136.157194] btrfs no csum found for inode 257 start 221184
[  136.157198] btrfs no csum found for inode 257 start 225280
[  136.157203] btrfs no csum found for inode 257 start 229376
[  136.157207] btrfs no csum found for inode 257 start 233472
[  136.157212] btrfs no csum found for inode 257 start 237568
[  136.157216] btrfs no csum found for inode 257 start 241664
[  136.157221] btrfs no csum found for inode 257 start 245760
[  136.157225] btrfs no csum found for inode 257 start 249856
[  136.157230] btrfs no csum found for inode 257 start 253952
[  136.157234] btrfs no csum found for inode 257 start 258048
[  136.157239] btrfs no csum found for inode 257 start 262144
[  136.157243] btrfs no csum found for inode 257 start 266240
[  136.157248] btrfs no csum found for inode 257 start 270336
[  136.157252] btrfs no csum found for inode 257 start 274432
[  136.157257] btrfs no csum found for inode 257 start 278528
[  136.157261] btrfs no csum found for inode 257 start 282624
[  136.157266] btrfs no csum found for inode 257 start 286720
[  136.157270] btrfs no csum found for inode 257 start 290816
[  136.157274] btrfs no csum found for inode 257 start 294912
[  136.157279] btrfs no csum found for inode 257 start 299008
[  136.157283] btrfs no csum found for inode 257 start 303104
[  136.157288] btrfs no csum found for inode 257 start 307200
[  136.157292] btrfs no csum found for inode 257 start 311296
[  136.157297] btrfs no csum found for inode 257 start 315392
[  136.157301] btrfs no csum found for inode 257 start 319488
[  136.157306] btrfs no csum found for inode 257 start 323584
[  136.157310] btrfs no csum found for inode 257 start 327680
[  136.157315] btrfs no csum found for inode 257 start 331776
[  136.157319] btrfs no csum found for inode 257 start 335872
[  136.157324] btrfs no csum found for inode 257 start 339968
[  136.169414] btrfs csum failed ino 257 off 16384 csum 2566472073 
private 0
[  136.169434] btrfs csum failed ino 257 off 20480 csum 2566472073 
private 0
[  136.169440] btrfs csum failed ino 257 off 24576 csum 2566472073 
private 0
[  136.169445] btrfs csum failed ino 257 off 28672 csum 2566472073 
private 0
[  136.169461] btrfs csum failed ino 257 off 32768 csum 2566472073 
private 0
[  136.169466] btrfs csum failed ino 257 off 36864 csum 2566472073 
private 0
[  136.170275] btrfs no csum found for inode 257 start 344064
[  136.170277] btrfs no csum found for inode 257 start 348160
[  136.170278] btrfs no csum found for inode 257 start 352256
[  136.170279] btrfs no csum found for inode 257 start 356352
[  136.170280] btrfs no csum found for inode 257 start 360448
[  136.170281] btrfs no csum found for inode 257 start 364544
[  136.170282] btrfs no csum found for inode 257 start 368640
[  136.170283] btrfs no csum found for inode 257 start 372736
[  136.170284] btrfs no csum found for inode 257 start 376832
[  136.170285] btrfs no csum found for inode 257 start 380928
[  136.170286] btrfs no csum found for inode 257 start 385024
[  136.170287] btrfs no csum found for inode 257 start 389120
[  136.170288] btrfs no csum found for inode 257 start 393216
[  136.170289] btrfs no csum found for inode 257 start 397312
[  136.170290] btrfs no csum found for inode 257 start 401408
[  136.170291] btrfs no csum found for inode 257 start 405504
[  136.170292] btrfs no csum found for inode 257 start 409600
[  136.170293] btrfs no csum found for inode 257 start 413696
[  136.170294] btrfs no csum found for inode 257 start 417792
[  136.170295] btrfs no csum found for inode 257 start 421888
[  136.170296] btrfs no csum found for inode 257 start 425984
[  136.170297] btrfs no csum found for inode 257 start 430080
[  136.170298] btrfs no csum found for inode 257 start 434176
[  136.170299] btrfs no csum found for inode 257 start 438272
[  136.170316] btrfs no csum found for inode 257 start 442368
[  136.170321] btrfs no csum found for inode 257 start 446464
[  136.170325] btrfs no csum found for inode 257 start 450560
[  136.170329] btrfs no csum found for inode 257 start 454656
[  136.170334] btrfs no csum found for inode 257 start 458752
[  136.170338] btrfs no csum found for inode 257 start 462848
[  136.170342] btrfs no csum found for inode 257 start 466944
[  136.170347] btrfs no csum found for inode 257 start 471040
[  136.170351] btrfs no csum found for inode 257 start 475136
[  136.170356] btrfs no csum found for inode 257 start 479232
[  136.170360] btrfs no csum found for inode 257 start 483328
[  136.170364] btrfs no csum found for inode 257 start 487424
[  136.170369] btrfs no csum found for inode 257 start 491520
[  136.170373] btrfs no csum found for inode 257 start 495616
[  136.170381] btrfs no csum found for inode 257 start 503808
[  136.170386] btrfs no csum found for inode 257 start 507904
[  136.170390] btrfs no csum found for inode 257 start 512000
[  136.170395] btrfs no csum found for inode 257 start 516096
[  136.170399] btrfs no csum found for inode 257 start 520192
[  136.170404] btrfs no csum found for inode 257 start 524288
[  136.170408] btrfs no csum found for inode 257 start 528384
[  136.170413] btrfs no csum found for inode 257 start 532480
[  136.170418] btrfs no csum found for inode 257 start 536576
[  136.170422] btrfs no csum found for inode 257 start 540672
[  136.170427] btrfs no csum found for inode 257 start 544768
[  136.170431] btrfs no csum found for inode 257 start 548864
[  136.170436] btrfs no csum found for inode 257 start 552960
[  136.170441] btrfs no csum found for inode 257 start 557056
[  136.170445] btrfs no csum found for inode 257 start 561152
[  136.170450] btrfs no csum found for inode 257 start 565248
[  136.170454] btrfs no csum found for inode 257 start 569344
[  136.170459] btrfs no csum found for inode 257 start 573440
[  136.170464] btrfs no csum found for inode 257 start 577536
[  136.170468] btrfs no csum found for inode 257 start 581632
[  136.170473] btrfs no csum found for inode 257 start 585728
[  136.170477] btrfs no csum found for inode 257 start 589824
[  136.170482] btrfs no csum found for inode 257 start 593920
[  136.170486] btrfs no csum found for inode 257 start 598016
[  136.170491] btrfs no csum found for inode 257 start 602112
[  136.170496] btrfs no csum found for inode 257 start 606208
[  136.170500] btrfs no csum found for inode 257 start 610304
[  136.170505] btrfs no csum found for inode 257 start 614400
[  136.170509] btrfs no csum found for inode 257 start 618496
[  136.170514] btrfs no csum found for inode 257 start 622592
[  136.170519] btrfs no csum found for inode 257 start 626688
[  136.170523] btrfs no csum found for inode 257 start 630784
[  136.170528] btrfs no csum found for inode 257 start 634880
[  136.170532] btrfs no csum found for inode 257 start 638976
[  136.170537] btrfs no csum found for inode 257 start 643072
[  136.170542] btrfs no csum found for inode 257 start 647168
[  136.170546] btrfs no csum found for inode 257 start 651264
[  136.170551] btrfs no csum found for inode 257 start 655360
[  136.170555] btrfs no csum found for inode 257 start 659456
[  136.170560] btrfs no csum found for inode 257 start 663552
[  136.170564] btrfs no csum found for inode 257 start 667648
[  136.170569] btrfs no csum found for inode 257 start 671744
[  136.170574] btrfs no csum found for inode 257 start 675840
[  136.170578] btrfs no csum found for inode 257 start 679936
[  136.170583] btrfs no csum found for inode 257 start 684032
[  136.170587] btrfs no csum found for inode 257 start 688128
[  136.170592] btrfs no csum found for inode 257 start 692224
[  136.170597] btrfs no csum found for inode 257 start 696320
[  136.170601] btrfs no csum found for inode 257 start 700416
[  136.170606] btrfs no csum found for inode 257 start 704512
[  136.170610] btrfs no csum found for inode 257 start 708608
[  136.170615] btrfs no csum found for inode 257 start 712704
[  136.170619] btrfs no csum found for inode 257 start 716800
[  136.170624] btrfs no csum found for inode 257 start 720896
[  136.170629] btrfs no csum found for inode 257 start 724992
[  136.170633] btrfs no csum found for inode 257 start 729088
[  136.170638] btrfs no csum found for inode 257 start 733184
[  136.170642] btrfs no csum found for inode 257 start 737280
[  136.170647] btrfs no csum found for inode 257 start 741376
[  136.170651] btrfs no csum found for inode 257 start 745472
[  136.170656] btrfs no csum found for inode 257 start 749568
[  136.170661] btrfs no csum found for inode 257 start 753664
[  136.170665] btrfs no csum found for inode 257 start 757760
[  136.170670] btrfs no csum found for inode 257 start 761856
[  136.170674] btrfs no csum found for inode 257 start 765952
[  136.170679] btrfs no csum found for inode 257 start 770048
[  136.170684] btrfs no csum found for inode 257 start 774144
[  136.170688] btrfs no csum found for inode 257 start 778240
[  136.170693] btrfs no csum found for inode 257 start 782336
[  136.170697] btrfs no csum found for inode 257 start 786432
[  136.170702] btrfs no csum found for inode 257 start 790528
[  136.170706] btrfs no csum found for inode 257 start 794624
[  136.170711] btrfs no csum found for inode 257 start 798720
[  136.170716] btrfs no csum found for inode 257 start 802816
[  136.170720] btrfs no csum found for inode 257 start 806912
[  136.170725] btrfs no csum found for inode 257 start 811008
[  136.170729] btrfs no csum found for inode 257 start 815104
[  136.170734] btrfs no csum found for inode 257 start 819200
[  136.170739] btrfs no csum found for inode 257 start 823296
[  136.170743] btrfs no csum found for inode 257 start 827392
[  136.170748] btrfs no csum found for inode 257 start 831488
[  136.170752] btrfs no csum found for inode 257 start 835584
[  136.170757] btrfs no csum found for inode 257 start 839680
[  136.170781] btrfs no csum found for inode 257 start 843776
[  136.170788] btrfs no csum found for inode 257 start 847872
[  136.170792] btrfs no csum found for inode 257 start 851968
[  136.170797] btrfs no csum found for inode 257 start 856064
[  136.170801] btrfs no csum found for inode 257 start 860160
[  136.170806] btrfs no csum found for inode 257 start 864256
[  136.180971] btrfs no csum found for inode 257 start 868352
[  136.180973] btrfs no csum found for inode 257 start 872448
[  136.180974] btrfs no csum found for inode 257 start 876544
[  136.180975] btrfs no csum found for inode 257 start 880640
[  136.180976] btrfs no csum found for inode 257 start 884736
[  136.180978] btrfs no csum found for inode 257 start 888832
[  136.180979] btrfs no csum found for inode 257 start 892928
[  136.180980] btrfs no csum found for inode 257 start 897024
[  136.180981] btrfs no csum found for inode 257 start 901120
[  136.180982] btrfs no csum found for inode 257 start 905216
[  136.180983] btrfs no csum found for inode 257 start 909312
[  136.180984] btrfs no csum found for inode 257 start 913408
[  136.180985] btrfs no csum found for inode 257 start 917504
[  136.180986] btrfs no csum found for inode 257 start 921600
[  136.180987] btrfs no csum found for inode 257 start 925696
[  136.180988] btrfs no csum found for inode 257 start 929792
[  136.180990] btrfs no csum found for inode 257 start 933888
[  136.180991] btrfs no csum found for inode 257 start 937984
[  136.180992] btrfs no csum found for inode 257 start 942080
[  136.180993] btrfs no csum found for inode 257 start 946176
[  136.180994] btrfs no csum found for inode 257 start 950272
[  136.180995] btrfs no csum found for inode 257 start 954368
[  136.180996] btrfs no csum found for inode 257 start 958464
[  136.180997] btrfs no csum found for inode 257 start 962560
[  136.180998] btrfs no csum found for inode 257 start 966656
[  136.180999] btrfs no csum found for inode 257 start 970752
[  136.181001] btrfs no csum found for inode 257 start 974848
[  136.181015] btrfs no csum found for inode 257 start 978944
[  136.181016] btrfs no csum found for inode 257 start 983040
[  136.181017] btrfs no csum found for inode 257 start 987136
[  136.181018] btrfs no csum found for inode 257 start 991232
[  136.181019] btrfs no csum found for inode 257 start 995328
[  136.181020] btrfs no csum found for inode 257 start 999424

