Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57260 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbbIUUAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Sep 2015 16:00:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Ze7GY-0007ji-Ab
	for linux-btrfs@vger.kernel.org; Mon, 21 Sep 2015 22:00:46 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 22:00:46 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2015 22:00:46 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: RAID1 storage server won't boot with one disk missing
Date: Mon, 21 Sep 2015 23:00:36 +0300
Message-ID: <m49mvwfczkr.fsf@coffee.modeemi.fi>
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
	<55FAD9CC.5060206@oracle.com> <55FAF198.2060106@libero.it>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli <kreijack@libero.it> writes:

> Hi Anand,
>
>
> On 2015-09-17 17:18, Anand Jain wrote:
>>  it looks like -o degraded is going to be a very obvious feature,
>>  I have plans of making it a default feature, and provide -o
>>  nodegraded feature instead. Thanks for comments if any.
>> 
>> Thanks, Anand
>
> I am not sure if there is a "good" default for this kind of problem; there are several aspects:
>
> - remote machine:
> for a remote machine, I think that the root filesystem should be mounted anyway. For a secondary filesystem (home ?), may be that an user intervention could be better (but without home, how an user could log?).

However, if the basis for requiring user intervention is that going
forward automatically with the situation as-is would result in risk to
the data, how can the default of going forward during runtime, when one
of the disks drops out, be rationalized?

Most certainly the risk is already there when you no longer have parity
device for RAID1/RAID5, so wouldn't the prudent action be to remount the
device read-only immediately - instead of going on, which is what btrfs
now does, just waiting for another device to die.

Of course, I think few people would agree with that, as it would stop
the service (the parts requiring write access), when in fact the whole
point of RAID is to keep serving the clients when a device dies. So why
is the startup a special case?

I suppose the thinking is that the default forces the administrator to
consider setting up a monitoring system before adding 'nodegraded' to
the root mounting options, but in the outlined scenario there could
easily be data loss when the second device dies, and the user/admin
would be none the wiser until it's too late, even with the current
defaults.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

