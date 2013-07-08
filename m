Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:37550 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3GHSpt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 14:45:49 -0400
Received: from frontend1.mail.m-online.net (frontend1.mail.intern.m-online.net [192.168.8.180])
	by mail-out.m-online.net (Postfix) with ESMTP id 3bpwbG619Rz3hhn0
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jul 2013 20:45:41 +0200 (CEST)
Received: from mail.kuther.net (ppp-46-244-135-46.dynamic.mnet-online.de [46.244.135.46])
	by mail.mnet-online.de (Postfix) with ESMTP id 3bpwb94ndXzbc1m
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jul 2013 20:45:41 +0200 (CEST)
Received: from [192.168.1.2] (kuther.net [192.168.1.2])
	by mail.kuther.net (Postfix) with ESMTPSA id 5F478109C275
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jul 2013 20:45:40 +0200 (CEST)
Message-ID: <51DB08D3.50802@kuther.net>
Date: Mon, 08 Jul 2013 20:45:39 +0200
From: Thomas Kuther <tom@kuther.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Qemu disk images on BTRFS suffer checksum errors
References: <c48018584d78271b5958df996a72207f@kuther.net> <20130708132038.GG2260@localhost.localdomain>
In-Reply-To: <20130708132038.GG2260@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 08.07.2013 15:20, schrieb Josef Bacik:
> On Mon, Jul 08, 2013 at 10:08:46AM +0200, Thomas Kuther wrote:
>> Hello,
>>
>> I'm about to migrate from VirtualBox to Qemu+VGA-Passthrough. All my virtual
>> disk images are stored in a BTRFS subvolume on-top of a MDRAID 1.
>> The host runs kernel 3.10, and Qemu 1.5.1. The Testing-VM is a Windows 7
>> 64bit, using a RAW virtio disk with cache=none, same happens for qcow2,
>> though.
>>
>> Using VirtualBox and in the past Vmware workstation I never had issues with
>> corrupted diskimages, but now with Qemu all tries ended up with lots of
>> errors like:
>>
>> [ 4871.863009] BTRFS info (device md10): csum failed ino 687 off 46213922816
>> csum 3817758510 private 402306600
>> [ 4872.481013] BTRFS info (device md10): csum failed ino 687 off 46213922816
>> csum 3817758510 private 402306600
>> [ 4904.055514] BTRFS info (device md10): csum failed ino 687 off 46213922816
>> csum 4060166193 private 402306600
>> [ 4904.748130] BTRFS info (device md10): csum failed ino 687 off 46213922816
>> csum 4060166193 private 402306600
>> [ 4904.987540] BTRFS info (device md10): csum failed ino 687 off 46213922816
>> csum 3817758510 private 402306600
>> [ 4905.024700] BTRFS info (device md10): csum failed ino 687 off 46213922816
>> csum 3817758510 private 402306600
>> [ 4932.497793] BTRFS info (device md10): csum failed ino 687 off 46213922816
>> csum 4060166193 private 402306600
>> [ 4932.533634] BTRFS info (device md10): csum failed ino 687 off 46213922816
>> csum 4060166193 private 402306600
>>
>> Trying to copy the disk image elsewhere causes I/O errors at some point.
>>
>> I found a thread about the issue
>> (http://comments.gmane.org/gmane.comp.file-systems.btrfs/20538) and also a
>> bug report against Qemu from Josef Bacik describing the exact same problem:
>> https://bugzilla.redhat.com/show_bug.cgi?id=693530 - Josef states it should
>> be fixed since quite a while.
>>
>> Is this a regression in BTRFS, a problem with my setup (md raid1 layer below
>> btrfs), or (still) a bug in Qemu?
>> Would cache=writethrough or writeback be an option with BTRFS?
>>
> 
> So there were two aspects to that bug, one is the thing I describe where we get
> the same buffer for two parts of an iovec on reads.  That part has been fixed.
> The second part is where the application will modify the page while it's in
> flight, and that hasn't been fixed.  We have a few options here
> 
> 1) Always double buffer direct io.  Kind of defeats the purpose of direct io.
> 
> 2) Check the buffer after we've written it to see if it matches the csum we put
> down, if not double buffer it and send it down again.  This makes you checksum
> the page twice and punishes O_DIRECT users that behave.
> 
> I opted for #3 and let this sort of thing happen.  So you can get around it by
> doing nodatacow for that particular image which will disable checksumming for
> just that file, or you can use cache=writethrough/writeback and that will use
> buffered io.  FYI this doesn't happen on _all_ qemu, just on guest OS'es that
> don't provide stable pages, so Windows or like old RHEL versions that are on
> ext3.  Thanks,
> 
> Josef
> 

Thanks very much for the explanation, Josef.

I opted for 3), too. Used chattr +C on the directory that is meant for
holding the qemu image(s), and re-created the RAW image in there (so it
has nodatacow flag set now)

So far, no issues. Perfect.

Thanks again.

~Tom


