Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59019 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaJQQ0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 12:26:43 -0400
Received: by mail-lb0-f172.google.com with SMTP id b6so965284lbj.31
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 09:26:42 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <543ED6FF.1080501@fb.com>
References: <543D555B.50708@pobox.com>
	<eff13bd09ee6883785a4be3ab005886b@miceliux.com>
	<543E7ACC.8080001@fb.com>
	<f9840abeffb3a13578c3358a9e6cfec0@miceliux.com>
	<543E8510.8020000@fb.com>
	<CAGfcS_moK9JLoz=nb54iNb_LCu3rtgBkYLkHLceT8eaiLJsL9g@mail.gmail.com>
	<543ED6FF.1080501@fb.com>
Date: Fri, 17 Oct 2014 17:26:41 +0100
Message-ID: <CAL3q7H6yMp84tvmS-w5r1TexFJMayF0mxxzdZn1a_PE7nZ_kGQ@mail.gmail.com>
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Rich Freeman <r-btrfs@thefreemanclan.net>,
        Juan Orti Alcaine <juan.orti@miceliux.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 9:20 PM, Josef Bacik <jbacik@fb.com> wrote:
> On 10/15/2014 03:30 PM, Rich Freeman wrote:
>>
>> On Wed, Oct 15, 2014 at 10:30 AM, Josef Bacik <jbacik@fb.com> wrote:
>>>
>>> We've found it, the Fedora guys are reverting the bad patch now, we'll
>>> get
>>> the fix sent back to stable shortly.  Sorry about that.
>>
>>
>> After reverting this commit, can the bad snapshots be
>> deleted/repaired/etc without wiping and restoring the entire
>> filesystem?  Copying 2.3TB of data isn't a particularly fast
>> operation...
>>
>
> I would certainly like to make fsck repair this sort of problem, let me
> reproduce the corruption locally and then make fsck fix it and then you can
> use that.  Thanks,

I just sent out a patch for fsck to fix this issue - i.e. bad
read-only snapshots (inaccessible without errors, impossible to
delete, etc).
It fixes the snapshots if, and only if, you haven't run fsck in repair
mode (--repair) before, as that would touch back references and other
metadata as it didn't expect for root items to incorrect (which is
essentially what the snapshots bug made).

The patch is this one:  https://patchwork.kernel.org/patch/5098331/

Also, if you have errors accessing files through a path that doesn't
contain any of the read-only snapshots, it's possible that it's the
corruption bug we had in 3.17 - bad extent map manipulation, that
manifests itself in several ways (e.g. reports:
http://www.spinics.net/lists/linux-btrfs/msg38045.html and
http://www.spinics.net/lists/linux-btrfs/msg37567.html).

Anyway, if you run into further issues, please report them.

thanks

>
> Josef
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
