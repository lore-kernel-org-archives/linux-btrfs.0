Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:37373 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeFTAGo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 20:06:44 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: RAID56
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXhoL+HLEp8ioMMt06fvykEjM3Usq7OMAk9VwpcsfTBHpA@mail.gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <2a4b8e37-60c2-bb67-a646-fe61dfe1410f@dirtcellar.net>
Date: Wed, 20 Jun 2018 02:06:41 +0200
MIME-Version: 1.0
In-Reply-To: <CAJH6TXhoL+HLEp8ioMMt06fvykEjM3Usq7OMAk9VwpcsfTBHpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gandalf Corvotempesta wrote:
> Another kernel release was made.
> Any improvements in RAID56?
> 
> I didn't see any changes in that sector, is something still being
> worked on or it's stuck waiting for something ?
> 
> Based on official BTRFS status page, RAID56 is the only "unstable"
> item marked in red.
> No interested from Suse in fixing that?
> 
> I think it's the real missing part for a feature-complete filesystem.
> Nowadays parity raid is mandatory, we can't only rely on mirroring.

First of all: I am not a BTRFS developer, but I follow the mailing list 
closely and I too have a particular interest in the "RAID"5/6 feature 
which realistically is probably about 3-4 years (if not more) in the future.

 From what I am able to understand the pesky write hole is one of the 
major obstacles for having BTRFS "RAID"5/6 work reliably. There was 
patches to fix this a while ago, but if these patches are to be 
classified as a workaround or actually as "the darn thing done right" is 
perhaps up for discussion.

In general there seems to be a lot more momentum on the "RAID"5/6 
feature now compared to earlier. There also seem to be a lot of focus on 
fixing bugs and running tests as well. This is why I am guessing that 
3-4 years ahead is a absolute minimum until "RAID"5/6 might be somewhat 
reliable and usable.

There are a few other basics missing that may be acceptable for you as 
long as you know about it. For example as far as I know BTRFS does still 
not use the "device-id" or "BTRFS internal number" for storage devices 
to keep track of the storage device.

This means that if you have a multi storage device filesystem with for 
example /dev/sda /dev/sdb /dev/sdc etc... and /dev/sdc disappears and 
show up again as /dev/sdx then BTRFS would not recoginize this and 
happily try to continue to write on /dev/sdc even if it does not exist.

...and perhaps even worse - I can imagine that if you swap device 
ordering and a different device takes /dev/sdc's place then BTRFS 
*could* overwrite data on this device - possibly making a real mess of 
things. I am not sure if this holds true, but if it does it's for sure a 
real nugget of basic functionality missing right there.

BTRFS also so far have no automatic "drop device" function e.g. it will 
not automatically kick out a storage device that is throwing lots of 
errors and causing delays etc. There may be benefits to keeping this 
design of course, but for some dropping the device might be desirable.

And no hot-spare "or hot-(reserved-)space" (which would be more accurate 
in BTRFS terms) is implemented either, and that is one good reason to 
keep an eye on your storage pool.

What you *might* consider is to have your metadata in "RAID"1 or 
"RAID"10 and your data in "RAID5" or even "RAID6" so that if you run 
into problems then you might in worst case loose some data, but since 
"RAID"1/10 is beginning to be rather mature then it is likely that your 
filesystem might survive a disk failure.

So if you are prepared to perhaps loose a file or two, but want to feel 
confident that your filesystem is surviving and will give you a report 
about what file(s) are toast then this may be acceptable for you as you 
can always restore from backups (because you do have backups right? If 
not, read 'any' of Duncan's posts - he explains better than most people 
why you need and should have backups!)

Now keep in mind that this is just a humble users analysis of the 
situation based on whatever I have picked up from the mailing list which 
may or may not be entirely accurate so take it for what it is!
