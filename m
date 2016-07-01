Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:35810 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbcGAUqc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jul 2016 16:46:32 -0400
Received: by mail-vk0-f49.google.com with SMTP id u68so125157805vkf.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jul 2016 13:46:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5776CF08.5040601@mail.ru>
References: <5776CF08.5040601@mail.ru>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 1 Jul 2016 22:46:31 +0200
Message-ID: <CAPmG0jaDczRh3wLULW17pNSxKHnCPY0A3UxchsDy5C=xHH8XCQ@mail.gmail.com>
Subject: Re: btrfs defrag questions
To: Dmitry Katsubo <dma_k@mail.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(email ends up in gmail spamfolder)
On Fri, Jul 1, 2016 at 10:14 PM, Dmitry Katsubo <dma_k@mail.ru> wrote:
> Hello everyone,
>
> Question #1:
>
> While doing defrag I got the following message:
>
> # btrfs fi defrag -r /home
> ERROR: defrag failed on /home/user/.dropbox-dist/dropbox: Success
> total 1 failures
>
> I feel that something went wrong, but the message is a bit misleading.
>
> Provided that Dropbox is running in the system, does it mean that it
> cannot be defagmented?

I think it is a matter of newlines in btrfs-progs and/or stdout/stderr mixup.

You should run the command with -v and probably also with -f, so that
it gets hopefully clearer what is wrong.

That it fails on dropbox is an error I think, but maybe known: Could
be mount option is compress and that that causes trouble for defrag
although that should not happen.

You can defrag just 1 file, so maybe you could try to make a reproducible case.
What kernel?
What btrfs-progs?


> Question #2:
>
> Suppose that in above example /home/ftp is mounted as another btrfs
> array (not subvolume). Will 'btrfs fi defrag -r /home' defragment it
> (recursively) as well?

I dont know, I dont think so, but you can simply try.
