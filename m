From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: Re: Hi!
Date: Thu, 21 Aug 2008 11:47:03 +0100
Message-ID: <f058a9c30808210347l3cd957f6lb518d884e479ad62@mail.gmail.com>
References: <1219221805.15514.13.camel@telesto>
	 <1219256750.7854.7.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Eric Anopolsky" <erpo41@gmail.com>, linux-btrfs@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1219256750.7854.7.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Aug 20, 2008 at 7:25 PM, Chris Mason <chris.mason@oracle.com> wrote:
> On Wed, 2008-08-20 at 02:43 -0600, Eric Anopolsky wrote:
>> Hi,
>>
>> I'm new here. For the past few months I've been contributing some code
>> and discussion to the ZFS-fuse project, but Sun's silence on the
>> licensing issue has left a bad taste in my mouth. I'm ready to switch
>> over to the light side of the force, but I have a couple of questions.
>>
>> 1. I've seen and modified the ZFS source code. Even if I never look at
>> it again, could that poison potential contributions to btrfs?
>>
>
> For now, yes, reading and changing the ZFS source code is not a good
> idea for people that want to contribute to btrfs.
>
>> 2. What needs doing? Easy stuff first, please. I've never done kernel
>> coding.
>
> Testing, discussing and reporting bugs are a great first step.

One thing that I would like to see, is how btrfs behaves with eavy
uses of version control systems like:
- git
- hg

big repos, greps, finds, and stuff like that.

It looks to me that git/hg/bazaar are everytime more widely used,
specially on power users' machines.
Btrfs should look good on those workloads...

Another thing that I'm particularly interested is in stuff like:
- remirror progress stats
- adding, removing,  drives, growing a volume, setting a drive faulty,
etc..  (feature parity with mdadm)
- create userland tools to enable booting from btrfs:
   - single disk and multi disk (raid1, 0 or 10)
   - which snapshot/subvolume ?
- support a migration path to ppl using mdadm + lvm.
   - provide similar tools and sintax to ppl used to lvm and mds.
(feature parity and more..)
   - provide higher level userland apps, and manage and know how to
work with LVM and MD devices,  support for equivalent (or better)
features on btrfs.
   - DeviceKit.Disks support (the future is DeviceKit! :-p) ->
       -> http://hal.freedesktop.org/docs/DeviceKit/
       -> http://lists.freedesktop.org/archives/hal/2008-May/011560.html
       -> http://gitweb.freedesktop.org/?p=DeviceKit/DeviceKit.git;a=summary
- grub support for btrfs (read only..) :D

kind regards..


-- 
Miguel Sousa Filipe
