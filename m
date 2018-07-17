Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47964 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729742AbeGQWlP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 18:41:15 -0400
Date: Wed, 18 Jul 2018 00:05:08 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH resend 0/2] btrfs: fix races between exec and defrag
Message-ID: <20180717220357.hn7mvajicpy7hu3l@angband.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qrmq5hzaqcdsblhm"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qrmq5hzaqcdsblhm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!
Here's a ping for a patch to fix ETXTBSY races between defrag and exec, just
like the dedupe counterpart.  Unlike that one which is shared to multiple
filesystems and thus lives in Al Viro's land, it is btrfs only.

Attached: a simple tool to fragment a file, by ten O_SYNC rewrites of length
1 at random positions; racey vs concurrent writes or execs but shouldn't
damage the file otherwise.

Also attached: a preliminary patch for -progs; it yet lacks a check for the
kernel version, but to add such a check we'd need to know which kernels
actually permit ro defrag for non-root.

No man page patch -- there's no man page to be patched...


Meow!
-- 
// If you believe in so-called "intellectual property", please immediately
// cease using counterfeit alphabets.  Instead, contact the nearest temple
// of Amon, whose priests will provide you with scribal services for all
// your writing needs, for Reasonable And Non-Discriminatory prices.

--qrmq5hzaqcdsblhm
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="fragme.c"

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdarg.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/syscall.h>

static void die(const char *txt, ...) __attribute__((format (printf, 1, 2)));
static void die(const char *txt, ...)
{
    fprintf(stderr, "fragme: ");

    va_list ap;
    va_start(ap, txt);
    vfprintf(stderr, txt, ap);
    va_end(ap);

    exit(1);
}

static uint64_t rnd(uint64_t max)
{
    __uint128_t r;
    if (syscall(SYS_getrandom, &r, sizeof(r), 0)==-1)
        die("getrandom(): %m\n");
    return r%max;
}

int main(int argc, char **argv)
{
    if (argc!=2)
        die("Usage: fragme <file>\n");

    int fd = open(argv[1], O_RDWR|O_SYNC);
    if (fd == -1)
        die("open(\"%s\"): %m\n", argv[1]);
    off_t size = lseek(fd, 0, SEEK_END);
    if (size == -1)
        die("lseek(SEEK_END): %m\n");

    for (int i=0; i<10; ++i)
    {
        off_t off = rnd(size);
        char b;
        if (lseek(fd, off, SEEK_SET) != off)
            die("lseek for read: %m\n");
        if (read(fd, &b, 1) != 1)
            die("read(%lu): %m\n", off);
        if (lseek(fd, off, SEEK_SET) != off)
            die("lseek for write: %m\n");
        if (write(fd, &b, 1) != 1)
            die("write: %m\n");
    }

    return 0;
}

--qrmq5hzaqcdsblhm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-defrag-open-files-RO.patch"

>From d040af09adb03daadbba4336700f40425a860320 Mon Sep 17 00:00:00 2001
From: Adam Borowski <kilobyte@angband.pl>
Date: Tue, 28 Nov 2017 01:00:21 +0100
Subject: [PATCH] defrag: open files RO

NOT FOR MERGING -- requires kernel versioning

Fixes EXTXBSY races.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 cmds-filesystem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 30a50bf5..7eb6b7bb 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -876,7 +876,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
 	if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
 		if (defrag_global_verbose)
 			printf("%s\n", fpath);
-		fd = open(fpath, O_RDWR);
+		fd = open(fpath, O_RDONLY);
 		if (fd < 0) {
 			goto error;
 		}
@@ -1012,7 +1012,7 @@ static int cmd_filesystem_defrag(int argc, char **argv)
 		int defrag_err = 0;
 
 		dirstream = NULL;
-		fd = open_file_or_dir(argv[i], &dirstream);
+		fd = open_file_or_dir3(argv[i], &dirstream, O_RDONLY);
 		if (fd < 0) {
 			error("cannot open %s: %m", argv[i]);
 			ret = -errno;
-- 
2.18.0


--qrmq5hzaqcdsblhm--
