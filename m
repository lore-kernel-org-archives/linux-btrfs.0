Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59598 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754881AbcGHQDA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 12:03:00 -0400
Subject: Re: A lot warnings in dmesg while running thunderbird
To: Gabriel C <nix.or.die@gmail.com>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <ab5cc111-7ed7-3209-7411-6c656892d4a3@fb.com>
 <CAEJqkgiWOnyk8AzROc-tGTqKiDJkCt364tgFT5P-2Sa+XwjeMA@mail.gmail.com>
 <b84d72ce-3221-1f0d-7f63-ae02fe0d776b@fb.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
CC: <linux-btrfs@vger.kernel.org>, <quwenruo@cn.fujitsu.com>
From: Chris Mason <clm@fb.com>
Message-ID: <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
Date: Fri, 8 Jul 2016 12:02:35 -0400
MIME-Version: 1.0
In-Reply-To: <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
Content-Type: multipart/mixed;
	boundary="------------65F68B43418548684FA20F56"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------65F68B43418548684FA20F56
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit



On 07/08/2016 11:02 AM, Gabriel C wrote:
> On 08.07.2016 14:41, Chris Mason wrote:
>
>>
>>
>> On 07/08/2016 05:57 AM, Gabriel C wrote:
>>> 2016-07-07 21:21 GMT+02:00 Chris Mason <clm@fb.com>:
>>>>
>>>>
>>>> On 07/07/2016 06:24 AM, Gabriel C wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> while running thunderbird on linux 4.6.3 and 4.7.0-rc6 ( didn't tested
>>>>> other versions )
>>>>> I trigger the following :
>>>>
>>>>
>>>> I definitely thought we had this fixed in v4.7-rc.  Can you easily
>>>> fsck this filesystem?  Something strange is going on.
>>>
>>> Yes , btrfs check and btrfs check  --check-data-csum are fine , no
>>> errors found.
>>>
>>> If you want me to test any patches let me know.
>>>
>>
>> Can you please try a v4.5 stable kernel?  I'm curious if this really
>> is the same regression that I tried to fix in v4.7
>>
>
> I'm on linux 4.5.7 now and everything is fine. I'm writing this email
> from thunderbird.. which was not
> possible in 4.6.3 or 4.7.-rc.
>
> Let me know you want me to test other kernels or whatever else may help
> fixing this problem.
>

Can you please run the attached test program:

gcc -o short-write short-write.c -lpthread
./short-write some-new-file-on-btrfs

I want to see if you're triggering the same problem we've tried to fix, 
or something else.

This program will create a new file, or overwrite an existing file. 
Don't pass it something you care about ;)

-chris


--------------65F68B43418548684FA20F56
Content-Type: text/x-csrc; name="short-write.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="short-write.c"

#define _FILE_OFFSET_BITS 64
#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/mman.h>

#define ROUNDS 8
#define BUFSIZE (1024 * 1024)
#define MAXSIZE (128 * 1024ULL * 1024ULL * 1024ULL)

void *dontneed(void *arg)
{
	char *p = arg;
	int ret;

	while(1) {
		ret = madvise(p, BUFSIZE/4, MADV_DONTNEED);
		if (ret) {
			perror("madvise");
			exit(1);
		}
	}
}

int main(int ac, char **av) {
	int ret;
	int fd;
	char *filename;
	unsigned long offset;
	char *buf;
	int i;
	pthread_t tid;

	if (ac != 2) {
		fprintf(stderr, "usage: short-write filename\n");
		exit(1);
	}

	buf = mmap(NULL, BUFSIZE, PROT_READ|PROT_WRITE,
		   MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	if (buf == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	memset(buf, 'a', BUFSIZE);
	filename = av[1];

	ret = pthread_create(&tid, NULL, dontneed, buf);
	if (ret) {
		fprintf(stderr, "error %d from pthread_create\n", ret);
		exit(1);
	}

	ret = pthread_detach(tid);
	if (ret) {
		fprintf(stderr, "pthread detach failed %d\n", ret);
		exit(1);
	}

	while (1) {
		fd = open(filename, O_RDWR | O_CREAT, 0600);
		if (fd < 0) {
			perror("open");
			exit(1);
		}

		for (i = 0; i < ROUNDS; i++) {
			int this_write = BUFSIZE;

			offset = rand() % MAXSIZE;
			ret = pwrite(fd, buf, this_write, offset);
			if (ret < 0) {
				perror("pwrite");
				exit(1);
			} else if (ret != this_write) {
				fprintf(stderr, "short write to %s offset %lu ret %d\n",
					filename, offset, ret);
				exit(1);
			}
			if (i == ROUNDS - 1) {
				ret = sync_file_range(fd, offset, 4096,
				    SYNC_FILE_RANGE_WRITE);
				if (ret < 0) {
					perror("sync_file_range");
					exit(1);
				}
			}
		}
		ret = ftruncate(fd, 0);
		if (ret < 0) {
			perror("ftruncate");
			exit(1);
		}
		ret = close(fd);
		if (ret) {
			perror("close");
			exit(1);
		}
		ret = unlink(filename);
		if (ret) {
			perror("unlink");
			exit(1);
		}

	}
	return 0;
}

--------------65F68B43418548684FA20F56--
