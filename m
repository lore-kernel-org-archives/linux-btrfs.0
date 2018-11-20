Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D242BC43610
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23DC320851
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ylTm++a6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23DC320851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbeKTSkz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 13:40:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbeKTSkz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 13:40:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAK8458m029190;
        Tue, 20 Nov 2018 08:13:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=zB0Q1VGXzRrc0LpuRDectc+Vh2HdvVd+dY8LcgSZmTY=;
 b=ylTm++a6mMhs7+77qCPOI4+jEu3RomWC6NL3ewLUWNljksdWnxfyvyjiDaLEkeQBa+TH
 Q/byidHiwcOWaOcNLx81HNnCj8wJdFTxQP/BV66XhZaUOR05dsinwIfsTsAa/FGUXSaX
 nZ5jJJBitE8WFt305kiJPSgo3Mwk5UsIueGpcGbn8Bir8KtPSVThz0noyBaWGrr9rjiQ
 Vf1c45l7mPuBJ2ApAkNoDGVOmCy2PYYH+/s5kLKQenBt030fqjXFV6S62uZFhEg/0ZV5
 lHkco5HyJqMNTl8wnwCx/Wbm+VD5NELQFe3NL8vz/oNgpvs2ES2VT2E8WXCC6yFX/vLO ZQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2ntaxq2cmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Nov 2018 08:13:01 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAK8D1pG020219
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Nov 2018 08:13:01 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAK8D1WH026508;
        Tue, 20 Nov 2018 08:13:01 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 00:13:00 -0800
Subject: Re: [PATCH v5 2/3] btrfs: balance: add args info during start and
 resume
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1542201432-8617-1-git-send-email-anand.jain@oracle.com>
 <1542201432-8617-3-git-send-email-anand.jain@oracle.com>
 <20181119170748.GH24115@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <1155f14e-29c5-ae27-151c-e80e82a3cb66@oracle.com>
