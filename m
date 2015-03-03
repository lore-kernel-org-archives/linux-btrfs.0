Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45491 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbCCHOM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Mar 2015 02:14:12 -0500
Message-ID: <54F55F40.6010508@gmail.com>
Date: Tue, 03 Mar 2015 08:14:08 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
MIME-Version: 1.0
To: "Darrick J. Wong" <darrick.wong@oracle.com>
CC: mtk.manpages@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: Documenting MS_LAZYTIME
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com> <54E7578E.4090809@redhat.com> <20150221025636.GB7922@thunk.org> <54EEDE23.6080009@gmail.com> <20150226133113.GD11217@thunk.org> <54EF2161.90607@gmail.com> <20150227000409.GC17174@thunk.org> <54F02446.2050008@gmail.com> <20150227175159.GC11031@birch.djwong.org>
In-Reply-To: <20150227175159.GC11031@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/27/2015 06:51 PM, Darrick J. Wong wrote:
> On Fri, Feb 27, 2015 at 09:01:10AM +0100, Michael Kerrisk (man-pages) wrote:
>> On 02/27/2015 01:04 AM, Theodore Ts'o wrote:
>>> On Thu, Feb 26, 2015 at 02:36:33PM +0100, Michael Kerrisk (man-pages) wrote:
>>>>
>>>>     The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
>>>>     in the case of a system crash, the atime and mtime fields
>>>>     on disk might be out of date by at most 24 hours.
>>>
>>> I'd change to "The disadvantage of MS_LAZYTIME is that..."  and
>>> perhaps move that so it's clear it applies to any use of MS_LAZYTIME
>>> has this as a downside.
>>>
>>> Does that make sense?
>>
>> Thanks, Ted. Got it. So, now we have:
>>
>>        MS_LAZYTIME (since Linux 3.20)
> 
> "since Linux 4.0".

D'oh! Yes, thanks. Fixed.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
