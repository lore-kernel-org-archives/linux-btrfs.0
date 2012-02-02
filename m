From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 12/12] Btrfs: Fix file clone when source offset is not
 0
Date: Thu, 02 Feb 2012 13:31:17 +0800
Message-ID: <4F2A1FA5.9020606@cn.fujitsu.com>
References: <4D412FE6.7050101@cn.fujitsu.com>	<4D4130D4.2000001@cn.fujitsu.com> <CAAM7YA=fCFfv-qObkpovQ6D7_6BdT1xU1c-0sVJNWjmPYHQBiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAM7YA=fCFfv-qObkpovQ6D7_6BdT1xU1c-0sVJNWjmPYHQBiw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan, Zheng wrote:
> On Thu, Jan 27, 2011 at 4:46 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Suppose:
>> - the source extent is: [0, 100]
>> - the src offset is 10
>> - the clone length is 90
>> - the dest offset is 0
>>
>> This statement:
>>
>>        new_key.offset = key.offset + destoff - off
>>
>> will produce such an extent for the dest file:
>>
>>        [ino, BTRFS_EXTENT_DATA_KEY, -10]
>>
>> , which is obviously wrong.
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ioctl.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index f87552a..1b61dab 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -1788,7 +1788,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>>
>>                        memcpy(&new_key, &key, sizeof(new_key));
>>                        new_key.objectid = inode->i_ino;
>> -                       new_key.offset = key.offset + destoff - off;
>> +                       if (off <= key.offset)
>> +                               new_key.offset = key.offset + destoff - off;
>> +                       else
>> +                               new_key.offset = destoff;
>>
>>                        trans = btrfs_start_transaction(root, 1);
>>                        if (IS_ERR(trans)) {
> 
> This is a disk format change, will cause Oops when deleting or
> truncating the file.
> 

This is a bug fix, never mean to make a change on disk format. I'll
appreciate if you point out what exactly is wrong in this fix.
