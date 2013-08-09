Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031447Ab3HIXQe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 19:16:34 -0400
Message-ID: <5205784E.7030705@redhat.com>
Date: Fri, 09 Aug 2013 18:16:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 V2] btrfs-progs: mark static & remove unused from
 non-kernel code
References: <52019C6D.9050308@redhat.com> <52019D5F.3070301@redhat.com> <52054F1F.5000407@redhat.com> <20130809224854.GN5284@twin.jikos.cz>
In-Reply-To: <20130809224854.GN5284@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/9/13 5:48 PM, David Sterba wrote:
> On Fri, Aug 09, 2013 at 03:20:47PM -0500, Eric Sandeen wrote:
>> Mark many functions as static, and remove any resulting dead code.
> 
> Thanks.
> 
>> -struct btrfs_root *link_subvol(struct btrfs_root *root, const char *base,
>> -			       u64 root_objectid)
>> +static struct btrfs_root *
>> +link_subvol(struct btrfs_root *root, const char *base, u64 root_objectid)
> 
> Please keep the function defintion style if possible. I've fixed that at
> commit time, no need to resend.

Ok, fair enough - so preferred is

<lots of type stuff> function(some args . . ,
                              . . .  more args . . .,
                              . . . last args)

?  sorry, old xfs habits die hard. ;)

-Eric

> david
> 

