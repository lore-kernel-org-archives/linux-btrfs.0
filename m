Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kitty.zeroloop.net ([62.210.85.244]:47249 "EHLO
	kitty.zeroloop.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbcAFW45 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 17:56:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 06 Jan 2016 23:51:40 +0100
From: Abe <ml-btrfs@zeroloop.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Broken RAID6, segfault on chunk-recover
In-Reply-To: <568A7460.6070607@zeroloop.net>
References: <568A7460.6070607@zeroloop.net>
Message-ID: <9e61601b1589f0fd9381dc9cf0232e0e@mail.zeroloop.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is the backtrace.
Any chance using chunk-recover will help repair this filesystem?
Thanks


btrfs-progs# git rev-parse HEAD
7c3394ed9ef2063a7256d4bc078a485b6f826bc5

btrfs-progs# gdb --args ./btrfs rescue chunk-recover -v /dev/sdf1

(gdb) r
Starting program: /root/btrfs-progs/btrfs rescue chunk-recover -v 
/dev/sdf1
[Thread debugging using libthread_db enabled]
Using host libthread_db library 
"/lib/x86_64-linux-gnu/libthread_db.so.1".
All Devices:
         Device: id = 7, name = /dev/sdh1
         Device: id = 8, name = /dev/sdg1
         Device: id = 4, name = /dev/sde1
         Device: id = 2, name = /dev/sdc1
         Device: id = 3, name = /dev/sdd1
         Device: id = 5, name = /dev/sdb1
         Device: id = 1, name = /dev/sdf1

[New Thread 0x7ffff6f95700 (LWP 26524)]
[New Thread 0x7ffff6794700 (LWP 26525)]
[New Thread 0x7ffff5f93700 (LWP 26526)]
[New Thread 0x7ffff5792700 (LWP 26527)]
[New Thread 0x7ffff4f91700 (LWP 26528)]
[New Thread 0x7fffe7fff700 (LWP 26529)]
[New Thread 0x7fffe77fe700 (LWP 26530)]

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff5f93700 (LWP 26526)]
btrfs_new_block_group_record (leaf=leaf@entry=0x7fffec0008c0, 
key=key@entry=0x7ffff5f92c30, slot=slot@entry=3) at cmds-check.c:5013
5013            rec->flags = btrfs_disk_block_group_flags(leaf, ptr);


(gdb) bt

#0  btrfs_new_block_group_record (leaf=leaf@entry=0x7fffec0008c0, 
key=key@entry=0x7ffff5f92c30, slot=slot@entry=3) at cmds-check.c:5013
#1  0x00000000004309c6 in process_block_group_item (slot=3, 
key=0x7ffff5f92c30, leaf=0x7fffec0008c0, bg_cache=0x7fffffffe3e8) at 
chunk-recover.c:232
#2  extract_metadata_record (rc=rc@entry=0x7fffffffe3b0, 
leaf=leaf@entry=0x7fffec0008c0) at chunk-recover.c:717
#3  0x0000000000431190 in scan_one_device (dev_scan_struct=0x695820) at 
chunk-recover.c:807
#4  0x00007ffff7341284 in start_thread (arg=0x7ffff5f93700) at 
pthread_create.c:333
#5  0x00007ffff707e74d in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:109


(gdb) thread apply all bt

Thread 8 (Thread 0x7fffe77fe700 (LWP 26530)):
#0  clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:81
#1  0x00007ffff73411c0 in ?? () at pthread_create.c:237 from 
/lib/x86_64-linux-gnu/libpthread.so.0
#2  0x00007fffe77fe700 in ?? ()
#3  0x0000000000000000 in ?? ()

Thread 7 (Thread 0x7fffe7fff700 (LWP 26529)):
#0  clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:81
#1  0x00007ffff73411c0 in ?? () at pthread_create.c:237 from 
/lib/x86_64-linux-gnu/libpthread.so.0
#2  0x00007fffe7fff700 in ?? ()
#3  0x0000000000000000 in ?? ()

Thread 6 (Thread 0x7ffff4f91700 (LWP 26528)):
#0  0x00007ffff734a013 in pread64 () at 
../sysdeps/unix/syscall-template.S:81
#1  0x0000000000430ea5 in pread64 (__offset=532480, __nbytes=<optimized 
out>, __buf=0x7fffdc00093c, __fd=7) at 
/usr/include/x86_64-linux-gnu/bits/unistd.h:117
#2  scan_one_device (dev_scan_struct=0x695860) at chunk-recover.c:776
#3  0x00007ffff7341284 in start_thread (arg=0x7ffff4f91700) at 
pthread_create.c:333
#4  0x00007ffff707e74d in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:109

