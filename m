From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 16:06:45 +0200
Message-ID: <4BF29EF5.4020408@gmail.com>
References: <4BF18525.8080904@gmail.com> <20100517193652.GC8635@think> <4BF1DBCD.7060208@gmail.com> <20100518003032.GK8635@think> <20100518005926.GM8635@think> <4BF28225.2000908@gmail.com> <20100518131304.GX8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100518131304.GX8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/05/10 15:13, Chris Mason wrote:
> 
> The thing is that different apps have a different version of 'right'.  Rename
> is atomically replacing one file with another, and I completely agree
> that when we have an established file on disk, we shouldn't replace it
> with something that is potentially garbage.
> 
> But for the zeros case we have a file that isn't on disk and we're just
> giving it a new name.  I can see a different class of applications
> getting upset about renames slowing the system down dramatically because
> they suddenly imply a lot of IO.
> 
> I'm more than open to discussion on this one, but I don't see how:
> 
> rm -f foo2
> dd if=/dev/zero of=foo bs=1M count=1000
> mv foo foo2
> 
> Should be expected to write 1GB of data.
> 
> -chris

The idea would be to delay the rename hitting the disk until the data
has been written anyway.
The mv would return immediately, and someday, after the data has been
written to disk, the rename would be written to disk.

Jakob
