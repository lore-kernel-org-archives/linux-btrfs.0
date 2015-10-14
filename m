Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32866 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbbJNPqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 11:46:15 -0400
Received: by wiyb4 with SMTP id b4so4253125wiy.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 08:46:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <530F6025.1030208@fb.com>
References: <1390500472-15144-1-git-send-email-jbacik@fb.com>
	<CAOfOLh-AoQ=+Zvk2LRx4frFD6005gXweY+EMVnZyen5jwGGv9Q@mail.gmail.com>
	<530F6025.1030208@fb.com>
Date: Wed, 14 Oct 2015 17:46:13 +0200
Message-ID: <CAOcd+r2C0bvxk_d=qW1qk60YpK8TYQRq4KXsyGQZ_X-mAJF4YA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Josef Bacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: =?UTF-8?B?6ZKx5Yev?= <alanqk@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
Looking at the latest Linus tree, I still see:

if (actual_count > 0) {
    u64 runtime = ktime_to_ns(ktime_sub(ktime_get(), start));
    ...
    avg = fs_info->avg_delayed_ref_runtime * 3 + runtime;
   avg = div64_u64(avg, 4);

So we need to divide "runtime" by "actual_count" before accounting it
in "avg_delayed_ref_runtime"?

Thanks,
Alex.


On Thu, Feb 27, 2014 at 5:56 PM, Josef Bacik <jbacik@fb.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 02/27/2014 10:38 AM, 钱凯 wrote:
>> I'm a little confused of what "avg_delayed_ref_runtime" means.
>>
>> In __btrfs_run_delayed_refs(), "avg_delayed_ref_runtime" is set to
>> the runtime of all delayed refs processed in current transaction
>> commit. However, in btrfs_should_throttle_delayed_refs(), we based
>> on the following condition to decide whether throttle refs or not:
>> ***************************************** avg_runtime =
>> fs_info->avg_delayed_ref_runtime; if (num_entries * avg_runtime >=
>> NSEC_PER_SEC) return 1; *****************************************
>> It looks like "avg_delayed_ref_runtime" is used as runtime of each
>> delayed ref processed in average here. So what does it really
>> means?
>>
>
> Yeah I screwed this up, I should have been dividing the total time by
> the number of delayed refs I ran.  I have a patch locally to fix it
> and I'll send it out after I finish my qgroup work.  Thanks,
>
> Josef
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>
> iQIcBAEBAgAGBQJTD2AlAAoJEANb+wAKly3BQkEP/0F/LGGDsO+x63SAFh/apRZo
> ZVmzi1yJGiArFImFs8IwZHKgr/HpP9yYYFqyDCTSYrErI32bjpPbSDKlFDiIKYBq
> 6mTptPlC6AJQcMJf3oV2SqUoQxI6Ea+04QaTtZwE5pDaTZsjD47QYfSyw/i+YwOr
> Ds11ayDeU3FSj8JVYDKFg5ZBifv/mIHbh1fb8xc4R5XCWsbRzIL9LiQa9c56EEOq
> vzXp57TIetbJdliK0cYQtPkA7R40us8TqVBH5MfcZPgITyBun3e0zrGxWmW6caTs
> viejEbqDhyHLHCing+mMI6GX7w16duq5oG+w4nnjjyuMzWAyNN2pxloqQsWwOyv8
> 7+33JZCtVG/txRMIXkvc3bqzetrUyPAruo+M3pstN7B2dph6TDV0QJSFnxee6mKf
> 4/zseNOJtQqjHe5QJNcVJtkDaxgGBkSONHLm5Gz8rFU3XKcNZQcocV+0EtIjE7Zs
> D5oDYCAyrxG1VKoFWhdaS883PDokRr75jcnFui4GhhFr5OAOdS3OOTLKVizWUag1
> O11d9XsjnzLWiVTsZH+f4K0ONQcUwJFV0zADgYsXtU2LDHHNIPZX9+qSAa+L66hT
> Ki6hocoZ4cXyGWcTZPtlGHxAmV2kEh8/Tr1ePfwy7FzTrg9hWUGLXY0DliQDPmIB
> w3TdOa+Ghjl8dcaGc2rX
> =kSsY
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
