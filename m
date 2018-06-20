Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58345 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932269AbeFTIos (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 04:44:48 -0400
Subject: Re: RAID56
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        waxhead@dirtcellar.net
Cc: linux-btrfs@vger.kernel.org
References: <CAJH6TXhoL+HLEp8ioMMt06fvykEjM3Usq7OMAk9VwpcsfTBHpA@mail.gmail.com>
 <2a4b8e37-60c2-bb67-a646-fe61dfe1410f@dirtcellar.net>
 <CAJH6TXgmbvfimGU_bX-T4-0Yomz0YsJR3xsc_dFT5H5OZ6A4GA@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <edd1172b-687b-872e-6647-3c2de9a8c344@suse.com>
Date: Wed, 20 Jun 2018 11:44:45 +0300
MIME-Version: 1.0
In-Reply-To: <CAJH6TXgmbvfimGU_bX-T4-0Yomz0YsJR3xsc_dFT5H5OZ6A4GA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.06.2018 10:34, Gandalf Corvotempesta wrote:
> Il giorno mer 20 giu 2018 alle ore 02:06 waxhead
> <waxhead@dirtcellar.net> ha scritto:
>> First of all: I am not a BTRFS developer, but I follow the mailing list
>> closely and I too have a particular interest in the "RAID"5/6 feature
>> which realistically is probably about 3-4 years (if not more) in the future.
> 
> Ok.
> 
> [cut]
> 
>> Now keep in mind that this is just a humble users analysis of the
>> situation based on whatever I have picked up from the mailing list which
>> may or may not be entirely accurate so take it for what it is!
> 
> I wasn't aware of all of these "restrictions".
> If this is true, now I understand why redhat lost interest in BTRFS.
> 3-4 years more for a "working" RAID56 is absolutely too much, in this case,
> ZFS support for RAID-Z expansion/reduction (actively being worked on)
> will be released
> much earlier (probably, a test working-version later this year and a
> stable version next year)
> 
> RAID-Z single disk espansion/removal is probably the real missing feature in ZFS
> allowing it to be considered a general-purpose FS.
> 
> Device removal was added some months ago and now is possible (so, if
> you add a single disk to a mirrored vdev,
> you don't have to destroy the whole pool to remove the accidentally-added disk)
> 
> In 3-4 years, maybe oracle release ZFS as GPL-compatible (solaris is
> dying, latest release is 3 years ago,
> so there is no need to keep a FS opensource compatible only with a died OS)
> 
> Keep in mind that i'm not a ZFS-fan (honestly, I don't like it) but
> with these 2 features added and tons of restriction in BTRFS,
> there is no other choise.

Of course btrfs is open source and new contributors are always welcome.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
