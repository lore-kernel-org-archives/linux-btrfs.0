From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCHv2 02/12]posix_acl: Add the check items
Date: Tue, 22 Dec 2009 12:08:03 +0000
Message-ID: <20091222120803.GR18217@ZenIV.linux.org.uk>
References: <4B2F619A.8000407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, joel.becker@oracle.com, cjb@laptop.org,
	jmorris@namei.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, onlyflyer@gmail.com,
	strongzgy@gmail.com
To: Liuwenyi <qingshenlwy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B2F619A.8000407@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 21, 2009 at 07:52:58PM +0800, Liuwenyi wrote:
> @@ -102,12 +102,9 @@ static int btrfs_set_acl(struct btrfs_trans_handle
> *trans,
> char *value = NULL;
> mode_t mode;
> 
> - if (acl) {
> - ret = posix_acl_valid(acl);
> - if (ret < 0)
> - return ret;
> - ret = 0;
> - }
> + ret = posix_acl_valid(acl);
> + if (ret < 0)
> + return ret;

... and now you can't remove acl from btrfs inode.  At all.

NAK the entire series.  You are changing existing user-visible behaviour
for all filesystems for no reason and at least in this case it's clearly
wrong change.
