Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3JUPVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 11:21:45 -0400
Message-ID: <52654686.2010100@redhat.com>
Date: Mon, 21 Oct 2013 10:21:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 2/8] xfstests: add regression test for kernel bz 60673
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com> <1382120790-31060-2-git-send-email-jbacik@fusionio.com> <5265422E.8000101@redhat.com> <20131021150950.GH6924@localhost.localdomain> <526544BA.2070506@redhat.com>
In-Reply-To: <526544BA.2070506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/13 10:14 AM, Eric Sandeen wrote:
> On 10/21/13 10:09 AM, Josef Bacik wrote:
>> On Mon, Oct 21, 2013 at 10:03:10AM -0500, Eric Sandeen wrote:
>>>> On 10/18/13 1:26 PM, Josef Bacik wrote:
>>>>>> There was a problem with send trying to overwrite a file that wasn't actually
>>>>>> the same.  This is a test to check this particular case where receive fails when
>>>>>> it should succeed properly.  I tested this to verify it fails without my fix and
>>>>>> passes with my fix.  Thanks,
>>>>
>>>> 2 things - 
>>>>
>>>> Why does the selinux context break things?  That seems like a problem w/ send
>>>> if it can't work on a context-mounted fs?  (disabling it for now doesn't bother
>>>> me, but I'm surprised that it's required).
>>>>
>> So it is the context that xfstests is using, not contexts itself.  Xfstests is
>> using the nfs context, and using selinux contexts intercepts all getxattr calls,
>> so when send tries to copy the xattrs for the file it calls getxattr, and
>> because we are using the nfs context it returns EOPNOTSUPP from selinux, it
>> never makes it down to btrfs.  When using the actual real context it works fine
>> because it calls down into the file system.
>>
> 
> This still sounds weird.  Is btrfs send trying to copy the selinux attrs directly?
> 
> Shouldn't they be skipped, and be left up to the receiving end to set the selinux
> xattrs (or not) per the policy for the destination?

Eh, ok, Josef pointed out that "cp -a" does exactly the same thing.

So I'll retract the concern & go learn more about selinux.  ;)

-Eric

