Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40027 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbbK0JRE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 04:17:04 -0500
Subject: Re: How to detect / notify when a raid drive fails?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1448601297.4093478.451242913.1CEE0D6D@webmail.messagingengine.com>
 <pan$2baa9$6d4c6e73$140f6177$488caa5a@cox.net>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56581F87.9080409@oracle.com>
Date: Fri, 27 Nov 2015 17:16:55 +0800
MIME-Version: 1.0
In-Reply-To: <pan$2baa9$6d4c6e73$140f6177$488caa5a@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/27/2015 01:30 PM, Duncan wrote:
> Ian Kelling posted on Thu, 26 Nov 2015 21:14:57 -0800 as excerpted:
>
>> I'd like to run "mail" when a btrfs raid drive fails, but I don't know
>> how to detect that a drive has failed. It don't see it in any docs.
>> Otherwise I assume I would never know until enough drives fail that the
>> filesystem stops working, and I'd like to know before that.
>
> Btrfs isn't yet mature enough to have a device failure notifier daemon,
> like for instance mdadm does.  There's a patch set going around that adds
> global spares, so btrfs can detect the problem and grab a spare, but it's
> only a rather simplistic initial implementation designed to provide the
> framework for more fancy stuff later, and that's about it in terms of
> anything close, so far.

Thanks Duncan.

  Adding more.. the above hot spare patch set also brings the device
  to a "failed state" when there is a confirmed flush/write failure.
  And prevents any further IOs to it in the context of raid, if there
  is no raid, it will kick in the FS error mode which generally goes
  to the readonly mode /panic as configured at mount. It will do this
  even if there is no hot spare configured.

  btrfs-progs part if not there yet. Because its waiting for sysfs
  patch set to be integrated, so that progs can use it instead of
  writing new/updating ioctls.

  These patch set also introduced another state which device can go
  into, that is "offline state". But it can work only when sysfs
  interface is provided. Offline will be used mainly when
  we don't have a confirmation that device has failed, but has just
  disappears, like pulling out a drive. Being in offline state, the
  resilver/replace will never begin.

  Since we wanted to avoid unnecessary hot replace/resilver, offline
  state is important.

  What is not there in this patch yet is (from the kernel side, apart
  from the btrfs-progs side) is to bring the disk back online (in the
  raid context). As of now it will do nothing, though progs tells
  user that kernel knows about the reappeared device.

  I understand as a user, a full md/lvm set of features are important
  to begin operations using btrfs and we don't have it yet. I have to
  blame it on the priority list.

Thanks, Anand


> What generally happens now, however, is that the btrfs will note failures
> attempting to write the device and start queuing up writes.  If the
> device reappears fast enough, btrfs will flush the queue and be back to
> normal.  Otherwise, you pretty much need to reboot and mount degraded,
> then add a device and rebalance. (btrfs device delete missing broke some
> versions ago and just got fixed by the latest btrfs-progs-4.3.1, IIRC.)
>
> As for alerts, you'd see the pile of accumulating write errors in the
> kernel log.  Presumably you can write up a script that can alert on that
> and mail you the log or whatever, but I don't believe there's anything
> official or close to it, yet.
>
