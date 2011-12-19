From: David Sterba <dsterba@suse.cz>
Subject: A sample tool how to use the new ioctl
Date: Mon, 19 Dec 2011 15:25:39 +0100
Message-ID: <20111219142539.GE12898@ds.suse.cz>
References: <1324304223-19079-1-git-send-email-dsterba@suse.cz>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1324304223-19079-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is a standalone tool I've used to exercise the ioctl, simply pass
the name of a file and see the result. The numbers are a rough
estimate. It also takes the range arguments, but the ratio will be bogus
due to comparison to whole file (st_blocks), an exact extent length
from fiemap/filefrag is be the correct one.


david


--rwEMma7ioTxnRzrJ
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="btrfs-compr-size.c"

/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License v2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 021110-1307, USA.
 */

#include <sys/ioctl.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <inttypes.h>

typedef uint64_t __u64;
typedef uint64_t u64;

#ifndef BTRFS_IOCTL_MAGIC
#define BTRFS_IOCTL_MAGIC 0x94
#endif

#ifndef BTRFS_IOC_COMPR_SIZE
#define BTRFS_IOC_COMPR_SIZE _IOR(BTRFS_IOCTL_MAGIC, 51, \
		struct __local__btrfs_ioctl_compr_size_args)
#endif

struct __local__btrfs_ioctl_compr_size_args {
	/* Range start, inclusive */
	__u64                           start;          /* in */
	/* Range end, exclusive */
	__u64                           end;            /* in */
	__u64                           size;           /* out */
	__u64                           reserved[2];
};

static u64 parse_size(char *s)
{
	int len = strlen(s);
	char c;
	u64 mult = 1;

	if (!isdigit(s[len - 1])) {
		c = tolower(s[len - 1]);
		switch (c) {
			case 'e':
			case 'E':
				mult *= 1024;
			case 't':
			case 'T':
				mult *= 1024;
			case 'g':
			case 'G':
				mult *= 1024;
			case 'm':
			case 'M':
				mult *= 1024;
			case 'k':
			case 'K':
				mult *= 1024;
			case 'b':
			case 'B':
				break;
			default:
				fprintf(stderr, "Unknown size descriptor %c\n", c);
				exit(1);
		}
		s[len - 1] = '\0';
	}
	return atoll(s) * mult;
}

static int open_file_or_dir(const char *fname)
{
	int ret;
	struct stat st;
	DIR *dirstream;
	int fd;

	ret = stat(fname, &st);
	if (ret < 0) {
		perror("stat");
		exit(1);
	}
	if (S_ISDIR(st.st_mode)) {
		dirstream = opendir(fname);
		if (!dirstream) {
			perror("opendir");
			exit(1);
		}
		fd = dirfd(dirstream);
	} else {
		fd = open(fname, O_RDONLY);
	}
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	return fd;
}
static char buf[64];
static const char* end_or_eof(u64 end)
{
	if (end == (u64)-1)
		return "EOF";
	snprintf(buf, 64, "%llu", (unsigned long long)end);
	return buf;
}

int main(int argc, char **argv)
{
	int fd;
	int ret;
	u64 cblocks;
	unsigned long sblocks;
	struct stat st;
	struct __local__btrfs_ioctl_compr_size_args args;

	if (argc < 2) {
		printf("Usage: btrfs-compr-size <file> [start [end] ]\n");
		exit(1);
	}

	fd = open_file_or_dir(argv[1]);
	if (fd == -1) {
		perror("open");
		exit(1);
	}

	if (argc >= 3)
		args.start = parse_size(argv[2]);
	else
		args.start = 0;

	if (argc >= 4)
		args.end = parse_size(argv[3]);
	else
		args.end = (u64)-1;

	ret = ioctl(fd, BTRFS_IOC_COMPR_SIZE, &args);
	if (ret < 0) {
		perror("ioctl");
		exit(1);
	}
	fstat(fd, &st);
	cblocks=args.size;
	sblocks=st.st_blocks;
	printf("Compressed size of %s [%llu,%s)\n", argv[1],
			(unsigned long long)args.start,
			end_or_eof(args.end));
	printf(" compr size/512:  % 11lu\n", cblocks);
	printf(" stat blocks/512: % 11lu\n", sblocks);
	if (sblocks)
		printf(" compr/stat*100:  % 14.2f%%\n", (((float)cblocks) / sblocks) * 100);
	else
		printf(" compr/stat*100:  % 14.2f%%\n", (float)0);
	return 0;
}

--rwEMma7ioTxnRzrJ--
