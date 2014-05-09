Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21360 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757267AbaEIUVA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 16:21:00 -0400
Message-ID: <536D38A6.9030107@fb.com>
Date: Fri, 9 May 2014 16:20:54 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: filter out selinux xattrs for generic/062
References: <1399664668-719-1-git-send-email-jbacik@fb.com> <536D37F6.90603@redhat.com>
In-Reply-To: <536D37F6.90603@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2014 04:17 PM, Eric Sandeen wrote:
> On 5/9/14, 2:44 PM, Josef Bacik wrote:
>> If you have selinux enabled getfattr will show the selinux xattrs, which screws
>> with the golden output of generic/062.  To make matters worse you can't just
>> greap it out because we'll still get the preamble and newline from getfattr when
>> the selinux attr is the only attr.  So this is the voodoo I came up with after
>> way more time than I'm comfortable admitting to make this test pass if you have
>> selinux enabled.  Thanks,
>
> I thought that we were pretty much universally mounting with an selinux
> context, rather than allowing selinux to add its own on-disk attrs.
>
> Why is that not the case for this test?
>
> Works for me on this old kernel anyway:
>
> [root@bp-05 xfstests]# getenforce
> Enforcing
> [root@bp-05 xfstests]# ./check generic/062
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 bp-05 2.6.32
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdc2
> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdc2 /mnt/scratch
>
> generic/062 60s ... 3s
> Ran: generic/062
> Passed all 1 tests
>
> Note the mount options above...
>

I have MOUNT_OPTIONS set to something else so I lose the context bit. 
Thanks,

Josef

