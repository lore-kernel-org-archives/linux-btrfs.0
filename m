Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35547 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456AbcBCEhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 23:37:45 -0500
Received: by mail-ig0-f172.google.com with SMTP id hb3so2821778igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Feb 2016 20:37:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
References: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
	<CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
	<CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
Date: Tue, 2 Feb 2016 21:37:44 -0700
Message-ID: <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 2, 2016 at 8:52 PM, Михаил Гаврилов
<mikhail.v.gavrilov@gmail.com> wrote:
> 2016-02-03 7:45 GMT+05:00 Chris Murphy <lists@colorremedies.com>:
>> journalctl -k > kernel-sysrqw_btrfscleaner770blocked.txt
>
>
> This I can do now or after next hang?

The sysrq+w should happen when the hang is happening. This dumps
hanged task info to kernel messages (dmesg) but can sometimes be
bigger than the default buffer, but all of it will be in journalctl -k
(as well as all kernel messages since boot which can sometimes be
useful).



-- 
Chris Murphy
