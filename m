Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:41764 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbeEUOm7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 10:42:59 -0400
Date: Mon, 21 May 2018 16:42:54 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/2] btrfs: fix races between exec and defrag
Message-ID: <20180521144254.4zdxt6jtxoeca26o@angband.pl>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="egphdl74ahioueus"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--egphdl74ahioueus
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi!
Here's a patch to fix ETXTBSY races between defrag and exec -- similar to
what was just submitted for dedupe, even to the point of being followed by
a second patch that replaces EINVAL with EPERM.

As defrag is not something you're going to do on files you don't write, I
skipped complex rules and I'm sending the original version of the patch
as-is.  It has stewed in my tree for two years (long story...), tested on
multiple machines.

Attached: a simple tool to fragment a file, by ten O_SYNC rewrites of length
1 at random positions; racey vs concurrent writes or execs but shouldn't
damage the file otherwise.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ 
⢿⡄⠘⠷⠚⠋⠀ Certified airhead; got the CT scan to prove that!
⠈⠳⣄⠀⠀⠀⠀ 

--egphdl74ahioueus
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

--egphdl74ahioueus--
