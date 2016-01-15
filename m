Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbcAOMnE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 07:43:04 -0500
Date: Fri, 15 Jan 2016 13:43:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Noah Massey <noah.massey@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        clm@fb.com
Subject: Static build fixed (Was: Re: Btrfs progs pre-release 4.4-rc1
Message-ID: <20160115124301.GD4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160114124748.GV4227@suse.cz>
 <CADfjVrjSDsD84MJ=kaXNFMj_Mgjnf5_nskROyt=nuTGgTJO3ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADfjVrjSDsD84MJ=kaXNFMj_Mgjnf5_nskROyt=nuTGgTJO3ew@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 09:41:58AM -0500, Noah Massey wrote:
>     [LD]     btrfs.static
> help.static.o: In function `usage_command':
> /usr/local/src/btrfs-progs/help.c:120: multiple definition of `usage_command'
> help.static.o:/usr/local/src/btrfs-progs/help.c:120: first defined here
...
> 
> git bisect blames  a6cc8ea10ad84e4b7d1303ed048e644f0dd7ae04

Thanks, I'm committing the following patch as you found the fix faster.

---
commit 1bb0bba1b625eec1bd288699f10c8855034daef1
Author: Noah Massey <noah.massey@gmail.com>
Date:   Fri Jan 15 13:31:01 2016 +0100

    btrfs-progs: fix static build

    Change in "btrfs-progs: introduce helper for parsing args without
    options" added a dependency on help.o that was duplicated for the static
    build.

    Signed-off-by: Noah Massey <noah.massey@gmail.com>
    Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/Makefile.in b/Makefile.in
index 1bd497aca469..19697ffaf0bf 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -265,9 +265,9 @@ btrfs: $(objects) btrfs.o $(cmds_objects) $(libs_static)
        $(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o $(cmds_objects) \
                $(objects) $(libs_static) $(LDFLAGS) $(LIBS)

-btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objects) $(static_libbtrfs_objects)
+btrfs.static: $(static_objects) btrfs.static.o $(static_cmds_objects) $(static_libbtrfs_objects)
        @echo "    [LD]     $@"
-       $(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
+       $(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o $(static_cmds_objects) \
                $(static_objects) $(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)

 # For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
