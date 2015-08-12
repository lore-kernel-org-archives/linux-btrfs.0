Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from d.mail.sonic.net ([64.142.111.50]:59504 "EHLO d.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbbHLSpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 14:45:03 -0400
Subject: Re: bedup --defrag freezing
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <55C2840E.4030909@gmail.com> <55C340B5.20005@gmail.com>
From: Konstantin Svist <fry.kun@gmail.com>
Message-ID: <55CB942B.7050301@gmail.com>
Date: Wed, 12 Aug 2015 11:44:59 -0700
MIME-Version: 1.0
In-Reply-To: <55C340B5.20005@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/06/2015 04:10 AM, Austin S Hemmelgarn wrote:
> On 2015-08-05 17:45, Konstantin Svist wrote:
>> Hi,
>>
>> I've been running btrfs on Fedora for a while now, with bedup --defrag
>> running in a night-time cronjob.
>> Last few runs seem to have gotten stuck, without possibility of even
>> killing the process (kill -9 doesn't work) -- all I could do is hard
>> power cycle.
>>
>> Did something change recently? Is bedup simply too out of date? What
>> should I use to de-duplicate across snapshots instead? Etc.?
>>
> AFAIK, bedup hasn't been actively developed for quite a while (I'm
> actually kind of surprised it runs with the newest btrfs-progs).
> Personally, I'd suggest using duperemove
> (https://github.com/markfasheh/duperemove)

Thanks, good to know.
Tried duperemove -- it looks like it builds a database of its own
checksums every time it runs... why won't it use BTRFS internal
checksums for fast rejection? Would run a LOT faster...


