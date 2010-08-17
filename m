From: David Pottage <david@electric-spoon.com>
Subject: Re: snapshot limit?
Date: Tue, 17 Aug 2010 22:13:41 +0100
Message-ID: <4C6AFB85.9020207@electric-spoon.com>
References: <4C6AC9AC.9000503@noir.com> <AANLkTin1kV1ebL-qOvOOv2e=DZ5qvyWYEEreg-+vqDdP@mail.gmail.com> <4C6AD78B.8070503@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C6AD78B.8070503@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

 On 17/08/10 19:40, K. Richard Pixley wrote:
> On 8/17/10 11:05 , Dhiru Kholia wrote:
>> On Tue, Aug 17, 2010 at 10:41 AM, K. Richard Pixley <rich@noir.com
>> <mailto:rich@noir.com>> wrote:
>>  >  Is there a limit to the number of snapshots that can exist on a file
>> system
>>  > concurrently?
>>
>> According to https://help.ubuntu.com/community/btrfs "You can create
>> as many subvolumes as you want, as long as you have storage capacity."
>>
>> -- 
>> Cheers,
>> Dhiru
>>
>
> Yes.  But if there's a limit to the number of paths that can point to
> a single file, then that's not strictly true.  Rather, there's a limit
> based on the number of snapshots pointing to the same file.

Would that limit also apply to de-duplicated copies of a file ?

Suppose I have tree under a btrfs file-system with lots of identical
files. (eg zero length lock files), and I run a de-duplication script on
it, to turn all those files into one, and then make a series of snapshots.

100 identical files multiplied by 100 snapshots (eg. daily for a few
months), comes to a rather large number of links pointing to the same file.

-- 
David Pottage

