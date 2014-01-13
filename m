Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27470 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213AbaAMShw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 13:37:52 -0500
Message-ID: <52D43235.7060502@fb.com>
Date: Mon, 13 Jan 2014 13:36:37 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Jim Salter <jim@jrs-s.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send: page allocation failure
References: <52D3E308.7060309@jrs-s.net> <20140113182312.GR6498@twin.jikos.cz>
In-Reply-To: <20140113182312.GR6498@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/13/2014 01:23 PM, David Sterba wrote:
> On Mon, Jan 13, 2014 at 07:58:48AM -0500, Jim Salter wrote:
>> Getting sporadic page allocation failures in btrfs send. This happened once
>> several weeks ago but was fine after a reboot; yesterday I did not reboot,
>> but had the failure back-to-back trying to send two different snapshots.
>> These are full sends, not incremental, of a bit over 600G of data. Test
>> machine has 32G of RAM, with 21G of it free (not including cache):
>>
>> root@gwa-virt1:/data/images/.snapshots# free -m
>>               total       used       free     shared    buffers cached
>> Mem:         32159      31789        369          0          0 21276
>> -/+ buffers/cache:      10513      21646
>> Swap:            0          0          0
>>
>> In both cases (all three, really) the btrfs send failed a bit more than half
>> of the way through the send (somewhere around the 380GB mark).
>>
>> Kern log snippets follow:
>>
>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627611] btrfs: page allocation
>> failure: order:6, mode:0x104050
>> Jan 12 14:05:36 gwa-virt1 kernel: [535523.627818] [<ffffffffa01876dd>] ?
>> ulist_add_merge+0xcd/0x270 [btrfs]
> That's the krealloc failure, Josef has a patch that came out of
> https://bugzilla.kernel.org/show_bug.cgi?id=60579
> but I don't see it merged anywhere.
That patch isn't quite right which is why it isn't merged, I'll come up 
with something better and send it out soonish.  Thanks,

Josef
