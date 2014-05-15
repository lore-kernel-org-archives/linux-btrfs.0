Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbaEORxx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 13:53:53 -0400
Message-ID: <5374FF30.5080708@redhat.com>
Date: Thu, 15 May 2014 12:53:52 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>, jshubin@redhat.com
Subject: Re: PATCH V3] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com> <53738D29.7020405@redhat.com> <5373AA3B.5000100@redhat.com> <5373E864.4040807@libero.it> <5373E908.4040800@redhat.com> <20140515173940.GS6917@twin.jikos.cz>
In-Reply-To: <20140515173940.GS6917@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/15/14, 12:39 PM, David Sterba wrote:
> On Wed, May 14, 2014 at 05:07:04PM -0500, Eric Sandeen wrote:
>>>> @@ -125,7 +154,20 @@ int make_btrfs(int fd, const char *device, const char *label,
>>>>  	memset(&super, 0, sizeof(super));
>>>>  
>>>>  	num_bytes = (num_bytes / sectorsize) * sectorsize;
>>>> -	uuid_generate(super.fsid);
>>>> +	if (fs_uuid) {
>>>> +		if (uuid_parse(fs_uuid, super.fsid) != 0) {
>>>> +			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
>>>> +			ret = -EINVAL;
>>>> +			goto out;
>>>> +		}
>>>> +		if (!test_uuid_unique(fs_uuid)) {
>>>> +			fprintf(stderr, "non-unique UUID: %s\n", fs_uuid);
>>>> +			ret = -EBUSY;
>>>> +			goto out;
>>>> +		}
>>>
>>> Why a second call to test_uuid_unique(fs_uuid) ?
>>
>> Because kdave said he thought it was worth being paranoid in an earlier email,
>> if I understood him correctly.
> 
> I'm thinking about it again. My original idea was not to easily allow
> to create a duplicate uuid to a regular user. But, if one uses --uuid
> already, that's something I can count as a willful action and any
> mistakes can be blamed on the user.
> 
> If we end up with a warning, then the documentation should say how
> spectacularly it can blow up the system.
> 

So, in my testing, I found that re-mkfsing a device with the same UUID lead
to weird & distant segfaults in other bits of code.  Probably due to the
uuid cache?  </handwave> - I didn't dig into it, because ...

... people didn't want to be able to create duplicate UUIDs, so I figured
the outright rejection of that was a trivial way to solve it ...

And like I mentioned, if you really want to recreate the same UUID, you
can mkfs twice.  It doesn't take long.  ;)

I dunno, maybe that's too lame.  For a feature that upstream development
doesn't really seem to want, I'm not sure how much more effort I should
put into it?

-Eric
