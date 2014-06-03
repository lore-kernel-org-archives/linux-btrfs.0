Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59308 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028AbaFCXyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 19:54:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WryXG-00017Q-3K
	for linux-btrfs@vger.kernel.org; Wed, 04 Jun 2014 01:54:30 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 01:54:30 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 01:54:30 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: What to do about snapshot-aware defrag
Date: Wed, 04 Jun 2014 00:54:14 +0100
Message-ID: <lmln77$ee0$1@ger.gmane.org>
References: <5388ED6B.8000706@fb.com> <lmav1p$ih7$1@ger.gmane.org> <538C7A79.8070407@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <538C7A79.8070407@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/06/14 14:22, Josef Bacik wrote:
> On 05/30/2014 06:00 PM, Martin wrote:
>> OK... I'll jump in...
>>
>> On 30/05/14 21:43, Josef Bacik wrote:
>>> Hello,
>>>
>>> TL;DR: I want to only do snapshot-aware defrag on inodes in snapshots
>>> that haven't changed since the snapshot was taken.  Yay or nay (with a
>>> reason why for nay)
>>
>> [...]
>>>
>>> === Summary and what I need ===
>>>
>>> Option 1: Only relink inodes that haven't changed since the snapshot was
>>> taken.
[...]
>> Obvious way to go for fast KISS.
>>
>>
>> One question:
>>
>> Will option one mean that we always need to mount with noatime or
>> read-only to allow snapshot defragging to do anything?
>>
> 
> Yeah atime would screw this up, I hadn't thought of that.  With that
> being the case I think the only option is to keep the old behavior, we
> don't want to screw up stuff like this just because users used a backup
> program on their snapshot and didn't use noatime.  Thanks,

Not so fast into non-KISS!


The *ONLY* application that I know of that uses atime is Mutt and then
*only* for mbox files!...

NOTHING else uses atime as far as I know.

We already have most distros enabling reltime by default as a
just-in-case...


Can we not have noatime as the default for btrfs? Also widely note that
default in the man page and wiki and with why?...

*And go KISS and move on faster* better?


Myself, I still use Mutt sometimes, but no mbox, and all my filesystems
have been noatime for many years now with good positive results. (Both
home and work servers.)

Regards,
Martin



