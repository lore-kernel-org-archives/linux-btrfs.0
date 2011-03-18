From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: properly access unaligned checksum buffer
Date: Fri, 18 Mar 2011 23:56:43 +0100
Message-ID: <20110318225643.GY17108@twin.jikos.cz>
References: <1300462105-30680-1-git-send-email-dsterba@suse.cz>
 <1300463770-sup-1372@think>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Sterba <dsterba@suse.cz>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	"adrien.dessemond" <adrien.dessemond@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300463770-sup-1372@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 18, 2011 at 11:56:53AM -0400, Chris Mason wrote:
> Thanks for fielding this one.  Does put_unaligned_le32 optimize away on
> platforms with efficient access?  It would be great if we didn't need
> the #ifdef.

(quicktest: assembly output is same for put_unaligned_le32 and direct
assignment on my x86_64)
I was originally following examples in
Documentation/unaligned-memory-access.txt. From other code it seems to me that
the define CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is intended for larger
portions of code. Macros/wrappers for {put,get}_unaligned* are chosen via
arch/<arch>/include/asm/unaligned.h accordingly, therefore it's safe to use
put_unaligned_le32 without the ifdef.

dave
--

From: David Sterba <dsterba@suse.cz>

fixes https://bugzilla.kernel.org/show_bug.cgi?id=29142
reported on SPARC64, warnings like:

[ 1523.941667] Kernel unaligned access at TPC[100e4034]
btrfs_csum_final+0x38/0x3c [btrfs]

Reported-by: Adrien Dessemond <adrien.dessemond@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
Tested-by: Adrien Dessemond <adrien.dessemond@gmail.com>
---
 fs/btrfs/disk-io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1aa8d6..80a6830 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -29,6 +29,7 @@
 #include <linux/crc32c.h>
 #include <linux/slab.h>
 #include <linux/migrate.h>
+#include <asm/unaligned.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -198,7 +199,7 @@ u32 btrfs_csum_data(struct btrfs_root *root, char *data, u32 seed, size_t len)

 void btrfs_csum_final(u32 crc, char *result)
 {
-       *(__le32 *)result = ~cpu_to_le32(crc);
+       put_unaligned_le32(~crc, result);
 }

 /*
--
1.7.4.1.176.g501cc
