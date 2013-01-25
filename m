Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756137Ab3AYQGS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 11:06:18 -0500
Message-ID: <5102AD72.2050307@redhat.com>
Date: Fri, 25 Jan 2013 10:06:10 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Gene Czarcinski <gene@czarc.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
References: <1359113550-23962-1-git-send-email-gene@czarc.net> <51029EFB.90301@czarc.net>
In-Reply-To: <51029EFB.90301@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/25/13 9:04 AM, Gene Czarcinski wrote:
> OK, I think I have gotten the message that this is a bad idea as
> implemented and that it should be dropped as such.  I believe that
> there are some things ("btrfs fi show" comes to mind) which will need
> root and I am going to explore doing something for that case.  And it
> also might be reasonable for some situations to issue the message
> about root if something errors-out.

So, in that particular case, I think the right fix is to make the code
in that spot be more informative; there are probably a whole lot of
places that could use fixes like this, though, not just this one.
Still, it would be helpful to the user, I think.

i.e. show:

[testuser@host btrfs-progs]$ whoami
testuser
[testuser@host btrfs-progs]$ ./btrfs fi show
failed to open /dev/sda: Permission denied
failed to open /dev/sda1: Permission denied
...


[PATCH] print more informative error when we fail to open a device

If open() fails, we should let the user know why it failed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/utils.c b/utils.c
index 595850b..a5673f7 100644
--- a/utils.c
+++ b/utils.c
@@ -1237,7 +1237,8 @@ scan_again:
 
 		fd = open(fullpath, O_RDONLY);
 		if (fd < 0) {
-			fprintf(stderr, "failed to read %s\n", fullpath);
+			fprintf(stderr, "failed to open %s: %s\n",
+				fullpath, strerror(errno));
 			continue;
 		}
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,

