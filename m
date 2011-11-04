From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] xfstests: meet btrfs fs size requirement in _scratch_mkfs_sized()
Date: Fri, 4 Nov 2011 14:06:51 +0800
Message-ID: <CA+dCu89OZxLx9wCS8511mkRi-uMUDnHFcJQ7yVfR+EL99avcBw@mail.gmail.com>
References: <1320374284-1534-1-git-send-email-guaneryu@gmail.com>
 <1320374284-1534-2-git-send-email-guaneryu@gmail.com> <20111104053908.GB16720@infradead.org>
Reply-To: guaneryu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111104053908.GB16720@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 4, 2011 at 1:39 PM, Christoph Hellwig <hch@infradead.org> w=
rote:
> On Fri, Nov 04, 2011 at 10:38:04AM +0800, Eryu Guan wrote:
>> btrfs requires at least 256M file system size, so check 'fssize' in
>> _scratch_mkfs_sized first and give it a proper value. Otherwise
>> mkfs.btrfs will complain something like
>>
>> "File system size 267386880 bytes is too small, 256M is required at =
least"
>>
>> This makes 015 077 and 083 run on btrfs.
>
> But it's not really going to test the ENOSPC conditions it was design=
ed
> to exercise. =A0It would be better to either find a way to make btrfs=
 run on
> smaller filesystem, or call _notrun for too small filesystems on btrf=
s
> from _scratch_mkfs_sized.

Yes, you're right. I checked 015 (it would dd zero to btrfs to full) bu=
t forgot
to check 077 and 083.

I'll try to find a better way. Thanks for reviewing!

Eryu Guan
>
>>
>> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>> ---
>> =A0common.rc | =A0 =A05 +++++
>> =A01 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/common.rc b/common.rc
>> index e948169..ab61786 100644
>> --- a/common.rc
>> +++ b/common.rc
>> @@ -356,6 +356,11 @@ _scratch_mkfs_sized()
>> =A0 =A0 =A0 /sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_D=
EV $blocks
>> =A0 =A0 =A0 ;;
>> =A0 =A0 =A0btrfs)
>> + =A0 =A0# btrfs needs at least 256M file system size
>> + =A0 =A0 if [ $fssize -lt $((256*1024*1024)) ]
>> + =A0 =A0 then
>> + =A0 =A0 =A0 =A0 =A0 =A0 fssize=3D$((256*1024*1024))
>> + =A0 =A0 fi
>> =A0 =A0 =A0 $MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
>> =A0 =A0 =A0 ;;
>> =A0 =A0 =A0*)
>> --
>> 1.7.7.1
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
