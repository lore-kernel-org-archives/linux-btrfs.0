Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33941 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758394Ab3KMI1Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 03:27:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VgVnE-0000z3-Ax
	for linux-btrfs@vger.kernel.org; Wed, 13 Nov 2013 09:27:20 +0100
Received: from dyndsl-080-228-178-141.ewe-ip-backbone.de ([80.228.178.141])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 09:27:20 +0100
Received: from hurikhan77+btrfs by dyndsl-080-228-178-141.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 09:27:20 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Error from Trying to Mount Btrfs
Date: Wed, 13 Nov 2013 09:27:40 +0100
Message-ID: <sopbla-03g.ln1@hurikhan77.spdns.de>
References: <1382915825.53433.YahooMailNeo@web125705.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

gatlin sullivan <gatlinsullivan@yahoo.com> schrieb:

> I have the attached error from trying to mount btrfs on external hard
> drive. The F.S. was my primary system, then I dd'd it to an external and
> reinstalled Fedora.
> 
[...]
> 
> What should I do?
> 
> Appreciatively, Gatlin.
> 
> P.S.
> This file system is very important to me becasue it has a large collection
> of songs.
>
> [root@dell-studio-1555 ~]# dmesg | tail
> [ 1773.320077] btrfs: open_ctree failed
> [ 1800.704035] mce: [Hardware Error]: Machine check events logged
> [ 1969.644418] CPU0: Core temperature above threshold, cpu clock throttled
> (total events = 42644)
> [ 1969.645068] CPU0: Core temperature/speed normal
> [ 1979.367137] device label fedora devid 1 transid 115316 /dev/sdb3
> [ 1979.369388] btrfs: superblock checksum mismatch
> [ 1979.374137] btrfs: open_ctree failed
> [ 2145.217088] device label fedora devid 1 transid 115316 /dev/sdb3
> [ 2145.229732] btrfs: superblock checksum mismatch
> [ 2145.234772] btrfs: open_ctree failed

Is that system overclocked? If yes, I suppose something bad happened to your 
data during dd and it is just borked now.

Another idea: After dd, did you recreate the original fs so it got a new 
uuid? Otherwise your system may now see the same uuid in two places.

Regards,
Kai

