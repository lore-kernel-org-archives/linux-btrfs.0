Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47501 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaG2CSb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 22:18:31 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 8E6963EE1A0
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 11:18:29 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id A639FAC051C
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 11:18:28 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 5DFDD1DB8049
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jul 2014 11:18:28 +0900 (JST)
Message-ID: <53D70469.1030504@jp.fujitsu.com>
Date: Tue, 29 Jul 2014 11:18:17 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Kyle Gates <kylegates@hotmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: Unify the messy error message formats
References: <53D1F661.1030504@jp.fujitsu.com> <BAY172-W33CE4C937687878CDD0C23B0FB0@phx.gbl>
In-Reply-To: <BAY172-W33CE4C937687878CDD0C23B0FB0@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Kyle,

(2014/07/28 22:24), Kyle Gates wrote:
>
> small wording error inline below
>
> ----------------------------------------
>> Date: Fri, 25 Jul 2014 15:17:05 +0900
>> From: takeuchi_satoru@jp.fujitsu.com
>> To: linux-btrfs@vger.kernel.org
>> Subject: [PATCH 2/2] btrfs-progs: Unify the messy error message formats
>>
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> - There are many format to show snapshot name in error messages,
>> "'%s'", "'%s", "%s", "('%s')", and "('%s)". Since it's messy,
>> unify these to "'%s'" format.
>> - Fix a type: s/uncorrect/incorrect/
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> ---
>> cmds-subvolume.c | 16 ++++++++--------
>> 1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/cmds-subvolume.c b/cmds-subvolume.c
>> index b7bfb3e..ce38503 100644
>> --- a/cmds-subvolume.c
>> +++ b/cmds-subvolume.c
>> @@ -140,14 +140,14 @@ static int cmd_subvol_create(int argc, char **argv)
>> dstdir = dirname(dupdir);
>>
>> if (!test_issubvolname(newname)) {
>> - fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
>> + fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
>> newname);
>> goto out;
>> }
>>
>> len = strlen(newname);
>> if (len == 0 || len>= BTRFS_VOL_NAME_MAX) {
>> - fprintf(stderr, "ERROR: subvolume name('%s)\n",
>> + fprintf(stderr, "ERROR: subvolume name too long '%s'\n",
>> newname);
>> goto out;
>> }
>> @@ -314,7 +314,7 @@ again:
>> free(cpath);
>>
>> if (!test_issubvolname(vname)) {
>> - fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
>> + fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
>> vname);
>> ret = 1;
>> goto out;
>> @@ -322,7 +322,7 @@ again:
>>
>> len = strlen(vname);
>> if (len == 0 || len>= BTRFS_VOL_NAME_MAX) {
>> - fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
>> + fprintf(stderr, "ERROR: too long snapshot name '%s'\n",
>
> + fprintf(stderr, "ERROR: snapshot name too long '%s'\n",

Thank you for your comment. Fixed. How about is it?

===
 From 73f9847c603fbe863f072d029b1a4948a1032d6e Mon Sep 17 00:00:00 2001
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Date: Fri, 25 Jul 2014 12:46:27 +0900
Subject: [PATCH] btrfs-progs: unify the format of error messages.

---
  cmds-subvolume.c | 16 ++++++++--------
  1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index b7bfb3e..5a99c94 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -140,14 +140,14 @@ static int cmd_subvol_create(int argc, char **argv)
  	dstdir = dirname(dupdir);
  
  	if (!test_issubvolname(newname)) {
-		fprintf(stderr, "ERROR: uncorrect subvolume name ('%s')\n",
+		fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
  			newname);
  		goto out;
  	}
  
  	len = strlen(newname);
  	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: subvolume name too long ('%s)\n",
+		fprintf(stderr, "ERROR: subvolume name too long '%s'\n",
  			newname);
  		goto out;
  	}
@@ -314,7 +314,7 @@ again:
  	free(cpath);
  
  	if (!test_issubvolname(vname)) {
-		fprintf(stderr, "ERROR: incorrect subvolume name ('%s')\n",
+		fprintf(stderr, "ERROR: incorrect subvolume name '%s'\n",
  			vname);
  		ret = 1;
  		goto out;
@@ -322,7 +322,7 @@ again:
  
  	len = strlen(vname);
  	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
+		fprintf(stderr, "ERROR: snapshot name too long '%s'\n",
  			vname);
  		ret = 1;
  		goto out;
@@ -722,14 +722,14 @@ static int cmd_snapshot(int argc, char **argv)
  	}
  
  	if (!test_issubvolname(newname)) {
-		fprintf(stderr, "ERROR: incorrect snapshot name ('%s')\n",
+		fprintf(stderr, "ERROR: incorrect snapshot name '%s'\n",
  			newname);
  		goto out;
  	}
  
  	len = strlen(newname);
  	if (len == 0 || len >= BTRFS_VOL_NAME_MAX) {
-		fprintf(stderr, "ERROR: snapshot name too long ('%s)\n",
+		fprintf(stderr, "ERROR: snapshot name too long '%s'\n",
  			newname);
  		goto out;
  	}
@@ -778,7 +778,7 @@ static int cmd_snapshot(int argc, char **argv)
  	res = ioctl(fddst, BTRFS_IOC_SNAP_CREATE_V2, &args);
  
  	if (res < 0) {
-		fprintf( stderr, "ERROR: cannot snapshot %s - %s\n",
+		fprintf( stderr, "ERROR: cannot snapshot '%s' - %s\n",
  			subvol_descr, strerror(errno));
  		goto out;
  	}
@@ -991,7 +991,7 @@ static int cmd_subvol_show(int argc, char **argv)
  
  	ret = find_mount_root(fullpath, &mnt);
  	if (ret < 0) {
-		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
+		fprintf(stderr, "ERROR: find_mount_root failed on '%s': "
  				"%s\n", fullpath, strerror(-ret));
  		goto out;
  	}
-- 
1.9.3

