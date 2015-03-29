Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46144 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbbC2UEW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Mar 2015 16:04:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YcJRP-0008UW-H2
	for linux-btrfs@vger.kernel.org; Sun, 29 Mar 2015 22:04:15 +0200
Received: from pd953e9c2.dip0.t-ipconnect.de ([217.83.233.194])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 22:04:15 +0200
Received: from holger.hoffstaette by pd953e9c2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2015 22:04:15 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Cannot convert to raid1
Date: Sun, 29 Mar 2015 20:04:09 +0000 (UTC)
Message-ID: <pan.2015.03.29.20.04.09@googlemail.com>
References: <1427656526.2251.8.camel@miceliux.com>
	<CAJCQCtQLPj2n=jO+s3z28_SdYL1mz97FBntK-0YLYn112EKBNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 29 Mar 2015 13:40:56 -0600, Chris Murphy wrote:

> On Sun, Mar 29, 2015 at 1:15 PM, Juan Orti Alcaine
> <juan.orti@miceliux.com> wrote:
> 
>> The filesystem was created with one device, and I have added two more
>> devices afterwards. To convert it to raid1, I have used:
>>
>> # btrfs balance start -dconvert=raid1 -mconvert=raid1 /mnt/btrfs_raid1
> 
>> The balance process has finished, but if I check my filesystem, it
>> shows up as single
> 
> Yeah, I'm kinda stumped. The only thing I'm thinking is if you're
> absolutely sure it's mounted at /mnt/btrfs_raid1 – because I've made
> this mistake before. (Oops.)

Nope, known bug in 4.0-rc:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/43117

..nag, nag..

-h

