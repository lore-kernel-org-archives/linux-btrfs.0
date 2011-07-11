From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs hang in flush-btrfs-5
Date: Mon, 11 Jul 2011 10:30:20 -0400
Message-ID: <4E1B08FC.6030907@redhat.com>
References: <iv6ntd$3o5$1@dough.gmane.org> <ivenfi$iph$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ivenfi$iph$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/11/2011 07:40 AM, Jeremy Sanders wrote:
> Jeremy Sanders wrote:
> 
>> Hi - I'm trying btrfs with kernel 2.6.38.8-32.fc15.x86_64 (a Fedora
>> kernel). I'm just doing a tar-to-tar copy onto the file system with
>> compress- force=zlib. Here are some traces of the stuck processes.
> 
> I've managed to reproduce the hang using the latest btrfs from the 
> repository. I had to remove some of the tracing lines to get it to compile 
> under 2.6.38.8 and an ioctl which wasn't defined. Here is is where it is 
> stuck:
> 

Hrm well that is just unlikely and hard to hit.  Will you try this and
see if it helps you?  Thanks,

Josef

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 59cbdb1..3c8c435 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1081,7 +1081,8 @@ static noinline int prepare_pages(struct
btrfs_root *root, struct file *file,

 again:
 	for (i = 0; i < num_pages; i++) {
-		pages[i] = grab_cache_page(inode->i_mapping, index + i);
+		pages[i] = find_or_create_page(inode->i_mapping, index + i,
+					       GFP_NOFS);
 		if (!pages[i]) {
 			faili = i - 1;
 			err = -ENOMEM;
