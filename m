Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3AQXj4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 18:39:56 -0500
Date: Thu, 17 Jan 2013 15:39:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Chris Mason <chris.mason@fusionio.com>,
        Steve French <sfrench@samba.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, cluster-devel@redhat.com
Subject: Re: [PATCH 4/4] fs: remove obsolete simple_strto<foo>
Message-Id: <20130117153954.e36a474b.akpm@linux-foundation.org>
In-Reply-To: <1354881319-23585-1-git-send-email-abhi.c.pawar@gmail.com>
References: <1354881319-23585-1-git-send-email-abhi.c.pawar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri,  7 Dec 2012 17:25:19 +0530
Abhijit Pawar <abhi.c.pawar@gmail.com> wrote:

> This patch replace the obsolete simple_strto<foo> with kstrto<foo>
> 

The XFS part (or something like it) has been applied.

>
> ...
>
> --- a/fs/9p/v9fs.c
> +++ b/fs/9p/v9fs.c
> @@ -112,7 +112,7 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
>  	substring_t args[MAX_OPT_ARGS];
>  	char *p;
>  	int option = 0;
> -	char *s, *e;
> +	char *s;
>  	int ret = 0;
>  
>  	/* setup defaults */
> @@ -249,8 +249,8 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
>  				v9ses->flags |= V9FS_ACCESS_CLIENT;
>  			} else {
>  				v9ses->flags |= V9FS_ACCESS_SINGLE;
> -				v9ses->uid = simple_strtoul(s, &e, 10);
> -				if (*e != '\0') {
> +				ret = kstrtouint(s, 10, &v9ses->uid);
> +				if (ret) {
>  					ret = -EINVAL;
>  					pr_info("Unknown access argument %s\n",
>  						s);

Here we should propagate the kstrtouint() errno back to the caller
rather than overwriting it with EINVAL.

> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 5b3429a..95d9e09 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1335,7 +1335,11 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
>  		sizestr = devstr + 1;
>  		*devstr = '\0';
>  		devstr = vol_args->name;
> -		devid = simple_strtoull(devstr, &end, 10);
> +		ret = kstrtoull(devstr, 10, &devid);
> +		if (ret) {
> +			ret = -EINVAL;
> +			goto out_free;
> +		}

Propagate the kstrtoull errno back to the caller.

>  		printk(KERN_INFO "btrfs: resizing devid %llu\n",
>  		       (unsigned long long)devid);
>  	}
>
> ...
>
> @@ -609,8 +610,9 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
>  	}
>  	/* else we have a number */
>  
> -	flags = simple_strtoul(flags_string, NULL, 0);
> -
> +	rc = kstrtouint(flags_string, 0, &flags);
> +	if (rc)
> +		return -EINVAL;

Here we should propagate the return value.

But if this error path is taken, we might already have altered
global_secflags.  Perhaps that change should be undone.  Or, better,
check the string before starting to change state.

>  	cFYI(1, "sec flags 0x%x", flags);
>  
>  	if (flags <= 0)  {
> --- a/fs/dlm/config.c
> +++ b/fs/dlm/config.c
> @@ -156,11 +156,14 @@ static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
>  			   const char *buf, size_t len)
>  {
>  	unsigned int x;
> +	int rc;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	x = simple_strtoul(buf, NULL, 0);
> +	rc = kstrtouint(buf, 0, &x);
> +	if (rc)
> +		return -EINVAL;

Propagate it back.

>  	if (check_zero && !x)
>  		return -EINVAL;
> @@ -729,7 +732,10 @@ static ssize_t comm_nodeid_read(struct dlm_comm *cm, char *buf)
>  static ssize_t comm_nodeid_write(struct dlm_comm *cm, const char *buf,
>  				 size_t len)
>  {
> -	cm->nodeid = simple_strtol(buf, NULL, 0);
> +	int rc;
> +	rc = kstrtoint(buf, 0, &cm->nodeid);
> +	if (rc)
> +		return -EINVAL;

Ditto

>  	return len;
>  }
>  
> @@ -741,7 +747,10 @@ static ssize_t comm_local_read(struct dlm_comm *cm, char *buf)
>  static ssize_t comm_local_write(struct dlm_comm *cm, const char *buf,
>  				size_t len)
>  {
> -	cm->local= simple_strtol(buf, NULL, 0);
> +	int rc;
> +	rc = kstrtoint(buf, 0, &cm->local);
> +	if (rc)
> +		return -EINVAL;

Ditto

>  	if (cm->local && !local_comm)
>  		local_comm = cm;
>  	return len;
> @@ -845,7 +854,10 @@ static ssize_t node_nodeid_write(struct dlm_node *nd, const char *buf,
>  				 size_t len)
>  {
>  	uint32_t seq = 0;
> -	nd->nodeid = simple_strtol(buf, NULL, 0);
> +	int rc;
> +	rc = kstrtoint(buf, 0, &nd->nodeid);
> +	if (rc)
> +		return -EINVAL;

Ditto

>  	dlm_comm_seq(nd->nodeid, &seq);
>  	nd->comm_seq = seq;
>  	return len;
> @@ -859,7 +871,10 @@ static ssize_t node_weight_read(struct dlm_node *nd, char *buf)
>  static ssize_t node_weight_write(struct dlm_node *nd, const char *buf,
>  				 size_t len)
>  {
> -	nd->weight = simple_strtol(buf, NULL, 0);
> +	int rc;
> +	rc = kstrtoint(buf, 0, &nd->weight);
> +	if (rc)
> +		return -EINVAL;

Ditto

>  	return len;
>  }
>  
> diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
> index 2e99fb0..e83abfb 100644
> --- a/fs/dlm/lockspace.c
> +++ b/fs/dlm/lockspace.c
> @@ -35,7 +35,10 @@ static struct task_struct *	scand_task;
>  static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
>  {
>  	ssize_t ret = len;
> -	int n = simple_strtol(buf, NULL, 0);
> +	int n, rc;
> +	rc = kstrtoint(buf, 0, &n);
> +	if (rc)
> +		return -EINVAL;

etcetera

>  	ls = dlm_find_lockspace_local(ls->ls_local_handle);
>  	if (!ls)
>
> ...
>

