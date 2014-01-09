Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29490 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753729AbaAIW2h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 17:28:37 -0500
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s09MIwh2018360
	for <linux-btrfs@vger.kernel.org>; Thu, 9 Jan 2014 14:28:37 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1ha3n187c5-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Jan 2014 14:28:36 -0800
From: Chris Mason <clm@fb.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH]   Btrfs: setup inode location during btrfs_init_inode_locked
Date: Thu, 9 Jan 2014 22:28:34 +0000
Message-ID: <1389306538.839.2.camel@ret.masoncoding.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have a race during inode init because the BTRFS+AF8-I(inode)-+AD4-location is setup
after the inode hash table lock is dropped.  btrfs+AF8-find+AF8-actor uses the location
field, so our search might not find an existing inode in the hash table if we
race with the inode init code.

This commit things to setup the location field sooner.  Also the find actor now
uses only the location objectid to match inodes.  For inode hashing, we just
need a unique and stable test, it doesn't have to reflect the inode numbers we
show to userland.

Signed-off-by: Chris Mason +ADw-clm+AEA-fb.com+AD4-

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9eaa1c8..8010b49 100644
--- a/fs/btrfs/inode.c
+-+-+- b/fs/btrfs/inode.c
+AEAAQA- -60,7 +-60,7 +AEAAQA-
 +ACM-include +ACI-hash.h+ACI-
 
 struct btrfs+AF8-iget+AF8-args +AHs-
-	u64 ino+ADs-
+-	struct btrfs+AF8-key +ACo-location+ADs-
 	struct btrfs+AF8-root +ACo-root+ADs-
 +AH0AOw-
 
+AEAAQA- -4932,7 +-4932,9 +AEAAQA- again:
 static int btrfs+AF8-init+AF8-locked+AF8-inode(struct inode +ACo-inode, void +ACo-p)
 +AHs-
 	struct btrfs+AF8-iget+AF8-args +ACo-args +AD0- p+ADs-
-	inode-+AD4-i+AF8-ino +AD0- args-+AD4-ino+ADs-
+-	inode-+AD4-i+AF8-ino +AD0- args-+AD4-location-+AD4-objectid+ADs-
+-	memcpy(+ACY-BTRFS+AF8-I(inode)-+AD4-location, args-+AD4-location,
+-	       sizeof(+ACo-args-+AD4-location))+ADs-
 	BTRFS+AF8-I(inode)-+AD4-root +AD0- args-+AD4-root+ADs-
 	return 0+ADs-
 +AH0-
+AEAAQA- -4940,19 +-4942,19 +AEAAQA- static int btrfs+AF8-init+AF8-locked+AF8-inode(struct inode +ACo-inode, void +ACo-p)
 static int btrfs+AF8-find+AF8-actor(struct inode +ACo-inode, void +ACo-opaque)
 +AHs-
 	struct btrfs+AF8-iget+AF8-args +ACo-args +AD0- opaque+ADs-
-	return args-+AD4-ino +AD0APQ- btrfs+AF8-ino(inode) +ACYAJg-
+-	return args-+AD4-location-+AD4-objectid +AD0APQ- BTRFS+AF8-I(inode)-+AD4-location.objectid +ACYAJg-
 		args-+AD4-root +AD0APQ- BTRFS+AF8-I(inode)-+AD4-root+ADs-
 +AH0-
 
 static struct inode +ACo-btrfs+AF8-iget+AF8-locked(struct super+AF8-block +ACo-s,
-				       u64 objectid,
+-				       struct btrfs+AF8-key +ACo-location,
 				       struct btrfs+AF8-root +ACo-root)
 +AHs-
 	struct inode +ACo-inode+ADs-
 	struct btrfs+AF8-iget+AF8-args args+ADs-
-	unsigned long hashval +AD0- btrfs+AF8-inode+AF8-hash(objectid, root)+ADs-
+-	unsigned long hashval +AD0- btrfs+AF8-inode+AF8-hash(location-+AD4-objectid, root)+ADs-
 
-	args.ino +AD0- objectid+ADs-
+-	args.location +AD0- location+ADs-
 	args.root +AD0- root+ADs-
 
 	inode +AD0- iget5+AF8-locked(s, hashval, btrfs+AF8-find+AF8-actor,
+AEAAQA- -4969,13 +-4971,11 +AEAAQA- struct inode +ACo-btrfs+AF8-iget(struct super+AF8-block +ACo-s, struct btrfs+AF8-key +ACo-location,
 +AHs-
 	struct inode +ACo-inode+ADs-
 
-	inode +AD0- btrfs+AF8-iget+AF8-locked(s, location-+AD4-objectid, root)+ADs-
+-	inode +AD0- btrfs+AF8-iget+AF8-locked(s, location, root)+ADs-
 	if (+ACE-inode)
 		return ERR+AF8-PTR(-ENOMEM)+ADs-
 
 	if (inode-+AD4-i+AF8-state +ACY- I+AF8-NEW) +AHs-
-		BTRFS+AF8-I(inode)-+AD4-root +AD0- root+ADs-
-		memcpy(+ACY-BTRFS+AF8-I(inode)-+AD4-location, location, sizeof(+ACo-location))+ADs-
 		btrfs+AF8-read+AF8-locked+AF8-inode(inode)+ADs-
 		if (+ACE-is+AF8-bad+AF8-inode(inode)) +AHs-
 			inode+AF8-tree+AF8-add(inode)+ADs-

