Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16640 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaDDVPd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 17:15:33 -0400
Message-ID: <533F20EB.2040500@oracle.com>
Date: Fri, 04 Apr 2014 17:15:23 -0400
From: Sasha Levin <sasha.levin@oracle.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>, dsterba@suse.cz, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: lock inversion between delayed_node->mutex and found->groups_sem
References: <53239AE0.8030306@oracle.com> <20140317130546.GE29256@twin.jikos.cz> <533307ED.8030700@suse.com>
In-Reply-To: <533307ED.8030700@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/26/2014 01:01 PM, Jeff Mahoney wrote:
> On 3/17/14, 9:05 AM, David Sterba wrote:
>>> On Fri, Mar 14, 2014 at 08:12:16PM -0400, Sasha Levin wrote:
>>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on the following:
>>>>> 
>>>>> [  788.458756]        CPU0                    CPU1 [  788.459188] ----                    ---- [  788.459625] lock(&found->groups_sem); [  788.460041] local_irq_disable(); [  788.460041] lock(&delayed_node->mutex); [  788.460041] lock(&found->groups_sem); [  788.460041]   <Interrupt> [ 788.460041]     lock(&delayed_node->mutex); [  788.460041] [ 788.460041]  *** DEADLOCK *** [  788.460041] [  788.460041] 2 locks held by kswapd3/4199:
>>> 
>>> I've once (3.14-rc5) seen the same warning also caused by xfstests/generic/224
> I think this is from my sysfs patches. We call kobject_add while holding the group_sem. kobject_add ultimately allocates with GFP_KERNEL, so it can enter reclaim. This particular case isn't dangerous, but it could hit while hot-adding a device. The fix should be pretty simple.

Is that fix available anywhere? I'm still seeing the issue in -next.


Thanks,
Sasha
