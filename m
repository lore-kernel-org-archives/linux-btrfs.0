Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34765 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbbJ1Ngn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 09:36:43 -0400
Received: by vkgs66 with SMTP id s66so4800508vkg.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 06:36:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151027113435.GA837@ret.edimax.com>
References: <1444702827-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1444702827-18169-7-git-send-email-quwenruo@cn.fujitsu.com>
	<CAL3q7H7mvHDYESXYHVYxJC7Yr+yXbvmajaRkWO7nu6iZBOYmSQ@mail.gmail.com>
	<562EF9D7.50101@cn.fujitsu.com>
	<20151027051403.GA23134@ret.thefacebook.com>
	<562F1032.7040103@cn.fujitsu.com>
	<20151027061203.GA25844@ret.thefacebook.com>
	<562F3E74.4040205@cn.fujitsu.com>
	<20151027113435.GA837@ret.edimax.com>
Date: Wed, 28 Oct 2015 14:36:42 +0100
Message-ID: <CAHji150-Drdan5GoF4g7Rp0vka1q7k+aTYJ7iD52ieE36LGLSQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/21] btrfs: delayed_ref: Add new function to record
 reserved space into delayed ref
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        fdmanana@gmail.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 27, 2015 at 12:34 PM, Chris Mason <clm@fb.com> wrote:
> On Tue, Oct 27, 2015 at 05:05:56PM +0800, Qu Wenruo wrote:
>>
>>
>> Chris Mason wrote on 2015/10/27 02:12 -0400:
>> >On Tue, Oct 27, 2015 at 01:48:34PM +0800, Qu Wenruo wrote:
>> >>>>Are you testing integration-4.4 from Chris repo?
>> >>>>Or 4.3-rc from mainline repo with my qgroup reserve patchset applied?
>> >>>>
>> >>>>Although integration-4.4 already merged qgroup reserve patchset, but it's
>> >>>>causing some strange bug like over decrease data sinfo->bytes_may_use,
>> >>>>mainly in generic/127 testcase.
>> >>>>
>> >>>>But if qgroup reserve patchset is rebased to integration-4.3 (I did all my
>> >>>>old tests based on that), no generic/127 problem at all.
>> >>>
>> >>>Did I mismerge things?
>> >>>
>> >>>-chris
>> >>>
>> >>Not sure yet.
>> >>
>> >>But at least some patches in 4.3 is not in integration-4.4, like the
>> >>following patch:
>> >>btrfs: Avoid truncate tailing page if fallocate range doesn't exceed inode
>> >>size
>> >
>> >Have you tried testing integration-4.4 merged with current Linus git?

Chris, something went definitely wrong with the 4.4-integration
branch, and it's not the point where you merged from Josef. Mainline
has: 0f6925fa2907df58496cabc33fa4677c635e2223 ("btrfs: Avoid truncate
tailing page if fallocate range doesn't exceed inode size"), and that
commit just doesn't exist in 4.4-integration any more. Neither did any
merges touch file.c, so it
seems this just got lost for some reason (rebase? forced push?).
It's difficult to say what else might have gone missing.

-h
