Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:37109 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbbKYLvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:51:53 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1984236.SDzE0v2Uyc@localhost.localdomain>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
	<1448449386-4186-7-git-send-email-chandan@linux.vnet.ibm.com>
	<CAL3q7H5W9LcoVx9MA9dOdGaeDiNYs1scDz3orN6FGjK+3Pgwog@mail.gmail.com>
	<1984236.SDzE0v2Uyc@localhost.localdomain>
Date: Wed, 25 Nov 2015 11:51:52 +0000
Message-ID: <CAL3q7H4U_b_OkpA4_5MU3DMdP1LPjxNYmFXCVU0j9Zi86c2szg@mail.gmail.com>
Subject: Re: [PATCH 06/12] Fix btrfs/094 to work on non-4k block sized filesystems
From: Filipe Manana <fdmanana@gmail.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        chandan@mykolab.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 25, 2015 at 11:47 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Wednesday 25 Nov 2015 11:11:27 Filipe Manana wrote:
>>
>> Hi Chandan,
>>
>> I can't agree with this change. We're no longer checking that file
>> data is correct after the cloning operations. The md5sum checks were
>> exactly for that. So essentially the test is only verifying the clone
>> operations don't fail with errors, it no longer checks for data
>> corruption...
>>
>> Same comment applies to at least a few other patches in the series.
>
> Hello Filipe,
>
> All the tests where we had md5sum being echoed into output have been replaced
> with code to verify the md5sum values as shown below,
>
>         if [ $foo_orig_hash != $foo_hash ]; then
>                 echo "Read operation failed on $SCRATCH_MNT/foo: "\
>                      "Mimatching hash values detected."
>         fi
>
> This will cause a diff between the test's ideal output versus the output
> obtained during the test run.

Right, it compares the digests before and after some operation (which
should always match). However we no longer validate that the file
content is correct before the operation. For some of the tests that is
more important, like the ones that test read corruption after cloning
compressed extents.

>
> In case of btrfs/094, I have added an associative array to hold the md5sums
> and
> the file content verification is being performed by the following code,
>
> for key in "${!src_fs_hash[@]}"; do
>         if [ ${src_fs_hash[$key]} != ${dst_fs_hash[$key]} ]; then
>                 echo "Mimatching hash value detected against \
> $(echo $key | tr _ /)"
>         fi
> done
>
> --
> chandan
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