Thread 5 (Thread 0x7ffff5792700 (LWP 26527)):
#0  0x00007ffff734a013 in pread64 () at 
../sysdeps/unix/syscall-template.S:81
#1  0x0000000000430ea5 in pread64 (__offset=368640, __nbytes=<optimized 
out>, __buf=0x7fffe000093c, __fd=6) at 
/usr/include/x86_64-linux-gnu/bits/unistd.h:117
#2  scan_one_device (dev_scan_struct=0x695840) at chunk-recover.c:776
#3  0x00007ffff7341284 in start_thread (arg=0x7ffff5792700) at 
pthread_create.c:333
#4  0x00007ffff707e74d in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:109

Thread 4 (Thread 0x7ffff5f93700 (LWP 26526)):
#0  btrfs_new_block_group_record (leaf=leaf@entry=0x7fffec0008c0, 
key=key@entry=0x7ffff5f92c30, slot=slot@entry=3) at cmds-check.c:5013
#1  0x00000000004309c6 in process_block_group_item (slot=3, 
key=0x7ffff5f92c30, leaf=0x7fffec0008c0, bg_cache=0x7fffffffe3e8) at 
chunk-recover.c:232
#2  extract_metadata_record (rc=rc@entry=0x7fffffffe3b0, 
leaf=leaf@entry=0x7fffec0008c0) at chunk-recover.c:717
#3  0x0000000000431190 in scan_one_device (dev_scan_struct=0x695820) at 
chunk-recover.c:807
#4  0x00007ffff7341284 in start_thread (arg=0x7ffff5f93700) at 
pthread_create.c:333
#5  0x00007ffff707e74d in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:109

Thread 3 (Thread 0x7ffff6794700 (LWP 26525)):
#0  0x00007ffff734a013 in pread64 () at 
../sysdeps/unix/syscall-template.S:81
#1  0x0000000000430ea5 in pread64 (__offset=3493888, __nbytes=<optimized 
out>, __buf=0x7fffe800093c, __fd=4)
     at /usr/include/x86_64-linux-gnu/bits/unistd.h:117
#2  scan_one_device (dev_scan_struct=0x695800) at chunk-recover.c:776
#3  0x00007ffff7341284 in start_thread (arg=0x7ffff6794700) at 
pthread_create.c:333
#4  0x00007ffff707e74d in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:109

Thread 2 (Thread 0x7ffff6f95700 (LWP 26524)):
#0  0x00007ffff734a013 in pread64 () at 
../sysdeps/unix/syscall-template.S:81
#1  0x0000000000430ea5 in pread64 (__offset=3751936, __nbytes=<optimized 
out>, __buf=0x7ffff000093c, __fd=3)
     at /usr/include/x86_64-linux-gnu/bits/unistd.h:117
#2  scan_one_device (dev_scan_struct=0x6957e0) at chunk-recover.c:776
#3  0x00007ffff7341284 in start_thread (arg=0x7ffff6f95700) at 
pthread_create.c:333
#4  0x00007ffff707e74d in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:109

Thread 1 (Thread 0x7ffff7fe08c0 (LWP 26520)):
#0  clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:81
#1  0x00007ffff73400fa in create_thread (pd=pd@entry=0x7fffe77fe700, 
attr=attr@entry=0x7fffffffe0e0, stopped_start=<optimized out>,
     stopped_start@entry=false, stackaddr=<optimized out>, 
thread_ran=0x7fffffffe0df) at 
../sysdeps/unix/sysv/linux/createthread.c:102
#2  0x00007ffff7341a08 in __pthread_create_2_1 
(newthread=newthread@entry=0x695900, attr=attr@entry=0x0,
     start_routine=start_routine@entry=0x430dd6 <scan_one_device>, 
arg=arg@entry=0x6958a0) at pthread_create.c:677
#3  0x000000000043150e in scan_devices (rc=0x7fffffffe3b0) at 
chunk-recover.c:876
#4  btrfs_recover_chunk_tree (path=path@entry=0x7fffffffe8ab 
"/dev/sdf1", verbose=verbose@entry=1, yes=yes@entry=0) at 
chunk-recover.c:2323
#5  0x000000000042f333 in cmd_rescue_chunk_recover (argc=<optimized 
out>, argv=<optimized out>) at cmds-rescue.c:95
#6  0x0000000000409ca4 in handle_command_group (grp=grp@entry=0x68de20 
<rescue_cmd_group>, argc=3, argv=<optimized out>) at btrfs.c:144
#7  0x000000000042f67e in cmd_rescue (argc=<optimized out>, 
argv=<optimized out>) at cmds-rescue.c:220
#8  0x0000000000409dfe in main (argc=4, argv=0x7fffffffe650) at 
btrfs.c:252
