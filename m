From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: Future Linux filesystems
Date: Tue, 3 Jun 2008 17:17:31 +0100
Message-ID: <f058a9c30806030917p748de6b2g5a70132c328eedb@mail.gmail.com>
References: <20824.143.166.255.41.1212443217.squirrel@tomslinux.homelinux.org>
	 <20080603065205.GA19533@infradead.org>
	 <9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
	 <20080603155206.GB22439@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Thomas King" <kingttx@tomslinux.homelinux.org>,
	linux-btrfs@vger.kernel.org
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080603155206.GB22439@2ka.mipt.ru>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Tue, Jun 3, 2008 at 4:52 PM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Hi.
>
> On Tue, Jun 03, 2008 at 09:37:27AM -0500, Thomas King (kingttx@tomslinux.homelinux.org) wrote:
>> I asked the author that question and he states XFS is actually a pretty good
>> answer to most of those issues but believes it still falls short where "the
>> metadata areas are not aligned with RAID strips and allocation units are FAR too
>> small but better than ext." Another detail he brought out was sending data and
>> metadata to different devices in those environments and referenced RT XFS.
>> Otherwise having them on the same device increases the possibility of corruption
>> and/or a longer filesystem check/repair. Will btrfs offer something like this in
>> the future?
>
> Right now btrfs can be created on top of multiple devices.
> AFAIK, there are no policies on hwo to put data and metadata between them.
>

But it does allow to specify to have different replication/stripping
policies for metadata and data.
Such has: configure a raid0 with N drives, but mirror the metadata
across all of them.

>> Do y'all foresee btrfs being used in exabtye installations?
>> Does/Will btrfs have RAID awareness in that it will align "the
>> superblock and metadata to the RAID stripe"?

This is a feature that is intented to provided in the future, this was
talked about in the
#btrfs@freenode.org irc channel.
There isn't code for this currently.



-- 
Miguel Sousa Filipe
