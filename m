From: Alex Elder <aelder@sgi.com>
Subject: Re: [PATCH] xfstests: add new getdents test
Date: Thu, 22 Sep 2011 15:18:22 -0500
Message-ID: <1316722702.2009.59.camel@doink>
References: <1315786747-12109-1-git-send-email-notasas@gmail.com>
Reply-To: <aelder@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1315786747-12109-1-git-send-email-notasas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2011-09-12 at 03:19 +0300, Grazvydas Ignotas wrote:
> The test checks if no duplicate d_off values are returned and that
> those values are seekable to the right inodes.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

I have two minor comments on the C program below,
but even if you don't want to address them this
looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> +#include <sys/syscall.h>
> +
> +struct linux_dirent64 {
> +	uint64_t	d_ino;
> +	uint64_t	d_off;
> +	unsigned short	d_reclen;
> +	unsigned char	d_type;
> +	char		d_name[0];
> +};
> +
> +#define BUF_SIZE 4096
> +#define HISTORY_LEN 1024
> +
> +static uint64_t d_off_histoty[HISTORY_LEN];
> +static uint64_t d_ino_histoty[HISTORY_LEN];

Is "histoty" intentional or a typo?

> +int
> +main(int argc, char *argv[])
> +{
> +	int fd, nread;
> +	char buf[BUF_SIZE];

. . .

> +
> +	/* check if seek works correctly */
> +	d = (struct linux_dirent64 *)buf;
> +	for (i = total - 1; i >= 0; i--)
> +	{
> +		lret = lseek(fd, i > 0 ? d_off_histoty[i - 1] : 0, SEEK_SET);
> +		if (lret == -1) {
> +			perror("lseek");
> +			exit(EXIT_FAILURE);
> +		}
> +
> +		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);

You could just use sizeof (struct linux_dirent_64) rather than
BUF_SIZE here.  I suppose it doesn't hurt but there's no real
sense in reading more than the one you're going to look at.

> +		if (nread == -1) {
> +			perror("getdents");
> +			exit(EXIT_FAILURE);
> +		}
> +

. . .


