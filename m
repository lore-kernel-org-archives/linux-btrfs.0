Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34315 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaJ2EpD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 00:45:03 -0400
Received: by mail-lb0-f179.google.com with SMTP id w7so1810854lbi.10
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 21:45:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141028144030.GA27030@twin.jikos.cz>
References: <1413147716-7478-1-git-send-email-cknvme@gmail.com>
	<20141028144030.GA27030@twin.jikos.cz>
Date: Tue, 28 Oct 2014 21:45:00 -0700
Message-ID: <CAGrovxW5BgQGmNd4hkcyMLUZwX6hE0kew3ZeU7BDCpfptUewxg@mail.gmail.com>
Subject: Re: [PATCH] [PATCH]Btrfs-prog: uniform error handling for utils.c
From: royy walls <cknvme@gmail.com>
To: dsterba@suse.cz, neo <cknvme@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You are correct, I tried to put all the error handling code in separate layer,
but if there is no need to print error for each system call then it does not
make sense to integrate this path.

One of the userspace project on
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Userspace_tools_project

stats that :"show meaning of various error codes, eg. for the
incompatibility bits".

So I thought it will be useful to have uniform error handling where it
can print the error
and its cause at one place and avoid the code repetition, looks like
it was not the right
approach.

Is it possible for you to guide to implement error handling appropriately ?

I would really like to work on btrfs userspace projects.

Regards,
Chaitanya


On Tue, Oct 28, 2014 at 7:40 AM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> without any explanation I can only speculate what's the purpose of this
> patch. I can see it hides the basic syscalls to wrappers and prints
> messages in case of an error value.
>
> Currently, the error codes are mostly handled and the error messages are
> printed as needed, we don't want to see all of them or not exactly at
> the time the error happens.
>
> I don't see any reason why the indirection layer is needed, the bare
> syscalls are usually enough. More complexity can be hidden to wrappers
> like open_file_or_dir.
>
> The code that's shared with kernel should stick to the kernel naming and
> generic functions, for that there's kerncompat.h . The userspace code
> shares the CodingStyle from kernel, but obviously has to use the
> userspace API so not every function starts with btrfs_ prefix etc.
>
> d.
