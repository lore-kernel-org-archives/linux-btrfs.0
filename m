Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34223 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbcBENAM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Feb 2016 08:00:12 -0500
Received: by mail-io0-f172.google.com with SMTP id 9so127896132iom.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Feb 2016 05:00:11 -0800 (PST)
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
To: Anand Jain <anand.jain@oracle.com>, Moviuro <moviuro@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
 <56B412FC.8060007@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56B49C98.7060406@gmail.com>
Date: Fri, 5 Feb 2016 07:59:04 -0500
MIME-Version: 1.0
In-Reply-To: <56B412FC.8060007@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-04 22:11, Anand Jain wrote:
>
>
>   If you look critically we have been using UI/CLI as API,
>   IMO these two class of interfaces be distinct clearly.
>
>   Btrfs needs library functions/APIs which is callable in
>   popular scripting language like python.
>
I wholeheartedly agree.  At a minimum, we need to get our C API properly 
in line.  I'm not certain how closely libbtrfs matches the btrfs CLI, 
but I'm pretty sure we have all the functionality needed for language 
bindings there, we just need to solidify the API (or at least figure out 
some way to properly version it).  One thing I would love to see added 
to both libbtrfs and the CLI though is some way to make EXTENT_SAME 
ioctl calls on arbitrary extents, there's no way to do this without 
writing your own program, and calling arbitrary ioctls from Python or 
Java or any number of other languages is decidedly non-trivial compared 
to C or C++.
