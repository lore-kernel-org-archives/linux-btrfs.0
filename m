Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34995 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbcBFVfY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Feb 2016 16:35:24 -0500
Received: by mail-io0-f174.google.com with SMTP id d63so162435112ioj.2
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Feb 2016 13:35:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B412FC.8060007@oracle.com>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
	<56B412FC.8060007@oracle.com>
Date: Sat, 6 Feb 2016 14:35:23 -0700
Message-ID: <CAJCQCtSKxYNhJVfixWbM8mgcGF4XL=TtEuZ6=Dx_n2F+HRWUMw@mail.gmail.com>
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
From: Chris Murphy <lists@colorremedies.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Moviuro <moviuro@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 4, 2016 at 8:11 PM, Anand Jain <anand.jain@oracle.com> wrote:
>
>
>  If you look critically we have been using UI/CLI as API,
>  IMO these two class of interfaces be distinct clearly.
>
>  Btrfs needs library functions/APIs which is callable in
>  popular scripting language like python.

I'm not sure what this is using to get btrfs info, it's written in c.
https://github.com/storaged-project/storaged/tree/master/modules/btrfs

This is python and has a btrfs backed that depends on user space
tools, the comments pretty clearly express the challenges with using
user space tools as a primary means to interface with Btrfs volumes.
http://sourceforge.net/p/storagemanager/code/ci/devel/tree/ssmlib/backends/btrfs.py

Red Hat's installer, Anaconda, has split out its storage configuration
module into python-blivet to enable a bunch of storage work to be done
in Python, including a lot of Btrfs functionality. Some of this just
got too complicated I guess for blivet, and has been split out into
libblockdev, which includes plugin apis, and there happens to be one
for Btrfs. But I have no idea where it goes from there.
https://github.com/rhinstaller/libblockdev
https://github.com/rhinstaller/libblockdev/blob/master/src/lib/plugin_apis/btrfs.api

So yeah, people are trying to do this.


-- 
Chris Murphy
