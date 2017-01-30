Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:46204 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754481AbdA3VQR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 16:16:17 -0500
Subject: Re: btrfs recovery
To: Michael Born <Michael.Born@aei.mpg.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
 <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <014c7da2-0129-caee-00d8-12f2af628efc@mendix.com>
Date: Mon, 30 Jan 2017 22:16:02 +0100
MIME-Version: 1.0
In-Reply-To: <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/30/2017 10:07 PM, Michael Born wrote:
> 
> 
> Am 30.01.2017 um 21:51 schrieb Chris Murphy:
>> On Mon, Jan 30, 2017 at 1:02 PM, Michael Born <Michael.Born@aei.mpg.de> wrote:
>>> Hi btrfs experts.
>>>
>>> Hereby I apply for the stupidity of the month award.
>>
>> There's still another day :-D
>>
>>
>>
>>>
>>> Before switching from Suse 13.2 to 42.2, I copied my / partition with dd
>>> to an image file - while the system was online/running.
>>> Now, I can't mount the image.
>>
>> That won't ever work for any file system. It must be unmounted.
> 
> I could mount and copy the data out of my /home image.dd (encrypted
> xfs). That was also online while dd-ing it.
> 
>>> Could you give me some instructions how to repair the file system or
>>> extract some files from it?
>>
>> Not possible. The file system was being modified while dd was
>> happening, so the image you've taken is inconsistent.
> 
> The files I'm interested in (fstab, NetworkManager.conf, ...) didn't
> change for months. Why would they change in the moment I copy their
> blocks with dd?

The metadata of btrfs is organized in a bunch of tree structures. The
top of the trees (the smallest parts, trees are upside-down here /\ )
and the superblock get modified quite often. Every time a tree gets
modified, the new modified parts are written as a modified copy in
unused space.

So even if the files themselves do not change... if you miss those new
writes which are being done in space that your dd already left behind...
you end up with old and new parts of trees all over the place.

In other words, a big puzzle with parts that do not connect with each
other any more.

And that's exactly what you see in all the errors. E.g. "parent transid
verify failed on 32869482496 wanted 550112 found 550121" <- a part of a
tree points to another part, but suddenly something else is found which
should not be there. In this case wanted 550112 found 550121 means it's
bumping into something "from the future". Whaaa..

-- 
Hans van Kranenburg
