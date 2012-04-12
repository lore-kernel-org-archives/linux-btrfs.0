From: =?ISO-8859-1?Q?Csaba_T=F3th?= <tcsaba@greengaialing.hu>
Subject: [PATCH] mkfs.btrfs on ARM
Date: Thu, 12 Apr 2012 11:36:40 +0100
Message-ID: <4F86B038.5060402@greengaialing.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090000080004060705010600"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090000080004060705010600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

    I tried to run the mkfs.btrfs command on an AT91SAM9260 processor 
(ARM, at91).
The cross compiling was quite simple but it doesn't work on the target 
platform.
The mkfs.btrfs stopped with an assert and the filesystem wasn't mountable.

    I looked for solution on the internet. Some people noticed this 
issue too, but nobody has a patch about it.
I found an interesting information, that some ARM processor isn't able 
to access a word from an
halfword aligned location 
(http://www.aleph1.co.uk/chapter-10-arm-structured-alignment-faq).
The gcc consider to use the correct alignment but in some situation the 
problem is remaining.

    In the btrfs-progs there are a struct named extent_buffer. It has a 
data field which could contains a bunch
of unaligned structs. The gcc can't access the member fields of these 
structs correctly.
I found a workaround/solution that solve this problem. If I use the 
memcpy command instead of setting or getting
members directly, the problem is eliminated.

    I have written a patch which works correctly on my platform.
I have attached this patch to my letter.

Best regards,
    Csaba Tóth, Watt 22 Ltd.



--------------090000080004060705010600
Content-Type: text/x-patch;
 name="btrfs-progs-0.19.arm_align.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfs-progs-0.19.arm_align.patch"

diff -ur btrfs-progs-0.19.orig/ctree.c btrfs-progs-0.19/ctree.c
--- btrfs-progs-0.19.orig/ctree.c	2009-06-11 17:56:15.000000000 +0100
+++ btrfs-progs-0.19/ctree.c	2012-04-08 20:54:48.012221953 +0100
@@ -722,14 +722,14 @@
 	int mid;
 	int ret;
 	unsigned long offset;
-	struct btrfs_disk_key *tmp;
+	struct btrfs_disk_key tmp;
 
 	while(low < high) {
 		mid = (low + high) / 2;
 		offset = p + mid * item_size;
 
-		tmp = (struct btrfs_disk_key *)(eb->data + offset);
-		ret = btrfs_comp_keys(tmp, key);
+		memcpy(&tmp, eb->data + offset, sizeof(struct btrfs_disk_key));
+		ret = btrfs_comp_keys(&tmp, key);
 
 		if (ret < 0)
 			low = mid + 1;
diff -ur btrfs-progs-0.19.orig/ctree.h btrfs-progs-0.19/ctree.h
--- btrfs-progs-0.19.orig/ctree.h	2009-06-11 17:56:15.000000000 +0100
+++ btrfs-progs-0.19/ctree.h	2012-04-08 20:25:04.578695193 +0100
@@ -890,14 +890,17 @@
 {									\
 	unsigned long offset = (unsigned long)s;			\
 	type *p = (type *) (eb->data + offset);				\
-	return le##bits##_to_cpu(p->member);				\
+	u##bits tmp;							\
+	memcpy(&tmp, &(p->member), sizeof(tmp));			\
+	return le##bits##_to_cpu(tmp);					\
 }									\
 static inline void btrfs_set_##name(struct extent_buffer *eb,		\
 				    type *s, u##bits val)		\
 {									\
 	unsigned long offset = (unsigned long)s;			\
 	type *p = (type *) (eb->data + offset);				\
-	p->member = cpu_to_le##bits(val);				\
+	u##bits tmp = cpu_to_le##bits(val);				\
+	memcpy(&(p->member), &tmp, sizeof(tmp));			\
 }
 
 #define BTRFS_SETGET_STACK_FUNCS(name, type, member, bits)		\


--------------090000080004060705010600--
