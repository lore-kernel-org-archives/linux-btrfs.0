Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:41282 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaBGAiX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 19:38:23 -0500
Received: by mail-vb0-f44.google.com with SMTP id f12so2098756vbg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 16:38:22 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 7 Feb 2014 00:38:22 +0000
Message-ID: <CALOYprUjGn0rEEJAUw+ggnsazL_F5x4KUMCg2n_+ZeAZT=RJ-w@mail.gmail.com>
Subject: integration-20140206 build failure
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Building the latest integration snapshot, I get the following failure:

----
...
    [CC]     cmds-filesystem.o
cmds-filesystem.c: In function 'cmd_show':
cmds-filesystem.c:740:12: error: invalid storage class for function 'cmd_sync'
 static int cmd_sync(int argc, char **argv)
            ^
cmds-filesystem.c:770:12: error: invalid storage class for function
'parse_compress_type'
 static int parse_compress_type(char *s)
            ^
cmds-filesystem.c:796:12: error: invalid storage class for function 'do_defrag'
 static int do_defrag(int fd, int fancy_ioctl,
            ^
cmds-filesystem.c:813:12: error: invalid storage class for function
'defrag_callback'
 static int defrag_callback(const char *fpath, const struct stat *sb,
            ^
cmds-filesystem.c:848:12: error: invalid storage class for function 'cmd_defrag'
 static int cmd_defrag(int argc, char **argv)
            ^
cmds-filesystem.c:1000:12: error: invalid storage class for function
'cmd_resize'
 static int cmd_resize(int argc, char **argv)
            ^
cmds-filesystem.c:1047:12: error: invalid storage class for function 'cmd_label'
 static int cmd_label(int argc, char **argv)
            ^
cmds-filesystem.c:1076:2: error: non-static initialization of a
flexible array member
  }
  ^
cmds-filesystem.c:1076:2: error: (near initialization for
'filesystem_cmd_group')
cmds-filesystem.c:1082:1: error: expected declaration or statement at
end of input
 }
 ^
cmds-filesystem.c: At top level:
cmds-filesystem.c:602:12: warning: 'cmd_show' defined but not used
[-Wunused-function]
 static int cmd_show(int argc, char **argv)
            ^
Makefile:113: recipe for target 'cmds-filesystem.o' failed
make: *** [cmds-filesystem.o] Error 1
----

Full output at [1]

Apologies if this has already been reported somewhere else, I couldn't
find anything on the mailing list.

Build environment:

Arch Linux
gcc: 4.8.2
glibc: 2.18
make: 4.0
e2fsprogs: 1.42.9
lzo2: 2.06
CFLAGS: -march=x86-64 -mtune=generic -O2 -pipe -fstack-protector
--param=ssp-buffer-size=4

Cheers,


WorMzy

[1] http://pastie.org/8706689
