Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029Ab3CHP1d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Mar 2013 10:27:33 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r28FRXEv012813
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2013 10:27:33 -0500
Message-ID: <513A0361.5090905@redhat.com>
Date: Fri, 08 Mar 2013 09:27:29 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/14] btrfs-progs: don't leak fd in get_fs_info
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com> <1362436804-16766-5-git-send-email-sandeen@redhat.com> <513682AA.4020500@redhat.com>
In-Reply-To: <513682AA.4020500@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/5/13 5:41 PM, Eric Sandeen wrote:
> On 3/4/13 4:39 PM, Eric Sandeen wrote:
>> If we discover that a passed-in fd is not a mountpoint,
>> we determine whether it is a device, and issue another
>> open() against the device's mount point if it is mounted.
>>
>> If we do so, ensure this 2nd fd gets closed before we return
>> so that it does not leak, by consolidating error returns.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Gah, self-nak on this for now, I started trying to make a
> regression test for scrub, and this makes it fail.
> 
> Don't know why yet.
> 
> -Eric

For posterity, it's because this function is actually
doing kind of a nasty thing - it closes the caller's
filehandle & re-opens it on a different path.

Usually the caller is none the wiser, but ick!  So permanent
NAK on this patch, I'm working on a different solution.

-Eric
