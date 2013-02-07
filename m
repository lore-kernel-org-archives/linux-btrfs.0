Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622Ab3BGPx3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 10:53:29 -0500
Message-ID: <5113CDCB.7010802@redhat.com>
Date: Thu, 07 Feb 2013 09:52:43 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH 2/2, RFC] btrfs-progs: overhaul mkfs.btrfs -r option
References: <510831DC.4070709@redhat.com> <510833E4.6080609@redhat.com> <20130207000812.GE12339@twin.jikos.cz>
In-Reply-To: <20130207000812.GE12339@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/6/13 6:08 PM, David Sterba wrote:
> On Tue, Jan 29, 2013 at 02:41:08PM -0600, Eric Sandeen wrote:
>> The manpage for the "-r" option simply says that
>> it will copy the path specified to -r into the newly
>> made filesystem.
>>
>> There's not a lot of reason to treat that option as differently
>> as it is now - today it ignores discard, fs size, and mixed
>> options, for example.  It also failed to check whether the
>> target device was mounted before proceeding.  Etc...
>>
>> Rework things so that we really follow the same paths whether
>> or not -r is specified, but with one special case for -r:
>>
>> * If the device does not exist, it will be created as
>>   a regular file of the minimum size to hold the -r path,
>>   or of size specified by the -b option.
>>
>> This also changes a little behavior; it does not pre-fill
>> the new file with zeros, but allows it to be sparse, and does
>> not truncate an existing device file.  If you want to start
>> with an empty file, just don't point it at an existing
>> file...
> 
> Fixes numerous bugs and I find the changes in behaviour sane and
> reasonable. A quick test failed for me when the image file does not
> exist:
> 
> $ rm image
> $ ./mkfs.btrfs -r . image
> ...
> not enough free space
> add_file_items failed
> unable to traverse_directory
> Making image is aborted.
> ret = -1
> mkfs.btrfs: mkfs.c:1533: main: Assertion `!(ret)' failed.
> 
> seems that the estimated size is not sufficient.

ho hum, thanks for checking.  I guess I only tried it on a very small
source directory.  For now, figuring out btrfs space usage for a given
set of files is above my pay grade and experience, I'm afraid.  :(

-Eric

> 'du' on the directory (without the image itself) gives me 59M, the image
> after failed mkfs has 102M, and it's empty when I try to mount it. Using
> the progs .git directory (18M) as sourcedir also failed, but it worked
> with man/ subdirectory (94K).
> 
> david
> 

