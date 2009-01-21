From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: BUG: btrfsck segfaults on regular file
Date: Wed, 21 Jan 2009 10:10:37 +0800
Message-ID: <4976841D.7010107@cn.fujitsu.com>
References: <200901191016.34941.z.carter@f5.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Zach Carter <z.carter@f5.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901191016.34941.z.carter@f5.com>
List-ID: <linux-btrfs.vger.kernel.org>



on 01/20/2009 02:16 AM, Zach Carter wrote:
> We should probably just get an informative error message here, not a segfault.
> 
> Also, I got the same segfault when running "btrfsck -h" (it was looking for a 
> file named "-h".  I'd be happy to contribute a getopts patch, if that is 
> desired.
> 
> -Zach
> 
> [zcarter@nudj btrfs-progs-unstable]$ touch foo
> [zcarter@nudj btrfs-progs-unstable]$ ./btrfsck ./foo
> No valid Btrfs found on ./foo
> Segmentation fault
> [zcarter@nudj btrfs-progs-unstable]$ gdb ./btrfsck
> GNU gdb Fedora (6.8-29.fc10)
> Copyright (C) 2008 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> and "show warranty" for details.
> This GDB was configured as "x86_64-redhat-linux-gnu"...
> (gdb) run ./foo
> Starting program: /opt/src/btrfs-progs-unstable/btrfsck ./foo
> No valid Btrfs found on ./foo
> 
> Program received signal SIGSEGV, Segmentation fault.
> check_extents (root=0x0) at btrfsck.c:2006
> 2006		add_root_to_pending(root->fs_info->tree_root->node, bits, bits_nr,
> (gdb) 

I think the following patch can fix this problem.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 btrfsck.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 4a41e6d..c95fe83 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2074,6 +2074,8 @@ int main(int ac, char **av)
 
 	radix_tree_init();
 	root = open_ctree(av[1], 0, 0);
+	if (!root)
+		return 1;
 
 	ret = check_extents(root);
 	if (ret)
-- 1.6.0.6 



