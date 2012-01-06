From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Crash in io_ctl_drop_pages after mount with csum errors
Date: Fri, 06 Jan 2012 15:17:59 +0800
Message-ID: <4F06A027.3060908@cn.fujitsu.com>
References: <20120105164919.GP7322@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120105164919.GP7322@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> I mounted a multi-folume fs created not-so-long ago in a 3.1 based
> kernel and mounted with v3.2-rc7-83-g115e8e7 , it crashed immediately.
> It's quite possible that the disk is to blame, it's an old 160G
> SP1614C, but syslog does not contain any error messages. I'm not sure
> whether the fs was cleanly unmounted, seems not, but anyway I do not
> expect a crash.
> 
> Label: none  uuid: 5f06f9eb-9736-49f7-91a2-2f45522512ef
>         Total devices 4 FS bytes used 1.38GB
>         devid    4 size 34.00GB used 34.00GB path /dev/sdg8
>         devid    3 size 34.00GB used 34.00GB path /dev/sdg7
>         devid    2 size 34.00GB used 34.00GB path /dev/sdg6
>         devid    1 size 34.00GB used 34.00GB path /dev/sdg5
> 
> mount options: compress-force=lzo,space_cache,autodefrag,inode_cache
> 
> [ 1461.732855] btrfs: force lzo compression
> [ 1461.732876] btrfs: enabling auto defrag
> [ 1461.732893] btrfs: enabling inode map caching
> [ 1461.732907] btrfs: disk space caching is enabled
> [ 1499.796181] btrfs: csum mismatch on free space cache
> [ 1499.796266] btrfs: failed to load free space cache for block group 29360128
> [ 1499.888699] btrfs csum failed ino 18446744073709551604 off 65536 csum 2566472073 private 1925235876
> [ 1499.888826] btrfs csum failed ino 18446744073709551604 off 327680 csum 2566472073 private 1925235876
> [ 1499.906229] btrfs csum failed ino 18446744073709551604 off 0 csum 1695430581 private 1170642078
> [ 1499.906345] btrfs csum failed ino 18446744073709551604 off 262144 csum 2566472073 private 1925235876
> [ 1499.906446] btrfs csum failed ino 18446744073709551604 off 524288 csum 2566472073 private 1925235876
> [ 1499.924469] btrfs csum failed ino 18446744073709551604 off 196608 csum 2566472073 private 1925235876
> [ 1499.924574] btrfs csum failed ino 18446744073709551604 off 458752 csum 2566472073 private 1925235876
> [ 1499.946076] btrfs csum failed ino 18446744073709551604 off 131072 csum 2566472073 private 1925235876
> [ 1499.946217] btrfs csum failed ino 18446744073709551604 off 393216 csum 2566472073 private 1925235876
> [ 1499.946318] btrfs csum failed ino 18446744073709551604 off 0 csum 1695430581 private 1170642078
> [ 1499.946362] btrfs: error reading free space cache

We have inconsitent data on disk with both free space cache and free ino cache.

> [ 1499.946409] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> [ 1499.946437] IP: [<ffffffffa0456dd7>] io_ctl_drop_pages+0x37/0x70 [btrfs]

0x01 is weired, don't know how it occured. Nevertheless we need this fix:

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index ec23d43..81771ca 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -319,9 +319,11 @@ static void io_ctl_drop_pages(struct io_ctl *io_ctl)
 	io_ctl_unmap_page(io_ctl);
 
 	for (i = 0; i < io_ctl->num_pages; i++) {
-		ClearPageChecked(io_ctl->pages[i]);
-		unlock_page(io_ctl->pages[i]);
-		page_cache_release(io_ctl->pages[i]);
+		if (io_ctl->pages[i]) {
+			ClearPageChecked(io_ctl->pages[i]);
+			unlock_page(io_ctl->pages[i]);
+			page_cache_release(io_ctl->pages[i]);
+		}
 	}
 }

I'll resend the patch along with my other pending patches for 3.3.
