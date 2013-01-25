Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:60944 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3AYMDV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 07:03:21 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130125120319.XTP7113.eastrmfepo102.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 25 Jan 2013 07:03:19 -0500
Message-ID: <51027487.9060701@czarc.net>
Date: Fri, 25 Jan 2013 07:03:19 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
References: <1359113550-23962-1-git-send-email-gene@czarc.net> <51026F74.4020307@giantdisaster.de>
In-Reply-To: <51026F74.4020307@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/25/2013 06:41 AM, Stefan Behrens wrote:
> On Fri, 25 Jan 2013 06:32:30 -0500, Gene Czarcinski wrote:
>> This patch hits a lot of files but adds little code.  It
>> could be considered a bugfix,  Currently, when one of the
>> btrfs user-space programs is executed by a regular user,
>> the result if oftem a number of strange error messages
>> which do not indicate the real problem.  This patch changes
>> that situation.
>>
>> A test is performed as to whether the program is running
>> as root.  If it is not, issue an error message and exit.
>> Signed-off-by: Gene Czarcinski <gene@czarc.net>
>> ---
>>   btrfs-corrupt-block.c | 5 +++++
>>   btrfs-image.c         | 5 +++++
>>   btrfs-map-logical.c   | 5 +++++
>>   btrfs-select-super.c  | 5 +++++
>>   btrfs-show-super.c    | 5 +++++
>>   btrfs-show.c          | 5 +++++
>>   btrfs-vol.c           | 5 +++++
>>   btrfs-zero-log.c      | 5 +++++
>>   btrfs.c               | 6 ++++++
>>   btrfsck.c             | 5 +++++
>>   btrfsctl.c            | 5 +++++
>>   btrfstune.c           | 5 +++++
>>   calc-size.c           | 5 +++++
>>   convert.c             | 6 ++++++
>>   debug-tree.c          | 5 +++++
>>   dir-test.c            | 5 +++++
>>   find-root.c           | 5 +++++
>>   ioctl-test.c          | 6 ++++++
>>   mkfs.c                | 5 +++++
>>   quick-test.c          | 6 ++++++
>>   restore.c             | 5 +++++
>>   21 files changed, 109 insertions(+)
>>
>> diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
>> index b57e757..083fd50 100644
>> --- a/btrfs-corrupt-block.c
>> +++ b/btrfs-corrupt-block.c
>> @@ -296,6 +296,11 @@ int main(int ac, char **av)
>>   
>>   	srand(128);
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c;
>>   		c = getopt_long(ac, av, "l:c:b:eEk", long_options,
>> diff --git a/btrfs-image.c b/btrfs-image.c
>> index 7dc131d..fd9b28a 100644
>> --- a/btrfs-image.c
>> +++ b/btrfs-image.c
>> @@ -831,6 +831,11 @@ int main(int argc, char *argv[])
>>   	int ret;
>>   	FILE *out;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while (1) {
>>   		int c = getopt(argc, argv, "rc:t:");
>>   		if (c < 0)
>> diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
>> index fa4fb3f..59f2f0e 100644
>> --- a/btrfs-map-logical.c
>> +++ b/btrfs-map-logical.c
>> @@ -116,6 +116,11 @@ int main(int ac, char **av)
>>   	int out_fd = 0;
>>   	int err;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", av[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c;
>>   		c = getopt_long(ac, av, "l:c:o:b:", long_options,
>> diff --git a/btrfs-select-super.c b/btrfs-select-super.c
>> index 0c4f5c0..049379d 100644
>> --- a/btrfs-select-super.c
>> +++ b/btrfs-select-super.c
>> @@ -46,6 +46,11 @@ int main(int ac, char **av)
>>   	int num;
>>   	u64 bytenr = 0;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c;
>>   		c = getopt(ac, av, "s:");
>> diff --git a/btrfs-show-super.c b/btrfs-show-super.c
>> index a9e2524..2fa4776 100644
>> --- a/btrfs-show-super.c
>> +++ b/btrfs-show-super.c
>> @@ -63,6 +63,11 @@ int main(int argc, char **argv)
>>   	int arg, i;
>>   	u64 sb_bytenr = btrfs_sb_offset(0);
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while ((opt = getopt(argc, argv, "ai:")) != -1) {
>>   		switch (opt) {
>>   		case 'i':
>> diff --git a/btrfs-show.c b/btrfs-show.c
>> index 8210fd2..6b3b91a 100644
>> --- a/btrfs-show.c
>> +++ b/btrfs-show.c
>> @@ -122,6 +122,11 @@ int main(int ac, char **av)
>>   		"** Please consider to switch to the btrfs utility\n"
>>   		"**\n");
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", av[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c;
>>   		c = getopt_long(ac, av, "", long_options,
>> diff --git a/btrfs-vol.c b/btrfs-vol.c
>> index ad824bd..7e02f72 100644
>> --- a/btrfs-vol.c
>> +++ b/btrfs-vol.c
>> @@ -83,6 +83,11 @@ int main(int ac, char **av)
>>   		"** Please consider to switch to the btrfs utility\n"
>>   		"**\n");
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", av[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c;
>>   		c = getopt_long(ac, av, "a:br:", long_options,
>> diff --git a/btrfs-zero-log.c b/btrfs-zero-log.c
>> index 1ea867b..80e4e38 100644
>> --- a/btrfs-zero-log.c
>> +++ b/btrfs-zero-log.c
>> @@ -45,6 +45,11 @@ int main(int ac, char **av)
>>   	struct btrfs_trans_handle *trans;
>>   	int ret;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", av[0]);
>> +		exit(1);
>> +	}
>> +
>>   	if (ac != 2)
>>   		print_usage();
>>   
>> diff --git a/btrfs.c b/btrfs.c
>> index 687acec..328966b 100644
>> --- a/btrfs.c
>> +++ b/btrfs.c
>> @@ -18,6 +18,7 @@
>>   #include <stdio.h>
>>   #include <stdlib.h>
>>   #include <string.h>
>> +#include <unistd.h>
>>   
>>   #include "crc32c.h"
>>   #include "commands.h"
>> @@ -261,6 +262,11 @@ int main(int argc, char **argv)
>>   {
>>   	const struct cmd_struct *cmd;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	crc32c_optimization_init();
>>   
>>   	argc--;
>> diff --git a/btrfsck.c b/btrfsck.c
>> index 6274ff7..bdfdfc5 100644
>> --- a/btrfsck.c
>> +++ b/btrfsck.c
>> @@ -3501,6 +3501,11 @@ int main(int ac, char **av)
>>   	int init_csum_tree = 0;
>>   	int rw = 0;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", av[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c;
>>   		c = getopt_long(ac, av, "as:", long_options,
>> diff --git a/btrfsctl.c b/btrfsctl.c
>> index 049a5f3..cbe41e7 100644
>> --- a/btrfsctl.c
>> +++ b/btrfsctl.c
>> @@ -113,6 +113,11 @@ int main(int ac, char **av)
>>   		"** Please consider to switch to the btrfs utility\n"
>>   		"**\n");
>>   	
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", av[0]);
>> +		exit(1);
>> +	}
>> +
>>   	if (ac == 2 && strcmp(av[1], "-a") == 0) {
>>   		fprintf(stderr, "Scanning for Btrfs filesystems\n");
>>   		btrfs_scan_one_dir("/dev", 1);
>> diff --git a/btrfstune.c b/btrfstune.c
>> index 6950f74..d4017f1 100644
>> --- a/btrfstune.c
>> +++ b/btrfstune.c
>> @@ -79,6 +79,11 @@ int main(int argc, char *argv[])
>>   	int seeding_value = 0;
>>   	int ret;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c = getopt(argc, argv, "S:");
>>   		if (c < 0)
>> diff --git a/calc-size.c b/calc-size.c
>> index c4adfb0..0d3442c 100644
>> --- a/calc-size.c
>> +++ b/calc-size.c
>> @@ -194,6 +194,11 @@ int main(int argc, char **argv)
>>   	int opt;
>>   	int ret = 0;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while ((opt = getopt(argc, argv, "vb")) != -1) {
>>   		switch (opt) {
>>   			case 'v':
>> diff --git a/convert.c b/convert.c
>> index 1de2a44..1b0e27c 100644
>> --- a/convert.c
>> +++ b/convert.c
>> @@ -2770,6 +2770,12 @@ int main(int argc, char *argv[])
>>   	int datacsum = 1;
>>   	int rollback = 0;
>>   	char *file;
>> +
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c = getopt(argc, argv, "dinr");
>>   		if (c < 0)
>> diff --git a/debug-tree.c b/debug-tree.c
>> index f6bd5d8..5b2f531 100644
>> --- a/debug-tree.c
>> +++ b/debug-tree.c
>> @@ -129,6 +129,11 @@ int main(int ac, char **av)
>>   	u64 block_only = 0;
>>   	struct btrfs_root *tree_root_scan;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", av[0]);
>> +		exit(1);
>> +	}
>> +
>>   	radix_tree_init();
>>   
>>   	while(1) {
>> diff --git a/dir-test.c b/dir-test.c
>> index c7644d6..9fa5b06 100644
>> --- a/dir-test.c
>> +++ b/dir-test.c
>> @@ -433,6 +433,11 @@ int main(int ac, char **av)
>>   	int err = 0;
>>   	int initial_only = 0;
>>   	struct btrfs_trans_handle *trans;
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	radix_tree_init();
>>   
>>   	root = open_ctree(av[ac-1], &super, 0);
>> diff --git a/find-root.c b/find-root.c
>> index 83f1592..06465eb 100644
>> --- a/find-root.c
>> +++ b/find-root.c
>> @@ -414,6 +414,11 @@ int main(int argc, char **argv)
>>   	int opt;
>>   	int ret;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while ((opt = getopt(argc, argv, "vo:")) != -1) {
>>   		switch(opt) {
>>   			case 'v':
>> diff --git a/ioctl-test.c b/ioctl-test.c
>> index 1c27d61..299d2af 100644
>> --- a/ioctl-test.c
>> +++ b/ioctl-test.c
>> @@ -1,5 +1,6 @@
>>   #include <stdio.h>
>>   #include <stdlib.h>
>> +#include <unistd.h>
>>   #include "kerncompat.h"
>>   #include "ioctl.h"
>>   
>> @@ -28,6 +29,11 @@ unsigned long ioctls[] = {
>>   int main(int ac, char **av)
>>   {
>>   	int i = 0;
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(ioctls[i]) {
>>   		printf("%lu\n" ,ioctls[i]);
>>   		i++;
>> diff --git a/mkfs.c b/mkfs.c
>> index a129ec4..501e384 100644
>> --- a/mkfs.c
>> +++ b/mkfs.c
>> @@ -1274,6 +1274,11 @@ int main(int ac, char **av)
>>   	u64 source_dir_size = 0;
>>   	char *pretty_buf;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", av[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while(1) {
>>   		int c;
>>   		c = getopt_long(ac, av, "A:b:l:n:s:m:d:L:r:VMK", long_options,
>> diff --git a/quick-test.c b/quick-test.c
>> index 05d73fd..e2d6f78 100644
>> --- a/quick-test.c
>> +++ b/quick-test.c
>> @@ -19,6 +19,7 @@
>>   #include <stdio.h>
>>   #include <stdlib.h>
>>   #include <fcntl.h>
>> +#include <unistd.h>
>>   #include "kerncompat.h"
>>   #include "radix-tree.h"
>>   #include "ctree.h"
>> @@ -49,6 +50,11 @@ int main(int ac, char **av) {
>>   	buf = malloc(512);
>>   	memset(buf, 0, 512);
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	radix_tree_init();
>>   
>>   	root = open_ctree(av[1], BTRFS_SUPER_INFO_OFFSET, O_RDWR);
>> diff --git a/restore.c b/restore.c
>> index 80afb84..4efc8b5 100644
>> --- a/restore.c
>> +++ b/restore.c
>> @@ -771,6 +771,11 @@ int main(int argc, char **argv)
>>   	int super_mirror = 0;
>>   	int find_dir = 0;
>>   
>> +	if (geteuid() != 0) {
>> +		fprintf(stderr,"Error: %s must run as root\n", argv[0]);
>> +		exit(1);
>> +	}
>> +
>>   	while ((opt = getopt(argc, argv, "sviot:u:df:")) != -1) {
>>   		switch (opt) {
>>   			case 's':
>>
> 21 times copy & paste, you set a new record :)
>
I was very tempted to do a little more.  I know that there is no 
standard that says the two parameters of main() are named argc and argv 
but it is traditional.  I could not believe I got errors because it was 
named av instead of argv.  But, patches like this should stay on topic.

Gene
