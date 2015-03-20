Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:42075 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbbCTCe2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 22:34:28 -0400
Message-ID: <550B8732.5000302@comcast.net>
Date: Thu, 19 Mar 2015 19:34:26 -0700
From: don fisher <hdf3@comcast.net>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: nube trying to backup my systems
References: <550B5C63.6010401@comcast.net>	<CAJCQCtRj6MWc=YzvEepjiZTQYrN7CKbO0EivotZNjS218Gz56Q@mail.gmail.com>	<550B7CAC.6030005@comcast.net> <CAJCQCtTO89u8203U+Oc_eyUbEDrT4YZU8xf1gG6omGWS0ehhSQ@mail.gmail.com>
In-Reply-To: <CAJCQCtTO89u8203U+Oc_eyUbEDrT4YZU8xf1gG6omGWS0ehhSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/19/2015 07:15 PM, Chris Murphy wrote:
> On Thu, Mar 19, 2015 at 7:49 PM, don fisher <hdf3@comcast.net> wrote:
>> My rot
>> is mounted at /usr11. I tried:
>>
>> UUID=26d63d99-92f4-4a49-878b-236f5e88af69 /usr11/srv btrfs
>> subvol=usr11/srv       0 0
>>
>> but /usr11/srv did not mount. I replaced the number and it did mount. Would
>> like to use string like you suggested since they are more understandable. Do
>> you see what I did wrong?
>
> Use 'btrfs subvolume list -a' like I suggested and use that path minus
> any leading /. Chances are the path to the subvolume srv is just srv,
> in which case it should be subvol=srv
>
>> Any thoughts on stability of the IDs across boots?
>
> They're completely reliable between reboots and renames. They're
> assigned at creation, and either btrfs sub create or btfs sub snap
> creates subvolumes.

Thanks. I will try that. How does the mount distinguish between /srv and 
/usr11/srv if the subvol=srv is the same for both? It appears to work, 
for when I do a df the sizes are different. I guess it can tell from the 
UUID of / as opposed to that of /usr11. I missed that one completely.

/dev/sdc2       20972544   6117628  14641012  30% /srv
/dev/sdb2       20972544   9492892  11112580  47% /usr11/srv

I would still like to know why we need to mount the subvolumes at all. I 
tried to dismount one of the subvolumes mounted on / and got a:

umount: /var/log: target is busy

message, so could not test to /var/log access without a mount. It is 
easy to access /usr11/var/log without it being mounted. Again, why mount 
it? I understood mounting partitions, because that was the only access. 
But the appears to be two access channels here.

I made another openSuse system on a 2.5" USB drive. I will use it for 
the test tomorrow when more of my neurons are firing.

Thanks
Don





