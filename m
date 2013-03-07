Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:60782 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab3CGVjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 16:39:00 -0500
Received: by mail-oa0-f44.google.com with SMTP id h1so1234371oag.31
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2013 13:39:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5138D80F.1080304@petaramesh.org>
References: <513883DD.8080203@petaramesh.org>
	<5138980C.8080000@redhat.com>
	<5138ADA6.5070101@petaramesh.org>
	<5138AE96.3020304@redhat.com>
	<5138B08F.70607@petaramesh.org>
	<CALJXSJrbF678ghk63P=m2wc5NGnRjrvk2cGMqSnKHXzXG+i3Tg@mail.gmail.com>
	<5138D80F.1080304@petaramesh.org>
Date: Thu, 7 Mar 2013 15:38:59 -0600
Message-ID: <CAKcLGm8AmvQXU8uvDdVJAKRWmv97cpgM80mnUzxbsc39uC3MOg@mail.gmail.com>
Subject: Re: mkfs.btrfs broken
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Cc: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>,
        Anand Jain <Anand.Jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 7, 2013 at 12:10 PM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> Le 07/03/2013 19:06, Jérôme Poulin a écrit :
>> mkfs.btrfs tries to lookup loop devices by their filenames and fails
>> if any loop device file is missing.
>
> Hmm.... Why would mkfs.btrfs want to lookup anything else but the device
> we're trying to format, to check if it's mounted or not ?
>

At Sabayon, we pretty-much hacked our way around this with a
"make-it-go" kind of patch.

Otherwise, our installation would break with btrfs on our
Live-[CD/DVD/USB] media.

I know we should have taken the time to put together a proper
solution, but I could never figure out the  reasoning for needing to
scan every device either.

--- btrfs-progs-0.19.orig/utils.c
+++ btrfs-progs-0.19/utils.c
@@ -708,6 +708,21 @@ int is_same_blk_file(const char* a, cons
 	return 0;
 }

+/* Checks if a file exists and is a block or regular file*/
+int is_existing_blk_or_reg_file(const char* filename)
+{
+	struct stat st_buf;
+
+	if(stat(filename, &st_buf) < 0) {
+		if(errno == ENOENT)
+			return 0;
+		else
+			return -errno;
+	}
+
+	return (S_ISBLK(st_buf.st_mode) || S_ISREG(st_buf.st_mode));
+}
+
 /* checks if a and b are identical or device
  * files associated with the same block device or
  * if one file is a loop device that uses the other
@@ -727,7 +742,10 @@ int is_same_loop_file(const char* a, con
 	} else if(ret) {
 		if((ret = resolve_loop_device(a, res_a, sizeof(res_a))) < 0)
 			return ret;
-
+		/* if the resolved path is not available, there is nothing
+		   we can do */
+		if((ret = is_existing_blk_or_reg_file(res_a)) == 0)
+			return ret;
 		final_a = res_a;
 	} else {
 		final_a = a;
@@ -739,6 +757,10 @@ int is_same_loop_file(const char* a, con
 	} else if(ret) {
 		if((ret = resolve_loop_device(b, res_b, sizeof(res_b))) < 0)
 			return ret;
+		/* if the resolved path is not available, there is nothing
+		   we can do */
+		if((ret = is_existing_blk_or_reg_file(res_b)) == 0)
+			return ret;

 		final_b = res_b;
 	} else {
@@ -748,21 +770,6 @@ int is_same_loop_file(const char* a, con
 	return is_same_blk_file(final_a, final_b);
 }

-/* Checks if a file exists and is a block or regular file*/
-int is_existing_blk_or_reg_file(const char* filename)
-{
-	struct stat st_buf;
-
-	if(stat(filename, &st_buf) < 0) {
-		if(errno == ENOENT)
-			return 0;
-		else
-			return -errno;
-	}
-
-	return (S_ISBLK(st_buf.st_mode) || S_ISREG(st_buf.st_mode));
-}
-
 /* Checks if a file is used (directly or indirectly via a loop device)
  * by a device in fs_devices
  */
