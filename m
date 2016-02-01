Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:35777 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbcBAOUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 09:20:49 -0500
Received: by mail-qk0-f182.google.com with SMTP id o6so51075273qkc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 06:20:48 -0800 (PST)
Subject: Re: Progress indicator when (slowly) mounting a btrfs filesystem?
To: Christian Rohmann <crohmann@netcologne.de>,
        Chris Murphy <lists@colorremedies.com>
References: <56A8EF4F.7060900@netcologne.de>
 <CAJCQCtQ6RwedgskkT9EECdj_2aZVEZZhfNwvkqOWztzk-MyKTg@mail.gmail.com>
 <56AF659E.2080009@netcologne.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56AF6973.5070809@gmail.com>
Date: Mon, 1 Feb 2016 09:19:31 -0500
MIME-Version: 1.0
In-Reply-To: <56AF659E.2080009@netcologne.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-01 09:03, Christian Rohmann wrote:
> Hey Chris,
>
> On 01/28/2016 12:47 AM, Chris Murphy wrote:
>> Might be a bug, but more likely might be a lack of optimization. If it
>> eventually mounts without errors that's a pretty good plus. Lots of
>> file systems can't handle power failures well at all.
>
> So what and how should I go about profiling such a long running mount in
> order to help finding point where optimization is needed the most then?
It would probably require some work with perf and ftrace, which means 
you likely need to build a special kernel just for testing, and then 
generate an ideally clean-room like environment (whatever hosting, plus 
userspace, plus a consistent filesystem image that you can reuse for 
each test, etc).

Kernel profiling is a decidedly non-trivial task, and is not something I 
would recommend somebody try unless both:
a) They already have a working knowledge of kernel internals, or are 
willing to learn.
b) They have the time and resources to do it right in a reproducible manner.
