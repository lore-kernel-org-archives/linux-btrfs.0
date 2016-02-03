Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37801 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbcBCEsG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 23:48:06 -0500
Received: by mail-ig0-f175.google.com with SMTP id 5so28067827igt.0
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Feb 2016 20:48:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
References: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
	<CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
	<CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
	<CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
Date: Tue, 2 Feb 2016 21:48:05 -0700
Message-ID: <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
To: bo.li.liu@oracle.com
Cc: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mike: From your attachment, looks like you rebooted. So do this:

echo 1 > /proc/sys/kernel/sysrq
Reproduce the problem where you get blocked task messages in dmesg
echo w > /proc/sysrq-trigger
journalctl -k > kernel-sysrqw-btrfscleaner770blocked-2.txt


Make sure you use the same mount options. Looks like you're using
autodefrag, and inode_cache. Are there others? And can you say what
the workload is? Especially because inode_cache is not a default mount
option and isn't recommended except for certain workloads, but still I
think it shouldn't hang. But that's a question for Liu Bo.


Chris Murphy
