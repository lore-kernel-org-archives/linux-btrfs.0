Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59913 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbaDDPv3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 11:51:29 -0400
Received: by mail-ie0-f178.google.com with SMTP id lx4so3424578iec.23
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Apr 2014 08:51:29 -0700 (PDT)
Message-ID: <533ED507.3020004@gmail.com>
Date: Fri, 04 Apr 2014 11:51:35 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
References: <2692878.dRG1K49eOP@fnix> <533EA686.5030909@gmail.com> <1847185.lRc2jIirHz@fnix>
In-Reply-To: <1847185.lRc2jIirHz@fnix>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-04-04 08:48, Swâmi Petaramesh wrote:
> Le vendredi 4 avril 2014 08:33:10 Austin S Hemmelgarn a écrit :
>>> However I'm still concerned with chronic BTRFS dreadful performance and
>>> still  find that BRTFS degrades much over time even with periodic defrag
>>> and "best practices" etc.
>>
>> I keep hearing this from people, but i personally don't see this to be
>> the case at all.  I'm pretty sure the 'big' performance degradation that
>> people are seeing is due to how they are using snapshots, not a result
>> using BTRFS itself (I don't use them for anything other than ensuring a
>> stable system image for rsync and/or tar based backups).
> 
> Maybe I was wrong to suppose that if a feature exists, it is supposed to be 
> usable... I have used ZFS for years, and on ZFS having *hundreds* of snapshots 
> of any given FS have exactly zero impact on performance...
> 
> With BTRFS, some time ago I tried to use SuSE "snapper" that passes its time 
> doing and releasing snapshots, but it soon made my systems unusable...
> 
> Now, I only keep 2-3 manually made snapshots just for keeping a "stable and OK 
> archive of my machine in a known state" just in case...
> 
> But if even this has a noticeable negative impact on BTRFS performance, then 
> what the hell are BTRFS snapshots good at ??
> 
> Kind regards.
> 
I'm not saying that using a few snapshots is a bad thing, I'm saying
that thousands of snapshots is a bad thing (I have actually seen people
with hat many, including one individual who had almost 32,000 snapshots
on the same drive).  I personally do keep a few around on my system on a
regular basis, even aside from the backups, and have no noticable
performance degradation.  For reference, the (main) system that I am
using has a Intel Celeron 847 running at 1.1GHz, 4G of DDR3-1333 RAM,
and a 500G 5400 RPM SATAII hard disk.  My root filesystem is BTRFS
volume mounted with autodefrag,space_cache,compress-force=lzo,noatime
(the noatime improves performance (and power efficency) for btrfs
because metadata updates end up cascading up the metadata tree (updating
the atime on /etc/foo/bar causes the atime to be updated on /etc/foo,
which causes the atime to be updated on /etc, which causes the atime to
be updated on /)
