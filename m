From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs-progs: btrfs file system size should be bigger
 then 256m
Date: Wed, 31 Dec 2008 17:20:14 +0800
Message-ID: <495B394E.8070406@cn.fujitsu.com>
References: <495B0D54.7060806@cn.fujitsu.com> <495B2217.3030403@cs.drexel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <495B2217.3030403@cs.drexel.edu>
List-ID: <linux-btrfs.vger.kernel.org>

My test shows that at least 100M is needed for a btrfs partition.

on 12/31/2008 03:41 PM, Lee Trager wrote:
> This has been bothering me for some time. Why does btrfs need to have a
> disk greater then 256M? I could see a much smaller limit, say 16M but
> why so much? The file system itself does not need that much space for
> its own use.
> 
> Thanks,
> 
> Lee
> 
> Shen Feng wrote:
>> According to btrfs_prepare_device, btrfs file sysstem size
>> should be bigger then 256m.
>>
>> If mkfs.btrfs specifies the file system size samaller then
>> that, mkfs.btrfs should report error.
>>
>> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
>> ---
>>  mkfs.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/mkfs.c b/mkfs.c
>> index be93aaa..447e8d7 100644
>> --- a/mkfs.c
>> +++ b/mkfs.c
>> @@ -377,6 +377,10 @@ int main(int ac, char **av)
>>                  break;
>>              case 'b':
>>                  block_count = parse_size(optarg);
>> +                if (block_count < 256*1024*1024) {
>> +                    fprintf(stderr, "File system size is too small\n");
>> +                    exit(1);
>> +                }
>>                  zero_end = 0;
>>                  break;
>>              default:
>>   
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Best Regards,
--------------------------------------------------
Shen Feng
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
8/F., Civil Defense Building, No.189 Guangzhou Road,
Nanjing, 210029, China
PHONE: +86-25-86630566-950
COINS: 79955-950
FAX: +86-25-83317685
MAIL: shen@cn.fujitsu.com
-------------------------------------------------
This communication is for use by the intended recipient(s) only and may contain information that is privileged, confidential and exempt from disclosure under applicable law. If you are not an intended recipient of this communication, you are hereby notified that any dissemination, distribution or copying hereof is strictly prohibited.  If you have received this communication in error, please notify me by reply e-mail, permanently delete this communication from your system, and destroy any hard copies you may have printed.
