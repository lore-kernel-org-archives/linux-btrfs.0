Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46020 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3HADyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 23:54:09 -0400
Received: by mail-oa0-f52.google.com with SMTP id n12so3284151oag.11
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 20:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG_LFoDKiTAPApEPfuhrruvH=oUxW4VP+dFsdnWJpN=CYDBS8A@mail.gmail.com>
References: <CAG_LFoDN2bsvfyE_FY9yvyFMLDeUDpB6FkaSy81PU02dvfAdKw@mail.gmail.com>
	<20130730020705.GA32721@localhost.localdomain>
	<CAG_LFoDKiTAPApEPfuhrruvH=oUxW4VP+dFsdnWJpN=CYDBS8A@mail.gmail.com>
Date: Thu, 1 Aug 2013 09:24:08 +0530
Message-ID: <CAG_LFoBL+tH-9OE-h45_C_AVubstFTDwTf0bgUbRPW9EhSj3Kg@mail.gmail.com>
Subject: Fwd: Online data deduplication
From: Hemanth Kumar <hemanthkumar51@gmail.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I tried to apply deduplication patch on to 3.11-rc2 kernel but i am
getting the following error. Can you pls thake a look at it and let me
know whats wrong.

linux-3805:/home/hemanth/linux-3.11-rc2 # patch -p1 <
/home/hemanth/RFC-V4-1-2-Btrfs-skip-merge-part-for-delayed-data-refs.patch
patching file fs/btrfs/delayed-ref.c
linux-3805:/home/hemanth/linux-3.11-rc2 # patch -p1 <
/home/hemanth/RFC-V4-2-2-Btrfs-online-data-deduplication.patch
patching file fs/btrfs/ctree.h
Hunk #2 succeeded at 95 with fuzz 2.
Hunk #7 succeeded at 1328 (offset 12 lines).
Hunk #8 succeeded at 1669 (offset 15 lines).
Hunk #9 succeeded at 1971 (offset 40 lines).
Hunk #10 succeeded at 2008 (offset 40 lines).
Hunk #11 succeeded at 2944 (offset 40 lines).
Hunk #12 succeeded at 3421 with fuzz 1 (offset 59 lines).
Hunk #13 succeeded at 3586 (offset 59 lines).
patching file fs/btrfs/disk-io.c
Hunk #1 succeeded at 1581 with fuzz 2 (offset 39 lines).
Hunk #2 FAILED at 1997.
Hunk #3 FAILED at 2010.
Hunk #4 succeeded at 2101 (offset 26 lines).
Hunk #5 FAILED at 2088.
Hunk #6 succeeded at 2189 with fuzz 1 (offset 20 lines).
Hunk #7 succeeded at 2288 (offset 19 lines).
Hunk #8 succeeded at 2464 (offset 20 lines).
Hunk #9 FAILED at 2669.
4 out of 9 hunks FAILED -- saving rejects to file fs/btrfs/disk-io.c.rej
patching file fs/btrfs/extent-tree.c
Hunk #1 succeeded at 2219 (offset -3 lines).
Hunk #2 succeeded at 4653 with fuzz 2 (offset 88 lines).
Hunk #3 succeeded at 5806 (offset 189 lines).
patching file fs/btrfs/extent_io.c
Hunk #1 succeeded at 1259 (offset 43 lines).
Hunk #2 succeeded at 1718 (offset 43 lines).
Hunk #3 succeeded at 2429 (offset 21 lines).
Hunk #4 succeeded at 2634 with fuzz 2 (offset 47 lines).
Hunk #5 succeeded at 2674 (offset 47 lines).
Hunk #6 succeeded at 3736 (offset 46 lines).
patching file fs/btrfs/extent_io.h
Hunk #1 FAILED at 19.
Hunk #2 succeeded at 52 (offset 1 line).
Hunk #3 succeeded at 226 (offset 1 line).
Hunk #4 succeeded at 353 (offset 3 lines).
1 out of 4 hunks FAILED -- saving rejects to file fs/btrfs/extent_io.h.rej
patching file fs/btrfs/file-item.c
Hunk #1 succeeded at 858 (offset -34 lines).
patching file fs/btrfs/inode.c
Hunk #1 succeeded at 105 (offset 3 lines).
Hunk #2 succeeded at 296 (offset 3 lines).
Hunk #3 succeeded at 314 (offset 3 lines).
Hunk #4 succeeded at 369 (offset 3 lines).
Hunk #5 succeeded at 438 (offset 3 lines).
Hunk #6 succeeded at 575 (offset 3 lines).
Hunk #7 succeeded at 603 (offset 3 lines).
Hunk #8 succeeded at 671 (offset 3 lines).
Hunk #9 succeeded at 772 (offset 7 lines).
Hunk #10 succeeded at 797 (offset 7 lines).
Hunk #11 succeeded at 818 (offset 7 lines).
Hunk #12 succeeded at 1214 (offset 7 lines).
Hunk #13 succeeded at 1316 (offset 7 lines).
Hunk #14 succeeded at 1406 (offset 7 lines).
Hunk #15 succeeded at 1799 (offset 7 lines).
Hunk #16 succeeded at 1875 (offset 7 lines).
Hunk #17 succeeded at 1903 (offset 7 lines).
Hunk #18 succeeded at 1925 (offset 7 lines).
Hunk #19 succeeded at 2360 (offset 32 lines).
Hunk #20 succeeded at 2423 (offset 32 lines).
Hunk #21 succeeded at 3182 (offset 27 lines).
patching file fs/btrfs/ioctl.c
Hunk #1 succeeded at 4097 (offset 23 lines).
Hunk #2 succeeded at 4298 (offset 25 lines).
patching file fs/btrfs/ordered-data.c
Hunk #1 succeeded at 183 with fuzz 2 (offset 1 line).
Hunk #2 succeeded at 204 (offset 2 lines).
Hunk #3 succeeded at 264 (offset 10 lines).
Hunk #4 succeeded at 281 (offset 10 lines).
Hunk #5 succeeded at 526 (offset 10 lines).
patching file fs/btrfs/ordered-data.h
Hunk #1 succeeded at 102 (offset -12 lines).
Hunk #2 succeeded at 131 (offset -12 lines).
Hunk #3 succeeded at 167 (offset -15 lines).
patching file fs/btrfs/super.c
Hunk #1 succeeded at 320 (offset 2 lines).
Hunk #2 succeeded at 362 (offset 2 lines).
Hunk #3 succeeded at 629 (offset 2 lines).
Hunk #4 succeeded at 964 (offset -1 lines).
patching file include/uapi/linux/btrfs.h
Hunk #2 FAILED at 542.
1 out of 2 hunks FAILED -- saving rejects to file include/uapi/linux/btrfs.h.rej


On Tue, Jul 30, 2013 at 7:37 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Mon, Jul 29, 2013 at 09:05:42PM +0530, Hemanth Kumar wrote:
>> Hello,
>> I am willing to perform QA on online data deduplication. From where
>> can i download the patches?
>
> Hi Hemanth Kumar H C,
>
> I really appreciate this :)
>
> Right now I'm planning v5 version patch set, which will come out probably in
> this week(Only one bug is left on my hands)
>
> v5 version will have a big change on disk format, performance, btw.
>
> For v4 you can find it in the following url:
> https://patchwork.kernel.org/patch/2565601/
> https://patchwork.kernel.org/patch/2565591/
>
> thanks,
> -liubo



--
Thanks,
Hemanth Kumar H C
