Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:60168 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbaK2HzO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 02:55:14 -0500
Message-ID: <54797BDB.1050905@pobox.com>
Date: Fri, 28 Nov 2014 23:55:07 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <20141121042814.GR17395@hungrycats.org> <5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org> <5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org> <5474FBD9.5070709@inwind.it> <20141125222126.GQ17380@hungrycats.org> <54760B89.3050604@inwind.it> <20141127041510.GV17380@hungrycats.org> <5478AB6C.7030809@inwind.it> <20141129045924.GX17395@hungrycats.org>
In-Reply-To: <20141129045924.GX17395@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/28/2014 08:59 PM, Zygo Blaxell wrote:
> On Fri, Nov 28, 2014 at 06:05:48PM +0100, Goffredo Baroncelli wrote:
>> On 11/27/2014 05:15 AM, Zygo Blaxell wrote:
>>> This is a weakness of the current udev and asynchronous device hotplug
>>> concept:  there is no notion of bus enumeration in progress, so we can be
>>> trying to assemble multi-device storage before we have all the devices
>>> visible.  Assembly of aggregate storage (whatever it is--btrfs, md,
>>> lvm2...) has to wait until all known storage buses are fully enumerated
>>> in order to detect if there are duplicates.
>>
>> It is more complex than that. Some devices may appear after the "1st" bus
>> enumeration.
>
> That case is well handled already--a new enumeration will start with the
> second (and all later) hotplug events.
>
> The problem arises when we try to assemble disk arrays before the
> known end of the "1st" (or any) enumeration.  There is no way for an
> enumerating agent to tell other agents "this is definitely not the
> complete list of devices yet, other devices may be inserted imminently"
> and defer all the multi-device assembly until the address space of the
> enumering bus is fully covered.
>
MDADM has an "attached" but not "started" state for arrays that handles 
this condition during incremental assembly. (see "mdadm --incremental 
/dev/whatever"),

To slightly misuse the vocabulary, as each partition is encountered and 
submitted to the system it's checked for a superblock. If one is found 
then it has the identity of an array encoded on it and if that array 
doesn't exist it is allocated, otherwise the device is added to the 
existent array. The array is only started if all the devices are 
accounted for unless an option is added to allow earlier starts, and 
even then "enough" of the devices must be present to make sense (e.g. 
only one device missing from a RAID5, or a correct pair of devices for a 
RAID10 etc.)

So we'd need a "partially assembled but not started" state and some 
ioctls to do things like force-start or force-disown a filesystem that 
cannot be "finished" automatically.

That sort of thing is very easy to do with devices because devices don't 
have to be opened and can reject an open attempt, or at least the 
read/writes after an open and such.

Unfortunately a filesystem can really only exist as a mounted thing, and 
can really only be controlled by remounting thereafter. The most 
efficient way to do this would be to have a alternate file system 
operations structure that was filled mostly with dummy operations that 
would return ENOENT and friends. Then the remount that finally fulfilled 
the file system's requirements would then switch out that struct for the 
fully functional one. That remount would need an "adddev=" and some 
other such options (much like AUFS adds layers).

It;s all doable. But it stretches to near breaking the "mount" paradigm. 
You would need an operation that looked like "mount -t btrfs -o 
do_we_need_this /dev/whatever /this/datum/means/nothing" to match and 
attach a device "wherever it goes" or you might end up needing to do the 
Cartesian product of trial attachments of each new device to all active 
fileystems to match it up, which is an ugly external scripting requirement.

As far as waiting for the address space to be fully covered. Meh. If a 
ready-or-not, or ready-enough, status is established in the file system 
it would be undesirable for it to know anything about any other subsystem.

We don't care if enumeration is "done" we only care if we have a 
rational set of storage, and whether that rational set is "enough" to be 
fully ready, enough to be only read-ready, or just plain not enough.

In theory, the idempotent mount command could be

mount -t btrfs some-uuid-instead-of-device /mount/point
mount -t btrfs some-other-uuid-here /other/mount/point

to create the zero-devices involved entity, followed by

mount -t btrfs -o trydev /dev/something /this/bit/is/ignored

repeated for all possible somethings. /mount/point and 
/other/mount/point would be returning ENOENT for their contents until 
they were ready-enough.

In practice this is very impure compared to how mdadm has the /dev/md- 
namespace in which to build its devices before any actual mount is possible.
