Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33010 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642AbcBCCpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 21:45:46 -0500
Received: by mail-io0-f173.google.com with SMTP id f81so40441561iof.0
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Feb 2016 18:45:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
References: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
Date: Tue, 2 Feb 2016 19:45:45 -0700
Message-ID: <CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 2, 2016 at 1:20 PM, Михаил Гаврилов
<mikhail.v.gavrilov@gmail.com> wrote:
> Hi all! I have problem with hanging btrfs file system.


Can you list the workload at the time, and also the mount options? To
do sysrq+w as Liu Bo asks for, do this:

echo 1 > /proc/sys/kernel/sysrq
echo w > /proc/sysrq-trigger

And then 'journalctl -k > kernel-sysrqw_btrfscleaner770blocked.txt'
See if that will attach to the list, and if it's too big and bounces,
put it up somewhere and post the URL.

-- 
Chris Murphy
