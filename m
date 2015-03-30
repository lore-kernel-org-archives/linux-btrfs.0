Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54045 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbbC3J7i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 05:59:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YcWTV-00020Z-HJ
	for linux-btrfs@vger.kernel.org; Mon, 30 Mar 2015 11:59:17 +0200
Received: from p4ff58186.dip0.t-ipconnect.de ([79.245.129.134])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 11:59:17 +0200
Received: from holger.hoffstaette by p4ff58186.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 11:59:17 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Cannot convert to raid1
Date: Mon, 30 Mar 2015 09:59:10 +0000 (UTC)
Message-ID: <pan.2015.03.30.09.59.10@googlemail.com>
References: <1427656526.2251.8.camel@miceliux.com>
	<CAJCQCtQLPj2n=jO+s3z28_SdYL1mz97FBntK-0YLYn112EKBNg@mail.gmail.com>
	<pan.2015.03.29.20.04.09@googlemail.com>
	<a713705efd7fb91a19f773253c34b426@miceliux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 30 Mar 2015 08:16:44 +0200, Juan Orti Alcaine wrote:

> El 2015-03-29 22:04, Holger Hoffstätte escribió:
>> On Sun, 29 Mar 2015 13:40:56 -0600, Chris Murphy wrote:
>> 
>>> On Sun, Mar 29, 2015 at 1:15 PM, Juan Orti Alcaine
>>> <juan.orti@miceliux.com> wrote:
>>> 
>>>> The filesystem was created with one device, and I have added two more
>>>> devices afterwards. To convert it to raid1, I have used:
>>>> 
>>>> # btrfs balance start -dconvert=raid1 -mconvert=raid1 
>>>> /mnt/btrfs_raid1
>>> 
>>>> The balance process has finished, but if I check my filesystem, it
>>>> shows up as single
>>> 
>>> Yeah, I'm kinda stumped. The only thing I'm thinking is if you're
>>> absolutely sure it's mounted at /mnt/btrfs_raid1 – because I've made
>>> this mistake before. (Oops.)
>> 
>> Nope, known bug in 4.0-rc:
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/43117
> 
> 
> Do you know if the fix is going to do it for 4.0 final?
> Thank you.

No idea, sorry. So far I don't see anything in Chris' trees.
I maintain my own kernel (for btrfs and some other extensions) and
just skipped that particular commit for now.

-h