Date:   Tue, 20 Nov 2018 16:12:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181119170748.GH24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9082 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811200074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/20/2018 01:07 AM, David Sterba wrote:
> On Wed, Nov 14, 2018 at 09:17:11PM +0800, Anand Jain wrote:
>> Balance arg info is an important information to be reviewed for the
>> system audit. So this patch adds them to the kernel log.
>>
>> Example:
>> ->btrfs bal start -f -mprofiles=raid1,convert=single,soft -dlimit=10..20,usage=50 /btrfs
>>
>> kernel: BTRFS info (device sdb): balance: start -f -dusage=50,limit=10..20 -msoft,profiles=raid1,convert=single -ssoft,profiles=raid1,convert=single
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v4.1->v5: Per David review comment the code..
>>             bp += snprintf(bp, buf - bp + size_buf, "soft,");
>> 	  is not safe if 'buf - bp + size_buf' becomes accidentally
>> 	  negative, so fix this by using following snprintf.
>>
>>   #define CHECK_UPDATE_BP_1(a) \
>>         do { \
>>                 ret = snprintf(bp, size_bp, a); \
>>                 if (ret < 0 || ret >= size_bp) \
>>                         goto out; \
>>                 size_bp -= ret; \
>>                 bp += ret; \
>>         } while (0)
>>
>> 	And initialize the tmp_buf to null.
>>
>> v4->v4.1: Rename last missed sz to size_buf.
>>
>> v3->v4: Change log updated with new example.
>> 	Log format is changed to almost match with the cli.
>> 	snprintf drop %s for inline string.
>> 	Print range as =%u..%u instead of min=%umax=%u.
>> 	soft is under the args now.
>> 	force is printed as -f.
>>
>> v2->v3: Change log updated.
>>          Make use of describe_block_group() added in 1/4
>>          Drop using strcat instead use snprintf.
>>          Logs string format updated as shown in the example above.
>>
>> v1->v2: Change log update.
>>          Move adding the logs for balance complete and end to a new patch
>>
>>   fs/btrfs/volumes.c | 172 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 169 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 12b3d0625c6a..8397f72bdac7 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -3754,6 +3754,173 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
>>   		 (bctl_arg->target & ~allowed)));
>>   }
>>   
>> +static void describe_balance_args(struct btrfs_balance_args *bargs, char *buf,
>> +				 u32 size_buf)
>> +{
>> +	int ret;
>> +	u32 size_bp = size_buf;
>> +	char *bp = buf;
>> +	u64 flags = bargs->flags;
>> +	char tmp_buf[128] = {'\0'};
>> +
>> +	if (!flags)
>> +		return;
>> +
>> +#define CHECK_UPDATE_BP_1(a) \
> 
> CHECK_UPDATE_BP_NOARG and the others CHECK_UPDATE_BP_1ARG, though I'm
> thinking about picking another name for the macro like CHECK_APPEND_2ARG
> etc.

  I liked CHECK_APPEND_XXX I have renamed
   CHECK_UPDATE_BP_1 to CHECK_APPEND_NOARG
   CHECK_UPDATE_BP_2 to CHECK_APPEND_1ARG
   CHECK_UPDATE_BP_3 to CHECK_APPEND_2ARG

Hope its better now.

>> +	do { \
>> +		ret = snprintf(bp, size_bp, a); \
>> +		if (ret < 0 || ret >= size_bp) \
>> +			goto out; \
> 
> out_overflow and align \ to the right, please.

  Yep done.

>> +		size_bp -= ret; \
>> +		bp += ret; \
>> +	} while (0)
>> +
>> +#define CHECK_UPDATE_BP_2(a, v1) \
>> +	do { \
>> +		ret = snprintf(bp, size_bp, a, v1); \
>> +		if (ret < 0 || ret >= size_bp) \
>> +			goto out; \
>> +		size_bp -= ret; \
>> +		bp += ret; \
>> +	} while (0)
>> +
>> +#define CHECK_UPDATE_BP_3(a, v1, v2) \
>> +	do { \
>> +		ret = snprintf(bp, size_bp, a, v1, v2); \
>> +		if (ret < 0 || ret >= size_bp) \
>> +			goto out; \
>> +		size_bp -= ret; \
>> +		bp += ret; \
>> +	} while (0)
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_SOFT) {
>> +		CHECK_UPDATE_BP_1("soft,");
>> +	}
> 
> no { } around single statement

  fixed.

