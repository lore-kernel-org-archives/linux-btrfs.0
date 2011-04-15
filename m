From: Josef Bacik <josef@redhat.com>
Subject: Re: [RFC] Add a new file op for fsync to give fs's more control
Date: Fri, 15 Apr 2011 15:32:41 -0400
Message-ID: <4DA89D59.1070402@redhat.com>
References: <1302894582-24341-1-git-send-email-josef@redhat.com> <20110415192412.GA17974@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110415192412.GA17974@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/15/2011 03:24 PM, Christoph Hellwig wrote:
> Sorry, but this is too ugly to live.  If the reason for this really is
> good enough we'll just need to push the filemap_write_and_wait_range
> and i_mutex locking into every ->fsync instance.
>

So part of what makes small fsyncs slow in btrfs is all of our random 
threads to make checksumming not suck.  So we submit IO which spreads it 
out to helper threads to do the checksumming, and then when it returns 
it gets handed off to endio threads that run the endio stuff.  This 
works awesome with doing big writes and such, but if say we're and RPM 
database and write a couple of kilbytes, this tends to suck because we 
keep handing work off to other threads and waiting, so the scheduling 
latencies really hurt.

So we'd like to be able to say "hey this is a small amount of io, lets 
just do the checksumming in the current thread", and the same with 
handling the endio stuff.  We can't do that currently because 
filemap_write_and_wait_range is called before we get to fsync.  We'd 
like to be able to control this so we can do the appropriate magic to do 
the submission within the fsyncings thread context in order to speed 
things up a bit.

That plus the stuff I said about i_mutex.  Is that a good enough reason 
to just push this down into all the filesystems?  Thanks,

Josef
