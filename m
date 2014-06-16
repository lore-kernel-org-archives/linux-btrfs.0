Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43805 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbaFPHGY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 03:06:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WwQzl-0004pq-Vb
	for linux-btrfs@vger.kernel.org; Mon, 16 Jun 2014 09:06:21 +0200
Received: from p5b007136.dip0.t-ipconnect.de ([91.0.113.54])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 09:06:21 +0200
Received: from holger.hoffstaette by p5b007136.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jun 2014 09:06:21 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Transaction commit: none (default)
Date: Mon, 16 Jun 2014 07:06:08 +0000 (UTC)
Message-ID: <pan.2014.06.16.07.06.08@googlemail.com>
References: <20140614160554.GP6584@merlins.org>
	<539E49DB.80305@cn.fujitsu.com> <20140616014739.GB19071@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 15 Jun 2014 18:47:39 -0700, Marc MERLIN wrote:

> On Mon, Jun 16, 2014 at 09:35:23AM +0800, Wang Shilong wrote:
>> On 06/15/2014 12:05 AM, Marc MERLIN wrote:
>> >Taking snapshots is now output this in addition of the snapshot
>> >operation.
>> >
>> >Transaction commit: none (default)
>> >
>> >1) Is that expected/normal? It looks kind of spamming/useless to me?
>> >2) If it's useful, what's the use I'm not getting?
>> Addressed a issue that subvolumes reappear after deletetion if poweroff
>> happen.
>> 
>> http://www.spinics.net/lists/linux-btrfs/msg29547.html
> 
> I see, thank you for the pointer.
> In the case of my script, it's console spam that I wish I could make go
> away, but grep -v will do that for me :)
> 
> If it annoys other people, maybe having a -q (quiet) that removes this
> message would be useful?

IMHO it should be the reverse: be quiet by default and require -v, just 
as more explicit behaviour also requires additional options.
With default options I expect default behaviour. Telling me that the 
default behaviour happened is just noise.

cheers
Holger

