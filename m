Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19763 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755405AbaDGRRY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 13:17:24 -0400
Message-ID: <5342DD99.3010502@fb.com>
Date: Mon, 7 Apr 2014 13:17:13 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Sasha Levin <sasha.levin@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>, <jbacik@fb.com>,
        <linux-btrfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: btrfs: lock inversion between delayed_node->mutex and found->groups_sem
References: <53239AE0.8030306@oracle.com> <20140317130546.GE29256@twin.jikos.cz> <533307ED.8030700@suse.com> <533F20EB.2040500@oracle.com> <20140407165449.GA29256@twin.jikos.cz>
In-Reply-To: <20140407165449.GA29256@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/07/2014 12:54 PM, David Sterba wrote:
> On Fri, Apr 04, 2014 at 05:15:23PM -0400, Sasha Levin wrote:
>> On 03/26/2014 01:01 PM, Jeff Mahoney wrote:
>>> On 3/17/14, 9:05 AM, David Sterba wrote:
>>>>> On Fri, Mar 14, 2014 at 08:12:16PM -0400, Sasha Levin wrote:
>>>>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on the following:
>>>>>>>
>>>>>>> [  788.458756]        CPU0                    CPU1 [  788.459188] ----                    ---- [  788.459625] lock(&found->groups_sem); [  788.460041] local_irq_disable(); [  788.460041] lock(&delayed_node->mutex); [  788.460041] lock(&found->groups_sem); [  788.460041]   <Interrupt> [ 788.460041]     lock(&delayed_node->mutex); [  788.460041] [ 788.460041]  *** DEADLOCK *** [  788.460041] [  788.460041] 2 locks held by kswapd3/4199:
>>>>>
>>>>> I've once (3.14-rc5) seen the same warning also caused by xfstests/generic/224
>>> I think this is from my sysfs patches. We call kobject_add while holding the group_sem. kobject_add ultimately allocates with GFP_KERNEL, so it can enter reclaim. This particular case isn't dangerous, but it could hit while hot-adding a device. The fix should be pretty simple.
>>
>> Is that fix available anywhere? I'm still seeing the issue in -next.
>
> It is: https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/3894781/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=HQJVSK4wPTft1zWwI1cGvwj5OfdmN5UItVlucU1K31o%3D%0A&s=5113699a2e7345a779333c87dd5b1d88b4410a7c7fcd5fa424baeb838ad7d31b , will probably hit -rc2
>

Its in the integration branch now along with some other important fixes. 
  We'll get it out shortly

-chris
