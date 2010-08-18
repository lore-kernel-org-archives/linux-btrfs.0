From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Poor creat/delete files performance
Date: Wed, 18 Aug 2010 18:12:46 +0800
Message-ID: <4C6BB21E.3000809@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090707090108030904030907"
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	Yan Zheng <zheng.yan@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090707090108030904030907
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit

Hi,

We did some performance test and found the create/delete files performance
of btrfs is very poor.

The test is that we create 50000 files and measure the file-create time
first, and then delete these 50000 files and measure the file-delete time. 
(The attached file is the reproduce program)

The result is following:
(Unit: second)
  Create file performance
		BtrFS		Ext4
  Total times:	2.462625	1.449550
  Average:	0.000049	0.000029

  Delete file performance
		BtrFS		Ext4
  Total times:	3.312796	0.997946
  Average:	0.000066	0.000020

The results were measured on a x86_64 server with 4 cores and 2 SAS disks.
By debuging, we found the btrfs spent a lot of time on searching and
inserting/removing items in the ctree.

Is anyone looking at this issue?

Regards
Miao Xie

--------------090707090108030904030907
Content-Type: text/x-csrc;
 name="creat_unlink.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="creat_unlink.c"

/* gcc creat_unlink.c -o creat_unlink */
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define UNUSED          __attribute__ ((unused))
#define PATH_SIZE       100
#define TST_DIR		"tst_dir"

int initialize(void)
{
	int ret;

	ret = mkdir(TST_DIR, 0775);
	if (ret) {
		perror("init fail - mkdir failed\n");
		goto err;
	}

	ret = chdir(TST_DIR);
	if (ret) {
		perror("init fail - chdir failed\n");
		rmdir(TST_DIR);
	}
err:
	return ret;
}

int cleanup(void)
{
	int ret;

	ret = chdir("..");
	if (ret) {
		perror("cleanup fail - chdir failed\n");
		goto err;
	}

	ret = rmdir(TST_DIR);
	if (ret)
		perror("cleanup fail - rmdir failed\n");

err:
	return ret;
}

int get_start_time(struct timeval *tv)
{
	if (gettimeofday(tv, NULL)) {
		perror("get start time failed.\n");
		return 1;
	}

	return 0;
}

void account_time(struct timeval *stv, struct timeval *etv, int files)
{
	if (gettimeofday(etv, NULL)) {
		perror("get end time failed.\n");
	} else if (files) {
		double ts;

		while (etv->tv_usec < stv->tv_usec) {
			etv->tv_sec--;
			etv->tv_usec += 1000000;
		}

		etv->tv_usec -= stv->tv_usec;
		etv->tv_sec -= stv->tv_sec;

		while (etv->tv_usec > 1000000) {
			etv->tv_usec -= 1000000;
			etv->tv_sec++;
		}

		ts = (double)etv->tv_usec / (double)1000000 + etv->tv_sec;
		printf("\tTotal files: %d\n", files);
		printf("\tTotal time: %lf\n", ts);

		ts /= files;
		printf("\tAverage time: %lf\n", ts);
	} else
		perror("Didn't create/delete any files");

}

int create_files(int nfiles)
{
	int i, fd;
	char fpath[PATH_SIZE];
	struct timeval stv, etv;

	printf("Create files:\n");
	if (get_start_time(&stv))
		return 0;

	for (i = 0; i < nfiles; i++) {
		sprintf(fpath, "%d", i);
		fd = creat(fpath, 0555);
		if (fd < 0) {
			perror("creat file failed.\n");
			break;
		}
		close(fd);
	}

	account_time(&stv, &etv, i);

	return i;
}

int unlink_files(int nfiles)
{
	int i, ret = 0;
	char fpath[PATH_SIZE];
	struct timeval stv, etv;

	printf("Delete files:\n");
	if (get_start_time(&stv))
		return 1;

	for (i = 0; i < nfiles; i++) {
		sprintf(fpath, "%d", i);
		ret = unlink(fpath);
		if (ret)
			break;
	}

	account_time(&stv, &etv, i);

	return ret;
}

int main(int argc, char **argv)
{
	int nfiles, n_done, ret;

	/* parse the options */
	if (argc != 2) {
		fprintf(stderr, "options is wrong.\n");
		fprintf(stderr, "%s [nfiles]\n", argv[0]);
		exit(1);
	}

	nfiles = atoi(argv[1]);
	if (nfiles <= 0) {
		fprintf(stderr, "option nfiles is wrong.");
		exit(1);
	}

	/* initialize - create the test directory and change the current dir */
	ret = initialize();
	if (ret)
		exit(1);

	n_done = create_files(nfiles);
	if (n_done != nfiles) {
		unlink_files(n_done);
		cleanup();
		exit(1);
	}

	ret = unlink_files(n_done);
	if (ret)
		exit(1);

	ret = cleanup();
	if (ret)
		exit(1);

	return 0;
}

--------------090707090108030904030907--
