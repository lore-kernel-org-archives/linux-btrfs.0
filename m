Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:37224 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbAOAJ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 19:09:29 -0500
Received: by mail-yk0-f173.google.com with SMTP id 19so5573527ykq.4
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Jan 2015 16:09:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150114224406.GO13806@merlins.org>
References: <CAA7pwKM9WoGy0JbOfnLc9ifACcZMxbAan4XJqAMcqnfV-cWKtA@mail.gmail.com>
	<20150114224406.GO13806@merlins.org>
Date: Wed, 14 Jan 2015 17:09:28 -0700
Message-ID: <CAJCQCtS2n=dbncq5g+ZOEajqz1ykstefBvfECXiLQxxOTZbyCw@mail.gmail.com>
Subject: Re: Btrfs on top of LUKS (dm-crypt)
From: Chris Murphy <lists@colorremedies.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2015 at 3:44 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Jan 12, 2015 at 05:02:00PM +0100, Patrik Lundquist wrote:
>> Hi,
>>
>> I've been looking at recommended cryptsetup options for Btrfs and I
>> have one question:
>>
>> Marc uses "cryptsetup luksFormat --align-payload=1024" directly on a
>> disk partition and not on e.g. a striped mdraid. Is there a Btrfs
>> reason for that alignment?
>>
>> http://marc.merlins.org/perso/btrfs/post_2014-04-27_Btrfs-Multi-Device-Dmcrypt.html
>
> Sorry for the delay, and greetings from linux.conf.au :)
>
> This was discussed here some time back, see
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/34763
> (last message on that page)

Following the trail backward leads to this one
http://wiki.drewhess.com/wiki/Creating_an_encrypted_filesystem_on_a_partition

Which has a subheading "md RAID array" that starts out:

"If the device to be encrypted is an md RAID array..."

This is referring to encrypting the array, not the individual member
physical devices. We can't encrypt a Btrfs array with dmcrypt we'd
need to use ecryptfs or an encrypted raw file mounted as a loop
device. We can only encrypt member devices, and then use them to
create a Btrfs volume. So this option isn't applicable as it's
described.

Further, man 8 cryptsetup tells us that "If not specified, cryptsetup
tries to use topology info provided by kernel for underlying device to
get optimal alignment..." so we don't need to use the option unless
there's something we know for sure that the kernel doesn't know. For
quite a while dm understands what info to supply upstream so for
instance if you use md raid then LVM to create an LV, and then encrypt
the LV, and then mkfs.xfs you'll see that mkfs.xfs automatically sets
sunit swidth correctly, it doesn't use the single drive defaults.


-- 
Chris Murphy
