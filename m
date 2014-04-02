Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37855 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933029AbaDBTno (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Apr 2014 15:43:44 -0400
Message-ID: <533C6871.7060003@fb.com>
Date: Wed, 2 Apr 2014 15:43:45 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Josh Boyer <jwboyer@fedoraproject.org>, <jbacik@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Btrfs lockdep with 3.15 merge window v3.14-751-g683b6c6f82a6
References: <CA+5PVA787+k0TVFUuo6PxNWMwffWDKixmt2C+E4_9szUJatYkw@mail.gmail.com> <20140402164709.GI29256@twin.jikos.cz>
In-Reply-To: <20140402164709.GI29256@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/02/2014 12:47 PM, David Sterba wrote:
> On Tue, Apr 01, 2014 at 06:23:11PM -0400, Josh Boyer wrote:
>> Below is a lockdep spew I have on a local VM running Linus' tree as of
>> this afternoon.  The specific git commit is v3.14-751-g683b6c6f82a6.
>
>> [  295.349016]        CPU0                    CPU1
>> [  295.349016]        ----                    ----
>> [  295.349016]   lock(&found->groups_sem);
>> [  295.349016]                                local_irq_disable();
>> [  295.349016]                                lock(&delayed_node->mutex);
>> [  295.349016]                                lock(&found->groups_sem);
>> [  295.349016]   <Interrupt>
>> [  295.349016]     lock(&delayed_node->mutex);
>
> Fixed by https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/3894781/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=R1vuFCUzlD4QksU2UH3APFiFgMVkwmMci%2Bktv%2BzqQnE%3D%0A&s=adbe2bfbb243d9781307cfff001f30c01afd35a32e0fb976ecca933ef4cebd26
>

I've got this lined up for my next pull as well.  I sent early this 
time, but more is going in.

-chris
