Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:45712 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751882AbeDJVE0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 17:04:26 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH v2] btrfs-progs: dump-super: Refactor print function and
 add extra check
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180409091934.5429-1-wqu@suse.com>
 <9ca6c0f7-5bfb-6f9d-1882-f76619330e22@libero.it>
 <84880c72-3f76-99c8-6204-562ca4cee0a7@gmx.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <2d59d411-d6a3-ed57-d087-63cefc7abf7f@inwind.it>
Date: Tue, 10 Apr 2018 23:04:20 +0200
MIME-Version: 1.0
In-Reply-To: <84880c72-3f76-99c8-6204-562ca4cee0a7@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

On 04/10/2018 04:00 AM, Qu Wenruo wrote:
> 
> 
> On 2018年04月10日 05:50, Goffredo Baroncelli wrote:
>> Hi Qu,
>>
>> On 04/09/2018 11:19 AM, Qu Wenruo wrote:
>>> When manually patching super blocks, current validation check is pretty
>>> weak (limited to magic number and csum) and doesn't provide extra check
>>> for some obvious corruption (like invalid sectorsize).
>> [...]
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> changelog:
>>> v2:
>>>   Generate tab based indent string in helper macro instead of passing spacer
>>>   string from outside, suggested by Nikolay.
>>>   (In fact, if using %*s it would be much easier, however it needs extra
>>>    rework for existing code as they still use tab as indent)
>>> ---
>>>  cmds-inspect-dump-super.c | 206 +++++++++++++++++++++++++-------------
>>>  1 file changed, 137 insertions(+), 69 deletions(-)
>>>
>>> diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
>>> index 24588c87cce6..68d6f59ad727 100644
>>> --- a/cmds-inspect-dump-super.c
>>> +++ b/cmds-inspect-dump-super.c
>>> @@ -312,11 +312,80 @@ static void print_readable_super_flag(u64 flag)
>>>  				     super_flags_num, BTRFS_SUPER_FLAG_SUPP);
>>>  }
>>>  
>>> +#define INDENT_BUFFER_LEN	80
>>> +#define TAB_LEN			8
>>> +#define SUPER_INDENT		24
>>> +
>>> +/* helper to generate tab based indent string */
>>> +static void generate_tab_indent(char *buf, unsigned int indent)
>>> +{
>>> +	buf[0] = '\0';
>>> +	for (indent = round_up(indent, TAB_LEN); indent > 0; indent -= TAB_LEN)
>>> +		strncat(buf, "\t", INDENT_BUFFER_LEN);
>>> +}
>>> +
>>> +/* Helper to print member in %llu */
>>> +#define print_super(sb, member)						\
>>> +({									\
>>> +	int indent = SUPER_INDENT - strlen(#member);			\
>>> +	char indent_str[INDENT_BUFFER_LEN];				\
>>> +									\
>>> +	generate_tab_indent(indent_str, indent);			\
>>> +	printf("%s%s%llu\n", #member, indent_str,			\
>>> +	       (u64) btrfs_super_##member(sb));				\
>>
>> Why not something like:
>>
>>             static const char tabs[] = "\t\t\t\t";        \
>>             int i = (sizeof(#member)+6)/8;                \
>>             if (i > sizeof(tabs)-1)                       \
>>                 i = sizeof(tabs-1);                       \
>>             u64 value = (u64)btrfs_super_##member(sb);    \
>>             printf("%s%s" format,                         \
>>                 #member, tabs+i, value);  
>>
>>
>> so to get rid  of generate_tab_indent and indent_str
> 
> And we need to call such functions in each helper macros, with
> duplicated codes.

Please look at the asm generated: even if the "source generated" by the expansion of the macro is bigger, the binary code is smaller.
E.g. the code below 

             static const char tabs[] = "\t\t\t\t";        \
             int i = (sizeof(#member)+6)/8;                \
             if (i > sizeof(tabs)-1)                       \
                 i = sizeof(tabs)-1;                       \

is translate as single move (see https://godbolt.org/g/4oxmAZ)

  main::tabs:
        .string "\t\t\t\t"

	movl    main::tabs+1, %edx


These days, the compilers are smart enough to evaluate the code above at compile time. This is not true for generate_tab_indent(), which is too complex. 

Of course all the above consideration are meaningless, because I don't think that the size (or the speed) matters in the specific case of dump_superblock(). However I want to point out that the compiler sometime are smarter than the programmer (or almost smarter than me :-) ) in a surprising way, and what would seems bigger at the end results smaller.
 
[...]

>>> + */
>>> +#define print_check_super(sb, member, bad_condition)			\
>>> +({									\
>>> +	int indent = SUPER_INDENT - strlen(#member);			\
>>> +	char indent_str[INDENT_BUFFER_LEN];				\
>>> +	u64 value;							\
>>> +									\
>>> +	generate_tab_indent(indent_str, indent);			\
>>> +	value = btrfs_super_##member(sb);				\
>>> +	printf("%s%s%llu", #member, indent_str,	(u64) value);		\
>>> +	if (bad_condition)						\
>>> +		printf(" [INVALID]");					\
>>
>> What about printing also the condition: something like
>>
>> +	if (bad_condition)						\
>> +		printf(" [INVALID '%s']", #bad_condition);		\
>>
>> it would be even better a "good_condition":
> 
> When passing random stream to dump-super, such reason will make output
> quite nasty.
> So just INVALID to info the user that some of the members don't look
> valid is good enough, as the tool is only to help guys who are going to
> manually patching superblocks.

I think that we should increase the possible target also to who want to make some debugging :-)

> 
> Thanks,
> Qu
> 
>>
>> so instead of:
>> +	print_check_super(sb, bytenr, (!IS_ALIGNED(value, SZ_4K)));
>> do
>> +	print_check_super(sb, bytenr, (IS_ALIGNED(value, SZ_4K)));
>>
>> and
>>
>> +	if (!good_condition)						\
>> +		printf(" [ERROR: required '%s']", #good_condition);	\
>>
>>
>> All above functions could be written as:
>>
>>   #define __print_and_check(sb, member, format, expected)   \
>>         do{                                               \
>>             static const char tabs[] = "\t\t\t\t";        \
>>             int i = (sizeof(#member)+6)/8;                \
>>             if (i > sizeof(tabs)-1)                       \
>>                 i = sizeof(tabs-1);                       \

The line above obviously is wrong: it should be "i = sizeof(tabs) -1;" :-)

>>             u64 value = (u64)btrfs_super_##member(sb);    \
>>             printf("%s%s" format,                         \
>>                 #member, tabs+i, value);                  \
>>             if (!(expected))                              \
>>                 printf(" [ERROR: expected '%s']", #expected);    \

As further example about the compiler smartness, if "expected" is evaluate as false at compile time, the "if" above is skipped

>>             printf("\n");                           \
>>          } while(0)
>>          
>>   #define print_super(sb, member) \
>>     __print_and_check(sb, member, "%llu", 1);
>>
>>   #define print_super_hex(sb, member) \
>>     __print_and_check(sb, member, "0x%llx", 1);
>>
>>   #define print_check_super(sb, member, condition) \
>>     __print_and_check(sb, member, "0x%llx", condition);
>>

BR
G.Baroncelli


>> And the value should be printed as (I removed the !):
>>
>>   print_check_super(sb, root, (IS_ALIGNED(value, SZ_4K)));
>>
>> In case of error:
>>
>> test                        12 [ERROR: expected 'IS_ALIGNED(value, SZ_4K)']
>>
>>
>>
>>
>>> +	printf("\n");							\
>>> +})
>>> +
>>> +#define DEV_INDENT	(SUPER_INDENT - strlen("dev_item."))
>>> +BUILD_ASSERT(DEV_INDENT > 0);
>>> +
>>> +/* Helper to print sb->dev_item members */
>>> +#define print_super_dev(sb, member)					\
>>> +({									\
>>> +	int indent = DEV_INDENT - strlen(#member);			\
>>> +	char indent_str[INDENT_BUFFER_LEN];				\
>>> +									\
>>> +	generate_tab_indent(indent_str, indent);			\
>>> +	printf("dev_item.%s%s%llu\n", #member, indent_str,		\
>>> +	       (u64) btrfs_stack_device_##member(&sb->dev_item));	\
>>> +})
>>> +dump_superblock(
>>>  static void dump_superblock(struct btrfs_super_block *sb, int full)
>>>  {
>>>  	int i;
>>>  	char *s, buf[BTRFS_UUID_UNPARSED_SIZE];
>>> +	int max_level = BTRFS_MAX_LEVEL; /* to save several chars */
>>>  	u8 *p;
>>> +	u64 super_gen;
>>>  	u32 csum_size;
>>>  	u16 csum_type;
>>>  
>>> @@ -348,10 +417,16 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
>>>  		printf(" [DON'T MATCH]");
>>>  	putchar('\n');
>>>  
>>> -	printf("bytenr\t\t\t%llu\n",
>>> -		(unsigned long long)btrfs_super_bytenr(sb));
>>> -	printf("flags\t\t\t0x%llx\n",
>>> -		(unsigned long long)btrfs_super_flags(sb));
>>> +	/*
>>> +	 * Use btrfs minimal sector size as basic check for bytenr, since we
>>> +	 * can't trust sector size from super block.
>>> +	 * This 4K check should works fine for most architecture, and will be
>>> +	 * just a little loose for 64K page system.
>>> +	 *
>>> +	 * And such 4K check will be used for other members too.
>>> +	 */
>>> +	print_check_super(sb, bytenr, (!IS_ALIGNED(value, SZ_4K)));
>>> +	print_super_hex(sb, flags);
>>>  	print_readable_super_flag(btrfs_super_flags(sb));
>>>  
>>>  	printf("magic\t\t\t");
>>> @@ -372,53 +447,56 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
>>>  		putchar(isprint(s[i]) ? s[i] : '.');
>>>  	putchar('\n');
>>>  
>>> -	printf("generation\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_generation(sb));
>>> -	printf("root\t\t\t%llu\n", (unsigned long long)btrfs_super_root(sb));
>>> -	printf("sys_array_size\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_sys_array_size(sb));
>>> -	printf("chunk_root_generation\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_chunk_root_generation(sb));
>>> -	printf("root_level\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_root_level(sb));
>>> -	printf("chunk_root\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_chunk_root(sb));
>>> -	printf("chunk_root_level\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_chunk_root_level(sb));
>>> -	printf("log_root\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_log_root(sb));
>>> -	printf("log_root_transid\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_log_root_transid(sb));
>>> -	printf("log_root_level\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_log_root_level(sb));
>>> -	printf("total_bytes\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_total_bytes(sb));
>>> -	printf("bytes_used\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_bytes_used(sb));
>>> -	printf("sectorsize\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_sectorsize(sb));
>>> -	printf("nodesize\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_nodesize(sb));
>>> +	print_check_super(sb, sys_array_size,
>>> +			  (value > BTRFS_SYSTEM_CHUNK_ARRAY_SIZE));
>>> +
>>> +	super_gen = btrfs_super_generation(sb);
>>> +	print_check_super(sb, root, (!IS_ALIGNED(value, SZ_4K)));
>>> +	print_check_super(sb, root_level, (value >= max_level));
>>> +	print_super(sb, generation);
>>> +
>>> +	print_check_super(sb, chunk_root, (!IS_ALIGNED(value, SZ_4K)));
>>> +	print_check_super(sb, chunk_root_level, (value >= max_level));
>>> +	/*
>>> +	 * Here we trust super generation, and use it as checker for other
>>> +	 * tree roots. Applies to all other trees.
>>> +	 */
>>> +	print_check_super(sb, chunk_root_generation, (value > super_gen));
>>> +
>>> +	print_check_super(sb, log_root, (!IS_ALIGNED(value, SZ_4K)));
>>> +	print_check_super(sb, log_root_level, (value >= max_level));
>>> +	print_check_super(sb, log_root_transid, (value > super_gen + 1));
>>> +
>>> +	/*
>>> +	 * For total bytes, it's possible that old kernel is using unaligned
>>> +	 * size, not critical so don't do 4K check here.
>>> +	 */
>>> +	print_super(sb, total_bytes);
>>> +
>>> +	/* Used bytes must be aligned to 4K */
>>> +	print_check_super(sb, bytes_used, (!IS_ALIGNED(value, SZ_4K)));
>>> +	print_check_super(sb, sectorsize,
>>> +			  (!(is_power_of_2(value) && value >= SZ_4K &&
>>> +			     value <= SZ_64K)));
>>> +	print_check_super(sb, nodesize,
>>> +			  (!(is_power_of_2(value) && value >= SZ_4K &&
>>> +			     value <= SZ_64K &&
>>> +			     value > btrfs_super_sectorsize(sb))));
>>>  	printf("leafsize (deprecated)\t%u\n",
>>>  	       le32_to_cpu(sb->__unused_leafsize));
>>> -	printf("stripesize\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_stripesize(sb));
>>> -	printf("root_dir\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_root_dir(sb));
>>> -	printf("num_devices\t\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_num_devices(sb));
>>> -	printf("compat_flags\t\t0x%llx\n",
>>> -	       (unsigned long long)btrfs_super_compat_flags(sb));
>>> -	printf("compat_ro_flags\t\t0x%llx\n",
>>> -	       (unsigned long long)btrfs_super_compat_ro_flags(sb));
>>> +
>>> +	/* Not really used, just check it the same way as kernel */
>>> +	print_check_super(sb, stripesize, (!is_power_of_2(value)));
>>> +	print_super(sb, root_dir);
>>> +	print_super(sb, num_devices);
>>> +	print_super_hex(sb, compat_flags);
>>> +	print_super_hex(sb, compat_ro_flags);
>>>  	print_readable_compat_ro_flag(btrfs_super_compat_ro_flags(sb));
>>> -	printf("incompat_flags\t\t0x%llx\n",
>>> -	       (unsigned long long)btrfs_super_incompat_flags(sb));
>>> +	print_super_hex(sb, incompat_flags);
>>>  	print_readable_incompat_flag(btrfs_super_incompat_flags(sb));
>>> -	printf("cache_generation\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_cache_generation(sb));
>>> -	printf("uuid_tree_generation\t%llu\n",
>>> -	       (unsigned long long)btrfs_super_uuid_tree_generation(sb));
>>> +	print_check_super(sb, cache_generation,
>>> +			  (value > super_gen && value != (u64)-1));
>>> +	print_check_super(sb, uuid_tree_generation, (value > super_gen));
>>>  
>>>  	uuid_unparse(sb->dev_item.uuid, buf);
>>>  	printf("dev_item.uuid\t\t%s\n", buf);
>>> @@ -428,28 +506,18 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
>>>  		!memcmp(sb->dev_item.fsid, sb->fsid, BTRFS_FSID_SIZE) ?
>>>  			"[match]" : "[DON'T MATCH]");
>>>  
>>> -	printf("dev_item.type\t\t%llu\n", (unsigned long long)
>>> -	       btrfs_stack_device_type(&sb->dev_item));
>>> -	printf("dev_item.total_bytes\t%llu\n", (unsigned long long)
>>> -	       btrfs_stack_device_total_bytes(&sb->dev_item));
>>> -	printf("dev_item.bytes_used\t%llu\n", (unsigned long long)
>>> -	       btrfs_stack_device_bytes_used(&sb->dev_item));
>>> -	printf("dev_item.io_align\t%u\n", (unsigned int)
>>> -	       btrfs_stack_device_io_align(&sb->dev_item));
>>> -	printf("dev_item.io_width\t%u\n", (unsigned int)
>>> -	       btrfs_stack_device_io_width(&sb->dev_item));
>>> -	printf("dev_item.sector_size\t%u\n", (unsigned int)
>>> -	       btrfs_stack_device_sector_size(&sb->dev_item));
>>> -	printf("dev_item.devid\t\t%llu\n",
>>> -	       btrfs_stack_device_id(&sb->dev_item));
>>> -	printf("dev_item.dev_group\t%u\n", (unsigned int)
>>> -	       btrfs_stack_device_group(&sb->dev_item));
>>> -	printf("dev_item.seek_speed\t%u\n", (unsigned int)
>>> -	       btrfs_stack_device_seek_speed(&sb->dev_item));
>>> -	printf("dev_item.bandwidth\t%u\n", (unsigned int)
>>> -	       btrfs_stack_device_bandwidth(&sb->dev_item));
>>> -	printf("dev_item.generation\t%llu\n", (unsigned long long)
>>> -	       btrfs_stack_device_generation(&sb->dev_item));
>>> +	/* For embedded device item, don't do extra check, just like kernel */
>>> +	print_super_dev(sb, type);
>>> +	print_super_dev(sb, total_bytes);
>>> +	print_super_dev(sb, bytes_used);
>>> +	print_super_dev(sb, io_align);
>>> +	print_super_dev(sb, io_width);
>>> +	print_super_dev(sb, sector_size);
>>> +	print_super_dev(sb, id);
>>> +	print_super_dev(sb, group);
>>> +	print_super_dev(sb, seek_speed);
>>> +	print_super_dev(sb, bandwidth);
>>> +	print_super_dev(sb, generation);
>>>  	if (full) {
>>>  		printf("sys_chunk_array[%d]:\n", BTRFS_SYSTEM_CHUNK_ARRAY_SIZE);
>>>  		print_sys_chunk_array(sb);
>>>
>>
>>
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
