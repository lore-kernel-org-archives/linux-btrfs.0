From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] Check for immutable flag in fallocate path
Date: Mon, 21 Feb 2011 17:50:21 +0100
Message-ID: <AANLkTi=bJBeR0m3xuGX_9YZPqRFuMY=bKoxZEWJt37=M@mail.gmail.com>
References: <4D6221B8.9040303@gmail.com>
	<20110221124635.GA5525@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	cluster-devel@redhat.com,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20110221124635.GA5525@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011/2/21 Christoph Hellwig <hch@infradead.org>:
> On Mon, Feb 21, 2011 at 09:26:32AM +0100, Marco Stornelli wrote:
>> From: Marco Stornelli <marco.stornelli@gmail.com>
>>
>> All fs must check for the immutable flag in their fallocate callback.
>> It's possible to have a race condition in this scenario: an application
>> open a file in read/write and it does something, meanwhile root set the
>> immutable flag on the file, the application at that point can call
>> fallocate with success. Only Ocfs2 check for the immutable flag at the
>> moment.
>
> Please add the check in fs/open.c:do_fallocate() so that it covers all
> filesystems.
>
>

The check should be done after the fs got the inode mutex lock.

Marco
