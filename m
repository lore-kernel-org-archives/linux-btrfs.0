From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs bug while defragmenting
Date: Tue, 9 Mar 2010 14:25:16 -0500
Message-ID: <20100309192516.GQ15485@think>
References: <D09C8589-EA52-4778-8B29-1B06B27292D0@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Philip Love <Love_Phil@emc.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <D09C8589-EA52-4778-8B29-1B06B27292D0@emc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 09, 2010 at 10:45:13AM -0800, Philip Love wrote:
> I had some 10gb files that I was using for random write testing (with cow enabled). I remount the fs with nodatacow, then ran btrfsctl to defragement the file. A BUG message appeared in the messages file. After a reboot btrfsck gave no errors.
> 
> Please let me know what extra information you need.
> Thanks
> Phil
> 
> Mar  9 10:12:25 sentryA kernel: [66771.230266] BUG: Bad page state in process btrfsctl  pfn:201575
> Mar  9 10:12:25 sentryA kernel: [66771.230270] page:ffffea000704b198 flags:0040000000000000 count:-1608652401 mapcount:0 mapping:ffff88002e84b000 index:ffffc90002633d40

Well, I don't think that count is quite right.  But I also don't see
anything in the ioctl that could cause it.  How easily can you reproduce
this?

I do see that the ioctl should be triple checking the page is part of
the mapping after doing a readpage on it, but it should only get dropped
in the face of truncate.  Is this file actively in use at the time that
you're running the ioctl?

-chris
