Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8341 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751167AbbASHya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 02:54:30 -0500
Message-ID: <54BCB800.7050906@cn.fujitsu.com>
Date: Mon, 19 Jan 2015 15:53:36 +0800
From: =?UTF-8?B?RmFuIENoZW5nbmlhbmcv5qiK5oiQ6YW/?=
	<fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] btrfs-progs: make btrfs qgroups show human readable
 sizes
References: <1421651898-792-1-git-send-email-fancn.fnst@cn.fujitsu.com> <98D897F2-93B8-493B-9281-13A3DC407C5A@gmail.com>
In-Reply-To: <98D897F2-93B8-493B-9281-13A3DC407C5A@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


在 2015年01月19日 15:31, Wang Shilong 写道:
> Hello,
>
>
>> add --raw, --si, --iec, --kbytes, --mbytes, --gbytes, --tbytes options
>> make columns which show sizes align to right. Others aligned to left.
>>
>> example:
>> qgroupid         rfer         excl     max_rfer     max_excl parent  child
>> --------         ----         ----     --------     -------- ------  -----
>> 0/5         299.58MiB    299.58MiB    300.00MiB    300.00MiB 1/1     ---
>> 0/265       299.58MiB     16.00KiB    400.00MiB        0.00B 1/1     ---
>> 0/266       299.58MiB     16.00KiB    350.00MiB        0.00B ---     ---
>> 1/1         599.16MiB    299.59MiB    800.00MiB        0.00B ---     0/5,0/265
>>
>> Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
>> ---
>> v2:
>> - change -h option to --human-readable
>> - merge need_print and human_readable into format
>> - add print_group_size function
>> v3:
>> - remove --human-readable option
>> - add --raw, --si, --iec, --kbytes, --mbytes, --gbytes, --tbytes options
>> - by default, sizes are shown in human readable format
> Oh, really...
> Have you run with this patch with xfstests?
>
> I am not sure whether some qgroup tests could pass this, if not
> you need keep default raw output, or please modify xfstests to make
> it pass.
>
I will test and repair it.thanx
>> - make columns which show sizes align to right. Othersligned to left.
>>
>> Documentation/btrfs-qgroup.txt | 14 ++++++++
>> cmds-qgroup.c                  | 56 ++++++++++++++++++++++++------
>> qgroup.c                       | 77 ++++++++++++++++++++++++++++--------------
>> qgroup.h                       |  1 +
>> 4 files changed, 113 insertions(+), 35 deletions(-)
>>
>> diff --git a/Documentation/btrfs-qgroup.txt b/Documentation/btrfs-qgroup.txt
>> index 3e13373..89dbd6c 100644
>> --- a/Documentation/btrfs-qgroup.txt
>> +++ b/Documentation/btrfs-qgroup.txt
>> @@ -73,6 +73,20 @@ print max exclusive size of qgroup.
>> list all qgroups which impact the given path(include ancestral qgroups)
>> -f::::
>> list all qgroups which impact the given path(exclude ancestral qgroups)
>> +--raw::::
>> +raw numbers in bytes, without the 'B' suffix.
>> +--iec::::
>> +select the 1024 base for the following options, according to the IEC standard.
>> +--si::::
>> +select the 1000 base for the following options, according to the SI standard.
>> +--kbytes::::
>> +show sizes in KiB, or kB with --si.
>> +--mbytes::::
>> +show sizes in MiB, or MB with --si.
>> +--gbytes::::
>> +show sizes in GiB, or GB with --si.
>> +--tbytes::::
>> +show sizes in TiB, or TB with --si.
>> --sort=[\+/-]<attr>[,[+/-]<attr>]...::::
>> list qgroups in order of <attr>.
>> +
>> diff --git a/cmds-qgroup.c b/cmds-qgroup.c
>> index 957fbc9..2474251 100644
>> --- a/cmds-qgroup.c
>> +++ b/cmds-qgroup.c
>> @@ -208,19 +208,26 @@ static const char * const cmd_qgroup_show_usage[] = {
>> 	"btrfs qgroup show -pcreFf "
>> 	"[--sort=qgroupid,rfer,excl,max_rfer,max_excl] <path>",
>> 	"Show subvolume quota groups.",
>> -	"-p		print parent qgroup id",
>> -	"-c		print child qgroup id",
>> -	"-r		print max referenced size of qgroup",
>> -	"-e		print max exclusive size of qgroup",
>> -	"-F		list all qgroups which impact the given path"
>> +	"-p             print parent qgroup id",
>> +	"-c             print child qgroup id",
>> +	"-r             print max referenced size of qgroup",
>> +	"-e             print max exclusive size of qgroup",
>> +	"-F             list all qgroups which impact the given path"
>> 	"(include ancestral qgroups)",
>> -	"-f		list all qgroups which impact the given path"
>> +	"-f             list all qgroups which impact the given path"
>> 	"(exclude ancestral qgroups)",
>> +	"--raw          raw numbers in bytes",
>> +	"--iec          use 1024 as a base (KiB, MiB, GiB, TiB)",
>> +	"--si           use 1000 as a base (kB, MB, GB, TB)",
>> +	"--kbytes       show sizes in KiB, or kB with --si",
>> +	"--mbytes       show sizes in MiB, or MB with --si",
>> +	"--gbytes       show sizes in GiB, or GB with --si",
>> +	"--tbytes       show sizes in TiB, or TB with --si",
>> 	"--sort=qgroupid,rfer,excl,max_rfer,max_excl",
>> -	"		list qgroups in order of qgroupid,"
>> +	"               list qgroups in order of qgroupid,"
>> 	"rfer,max_rfer or max_excl",
>> -	"		you can use '+' or '-' in front of each item.",
>> -	"		(+:ascending, -:descending, ascending default)",
>> +	"               you can use '+' or '-' in front of each item.",
>> +	"               (+:ascending, -:descending, ascending default)",
>> 	NULL
>> };
>>
>> @@ -234,6 +241,8 @@ static int cmd_qgroup_show(int argc, char **argv)
>> 	int c;
>> 	u64 qgroupid;
>> 	int filter_flag = 0;
>> +	int option_index = 0;
>> +	unsigned unit_mode = UNITS_DEFAULT;
>>
>> 	struct btrfs_qgroup_comparer_set *comparer_set;
>> 	struct btrfs_qgroup_filter_set *filter_set;
>> @@ -241,16 +250,41 @@ static int cmd_qgroup_show(int argc, char **argv)
>> 	comparer_set = btrfs_qgroup_alloc_comparer_set();
>> 	struct option long_options[] = {
>> 		{"sort", 1, NULL, 'S'},
>> +		{"raw", no_argument, NULL, 0},
>> +		{"kbytes", no_argument, NULL, 0},
>> +		{"mbytes", no_argument, NULL, 0},
>> +		{"gbytes", no_argument, NULL, 0},
>> +		{"tbytes", no_argument, NULL, 0},
>> +		{"si", no_argument, NULL, GETOPT_VAL_SI},
>> +		{"iec", no_argument, NULL, GETOPT_VAL_IEC},
>> 		{0, 0, 0, 0}
>> 	};
>>
>> 	optind = 1;
>> 	while (1) {
>> 		c = getopt_long(argc, argv, "pcreFf",
>> -				long_options, NULL);
>> +				long_options, &option_index);
>> 		if (c < 0)
>> 			break;
>> 		switch (c) {
>> +		case 0:
>> +			if (option_index == 1)
>> +				unit_mode = UNITS_RAW;
>> +			else if (option_index == 2)
>> +				units_set_base(&unit_mode, UNITS_KBYTES);
>> +			else if (option_index == 3)
>> +				units_set_base(&unit_mode, UNITS_MBYTES);
>> +			else if (option_index == 4)
>> +				units_set_base(&unit_mode, UNITS_GBYTES);
>> +			else if (option_index == 5)
>> +				units_set_base(&unit_mode, UNITS_TBYTES);
>> +			break;
>> +		case GETOPT_VAL_SI:
>> +			units_set_mode(&unit_mode, UNITS_DECIMAL);
>> +			break;
>> +		case GETOPT_VAL_IEC:
>> +			units_set_mode(&unit_mode, UNITS_BINARY);
>> +			break;
>> 		case 'p':
>> 			btrfs_qgroup_setup_print_column(
>> 				BTRFS_QGROUP_PARENT);
>> @@ -283,6 +317,8 @@ static int cmd_qgroup_show(int argc, char **argv)
>> 			usage(cmd_qgroup_show_usage);
>> 		}
>> 	}
>> +	btrfs_qgroup_setup_human_readable(unit_mode);
>> +
>> 	if (check_argc_exact(argc - optind, 1))
>> 		usage(cmd_qgroup_show_usage);
>>
>> diff --git a/qgroup.c b/qgroup.c
>> index 1a4866c..8ec55df 100644
>> --- a/qgroup.c
>> +++ b/qgroup.c
>> @@ -20,6 +20,7 @@
>> #include <sys/ioctl.h>
>> #include "ctree.h"
>> #include "ioctl.h"
>> +#include "utils.h"
>>
>> #define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
>> #define BTRFS_QGROUP_NCOMPS_INCREASE (2 * BTRFS_QGROUP_COMP_MAX)
>> @@ -80,53 +81,62 @@ static struct {
>> 	char *name;
>> 	char *column_name;
>> 	int need_print;
>> +	unsigned unit_mode;
>> 	int max_len;
>> } btrfs_qgroup_columns[] = {
>> 	{
>> 		.name		= "qgroupid",
>> 		.column_name	= "Qgroupid",
>> 		.need_print	= 1,
>> +		.unit_mode	= 0,
>> 		.max_len	= 8,
>> 	},
>> 	{
>> 		.name		= "rfer",
>> 		.column_name	= "Rfer",
>> 		.need_print	= 1,
>> -		.max_len	= 4,
>> +		.unit_mode	= UNITS_DEFAULT,
>> +		.max_len	= 12,
>> 	},
>> 	{
>> 		.name		= "excl",
>> 		.column_name	= "Excl",
>> 		.need_print	= 1,
>> -		.max_len	= 4,
>> +		.unit_mode	= UNITS_DEFAULT,
>> +		.max_len	= 12,
>> 	},
>> 	{	.name		= "max_rfer",
>> 		.column_name	= "Max_rfer",
>> 		.need_print	= 0,
>> -		.max_len	= 8,
>> +		.unit_mode	= UNITS_DEFAULT,
>> +		.max_len	= 12,
>> 	},
>> 	{
>> 		.name		= "max_excl",
>> 		.column_name	= "Max_excl",
>> 		.need_print	= 0,
>> -		.max_len	= 8,
>> +		.unit_mode	= UNITS_DEFAULT,
>> +		.max_len	= 12,
>> 	},
>> 	{
>> 		.name		= "parent",
>> 		.column_name	= "Parent",
>> 		.need_print	= 0,
>> +		.unit_mode	= 0,
>> 		.max_len	= 7,
>> 	},
>> 	{
>> 		.name		= "child",
>> 		.column_name	= "Child",
>> 		.need_print	= 0,
>> +		.unit_mode	= 0,
>> 		.max_len	= 5,
>> 	},
>> 	{
>> 		.name		= NULL,
>> 		.column_name	= NULL,
>> 		.need_print	= 0,
>> +		.unit_mode	= 0,
>> 	},
>> };
>>
>> @@ -147,6 +157,14 @@ void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column)
>> 		btrfs_qgroup_columns[i].need_print = 1;
>> }
>>
>> +void btrfs_qgroup_setup_human_readable(unsigned unit_mode)
>> +{
>> +	btrfs_qgroup_columns[BTRFS_QGROUP_RFER].unit_mode = unit_mode;
>> +	btrfs_qgroup_columns[BTRFS_QGROUP_EXCL].unit_mode = unit_mode;
>> +	btrfs_qgroup_columns[BTRFS_QGROUP_MAX_RFER].unit_mode = unit_mode;
>> +	btrfs_qgroup_columns[BTRFS_QGROUP_MAX_EXCL].unit_mode = unit_mode;
>> +}
>> +
>> static int print_parent_column(struct btrfs_qgroup *qgroup)
>> {
>> 	struct btrfs_qgroup_list *list = NULL;
>> @@ -194,6 +212,8 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
>> {
>> 	BUG_ON(column >= BTRFS_QGROUP_ALL || column < 0);
>> 	int len;
>> +	int unit_mode = btrfs_qgroup_columns[column].unit_mode;
>> +	int max_len = btrfs_qgroup_columns[column].max_len;
>>
>> 	switch (column) {
>>
>> @@ -203,24 +223,20 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
>> 		print_qgroup_column_add_blank(BTRFS_QGROUP_QGROUPID, len);
>> 		break;
>> 	case BTRFS_QGROUP_RFER:
>> -		len = printf("%llu", qgroup->rfer);
>> -		print_qgroup_column_add_blank(BTRFS_QGROUP_RFER, len);
>> +		len = printf("%*s", max_len, pretty_size_mode(qgroup->rfer, unit_mode));
>> 		break;
>> 	case BTRFS_QGROUP_EXCL:
>> -		len = printf("%llu", qgroup->excl);
>> -		print_qgroup_column_add_blank(BTRFS_QGROUP_EXCL, len);
>> +		len = printf("%*s", max_len, pretty_size_mode(qgroup->excl, unit_mode));
>> 		break;
>> 	case BTRFS_QGROUP_PARENT:
>> 		len = print_parent_column(qgroup);
>> 		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
>> 		break;
>> 	case BTRFS_QGROUP_MAX_RFER:
>> -		len = printf("%llu", qgroup->max_rfer);
>> -		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_RFER, len);
>> +		len = printf("%*s", max_len, pretty_size_mode(qgroup->max_rfer, unit_mode));
>> 		break;
>> 	case BTRFS_QGROUP_MAX_EXCL:
>> -		len = printf("%llu", qgroup->max_excl);
>> -		print_qgroup_column_add_blank(BTRFS_QGROUP_MAX_EXCL, len);
>> +		len = printf("%*s", max_len, pretty_size_mode(qgroup->max_excl, unit_mode));
>> 		break;
>> 	case BTRFS_QGROUP_CHILD:
>> 		len = print_child_column(qgroup);
>> @@ -250,30 +266,41 @@ static void print_table_head()
>> {
>> 	int i;
>> 	int len;
>> +	int max_len;
>>
>> 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
>> +		max_len = btrfs_qgroup_columns[i].max_len;
>> 		if (!btrfs_qgroup_columns[i].need_print)
>> 			continue;
>> -		printf("%s", btrfs_qgroup_columns[i].name);
>> -		len = btrfs_qgroup_columns[i].max_len -
>> -		      strlen(btrfs_qgroup_columns[i].name);
>> -		while (len--)
>> -			printf(" ");
>> +		if ((i == BTRFS_QGROUP_QGROUPID) | (i == BTRFS_QGROUP_PARENT) |
>> +			(i == BTRFS_QGROUP_CHILD))
>> +			printf("%-*s", max_len, btrfs_qgroup_columns[i].name);
>> +		else
>> +			printf("%*s", max_len, btrfs_qgroup_columns[i].name);
>> 		printf(" ");
>> 	}
>> 	printf("\n");
>> 	for (i = 0; i < BTRFS_QGROUP_ALL; i++) {
>> +		max_len = btrfs_qgroup_columns[i].max_len;
>> 		if (!btrfs_qgroup_columns[i].need_print)
>> 			continue;
>> -
>> -		len = strlen(btrfs_qgroup_columns[i].name);
>> -		while (len--)
>> -			printf("-");
>> -		len = btrfs_qgroup_columns[i].max_len -
>> -		      strlen(btrfs_qgroup_columns[i].name);
>> +		if ((i == BTRFS_QGROUP_QGROUPID) | (i == BTRFS_QGROUP_PARENT) |
>> +			(i == BTRFS_QGROUP_CHILD)) {
>> +			len = strlen(btrfs_qgroup_columns[i].name);
>> +			while (len--)
>> +				printf("-");
>> +			len = max_len - strlen(btrfs_qgroup_columns[i].name);
>> +			while (len--)
>> +				printf(" ");
>> +		} else {
>> +			len = max_len - strlen(btrfs_qgroup_columns[i].name);
>> +			while (len--)
>> +				printf(" ");
>> +			len = strlen(btrfs_qgroup_columns[i].name);
>> +			while (len--)
>> +				printf("-");
>> +		}
>> 		printf(" ");
>> -		while (len--)
>> -			printf(" ");
>> 	}
>> 	printf("\n");
>> }
>> diff --git a/qgroup.h b/qgroup.h
>> index 653cf1c..09070b6 100644
>> --- a/qgroup.h
>> +++ b/qgroup.h
>> @@ -83,6 +83,7 @@ u64 btrfs_get_path_rootid(int fd);
>> int btrfs_show_qgroups(int fd, struct btrfs_qgroup_filter_set *,
>> 		       struct btrfs_qgroup_comparer_set *);
>> void btrfs_qgroup_setup_print_column(enum btrfs_qgroup_column_enum column);
>> +void btrfs_qgroup_setup_human_readable(unsigned unit_mode);
>> struct btrfs_qgroup_filter_set *btrfs_qgroup_alloc_filter_set(void);
>> void btrfs_qgroup_free_filter_set(struct btrfs_qgroup_filter_set *filter_set);
>> int btrfs_qgroup_setup_filter(struct btrfs_qgroup_filter_set **filter_set,
>> -- 
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Best Regards,
> Wang Shilong
>

