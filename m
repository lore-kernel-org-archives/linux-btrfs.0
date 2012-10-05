Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:60737 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2JEOFG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2012 10:05:06 -0400
Message-ID: <506EE919.1030903@giantdisaster.de>
Date: Fri, 05 Oct 2012 16:05:13 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clmason@fusionio.com>
Subject: Re: [PATCH] Btrfs: make filesystem read-only when submitting barrier
 fails
References: <1344605915-22526-1-git-send-email-sbehrens@giantdisaster.de> <20121005125159.GP2370@localhost.localdomain> <20121005130911.GA9134@shiny>
In-Reply-To: <20121005130911.GA9134@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 5 Oct 2012 09:09:11 -0400, Chris Mason wrote:
> On Fri, Oct 05, 2012 at 06:51:59AM -0600, Josef Bacik wrote:
>> On Fri, Aug 10, 2012 at 07:38:35AM -0600, Stefan Behrens wrote:
>>> So far the return code of barrier_all_devices() is ignored, which
>>> means that errors are ignored. The result can be a corrupt
>>> filesystem which is not consistent.
>>> This commit adds code to evaluate the return code of
>>> barrier_all_devices(). The normal btrfs_error() mechanism is used to
>>> switch the filesystem into read-only mode when errors are detected.
>>>
>>> In order to decide whether barrier_all_devices() should return
>>> error or success, the number of disks that are allowed to fail the
>>> barrier submission is calculated. This calculation accounts for the
>>> worst RAID level of metadata, system and data. If single, dup or
>>> RAID0 is in use, a single disk error is already considered to be
>>> fatal. Otherwise a single disk error is tolerated.
>>>
>>> The calculation of the number of disks that are tolerated to fail
>>> the barrier operation is performed when the filesystem gets mounted,
>>> when a balance operation is started and finished, and when devices
>>> are added or removed.
>>>
>>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>>
>> So we're going from EOPNOTSUPP resulting in barriers just being turned off to
>> the file system being mounted read only?  This is not inline with what every
>> other linux file system does, which isn't necessarily a problem but I'm not sure
>> it's the kind of change we want to make.  Think about somebody formatting a
>> cheap usb stick as btrfs and not understanding why they can't write to it.  I'm
>> fine either way, I just want to make sure that we think about the consequences
>> of this before we pull it in.  Thanks,

(Just for the matter of completeness: A few minutes ago Josef agreed on
IRC that this is not the case, EOPNOTSUPP is not seen as an error.)

> 
> In the past I haven't really trusted the drives to return good errors
> when there are problems with cache flushes.  It might be that drives
> (and the block layer) are really smart about this now, I know that
> Christoph thought any EIOs coming up from a barrier really were eios.
> 
> But I still have my doubts, mostly because I don't think anyone tests
> these conditions on a regular basis.

Looking at the risk of this patch, the worst thing that can happen is
that a flush request results in an EIO although there is no error at
all. Then the filesystem is switched read-only and the user is not
amused. All I can say is that I have not seen this so far, which does
not mean that it cannot happen.

But I have seen two cases (on IRC and on mailing list) where drives that
transitioned to offline caused flush errors and write errors. When we
ignore the flush errors, the super blocks referring to the new tree
roots are written to those disks that are still online, and the state of
the filesystem is not correct. The trees refer to data that is not on
disk (since it is not flushed and the write EOIs can be delayed since
we're talking of hardware issues like hot unplugged USB drives). In this
case, the user is not amused as well. And additionally, he needs to go
back to a previous tree root revision which can mean to lose data.
