Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36593 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbcDRUed (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 16:34:33 -0400
Received: by mail-wm0-f51.google.com with SMTP id v188so136154204wme.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 13:34:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <571502B4.2050401@gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<5714D39B.90402@gmail.com>
	<CAJCQCtRQ_1-peN6QVd53P63xQUqxfvmth4aEbwXrpaCyjVds=Q@mail.gmail.com>
	<5714FA2F.6010207@gmail.com>
	<CAJCQCtTSdnD+n9UR7hWtqLdBzjb6WQXF71XKTgKJNgZPcdA3fg@mail.gmail.com>
	<571502B4.2050401@gmail.com>
Date: Mon, 18 Apr 2016 16:34:31 -0400
Message-ID: <CAD=QJKjhYoMOKkB1GA5EWONHifeBUpVH9-WgL9R_PozS+o+PLw@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18 April 2016 at 11:52, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> On 2016-04-18 11:39, Chris Murphy wrote:
>>
>> On Mon, Apr 18, 2016 at 9:15 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
> Like I said in one of my earlier e-mails though, these kind of limitations
> are part of why I switched to Gentoo, there's no GUI installer, but you can
> put the system together however the hell you want (which is especially nice
> with BTRFS, because none of the installers out there will let you use BTRFS
> on top of LVM, which is useful for things like BTRFS raid1 on top of
> DM-RAID0).

Limitations?  ;-)  Debian has a variety of bootstrapping methods,
though I forget if they're more analogous to starting a Gentoo
installation from stage2 or stage3...I haven't used Gentoo since 2002.
Please consult the following doc for one of the methods:
https://www.debian.org/releases/stable/amd64/apds03.html.en

Best regards,
Nicholas
