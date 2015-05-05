Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34203 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756586AbbEEHfE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 May 2015 03:35:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YpXNe-0001y0-Qv
	for linux-btrfs@vger.kernel.org; Tue, 05 May 2015 09:35:03 +0200
Received: from c-24-5-205-109.hsd1.ca.comcast.net ([24.5.205.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 09:35:02 +0200
Received: from obiwantje by c-24-5-205-109.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 09:35:02 +0200
To: linux-btrfs@vger.kernel.org
From: TheJay <obiwantje@gmail.com>
Subject: Re: [REQ] Help to gain access to btrfsraid6 pool that won't mount
Date: Tue, 5 May 2015 07:30:18 +0000 (UTC)
Message-ID: <mi9ria$ri6$3@ger.gmane.org>
References: <mi8452$i00$1@ger.gmane.org>
	<CAJCQCtR2hZu7Dxr1PpHyTyaDYhRMeC7Rf=we59WzRCGncZ7=QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 05 May 2015 00:48:35 -0600, Chris Murphy wrote:

> On Mon, May 4, 2015 at 9:44 AM, TheJay <obiwantje@gmail.com> wrote:
>> $ sudo btrfs fi show
>> Label: 'roms03'  uuid: b0025417-4045-4c63-a432-0625b7cc41ea
>>         Total devices 4 FS bytes used 2.67TiB
>>         devid    1 size 1.36TiB used 1.36TiB path /dev/sdz
>>         devid    3 size 1.36TiB used 1.36TiB path /dev/sdaa
>>         devid    4 size 1.36TiB used 1.36TiB path /dev/sdab
>>         *** Some devices missing
> 
> How many devices are missing?
> 
>> [Mon May  4 08:35:08 2015] BTRFS: failed to read chunk tree on sdz
> 
> That's not good. What do you get for 'btrfs check" (without --repair)?
> 
> -- 
> Chris Murphy

Appriciate the response Chris

> How many devices are missing?
One (1) of the 4 devices is missing - "device 2".

> What do you get for 'btrfs check" (without --repair)?
$ btrfs check /dev/sdaa
warning, device 2 is missing
warning devid 2 not found already
checksum verify failed on 21200896 found 44715E95 wanted A092E323
checksum verify failed on 21200896 found 91AC994F wanted 987F5E0F
checksum verify failed on 21200896 found 44715E95 wanted A092E323
bytenr mismatch, want=21200896, have=65536
Couldn't read chunk tree
Couldn't open file system




