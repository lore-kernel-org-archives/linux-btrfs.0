From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 15:53:56 -0500
Message-ID: <20100226205356.GL12841@think>
References: <20100226191544.GK12841@think>
 <20100226204534.ECFEF40974@viridian.itc.virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Fedyk <mfedyk@mikefedyk.com>, linux-btrfs@vger.kernel.org
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226204534.ECFEF40974@viridian.itc.virginia.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 03:45:34PM -0500, Bill Pemberton wrote:
> > 
> > Bill, I've got a great little application that you can use to test the
> > safety of the array against power failures.  You'll have to pull the
> > plug on the poor machine about 10 times to be sure, just let me know if
> > you're interested.
> > 
> > If the raid array works, the power failure test won't hurt any of the
> > existing filesystems.  If not, it's possible they will all get
> > corrupted, so I wouldn't blame you for not wanting to run it.
> > 
> 
> I have one of the servers idled now, so I can abuse it anyway you'd
> like.

http://oss.oracle.com/~mason/barrier-test

I'd run this on an ext3 partition on your raid array.  You can use btrfs
too, but it will give us some third party verification.

mount ext3 with mount -o barrier=1

Then run barrier-test -p <70% of your system ram in MB> -s 128 -d <path to ext3>

It will print some status:

Memory pin ready
fsyncs ready
Renames ready

Once you see all three ready lines, turn off power.  Don't use the
power button on the front of the machine, either pull the plug, use
the power switch on the back of the machine, or use an external controller

When the machine comes back, run fsck -f on the ext3 partition.  If you get
errors, things have gone horribly wrong.

Ripping the power out isn't nice, if this is a production system please
make sure you have backups of all the partitions.  I suggest running
sync a few times before running the application.

If the write cache isn't working, you'll get errors about 50% of the
time.  If you run it 10 times without any errors you're probably safe.

-chris

