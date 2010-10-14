From: David Nicol <davidnicol@gmail.com>
Subject: Re: btrfs filesystem df not working
Date: Thu, 14 Oct 2010 11:06:55 -0500
Message-ID: <AANLkTi=J67ZWz31UwWEccNHA+QL-7EB9WZtUqVYS75XD@mail.gmail.com>
References: <AANLkTik-414saDjSZFtEKWn4h7zSbbLBqa_0S+uf4SQR@mail.gmail.com>
 <AANLkTi=1VgjsZoJqzkp-zto3vAMUThh7TN054xQ1mpEu@mail.gmail.com>
 <AANLkTinYN+b=5qU_+pC_O6OK96JXez8QQeifdzC8dkCK@mail.gmail.com>
 <20101013004332.GK22691@think> <AANLkTinta=KNbF2Poync8oSTCQSsjvFErBsmGUrkpGSg@mail.gmail.com>
 <20101013150237.GU22691@think> <AANLkTimRTycuHq6aWir=ZJUAHKc1rb6QXteLG7sMN6ge@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimRTycuHq6aWir=ZJUAHKc1rb6QXteLG7sMN6ge@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 14, 2010 at 6:45 AM, Leonidas Spyropoulos
<artafinde@gmail.com> wrote:

> My question though is, if I use experimental kernels can I then load
> an "old" kernel and still use the btrfs filesystem?
> Or the newer kernels write anything specials on ionodes which the old
> ones cannot read?

My understanding is that what you have just described is the point of
"freezing the on-disk format" and that the on-disk format is frozen.

I hope someone will correct me if this is wrong.

If a filesystem revision uses something different for the i-node
number as presented to the VFS, therefore, it would have to do that
without affecting the on-disk format. (considering trying to allow
symlinks over subvolume boundaries, or at least better understand the
cases necessitating their prohibition)

Also, the system xattr name space might get different things written
to it for new experimental features besides access control, but
existence of this additional metadata would not affect readability by
an older system, unless the metadata in question was for instance an
encryption key. (just made that up as an example, not working on
anything like that)
