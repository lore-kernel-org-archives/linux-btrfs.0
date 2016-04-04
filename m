Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28417 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbcDDGUG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 02:20:06 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 00/13 v3] Introduce device state 'failed', Hot spare and
 Auto replace
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <1459560651-14809-1-git-send-email-anand.jain@oracle.com>
 <20160404020043.47ad35bf@jupiter.sol.kaishome.de>
Message-ID: <5702076B.3050108@oracle.com>
Date: Mon, 4 Apr 2016 14:19:23 +0800
MIME-Version: 1.0
In-Reply-To: <20160404020043.47ad35bf@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2016 08:00 AM, Kai Krakow wrote:
> Am Sat,  2 Apr 2016 09:30:38 +0800
> schrieb Anand Jain <anand.jain@oracle.com>:
>
>> Auto replace:
>>   Replace happens automatically, that is when there is any write
>>   failed or flush failed, the device will be marked as failed, which
>>   will stop any further IO attempt to that device. And in the next
>>   commit cycle the auto replace will pick the spare device to
>>   replace the failed device. And so the btrfs volume is back to a
>>   healthy state.
>
> Does this also implement "copy-back" - thus, it returns the hot-spare
> device to global hot-spares when the failed device has been replaced?

  Actually no. That means +1x more IO.

> Traditionally, the wording "hot spare" implies that the storage
> system runs a copy-back operation when the failing device has been
> replaced. The "hot spare" device then returns to its original "hot
> spare" function: sitting and waiting to jump in place...



> This also helps to keep your drives order in your storage enclosure.
> Without copy-back, the association between member drive and storage
> enclosure would fluctuate over time and you'd have to constantly update
> documentation.
> Add many identical systems, and you have a lot of
> different system configurations over time with individual
> documentation. This becomes confusing at best, and turns out
> dangerously probably (when pulling the wrong drive due to confusion).

   Noted and I agree, its always been very challenging in this area
   at the data centers.

   But strictly speaking its an enclosure services RFC to
   mitigate the issue of poor SW/CLI UI with hardware slots.
   ZFSSA HW added few more LEDs to help, I am not too sure
   but other recent HWs should have / might have enhancements
   in this area to help easy mapping/management.
   Further for the reason above, we shouldn't fix the problem at
   the wrong side, copy-back involves more IO, but.. I agree
   naming can be better to avoid confusion as such.

> Otherwise, I find "hot spare" misleading and it should be renamed.

  I never thought hot spare would be narrowed to such a specifics.
  When I wrote Solaris cpqarray (it was a very long time back
  though) I remember some RAID+JBOD HW wanted a strict disks ordering
  for _performance-reasons_, which made stronger reasons to have
  copy-back.

  Further in the long term what we need in btrfs is disk based tagging
  and grouping, that is it will help to create a btrfs across mixed
  types of JBODs, and then I hope it shall take care of narrower
  group based spare assignments.

  If there is any further reasons that copy-back should be a feature
  I think its ok to have it as an optional feature.

  About the naming.. the progs called it 'global spare' (device),
  kernel calls is 'spare'. Sorry this email thread called it
  hot spare. I should have paid little more attention here to maintain
  consistency.

  Thanks for the note.

Anand
