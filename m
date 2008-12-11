From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: btrfs and hotplug, auto-assembly, auto-setup, ...
Date: Thu, 11 Dec 2008 03:08:14 +0100
Message-ID: <ac3eb2510812101808p4a2d3c12n70eddee64dc87106@mail.gmail.com>
References: <ac3eb2510812091002g7d7c163am55f44b188dea0ef6@mail.gmail.com>
	 <1228959014.21376.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Greg <greg@kroah.com>
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228959014.21376.6.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 11, 2008 at 02:30, Chris Mason <chris.mason@oracle.com> wrote:
> On Tue, 2008-12-09 at 19:02 +0100, Kay Sievers wrote:

>> At a first look, it looks very promising, and I really like the idea
>> that the state of the (possibly incomplete) device tree is kept in the
>> kernel, and not somewhere in a file in userspace, like we usually see
>> for all sorts of multi-volume/multi-device setups. It should make
>> things much easier as usual.
>>
>
> I hope so, at least its the only way I can keep my brain wrapped around
> it.

Yeah, it makes a lot of sense.

>> Like with every other subsystem, people will expect btrfs to just work
>> with hotpluggable devices, without much configuration and explicit
>> setup after device connect. To assemble a mountable volume, we will
>> need to find the (possibly several independent) devices containing the
>> btrfs data.
>
> I did somewhat have hotplug in mind, there is btrfsctl -a to scan all
> of /dev and btrfsctl -A to scan a single device.

That works fine here. We just need to offer some non-sequential
scanning for some setups, to be reliable. But that should be fine, if
we find a way to plug the information together.

> Now that I have something close to a stable super block location and
> magic, I think the plan below is pretty good.  The majority of my plan
> here was to make a simple ioctl that hotplug could trigger, and let
> someone who knew hotplug better make suggetions on the best way to
> present the information.

I have the btrfs detection code in udev since while, to be able to
test it, and I'm tracking the changes.

After the metadata is finalized, I will come up with a few working
examples how we could make this information easily available, and
possible integrate it into the tools, and we can decide what we think
is the best.

One thing I like to check now, if I got it correctly - the volume that
gets mounted has:
  btrfs_super_block.fsid (the volume, may be used for mount-by-label)
  btrfs_super_block.label (the volume, may be used for mount-by-label)

The devices the volume is assembled from, which can be several, have:
  btrfs_super_block.dev_item.uuid (the device uuid, not used in userspace)
  btrfs_super_block.dev_item.fsid (the volume uuid, matches
btrfs_super_block.fsid)

Is this correct?

Thanks,
Kay
