Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50508 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab2JDTk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2012 15:40:28 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so874257obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Oct 2012 12:40:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506D9BC2.1050508@oracle.com>
References: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com>
	<1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
	<CAKcLGm_4iUB1B8DPOx1D7i8eMa7po9fWFUYVOqp1N9nmZ1ExHQ@mail.gmail.com>
	<50625569.9040102@oracle.com>
	<20121003140259.GA4458@shiny>
	<506D9BC2.1050508@oracle.com>
Date: Thu, 4 Oct 2012 14:40:28 -0500
Message-ID: <CAKcLGm-xxf4UahskmssDCPVYunEKJWz4EgVY8E1pR1_mUxpbiw@mail.gmail.com>
Subject: Re: [PATCH 2/2 v3] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 4, 2012 at 9:22 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On 10/03/2012 10:02 PM, Chris Mason wrote:
>> On Tue, Sep 25, 2012 at 07:07:53PM -0600, Liu Bo wrote:
>>> On 09/26/2012 01:39 AM, Mitch Harder wrote:
>>>> On Mon, Sep 17, 2012 at 4:58 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>>>> This comes from one of btrfs's project ideas,
>>>>> As we defragment files, we break any sharing from other snapshots.
>>>>> The balancing code will preserve the sharing, and defrag needs to grow this
>>>>> as well.
>>>>>
>>>>> Now we're able to fill the blank with this patch, in which we make full use of
>>>>> backref walking stuff.
>>>>>
>>>>> Here is the basic idea,
>>>>> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
>>>>> o  at endio, after we finish updating fs tree, we use backref walking to find
>>>>>    all parents of the ranges and re-link them with the new COWed file layout by
>>>>>    adding corresponding backrefs.
>>>>>
>>>>> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
>>>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>>>
>>>> I'm hitting the WARN_ON in record_extent_backrefs() indicating a
>>>> problem with the return value from iterate_inodes_from_logical().
>>
>> Me too.  It triggers reliably with mount -o autodefrag, and then crashes
>> a in the next function ;)
>>
>> -chris
>>
>
> Good news, I'm starting hitting the crash (a NULL pointer crash) ;)
>
> thanks,
> liubo

I'm also starting to hit this crash while balancing a test partition.

I guess this isn't surprising since both autodefrag and balancing make
use of relocation.
