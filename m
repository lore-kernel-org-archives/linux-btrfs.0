Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:34846 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbbEHWHN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 May 2015 18:07:13 -0400
Received: by ykec202 with SMTP id c202so23967418yke.2
        for <linux-btrfs@vger.kernel.org>; Fri, 08 May 2015 15:07:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D7C742B6-7DD3-49F3-B49A-4C8FD5B97527@plack.net>
References: <C42E48E9-4DA9-442D-8FAC-B1982EA5DF4B@plack.net>
 <4B045A3B-60E2-4151-86E7-029E79585886@plack.net> <60DA4BA3-C4FE-4A61-9D5C-399122FA2B96@plack.net>
 <EAC2F414-3D41-4458-9AF4-8533B1925C96@plack.net> <pan$ef76f$1decf414$ca28dae0$217ae55f@cox.net>
 <D7C742B6-7DD3-49F3-B49A-4C8FD5B97527@plack.net>
From: Noah Massey <noah.massey@gmail.com>
Date: Fri, 8 May 2015 18:06:31 -0400
Message-ID: <CADfjVrh9_-0OMxFjfOS4WP2Z6jLfs6RDEvGm7Y_fZOQXi2Kd9Q@mail.gmail.com>
Subject: Re: Kernel Dump scanning directory
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 8, 2015 at 5:37 PM, Anthony Plack <tmy@plack.net> wrote:
>
>> On May 8, 2015, at 3:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> And then I wasn't quite so concerned either about losing something
>> critical in the log, or the safety of simply blowing it away, since by
>> design, the log only deals with what hasn't been committed yet, and the
>> commits are themselves designed to be atomic and leave the filesystem in
>> a known good state.
>>
>
> Duncan,
> Thank you for joining me in my monolog here.
>
> 30 seconds on a server can be allot of data, and is to small of a time span for adequate backups to occur.  What you say makes sense, however, without this fixed going forward, BTRFS can never become a serious data storage file system.
>

Standard disclaimer: not a dev, just a user.
I believe the email Duncan referred to was
http://www.spinics.net/lists/linux-btrfs/msg43407.html
and my understanding was slightly different than his summary.
If I understood correctly, by the time an fsync returns success, the
BTRFS log will contain all the data needed to comply with the fsync
guarantee ("This data has been safely written to media").
If the system goes down before the next full transaction commit
(default 30 seconds), then on next rw mount, BTRFS will replay log.
The resulting filesystem state is the state of last transaction +
fsynced data.

In the event of log corruption, BTRFS may experience failures replaying the log.
In this case, you can zero the log: then the filesystem state becomes
the last transaction, without the last 30 seconds.
Normal operation should not result in a corrupt log, since the log is
it's own COW tree and is coherently on media before fsync returns.
