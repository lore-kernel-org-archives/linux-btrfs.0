Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35182 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab3COQFK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 12:05:10 -0400
Message-ID: <514346B4.3040701@sandeen.net>
Date: Fri, 15 Mar 2013 11:05:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Rich Johnston <rjohnston@sgi.com>
CC: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        xfs-oss <xfs@oss.sgi.com>,
        ext4 development <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: make defrag test 222 generic
References: <513F5B0A.4030405@redhat.com> <20130315145540.GG7229@twin.jikos.cz> <51434653.40808@sgi.com>
In-Reply-To: <51434653.40808@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/15/13 11:03 AM, Rich Johnston wrote:
> On 03/15/2013 09:55 AM, David Sterba wrote:
>> On Tue, Mar 12, 2013 at 11:42:50AM -0500, Eric Sandeen wrote:
>>> Define a new _defrag_dir() helper which just runs noisy/debug
>>> dir defrag for ext4 and/or btrfs as well, and use that in 222
>>> instead of hardcoded xfs_fsr.
>>
>> Dir defrag on btrfs does not recurse in the given directory to defrag
>> all files, but defragments the tree of the containing subvolume and the
>> whole extent tree (thus needs CAP_SYS_ADMIN).
>>
>> This is known (and not very intuitive) behaviour, it would be better to
>> add a special parameter to defrag the root and/or the extent root and
>> pass it down to the ioctl via flags.
>>
>> Until this is implemented I suggest to use a workaround via 'find':
>>
>>   find $dir -print -execdir $DEFRAG_PROG '{}' +
>>
>> Otherwise the test looks ok.
>>
>> david
> 
> Eric, I will make this change at commit time if you agree?
> 
> David, can I put your name as the reviewer when I do?

I think that's big enough change I should send a V2. and
make a btrfs-special case in _defrag_dir.

-Eric

> Thanks
> --Rich
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

