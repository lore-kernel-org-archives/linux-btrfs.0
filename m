Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:32884 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbbLITjC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 14:39:02 -0500
Received: by mail-ig0-f177.google.com with SMTP id mv3so347444igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 11:39:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1449682081.7150.0.camel@dhampton.net>
References: <1449637341.20669.0.camel@love2code.net>
	<CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
	<1449642609.20669.7.camel@love2code.net>
	<pan$2b447$368e596$ba3d70ae$2f6cd5d4@cox.net>
	<1449682081.7150.0.camel@dhampton.net>
Date: Wed, 9 Dec 2015 12:39:01 -0700
Message-ID: <CAJCQCtSuEQRVsrLim9AD3di7Rxv2xA9FOd872pNXs-CRiFZpcw@mail.gmail.com>
Subject: Re: Missing half of available space (resend)
From: Chris Murphy <lists@colorremedies.com>
To: David Hampton <mailinglists@dhampton.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 9, 2015 at 10:28 AM, David Hampton
<mailinglists@dhampton.net> wrote:
> On Wed, 2015-12-09 at 16:48 +0000, Duncan wrote:
>> David Hampton posted on Wed, 09 Dec 2015 01:30:09 -0500 as excerpted:
>>
>> > Seems I need to upgrade my tools.  That command was added in 3.18 and I
>> > only have the 3.12 tools.
>>
>> Definitely so, especially because you're running raid6, which wasn't
>> stable until 4.1 for both kernel and userspace.  3.12?  I guess it did
>> have the very basic raid56 support, but it's definitely nothing I'd
>> trust, at that old not for btrfs in general, but FOR SURE not raid56.
>
> I've upgraded to the 4.2.0 kernel and the 4.0 btrfs-tools package.

I think btrfs-progs 4.0 has a mkfs bug in it (or was that 4.0.1?)
Anyway, even that is still old in Btrfs terms. I think Ubuntu needs to
do better than this, or just acknowledge Btrfs is not supported, don't
include btrfs-progs at all by default, and stop making it an install
time option.


> These are the latest that Ubuntu has packaged for 15.10, and I've pulled
> them into my 14.10 based release.  Is this recent enough, or do I need
> to try the 4.3 kernel/tools build from the active development tree (that
> will eventually become 16.04)?

It's probably fine day to day, but if you ever were to need btrfs
check or repair, you'd want the current version no matter what. There
are just too many bug fixes and enhancements happening to not make
that effort. You kinda have to understand that you're effectively
testing Btrfs by using raid56. It is stabilizing, but it can hardly be
called stable or even feature complete seeing as there are all sorts
of missing failure notifications.

More than anything else you need to be willing to lose everything on
this volume, without further notice, i.e. you need a backup strategy
that you're prepared to use without undue stress. If you can't do
that, you need to look at another arrangement. Both LVM and mdadm
raid6 + XFS are more stable.


-- 
Chris Murphy
