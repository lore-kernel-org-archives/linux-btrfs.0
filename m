Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46752 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbbC0AIE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 20:08:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YbHof-0007Lg-Uv
	for linux-btrfs@vger.kernel.org; Fri, 27 Mar 2015 01:08:02 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2015 01:08:01 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2015 01:08:01 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
Date: Fri, 27 Mar 2015 00:07:29 +0000
Message-ID: <mf2701$d5k$1@ger.gmane.org>
References: <meq6hm$lbh$1@ger.gmane.org> <20150323232212.GL31762@carfax.org.uk> <CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/03/15 01:30, Rich Freeman wrote:
> On Mon, Mar 23, 2015 at 7:22 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Mon, Mar 23, 2015 at 11:10:46PM +0000, Martin wrote:
>>> As titled:
>>>
>>>
>>> Does btrfs have dedup (on raid1 multiple disks) that can be enabled?
>>
>>    The current state of play is on the wiki:
>>
>> https://btrfs.wiki.kernel.org/index.php/Deduplication
>>
> 
> I hadn't realized that bedup was deprecated.
> 
> This seems unfortunate since it seemed to be a lot smarter about
> detecting what has and hasn't already been scanned, and it also
> supported defragmenting files while de-duplicating them.
> 
> I'll give duperemove a shot.   I just packaged it on Gentoo.

Excellent and very rapid packaging, thanks!


Already compiled, installed, and soon to be tried on a test subvolume...


Anyone with any comments on how well duperemove performs for TB-sized
volumes?

Does it work across subvolumes? (Presumably not...)


Thanks,
Martin

