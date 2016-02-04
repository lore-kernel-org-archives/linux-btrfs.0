Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35765 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966067AbcBDTkt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 14:40:49 -0500
Received: by mail-io0-f181.google.com with SMTP id d63so104869433ioj.2
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 11:40:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B349BE.30003@gmail.com>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
	<56B2AA51.80908@cn.fujitsu.com>
	<CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
	<1724218.nF6PTv1Cei@merkaba>
	<56B349BE.30003@gmail.com>
Date: Thu, 4 Feb 2016 12:40:48 -0700
Message-ID: <CAJCQCtTYFeM-ryJbFHfsiPEK+xbwkNoAmZ1=k8eaJ5TnS7yLaQ@mail.gmail.com>
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 4, 2016 at 5:53 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:


> 4) Possibly get rid of the message on subvolume delete (It provides no
> useful information at all, and it has no option to not error out on non
> existence of a subvolume.  In addition, the same arguments as for create
> apply here too.).

btrfs sub del has different commit modes that affect the user space
command's completion behavior, and output. So I wouldn't say it isn't
useful.


-- 
Chris Murphy