>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_PROFILES) {
>> +		btrfs_describe_block_groups(bargs->profiles, tmp_buf,
>> +					    sizeof(tmp_buf));
>> +		CHECK_UPDATE_BP_2("profiles=%s,", tmp_buf);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_USAGE) {
>> +		CHECK_UPDATE_BP_2("usage=%llu,", bargs->usage);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) {
>> +		CHECK_UPDATE_BP_3("usage=%u..%u,",
>> +				  bargs->usage_min, bargs->usage_max);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_DEVID) {
>> +		CHECK_UPDATE_BP_2("devid=%llu,", bargs->devid);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_DRANGE) {
>> +		CHECK_UPDATE_BP_3("drange=%llu..%llu,",
>> +				  bargs->pstart, bargs->pend);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_VRANGE) {
>> +		CHECK_UPDATE_BP_3("vrange%llu..%llu,",
>> +				  bargs->vstart, bargs->vend);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_LIMIT) {
>> +		CHECK_UPDATE_BP_2("limit=%llu,", bargs->limit);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_LIMIT_RANGE) {
>> +		CHECK_UPDATE_BP_3("limit=%u..%u,",
>> +				bargs->limit_min, bargs->limit_max);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_STRIPES_RANGE) {
>> +		CHECK_UPDATE_BP_3("stripes=%u..%u,",
>> +				  bargs->stripes_min, bargs->stripes_max);
>> +	}
>> +
>> +	if (flags & BTRFS_BALANCE_ARGS_CONVERT) {
>> +		int index = btrfs_bg_flags_to_raid_index(bargs->target);
>> +
>> +		CHECK_UPDATE_BP_2("convert=%s,", get_raid_name(index));
>> +	}
>> +
>> +out:
>> +#undef CHECK_UPDATE_BP_3
>> +#undef CHECK_UPDATE_BP_2
>> +#undef CHECK_UPDATE_BP_1
>> +
>> +	if (size_bp < size_buf)
>> +		buf[size_buf - size_bp - 1] = '\0'; /* remove last , */
>> +	else
>> +		buf[0] = '\0';
>> +}
>> +
>> +static void describe_balance_start_or_resume(struct btrfs_fs_info *fs_info)
>> +{
>> +	u32 size_buf = 1024;
>> +	char tmp_buf[192] = {'\0'};
>> +	char *buf;
>> +	char *bp;
>> +	u32 size_bp = size_buf;
>> +	int ret;
>> +	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
>> +
>> +	buf = kzalloc(size_buf, GFP_KERNEL);
>> +	if (!buf)
>> +		return;
>> +
>> +	bp = buf;
>> +#define CHECK_UPDATE_BP_1(a) \
>> +	do { \
>> +		ret = snprintf(bp, size_bp, a); \
>> +		if (ret < 0 || ret >= size_bp) \
>> +			return; \

  Leaking buf above. By using goto out_overflow also fixes this.

Thanks, Anand


>> +		size_bp -= ret; \
>> +		bp += ret; \
>> +	} while (0)
>> +
>> +#define CHECK_UPDATE_BP_2(a, v1) \
>> +	do { \
>> +		ret = snprintf(bp, size_bp, a, v1); \
>> +		if (ret < 0 || ret >= size_bp) \
>> +			return; \
>> +		size_bp -= ret; \
>> +		bp += ret; \
>> +	} while (0)
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_FORCE) {
>> +		CHECK_UPDATE_BP_1("-f ");
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_DATA) {
>> +		describe_balance_args(&bctl->data, tmp_buf, sizeof(tmp_buf));
>> +		CHECK_UPDATE_BP_2("-d%s ", tmp_buf);
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_METADATA) {
>> +		describe_balance_args(&bctl->meta, tmp_buf, sizeof(tmp_buf));
>> +		CHECK_UPDATE_BP_2("-m%s ", tmp_buf);
>> +	}
>> +
>> +	if (bctl->flags & BTRFS_BALANCE_SYSTEM) {
>> +		describe_balance_args(&bctl->sys, tmp_buf, sizeof(tmp_buf));
>> +		CHECK_UPDATE_BP_2("-s%s ", tmp_buf);
>> +	}
>> +
>> +#undef CHECK_UPDATE_BP_2
>> +#undef CHECK_UPDATE_BP_1
>> +
>> +	if (size_bp < size_buf)
>> +		buf[size_buf - size_bp - 1] = '\0'; /* remove last " "*/
>> +	btrfs_info(fs_info, "%s %s",
>> +		   bctl->flags & BTRFS_BALANCE_RESUME ?
>> +		   "balance: resume":"balance: start", buf);
>> +
>> +	kfree(buf);
>> +}
>> +
>>   /*
>>    * Should be called with balance mutexe held
>>    */
>> @@ -3893,6 +4060,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>   
>>   	ASSERT(!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
>>   	set_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>> +	describe_balance_start_or_resume(fs_info);
>>   	mutex_unlock(&fs_info->balance_mutex);
>>   
>>   	ret = __btrfs_balance(fs_info);
>> @@ -3930,10 +4098,8 @@ static int balance_kthread(void *data)
>>   	int ret = 0;
>>   
>>   	mutex_lock(&fs_info->balance_mutex);
>> -	if (fs_info->balance_ctl) {
>> -		btrfs_info(fs_info, "balance: resuming");
>> +	if (fs_info->balance_ctl)
>>   		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
>> -	}
>>   	mutex_unlock(&fs_info->balance_mutex);
>>   
>>   	return ret;
>> -- 
>> 1.8.3.1
