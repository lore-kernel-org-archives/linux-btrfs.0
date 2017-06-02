Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50396 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751163AbdFBHaL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jun 2017 03:30:11 -0400
Subject: Re: [PATCH 10/12] apparmorfs: Replace CURRENT_TIME with
 current_time()
To: Deepa Dinamani <deepa.kernel@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: tglx@linutronix.de, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, arnd@arndb.de, bfields@fieldses.org,
        clm@fb.com, davem@davemloft.net, dsterba@suse.com, dushistov@mail.ru,
        eparis@redhat.com, jaegeuk@kernel.org, jbacik@fb.com,
        jlayton@poochiereds.net, john.stultz@linaro.org,
        jsimmons@infradead.org, mingo@redhat.com, oleg.drokin@intel.com,
        paul@paul-moore.com, rostedt@goodmis.org, yuchao0@huawei.com,
        ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-audit@redhat.com, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-security-module@vger.kernel.org, lustre-devel@lists.lustre.org,
        netdev@vger.kernel.org, samba-technical@lists.samba.org,
        y2038@lists.linaro.org
References: <1491613030-11599-1-git-send-email-deepa.kernel@gmail.com>
 <1491613030-11599-11-git-send-email-deepa.kernel@gmail.com>
From: John Johansen <john.johansen@canonical.com>
Message-ID: <b5d3d600-d3fe-669f-f6bc-01dcedbb7fe3@canonical.com>
Date: Fri, 2 Jun 2017 00:29:48 -0700
MIME-Version: 1.0
In-Reply-To: <1491613030-11599-11-git-send-email-deepa.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/2017 05:57 PM, Deepa Dinamani wrote:
> CURRENT_TIME macro is not y2038 safe on 32 bit systems.
> 
> The patch replaces all the uses of CURRENT_TIME by
> current_time().
> 
> This is also in preparation for the patch that transitions
> vfs timestamps to use 64 bit time and hence make them
> y2038 safe. current_time() is also planned to be transitioned
> to y2038 safe behavior along with this change.
> 
> CURRENT_TIME macro will be deleted before merging the
> aforementioned change.
> 
> Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>

This is all good, and I have no objections to it being merged for 4.12.
If it isn't this change is already queued up for the apparmor 4.13
merge

Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/apparmorfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
> index be0b498..4f6ac9d 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -1357,7 +1357,7 @@ static int aa_mk_null_file(struct dentry *parent)
>  
>  	inode->i_ino = get_next_ino();
>  	inode->i_mode = S_IFCHR | S_IRUGO | S_IWUGO;
> -	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
> +	inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
>  	init_special_inode(inode, S_IFCHR | S_IRUGO | S_IWUGO,
>  			   MKDEV(MEM_MAJOR, 3));
>  	d_instantiate(dentry, inode);
> 

