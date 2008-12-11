From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs and hotplug, auto-assembly, auto-setup, ...
Date: Wed, 10 Dec 2008 20:30:14 -0500
Message-ID: <1228959014.21376.6.camel@think.oraclecorp.com>
References: <ac3eb2510812091002g7d7c163am55f44b188dea0ef6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org, Greg <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812091002g7d7c163am55f44b188dea0ef6@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2008-12-09 at 19:02 +0100, Kay Sievers wrote:
> Hey,
> I thought it would be a good time good to play around a bit with btrfs
> in the usual hotplug setup, so we can - if needed - adapt things
> before it is going to be finalized.
> 

Thanks a lot for looking at this.

> At a first look, it looks very promising, and I really like the idea
> that the state of the (possibly incomplete) device tree is kept in the
> kernel, and not somewhere in a file in userspace, like we usually see
> for all sorts of multi-volume/multi-device setups. It should make
> things much easier as usual.
> 

I hope so, at least its the only way I can keep my brain wrapped around
it.

> Like with every other subsystem, people will expect btrfs to just work
> with hotpluggable devices, without much configuration and explicit
> setup after device connect. To assemble a mountable volume, we will
> need to find the (possibly several independent) devices containing the
> btrfs data.

I did somewhat have hotplug in mind, there is btrfsctl -a to scan all
of /dev and btrfsctl -A to scan a single device.

[ ...]

Now that I have something close to a stable super block location and
magic, I think the plan below is pretty good.  The majority of my plan
here was to make a simple ioctl that hotplug could trigger, and let
someone who knew hotplug better make suggetions on the best way to
present the information.

-chris


