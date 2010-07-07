From: Chris Mason <chris.mason@oracle.com>
Subject: Re: volume broken? btrfsck fails
Date: Tue, 6 Jul 2010 20:16:22 -0400
Message-ID: <20100707001622.GH15984@think>
References: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Yee-Ting Li <yee379@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <569BCC7F-1920-4AC4-8069-369419029373@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 26, 2010 at 03:15:04PM -0700, Yee-Ting Li wrote:
> Hi,
> 
> i think my btrfs volume is hosed.... it mounts okay, but iostat shows /dev/sdg on 100% load. dmesg shows lots of 'parent transid verify failed on x wanted y found z'. then after a while i can't read from it (access to the filesystem freezes).
> 
> the machine had crashed (prob from some other process), and upon reboot i've been experience this problem since.
> 
> can anyone provide any guidance in how to proceed?

These are definitely corruptions, and they probably came from the crash.
Can you tell me more about the crash? (Power failure, what is the
storage underneath etc, what are the write cache settings).  We don't
expect these kinds corruptions to happen.

Yan Zheng is making a lot of progress on btrfsck, but I don't think
you'll want to be one of the first testers there.  I can definitely help
copy things off if you're having trouble accessing the FS.

-chris
