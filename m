From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs: warn_slowpath in clean_tree_block and others
Date: Wed, 25 Feb 2009 14:26:43 -0500
Message-ID: <1235590003.32346.61.camel@think.oraclecorp.com>
References: <20090224230249.GA6859@vlad.carfax.org.uk>
	 <1235586986.32346.48.camel@think.oraclecorp.com>
	 <89ed0c690902251050g1e6dd23ay5d5426adb7086018@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
To: "Mitch Harder (aka DontPanic)" <mmharder@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <89ed0c690902251050g1e6dd23ay5d5426adb7086018@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

[ resend with the list cc'd ]

On Wed, 2009-02-25 at 12:50 -0600, Mitch Harder (aka DontPanic) wrote:
> I'll try to test that out.
> 
> I had just noticed that some of my kernel configuration settings (not
> sure which ones) seem to affect the clean_tree_block warnings I've
> been getting, and one of my customizations is usually to configure the
> kernel for a single processor.
> 

I'll push out a patch tonight that fixes things, the code to test for a
locked buffer is just broken on UP.  For now, the patch below will do:

diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 85506c4..4513ecf 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -222,6 +222,5 @@ int btrfs_tree_unlock(struct extent_buffer *eb)
 
 int btrfs_tree_locked(struct extent_buffer *eb)
 {
-	return test_bit(EXTENT_BUFFER_BLOCKING, &eb->bflags) ||
-			spin_is_locked(&eb->lock);
+	return 1;
 }


