From: "Tobias Arp" <tobiasarp@gmx.de>
Subject: mkfs.btrfs on arm
Date: Tue, 24 Apr 2012 16:10:57 +0200
Message-ID: <20120424141057.140060@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

yesterday i tried mkfs.btrfs on my embedded arm system without success (git clone from 2012-04-24).
I got always this error message (this "bug" where already mentioned some month ago)

mkfs.btrfs /dev/sda1
                                                                              
WARNING! - Btrfs Btrfs v0.19-dirty IS EPERIMENTAL                                             
WARNING! - see http://btrfs.wiki.kernel.org before using                                                                                                                                                                                                                                            
mkfs.btrfs: volumes.c:843: btrfs_alloc_chunk: Assertion `!(ret)' failed.
Aborted                                                                                                                                                                            

I turned aligment warnings on:

echo 1 > /proc/cpu/aligment

so i got this messages:

mkfs.btrfs /dev/sda1
                                                                                                                                                                                                                                           
WARNING! - Btrfs Btrfs v0.19-dirty IS EXPERIMENTAL                                             
WARNING! - see http://btrfs.wiki.kernel.org before using

Alignment trap: mkfs.btrfs (70) PC=0x00039f4c Instr=0xe8820018 Address=0xbebbbae9 FSR 0x813                                                                                                                                                      
Alignment trap: mkfs.btrfs (70) PC=0x00039f4c Instr=0xe8820018 Address=0xbebbbae9 FSR 0x813

mkfs.btrfs: volumes.c:843: btrfs_alloc_chunk: Assertion `!(ret)' failed.
Aborted      

I tracked down the problem and changed this:

--- volumes.c    2012-04-24 15:20:51.404182411 +0200
+++ ../btrfs-progs-test/volumes.c    2012-04-24 15:20:09.492181736 +0200
@@ -402,6 +402,7 @@
     struct btrfs_key key;
     struct btrfs_chunk *chunk;
     struct btrfs_key found_key;
+    u64 u64temp;
 
     path = btrfs_alloc_path();
     BUG_ON(!path);
@@ -427,8 +428,9 @@
         else {
             chunk = btrfs_item_ptr(path->nodes[0], path->slots[0],
                            struct btrfs_chunk);
-            *offset = found_key.offset +
+            u64temp = found_key.offset +
                 btrfs_chunk_length(path->nodes[0], chunk);
+            memcpy(offset,&u64temp,sizeof(u64));
         }
     }
     ret = 0;

But there are many other places where an aligment trap could occur, particularly where packed structures are used
(we will get often elements with adresses which are unaligned). So how can i fix it easily? I don't know much about btrfs so i cannot estimate where it is allowed to change...

Best regards

Tobias


-- 
NEU: FreePhone 3-fach-Flat mit kostenlosem Smartphone!                                  
Jetzt informieren: http://mobile.1und1.de/?ac=OM.PW.PW003K20328T7073a
