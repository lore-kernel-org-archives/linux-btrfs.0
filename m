From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 2/2] xfstests: meet btrfs fs size requirement in _scratch_mkfs_sized()
Date: Fri, 04 Nov 2011 09:21:32 +0100
Message-ID: <4EB3A08C.7010803@giantdisaster.de>
References: <1320374284-1534-1-git-send-email-guaneryu@gmail.com> <1320374284-1534-2-git-send-email-guaneryu@gmail.com> <20111104053908.GB16720@infradead.org> <CA+dCu89OZxLx9wCS8511mkRi-uMUDnHFcJQ7yVfR+EL99avcBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	linux-btrfs@vger.kernel.org
To: guaneryu@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+dCu89OZxLx9wCS8511mkRi-uMUDnHFcJQ7yVfR+EL99avcBw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/4/2011 7:06 AM, Eryu Guan wrote:
> On Fri, Nov 4, 2011 at 1:39 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Fri, Nov 04, 2011 at 10:38:04AM +0800, Eryu Guan wrote:
>>> btrfs requires at least 256M file system size, so check 'fssize' in
>>> _scratch_mkfs_sized first and give it a proper value. Otherwise
>>> mkfs.btrfs will complain something like
>>>
>>> "File system size 267386880 bytes is too small, 256M is required at least"

Commit bd7d6d45 from Zhong, Xin <xin.zhong@intel.com> with date
6/21/2011 removed the 256MB size limitation in mkfs.c in btrfs-progs.


>>>
>>> This makes 015 077 and 083 run on btrfs.
>>
>> But it's not really going to test the ENOSPC conditions it was designed
>> to exercise.  It would be better to either find a way to make btrfs run on
>> smaller filesystem, or call _notrun for too small filesystems on btrfs
>> from _scratch_mkfs_sized.
> 
> Yes, you're right. I checked 015 (it would dd zero to btrfs to full) but forgot
> to check 077 and 083.
> 
> I'll try to find a better way. Thanks for reviewing!
> 
> Eryu Guan
>>
>>>
>>> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>>> ---
>>>  common.rc |    5 +++++
>>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/common.rc b/common.rc
>>> index e948169..ab61786 100644
>>> --- a/common.rc
>>> +++ b/common.rc
>>> @@ -356,6 +356,11 @@ _scratch_mkfs_sized()
>>>       /sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
>>>       ;;
>>>      btrfs)
>>> +    # btrfs needs at least 256M file system size
>>> +     if [ $fssize -lt $((256*1024*1024)) ]
>>> +     then
>>> +             fssize=$((256*1024*1024))
>>> +     fi
>>>       $MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
>>>       ;;
>>>      *)
>>> --
>>> 1.7.7.1
