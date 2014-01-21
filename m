Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51747 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaAUQ7e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 11:59:34 -0500
Received: by mail-ie0-f174.google.com with SMTP id tp5so3832193ieb.33
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 08:59:34 -0800 (PST)
Message-ID: <52DEA774.2070603@gmail.com>
Date: Tue, 21 Jan 2014 11:59:32 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Sandy McArthur <sandymac@gmail.com>,
        Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Working on Btrfs as topic for master thesis
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local> <52DD148E.3060200@gmail.com> <CAPs0BijBB0JTJd_-89Jo3OUozDKN8cCWA27=irBD+UoRShxPiw@mail.gmail.com> <52DE6747.4050404@gmail.com> <20140121165200.GF3314@carfax.org.uk>
In-Reply-To: <20140121165200.GF3314@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-21 11:52, Hugo Mills wrote:
> On Tue, Jan 21, 2014 at 07:25:43AM -0500, Austin S Hemmelgarn wrote:
>> On 2014-01-21 01:42, Sandy McArthur wrote:
>>> On Mon, Jan 20, 2014 at 7:20 AM, Austin S Hemmelgarn
>>> <ahferroin7@gmail.com> wrote:
>>>>
>>>> On 2014-01-16 14:23, Toggenburger Lukas wrote:
>>>>> 3. Improving subvolume handling regarding taking recursive snapshots ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Take_recursive_snapshots ) and taking snapshots of arbitrary directories ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Snapshot_arbitrary_directories )
>>>>
>>>> Another option that I would personally love to see would be support for
>>>> write-mostly devices (that is, devices in a RAID1/RAID10 setup that only
>>>> get written too unless the data can't be found elsewhere).  This would
>>>> in particular provide an alternative to using bcache/dm-cache (namely an
>>>> SSD and HDD in RAID1 with the HDD set to write-mostly).
>>>> Based on the current development focus, I don't think anybody is working
>>>> on this already (I would be, but I don't have either the time or the
>>>> skills with kernel programming that would be needed).
>>>
>>> Maybe this happens already: Might a similar effect be automatically
>>> achieved by tracking per-device I/O load averages and distributing
>>> reads based on the I/O loads of possible read devices?
>>>
>> That might be the case, it depends on how the I/O load averages are
>> calculated.  I actually hadn't realized BTRFS did this, I thought it
>> behaved more like MD RAID (that is, distributing the reads among devices
>> in a un-weighted round-robin fashion).
> 
>    I think David tried that a while ago, and the benchmarks were
> actually worse. I'm not sure how much investigation he did into why,
> though.
> 
>    Hugo.
> 
If he implemented it such that it waited for the write to complete to
all devices before returning from the call to write(), then it is very
easy to see how it could be worse.  The trick (for writes at least) is
to wait synchronously for all of the non-writemostly devices to finish
the write, then return from write() and have a background thread cleanup
if there are write errors on the writemostly devices (at that point, you
already have a (probably) good copy on the other devices that you could
replicate to the device that failed the write).
As for the reads, you would only need to find some way to exclude the
writemostly devices from the read-scheduling code unless the read is
because of a read error on the other devices.
