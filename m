Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47197 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbaDOQBF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 12:01:05 -0400
Message-ID: <534D57B1.6090501@fb.com>
Date: Tue, 15 Apr 2014 12:00:49 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Miao Xie <miaox@cn.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs: protect snapshots from deleting during send
References: <cover.1397572052.git.dsterba@suse.cz> <6c15e8cf5f832398461e8dbde0a02255c35fdd4b.1397572052.git.dsterba@suse.cz> <534D479E.3070200@fb.com> <20140415154412.GU29256@twin.jikos.cz>
In-Reply-To: <20140415154412.GU29256@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/15/2014 11:44 AM, David Sterba wrote:
> On Tue, Apr 15, 2014 at 10:52:14AM -0400, Chris Mason wrote:
>> On 04/15/2014 10:41 AM, David Sterba wrote:
>>> The patch "Btrfs: fix protection between send and root deletion"
>>> (18f687d538449373c37c) does not actually prevent to delete the snapshot
>>> and just takes care during background cleaning, but this seems rather
>>> user unfriendly, this patch implements the idea presented in
>>>
>>> https://urldefense.proofpoint.com/v1/url?u=http://www.spinics.net/lists/linux-btrfs/msg30813.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=MrYh%2F3Q4f2DGE6aitHYI%2FFn%2F9KpbUxrrMnLZ69AX73s%3D%0A&s=5102d03d75a57a38a5f67f4a258b075a849ef8790cad39f8ed81adb40df73980
>>>
>>> - add an internal root_item flag to denote a dead root
>>> - check if the send_in_progress is set and refuse to delete, otherwise
>>>    set the flag and proceed
>>> - check the flag in send similar to the btrfs_root_readonly checks, for
>>>    all involved roots
>>>
>>> The root lookup in send via btrfs_read_fs_root_no_name will check if the
>>> root is really dead or not. If it is, ENOENT, aborted send. If it's
>>> alive, it's protected by send_in_progress, send can continue.
>>
>> I'm worried about the use case where we have:
>>
>>    * periodic automated snapshots
>>    * periodic automated deletion of old snapshots
>>    * periodic send for backup
>>
>> The automated deletion doesn't want to error out if send is in progress, it
>> just wants the deletion to happen in the background.
>
> I'd give the precedence to the 'backup' process before the 'clean old
> snapshots', because it can do more harm if the snapshot is removed
> meanwhile without any possibility to recover.

Right, we don't want either process to stop with an error.  We just want 
them to continue happily and do the right thing...

-chris
