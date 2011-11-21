From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] 254: disable space cache
Date: Mon, 21 Nov 2011 10:46:58 +0900
Message-ID: <4EC9AD92.6020000@jp.fujitsu.com>
References: <4EC61AC3.6010806@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC61AC3.6010806@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/11/18 17:43), Li Zefan wrote:
> I can't pass 254, and below is the output:
> 
> 254 3s ... - output mismatch (see 254.out.bad)
> ...
>  ID 256 top level 5 path snap
> -ID 257 top level 5 path subvol
> +ID 258 top level 5 path subvol
> 
> When space cache is enabled (and now mkfs.btrfs always enables it),
> there will be some space cache inodes in the root tree, and they
> consume some IDs, and that's why "subvol" has the ID 258 but not 257.
> 
> Just disable space cache for this test case.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  254 |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/254 b/254
> index 5216120..1cd4832 100755
> --- a/254
> +++ b/254
> @@ -48,7 +48,7 @@ _supported_os Linux
>  _require_scratch
>  
>  _scratch_mkfs > /dev/null 2>&1
> -_scratch_mount
> +_scratch_mount -o nospace_cache
>  
>  # First test basic snapshotting
>  echo "Creating file foo in root dir"

I got following error on fedora 16 with your patch:

@@ -1,40 +1,36 @@
 QA output created by 254
+mount: wrong fs type, bad option, bad superblock on /dev/sdc2,
+       missing codepage or helper program, or other error
+       In some cases useful info is found in syslog - try
+       dmesg | tail  or so
+
 Creating file foo in root dir
 List root dir
 foo
 Creating snapshot of root dir
-Create a snapshot of 'SCRATCH_MNT' in 'SCRATCH_MNT/snap'
+ERROR: '/mnt2' is not a subvolume
 List root dir after snapshot
 foo
-snap
 List snapshot dir
-foo
+ls: cannot access /mnt2/snap: No such file or directory
 :
 :

And in dmesg:

[246554.739092] btrfs: unrecognized mount option 'nospace_cache'


Thanks,
H.Seto

