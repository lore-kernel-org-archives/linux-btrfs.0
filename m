Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59059 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab3H2QOh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 12:14:37 -0400
Message-ID: <521F736B.2000009@sandeen.net>
Date: Thu, 29 Aug 2013 11:14:35 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: btrfs/003: regression test for subvol delete
 V2
References: <1376422458-2339-1-git-send-email-jbacik@fusionio.com> <520A8B1D.60307@redhat.com> <20130829132158.GI23113@twin.jikos.cz>
In-Reply-To: <20130829132158.GI23113@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/29/13 8:21 AM, David Sterba wrote:
> On Tue, Aug 13, 2013 at 02:38:05PM -0500, Eric Sandeen wrote:
>>> +. ./common/rc
>>> +. ./common/filter
>>> +
>>> +# real QA test starts here
>>> +_supported_fs btrfs
>>> +_supported_os Linux
>>> +_require_scratch
>>> +
>>> +_scratch_mkfs > /dev/null 2>&1
>>> +_scratch_mount
>>> +
>>> +# This will be set to subvolid 256.  If this ever changes in the future for
>>> +# whatever reason we'll have to pull the subvolid out of the subvol list command
>>> +# but since it's a newly mkfs'ed fs we should be fine with this.
>>
>> . . . and then you grab it out of the subvol list command anyway ;)
>>
>> So really this comment should go, and it sure would be nice to have 
>> a btrfs_get_subvolid() helper for future generations...
> 
> This is available in the 'btrfs subvol show /subvol':
> 
> # btrfs subvol show subv1
> /mnt/a15/subv1
>         Name:                   subv1
>         uuid:                   cf010ad0-38bf-7a42-88be-3360f68cd335
>         Parent uuid:            e6543f70-5d38-1845-b976-d18095860bdf
>         Creation time:          2013-08-29 15:18:18
>         Object ID:              258
>         Generation (Gen):       6
>         Gen at creation:        6
>         Parent:                 5
>         Top Level:              5
>         Flags:                  readonly
>         Snapshot(s):
> 
> Though it involves grep as well.

Ok, yeah, I just meant an xfstests helper routine, sorry.

I guess it could use the above, or subvol list as Josef
has done.

-Eric

> david
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

