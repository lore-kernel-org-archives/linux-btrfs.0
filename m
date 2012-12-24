Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:47420 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab2LXTKx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Dec 2012 14:10:53 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: incomplete erase of btrfs with wipefs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <50D89678.9070202@gmail.com>
Date: Mon, 24 Dec 2012 12:10:46 -0700
Message-Id: <E6A6B866-6EF0-4363-B855-EAB961BCA253@colorremedies.com>
References: <8C039D41-002B-440C-9888-9CAB1BC17190@colorremedies.com> <50D89678.9070202@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 24, 2012, at 10:52 AM, Goffredo Baroncelli <kreijack@gmail.com> wrote:

> Hi, Chrism
> 
> On 12/23/2012 10:11 PM, Chris Murphy wrote:
>> Hi,
>> 
>> I'm not completely sure if this is a wipefs bug, or a btrfs(-progs)
>> bug. The gist is that after using wipefs on a btrfs formatted
>> partition, then reformatted as ext4, mount sees it as ext4, parted
>> sees it as ext4, but I btrfs fi show sees it as a member device of a
>> btrfs volume. I have filed a bug against util-linux, but perhaps this
>> is a btrfs-progs over confidence in what it thinks is a valid volume.
>> I have included in the bug report the first 5MB of the device.
>> 
>> https://bugzilla.redhat.com/show_bug.cgi?id=889888
> 
> I cannot reproduce this behaviour [1]. However I have to point out that
> this [2][3] patch solved a problem like you reported.
> 
> Which version of btrfs-progs do you have ? It seems that F18 (beta)
> already has the latest btrfs-progs suite..

This happens with the current F18 test candidates, which have btrfs-progs-0.20.rc1.20121017git91d9eec-1.fc18


Chris Murphy