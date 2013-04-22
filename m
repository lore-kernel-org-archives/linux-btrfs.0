Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.jellyfishnet.co.uk ([93.91.20.10]:48424 "EHLO
	mail2.jellyfishnet.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3DVOBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 10:01:14 -0400
From: Mark Ridley <mark@backupsystems.co.uk>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Mon, 22 Apr 2013 15:01:14 +0100
Subject: =?windows-1256?Q?Re:_BTRFS_3.8.7_Kernel_Crash_Report=FE?=
Message-ID: <CD9B00AC.385FF%mark@backupsystems.co.uk>
In-Reply-To: <20130422134249.GN16427@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1256"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, David.

What causes this corruption and how can I fix it?

I'm very worried about running btrfs.fsck as last time it made a slight
corruption like this worse and the whole volume had to be trashed.

After fsck the "available space" on df ended up being negative so nothing
could be written to the volume.

Mark

On 22/04/2013 14:42, "David Sterba" <dsterba@suse.cz> wrote:

>On Mon, Apr 22, 2013 at 01:19:41PM +0000, Mark Ridley wrote:
>> If I then use rsync --inplace to update the images, I get a btrfs stack
>>trace 
>> and btrfs hangs:
>> 
>> This happens every night.
>
>> [<ffffffffa00bd5c1>] btrfs_set_item_key_safe+0x141/0x150 [btrfs]
>
>The check fails because it finds keys in reverted order. Given the
>conditions under which it happens I think it's an on-disk corruption and
>fsck should be able to at least detect it.
>
>david

