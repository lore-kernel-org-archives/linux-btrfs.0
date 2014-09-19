Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54496 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932078AbaISRp7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 13:45:59 -0400
Message-ID: <541C6BD1.7080604@fb.com>
Date: Fri, 19 Sep 2014 12:45:53 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <rob@robspanton.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Performance Issues
References: <1411129114.1811.7.camel@zarniwoop.blob>	 <541C464F.3030600@fb.com> <1411145469.1601.2.camel@zarniwoop.blob>
In-Reply-To: <1411145469.1601.2.camel@zarniwoop.blob>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2014 11:51 AM, Rob Spanton wrote:
> Hi,
>
> Thanks for the response everyone.
>
> I wrote:
>> I have a particularly uncomplicated setup (a desktop PC with a hard
>> disk) and I'm seeing particularly slow performance from btrfs.  A `git
>> status` in the linux source tree takes about 46 seconds after dropping
>> caches, whereas on other machines using ext4 this takes about 13s.  My
>> mail client (evolution) also seems to perform particularly poorly on
>> this setup, and my hunch is that it's spending a lot of time waiting on
>> the filesystem.
>
> The evolution problem has been improved: the sqlite db that it was using
> had over 18000 fragments, so I got evolution to recreate that file with
> nocow set.  It now takes "only" 30s to load my mail rather than 80s,
> which is better...
>
> On Fri, 2014-09-19 at 11:05 -0400, Josef Bacik wrote:
>> Weird, I get the exact opposite performance.  Anyway it's probably
>> because of your file layouts, try defragging your git dir and see if
>> that helps.  Thanks,
>
> Defragging has improved matters a bit: it now takes 26s (was 46s) to run
> git status.  Still not amazing, but at the moment I have no evidence to
> suggest that it's not something to do with the machine's hardware.  If I
> get time over the weekend I'll dig out an external hard disk and try a
> couple of benchmarks with that.
>
> For reference, these are the mount flags:
>          /dev/sda4 on / type btrfs (rw,noatime,space_cache)
>          /dev/sda4 on /home type btrfs (rw,noatime,space_cache)
>

You have an awful lot of metadata, do you have a lot of snapshots?  Also 
I'd be interested in making sure most of this is just from shitty 
metadata layout, could you make sure you have a recent version of 
trace-cmd and then drop caches and do

trace-cmd record -e sched:sched_switch git status

and send me the trace.dat so I can see where all the time is spent?  Thanks,

Josef

