Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37179 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbbK3OBe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 09:01:34 -0500
Subject: Re: How to detect / notify when a raid drive fails?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1448601297.4093478.451242913.1CEE0D6D@webmail.messagingengine.com>
 <pan$2baa9$6d4c6e73$140f6177$488caa5a@cox.net> <56581F87.9080409@oracle.com>
 <1448644747.11377.45.camel@scientia.net>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <565C56B6.7010106@oracle.com>
Date: Mon, 30 Nov 2015 22:01:26 +0800
MIME-Version: 1.0
In-Reply-To: <1448644747.11377.45.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 11/28/2015 01:19 AM, Christoph Anton Mitterer wrote:
> On Fri, 2015-11-27 at 17:16 +0800, Anand Jain wrote:
>>    I understand as a user, a full md/lvm set of features are important
>>    to begin operations using btrfs and we don't have it yet. I have to
>>    blame it on the priority list.
> What's would be especially nice from the admin side, would be something
> like /proc/mdstat, which centrally gives information about the health
> of your RAID.

  Yep. Its planned. A design doc was in my draft for some time now, I
  just sent it to the mailing list for review comments.


> It can/should of course be more than just "OK" / "not OK"...
> information about which devices are in which state, whether a
> rebuild/reconstruction/scrub is going on, etc. pp.

  right.

> Maybe even details of properties like chunk sizes (as far as these
> apply to btrfs).
>
> Having a dedicated monitoring process... well nice to have, but
> something like mdstat is, always there, doesn't need special userland
> tools and can easily used by 3rd party stuff like Icinga/Nagios
> check_raid.

  yep. will consider.

> I think the keywords here are human readable + parseable... so maybe
> even two files.

  yeah. for parseable reasons I liked procs, there is experimental
  /proc/fs/btrfs/devlist. but procs is kind of not recommended. So
  probably we would need a wrapper tool on top the sysfs to provide
  the same effect.

Thanks, Anand

>
> Cheers,
> Chris.
>
