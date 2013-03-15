Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:46490 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754196Ab3COQDI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 12:03:08 -0400
Message-ID: <51434653.40808@sgi.com>
Date: Fri, 15 Mar 2013 11:03:31 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
        xfs-oss <xfs@oss.sgi.com>,
        ext4 development <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: make defrag test 222 generic
References: <513F5B0A.4030405@redhat.com> <20130315145540.GG7229@twin.jikos.cz>
In-Reply-To: <20130315145540.GG7229@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/15/2013 09:55 AM, David Sterba wrote:
> On Tue, Mar 12, 2013 at 11:42:50AM -0500, Eric Sandeen wrote:
>> Define a new _defrag_dir() helper which just runs noisy/debug
>> dir defrag for ext4 and/or btrfs as well, and use that in 222
>> instead of hardcoded xfs_fsr.
>
> Dir defrag on btrfs does not recurse in the given directory to defrag
> all files, but defragments the tree of the containing subvolume and the
> whole extent tree (thus needs CAP_SYS_ADMIN).
>
> This is known (and not very intuitive) behaviour, it would be better to
> add a special parameter to defrag the root and/or the extent root and
> pass it down to the ioctl via flags.
>
> Until this is implemented I suggest to use a workaround via 'find':
>
>   find $dir -print -execdir $DEFRAG_PROG '{}' +
>
> Otherwise the test looks ok.
>
> david

Eric, I will make this change at commit time if you agree?

David, can I put your name as the reviewer when I do?

Thanks
--Rich
