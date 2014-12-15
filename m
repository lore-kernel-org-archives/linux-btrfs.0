Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:39878 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaLOJnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 04:43:05 -0500
Received: by mail-la0-f45.google.com with SMTP id gq15so9188943lab.18
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Dec 2014 01:43:04 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <548EAC72.9030006@cn.fujitsu.com>
References: <1418615699-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
	<CAL3q7H4S6UDMwZb5oX0c=cpa4=ryDdJLwRE7me5aBBVY9ercvg@mail.gmail.com>
	<548EAC72.9030006@cn.fujitsu.com>
Date: Mon, 15 Dec 2014 09:43:03 +0000
Message-ID: <CAL3q7H7sNTY8b2mzyxe-vOu=viNY=z=fxAFgMu+o_5+O2CJ0QQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
 script fsck test case.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 15, 2014 at 9:40 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
> -------- Original Message --------
> Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
> script fsck test case.
> From: Filipe David Manana <fdmanana@gmail.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年12月15日 17:00
>>
>> On Mon, Dec 15, 2014 at 3:54 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>> Although btrfsck test case support pure image dump(tar.xz), it is still
>>> too large for some images, e.g, a small 64M image with about 3 levels
>>> (level 0~2) metadata will produce about 2.6M after xz zip, which is too
>>> large for a single binary commit.
>>>
>>> However btrfs-image -c9 will works much finer, the above image with
>>> btrfs-image dump will only be less than 200K, which is quite reasonable.
>>>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>>   tests/fsck-tests.sh | 34 ++++++++++++++++++++++++++++++++--
>>>   1 file changed, 32 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
>>> index 8987d04..007e5b0 100644
>>> --- a/tests/fsck-tests.sh
>>> +++ b/tests/fsck-tests.sh
>>> @@ -22,16 +22,38 @@ run_check()
>>>          "$@" >> $RESULT 2>&1 || _fail "failed: $@"
>>>   }
>>>
>>> +# For complicated fsck repair case,
>>> +# where even repairing is OK, it may still report problem before or
>>> after
>>> +# reparing since the repair needs several loops to repair all the
>>> problems
>>> +# but report checks it before all repair loops done
>>> +run_check_no_fail()
>>> +{
>>> +       echo "############### $@" >> $RESULT 2>&1
>>> +       "$@" >> $RESULT 2>&1
>>> +}
>>
>> I'm confused with this function, why it's needed and the respective
>> comment.
>> So I can interpret it as either:
>>
>> 1) The several loops means fsck --repair does multiple passages
>> internally to fix some issues?
>>   If this is the case, we (user or script) only need to call fsck
>> --repair once, which should exit with status 0 if it was able to fix
>> all the issues, right? If so, then we should check that fsck --repair
>> exits with status 0, removing the need for this new function.
>
> Sorry for the poor explain.
>
> The problem is, there is some check cases before we doing repair and these
> check result is bad so
> btrfsck thinks there is err even it will be repaired later.
>
> So The result is, especially on corrupted-leaf case, btrfsck --repair will
> fix all the problems but
> still return 1, and the next btrfsck without --repair will return 0.

That seems wrong to me. If --repair was able to fix all problems it
should exit with status 0.
If a script is running fsck --repair it would incorrectly assume
--repair failed.

>
> I think there are still  a lot of other cases causing things like
> this(multiple different errors combines together)
> so just discard the return value of btrfsck --repair and focus on the second
> btrfsck return value.
>
> Thanks,
> Qu
>
>>
>> 2) The several loops means a user or script must call fsck --repair
>> multiple times to fix all the issues? If this is the case then you're
>> only calling this function once, for a single fsck --repair, in the
>> code below, which confuses me and it makes this new function redundant
>> too.
>>
>> Thanks
>>
>>> +
>>>   rm -f $RESULT
>>>
>>>   # test rely on corrupting blocks tool
>>>   run_check make btrfs-corrupt-block
>>>
>>> +# Supported test image formats:
>>> +# 1) btrfs-image dump(.img files)
>>>   # Some broken filesystem images are kept as .img files, created by the
>>> tool
>>> -# btrfs-image, and others are kept as .tar.xz files that contain raw
>>> filesystem
>>> +# btrfs-image
>>> +#
>>> +# 2) binary image dump only(only test.img in .tar.xz)
>>> +# Some are kept as .tar.xz files that contain raw filesystem
>>>   # image (the backing file of a loop device, as a sparse file). The
>>> reason for
>>>   # keeping some as tarballs of raw images is that for these cases
>>> btrfs-image
>>>   # isn't able to preserve all the (bad) filesystem structure for some
>>> reason.
>>> +# This provides great flexibility at the cost of large file size.
>>> +#
>>> +# 3) script generated dump(generate_image.sh + needed things in .tar.gz)
>>> +# The image is generated by the generate_image.sh script alone the
>>> needed
>>> +# files in the tarball, normally a quite small btrfs-image dump.
>>> +# This one combines the advatange of relative small btrfs-image and the
>>> +# flexibility to support corrupted image.
>>>   for i in $(find $here/tests/fsck-tests -name '*.img' -o -name
>>> '*.tar.xz' | sort)
>>>   do
>>>          echo "     [TEST]    $(basename $i)"
>>> @@ -39,16 +61,24 @@ do
>>>
>>>          extension=${i#*.}
>>>
>>> +       if [ -f generate_image.sh ]; then
>>> +               rm generate_image.sh
>>> +       fi
>>> +
>>>          if [ $extension == "img" ]; then
>>>                  run_check $here/btrfs-image -r $i test.img
>>>          else
>>>                  run_check tar xJf $i
>>>          fi
>>>
>>> +       if [ -x generate_image.sh ]; then
>>> +               ./generate_image.sh
>>> +       fi
>>> +
>>>          $here/btrfsck test.img >> $RESULT 2>&1
>>>          [ $? -eq 0 ] && _fail "btrfsck should have detected corruption"
>>>
>>> -       run_check $here/btrfsck --repair test.img
>>> +       run_check_no_fail $here/btrfsck --repair test.img
>>>          run_check $here/btrfsck test.img
>>>   done
>>>
>>> --
>>> 2.1.3
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
