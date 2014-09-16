Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39698 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaIPF14 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 01:27:56 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id E0D043EE0C1
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 14:27:54 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 1E2C2AC0165
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 14:27:54 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id C431E1DB8038
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 14:27:53 +0900 (JST)
Message-ID: <5417CA4A.40807@jp.fujitsu.com>
Date: Tue, 16 Sep 2014 14:27:38 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] Btrfs: add missing compression property remove in btrfs_ioctl_setflags
References: <1410361824-12676-1-git-send-email-fdmanana@suse.com>	<5411280A.9010601@jp.fujitsu.com> <CAL3q7H41wCtJ08h=91+wqzXK+DyBRLhNQBK1PtR9882Ddb1EKQ@mail.gmail.com>
In-Reply-To: <CAL3q7H41wCtJ08h=91+wqzXK+DyBRLhNQBK1PtR9882Ddb1EKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

# I added Chris to the CC list since this topic is to discuss
# whether the current behavior is correct or not.

(2014/09/11 18:48), Filipe David Manana wrote:
> On Thu, Sep 11, 2014 at 5:41 AM, Satoru Takeuchi
> <takeuchi_satoru@jp.fujitsu.com> wrote:
>> Hi Filipe,
>>
>> (2014/09/11 0:10), Filipe Manana wrote:
>>> The behaviour of a 'chattr -c' consists of getting the current flags,
>>> clearing the FS_COMPR_FL bit and then sending the result to the set
>>> flags ioctl - this means the bit FS_NOCOMP_FL isn't set in the flags
>>> passed to the ioctl. This results in the compression property not being
>>> cleared from the inode - it was cleared only if the bit FS_NOCOMP_FL
>>> was set in the received flags.
>>>
>>> Reproducer:
>>>
>>>       $ mkfs.btrfs -f /dev/sdd
>>>       $ mount /dev/sdd /mnt && cd /mnt
>>>       $ mkdir a
>>>       $ chattr +c a
>>>       $ touch a/file
>>>       $ lsattr a/file
>>>       --------c------- a/file
>>>       $ chattr -c a
>>>       $ touch a/file2
>>>       $ lsattr a/file2
>>>       --------c------- a/file2
>>>       $ lsattr -d a
>>>       ---------------- a
>>>
>>> Reported-by: Andreas Schneider <asn@cryptomilk.org>
>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>    fs/btrfs/ioctl.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index a010c44..8e6950c 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -333,6 +333,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>>>
>>>        } else {
>>>                ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
>>> +             ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);
>>
>> IMHO, this patch is going on a wrong way since this patch
>> changes the meaning of chattr. Here is the correct behavior.
>>
>> flag | BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS |
>> =====+======================+========================+
>> +c   |        set           |         unset          |
>> -c   |       unset          |         unset          |
>>
>> However, by your change, chattr -c results in unset
>> BTRFS_INODE_COMPRESS and *set* BTRFS_INODE_NOCOMPRESS.
>
> Right, for the reason mentioned below it's not a big deal, but
> nevertheless better to not break the expectations and behaviour from
> pre-properties era.
>
>> It's because btrfs_set_prop() will finally lead to
>> prop_compression_apply() with setting its value to "".
>> It's the behavior of calling ioctl() with FS_NOCOMP_FL.
>>
>> Please note that inode flag without both BTRFS_INODE_COMPRESS
>> nor BTRFS_INODE_NOCOMPRESS has its own meaning: whether file
>> is compress or not is decided by "compress" mount option.
>
> Right, which will set NOCOMPRESS if compression of the first write is
> worthless (compressed size >= uncompressed size).
> The fs has the right of setting NOCOMPRESS/FS_NOCOMP_FL if it wishes
> to (due to lack of any specification that forbids it).

Actually "mount -o compress-force" can forbid to set NOCOMPRESS.
Please refer to the following code.

linux/fs/btrfs/inode.c:
=======
...
	/* flag the file so we don't compress in the future */
	if (!btrfs_test_opt(root, FORCE_COMPRESS) &&
		!(BTRFS_I(inode)->force_compress)) {
		BTRFS_I(inode)->flags |= BTRFS_INODE_NOCOMPRESS;
	}
...
=======

>
>>
>> My suggestion is as follows and I'll write a patch based
>> on it soon.
>>
>>   - Change the meaning of btrfs.compression == "" to mean
>>     unset both BTRFS_INODE_COMPRESS and BTRFS_INODE_NOCOMPRESS,
>>     for chattr -c.
>
> Do that and you're breaking existing semantics - existing apps or
> users might already depend on the current semantics/apis (i.e. not a
> good idea).

Yes, my suggestion will break that behavior. However I consider the
existing behavior is inconsistent and is a bug.

In the current implementation, compression property == "" has
the two different meanings: one is with BTRFS_INODE_NOCOMPRESS,
and the other is without this flag.

So, even if the two files a and b have the same compression
property, "", and the same contents, one file seems to be
compressed and the other is not. It's difficult to understand
for users and also confuses them.

Here is the real example. Let assume the following two cases.

   a) A file created freshly (under a directory without both COMPRESS and
      NOCOMPRESS flag.)

   b) A exisiting file which is explicitly set "" to compression property.

In addition, here is the command log (I attach the source of
"getflags" program in this email.)

=======
$ rm -f a b; touch a b
$ btrfs prop set b compression ""
$ btrfs prop get a compression
$ btrfs prop get b compression
$ ./getflags a
0x0
$ ./getflags b
0x400             # 0x400 (FS_NOCOMP_FL) corresponds to BTRFS_INODE_NOCOMPRESS
=======

So both those two files have their compression property == "",
but have different NOCOMPRESS flag state leading to
different behavior.

case | BTRFS_INODE_NOCOMPRESS | behavior
=====+========================+=========================
    a | unset                  | might be compressed
    b | set                    | never be compressed

I consider that we should not expect users to remember
whether their files are case a or b and should introduce
another value for compress property anyway.

getflags.c
===================
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <linux/fs.h>

int main(int argc, char const* argv[])
{
   const char *name = argv[1];
   int fd = open(name, O_RDONLY);
   long x;
   ioctl(fd, FS_IOC_GETFLAGS, &x);
   printf("0x%lx\n", x);
   return 0;
}
===================

Thanks,
Satoru

> However you can add a new value that implements those semantics.
>
>>   - Add new value of "btrfs.compression" property, for example
>>     "no" or "off", to mean unset BTRFS_INODE_COMPRESS and set
>>     BTRFS_INODE_NOCOMPRESS. It's for ioctl() with FS_NOCOMP_FL.
>>   - Unify duplicated code of changing inode flags to props.c.
>>
>> Thanks,
>> Satoru
>>
>>> +             if (ret && ret != -ENODATA)
>>> +                     goto out_drop;
>>>        }
>>>
>>>        trans = btrfs_start_transaction(root, 1);
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

