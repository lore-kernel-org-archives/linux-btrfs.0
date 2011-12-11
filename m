From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: BUG during btrfs device delete missing
Date: Sun, 11 Dec 2011 11:22:18 +0800
Message-ID: <4EE421EA.60809@cn.fujitsu.com>
References: <CAHh_JMPvmRNRrhh0aQhQiej+NP4Vb36MbFtECFphc8cUM9B=ZQ@mail.gmail.com> <CAHh_JMOxrqLRC2ad5n3DuArL1hQdNiixO7jd8StYSKLkbLUB7A@mail.gmail.com> <20111208194556.GS8971@shiny> <CAHh_JMOfLyHV=BSnW8J=8tn6huH0A2AvKqk6+WdOLCdG6zqkAA@mail.gmail.com> <20111209165206.GE8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	David Marcin <djmarcin@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111209165206.GE8971@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

>>> On Thu, Dec 08, 2011 at 11:06:47AM -0800, David Marcin wrote:
>>>> raid10 metadata and data filesystem.  dmesg log follows.  The system
>>>> is unable to unmount the filesystem after this occurs.
>>>>
>>>> Filesystem mounted at/mnt/btrfs with -o compress,degraded
>>>> Command: btrfs device delete missing /mnt/btrfs
>>>>
>>>> [  283.398222] ------------[ cut here ]------------
>>>> [  283.398289] kernel BUG at /home/apw/COD/linux/fs/btrfs/transaction.c:1329!
> 
> So this crash means we failed to write all the blocks required to commit
> the transaction.  The reason is that we're getting failed bios to the
> missing device, and that failure isn't properly eaten by the
> raid aware endio code.
> 
> If you pull the top commit from my for-linus branch, it should all work.
> 
> I know you've got a big FS here, I haven't tested this on raid10 yet,
> only raid1.  If you want to wait a bit for safety I'll do a raid10 run
> too.
> 

The fix looks good to me, and I've tested it on raid10.
