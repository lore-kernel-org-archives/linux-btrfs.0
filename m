From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH V2] Btrfs: fix subvolume mount by name problem when default
 mount subvolume is set
Date: Wed, 06 Apr 2011 14:34:02 +0800
Message-ID: <4D9C095A.90400@cn.fujitsu.com>
References: <1302067633-20271-1-git-send-email-xin.zhong@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302067633-20271-1-git-send-email-xin.zhong@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

13:27, Zhong, Xin wrote:
> We create two subvolumes (meego_root and meego_home) in
> btrfs root directory. And set meego_root as default mount
> subvolume. After we remount btrfs, meego_root is mounted
> to top directory by default. Then when we try to mount
> meego_home (subvol=meego_home) to a subdirectory, it failed.
> The problem is when default mount subvolume is set to
> meego_root, we search meego_home in meego_root but can not find
> it. So the solution is to add a new mount option (subvolrootid)
> to specify subvol id of root and search subvol name in it. For
> our case, now we can use "-o subvolrootid=0,subvol=meego_home)
> to mount meego_home.
> 
> Detail information can be found in meego bugzilla:
> https://bugs.meego.com/show_bug.cgi?id=15055
> 
> Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
> ---
>  fs/btrfs/super.c |   43 ++++++++++++++++++++++++++++++++++---------
>  1 files changed, 34 insertions(+), 9 deletions(-)
> 

I guess you forgot to run checkpatch.pl.

ERROR: trailing whitespace
#183: FILE: fs/btrfs/super.c:807:
+^I^I$

ERROR: else should follow close brace '}'
#198: FILE: fs/btrfs/super.c:836:
        }
+       else {

total: 2 errors, 0 warnings, 100 lines checked
