Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60040 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967617Ab3DSAlW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 20:41:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1USzO8-0008Ua-2O
	for linux-btrfs@vger.kernel.org; Fri, 19 Apr 2013 02:41:16 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 02:41:16 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 02:41:16 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: RAID device nomination (Feature request)
Date: Fri, 19 Apr 2013 01:41:06 +0100
Message-ID: <kkq3qu$t2q$1@ger.gmane.org>
References: <kkotdg$o1e$1@ger.gmane.org> <20130418140604.GL7639@carfax.org.uk> <kkpilp$kdd$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <kkpilp$kdd$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 18/04/13 20:48, Alex Elsayed wrote:
> Hugo Mills wrote:
> 
>> On Thu, Apr 18, 2013 at 02:45:24PM +0100, Martin wrote:
>>> Dear Devs,
> <snip>
>>> Note that esata shows just the disks as individual physical disks, 4 per
>>> disk pack. Can physical disks be grouped together to force the RAID data
>>> to be mirrored across all the nominated groups?
>>
>>    Interesting you should ask this: I realised quite recently that
>> this could probably be done fairly easily with a modification to the
>> chunk allocator.
> <snip>
> 
> One thing that might be an interesting approach:
> 
> Ceph is already in mainline, and uses CRUSH in a similar way to what's 
> described (topology-aware placement+replication). Ceph does it by OSD nodes 
> rather than disk, and the units are objects rather than chunks, but it could 
> potentially be a rather good fit.
> 
> CRUSH does it by describing a topology hierarchy, and allocating the OSD ids 
> to that hierarchy. It then uses that to map from a key to one-or-more 
> locations. If we use chunk ID as the key, and use UUID_SUB in place of the 
> OSD id, it could do the job.

OK... That was a bit of a crash course (ok, sorry for the pun on crush :-) )

http://www.anchor.com.au/blog/2012/09/a-crash-course-in-ceph/


Interesting that the "CRUSH map is written by hand, then compiled and
passed to the cluster".

Hence, looks like simply have the sysadmin specify what gets grouped
into what group. (I certainly know what disk is where and where I want
the data mirrored!)


For my example, the disk packs are plugged into two servers (up to four
at a time at present) so that we have some fail-over if one server dies.
Ceph looks to be a little overkill for just two big storage users.

Or perhaps include the same Ceph code routines into btrfs?...


Regards,
Martin

