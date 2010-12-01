From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 15:00:08 -0500
Message-ID: <20101201200007.GH17142@fieldses.org>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
 <20101201194404.GE17142@fieldses.org>
 <20101201195433.GE7021@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@lst.de, ssorce@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201195433.GE7021@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 02:54:33PM -0500, Josef Bacik wrote:
> Oh well crud, I was hoping that I could leave the inode numbers as 256 for
> everything, but I forgot about readdir.  So the inode item in the parent would
> have to have a unique inode number that would get spit out in readdir, but then
> if we stat'ed the directory we'd get 256 for the inode number.  Oh well,
> incompat flag it is then.

I think you're already fine:

	# mkdir TMP
	# dd if=/dev/zero of=TMP-image bs=1M count=512
	# mkfs.btrfs TMP-image
	# mount -oloop TMP-image TMP/
	# btrfs subvolume create sub-a
	# btrfs subvolume create sub-b
	../readdir-inos .
	. 256 256
	.. 256 4130609
	sub-a 256 256
	sub-b 257 256

Where readdir-inos is my silly test program below, and the first number is from
readdir, the second from stat.

?

--b.

#include <stdio.h>
#include <err.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>

/* demonstrate that for mountpoints, readdir ino of mounted-on
 * directory, stat returns ino of mounted directory. */

int main(int argc, char *argv[])
{
	struct dirent *de;
	int ret;
	DIR *d;

	if (argc != 2)
		errx(1, "usage: %s <directory>", argv[0]);
	ret = chdir(argv[1]);
	if (ret)
		errx(1, "chdir /");
	d = opendir(".");
	if (!d)
		errx(1, "opendir .");
	while (de = readdir(d)) {
		struct stat st;

		ret = stat(de->d_name, &st);
		if (ret)
			errx(1, "stat %s", de->d_name);
		printf("%s %d %d\n", de->d_name, de->d_ino, st.st_ino);
	}
}

