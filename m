Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:49513 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaCMKBl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 06:01:41 -0400
Date: Thu, 13 Mar 2014 11:01:39 +0100
From: Goswin von Brederlow <goswin-v-b@web.de>
To: thanumalayan mad <madthanu@gmail.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Ordering of directory operations maintained across system
 crashes in Btrfs?
Message-ID: <20140313100138.GA13151@frosties>
References: <CAJ6LpRpbKyETTOicfXjTXe15u0pqwe7rMkLcAUKrH1xyHOB1Vw@mail.gmail.com>
 <5314BF28.5040209@fb.com>
 <CAJ6LpRoe8mA2QPrKK3zmeFqF07Va2DLbCiQeyOuZ+HpCAZ4OCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ6LpRoe8mA2QPrKK3zmeFqF07Va2DLbCiQeyOuZ+HpCAZ4OCQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 03, 2014 at 11:56:49AM -0600, thanumalayan mad wrote:
> Chris,
> 
> Great, thanks. Any guesses whether other filesystems (disk-based) do
> things similar to the last two examples you pointed out? Saying "we
> think 3 normal filesystems reorder stuff" seems to motivate
> application developers to fix bugs ...
> 
> Also, just for more information, the sequence we observed was,
> 
> Thread A:
> 
> unlink(foo)
> rename(somefile X, somefile Y)
> fsync(somefile Z)
> 
> The source and destination of the renamed file are unrelated to the
> fsync. But the rename happens in the fsync()'s transaction, while
> unlink() is delayed. I guess this has something to do with backrefs
> too.
> 
> Thanks,
> Thanu
> 
> On Mon, Mar 3, 2014 at 11:43 AM, Chris Mason <clm@fb.com> wrote:
> > On 02/25/2014 09:01 PM, thanumalayan mad wrote:
> >>
> >> Hi all,
> >>
> >> Slightly complicated question.
> >>
> >> Assume I do two directory operations in a Btrfs partition (such as an
> >> unlink() and a rename()), one after the other, and a crash happens
> >> after the rename(). Can Btrfs (the current version) send the second
> >> operation to the disk first, so that after the crash, I observe the
> >> effects of rename() but not the effects of the unlink()?
> >>
> >> I think I am observing Btrfs re-ordering an unlink() and a rename(),
> >> and I just want to confirm that my observation is true. Also, if Btrfs
> >> does send directory operations to disk out of order, is there some
> >> limitation on this? Like, is this restricted to only unlink() and
> >> rename()?
> >>
> >> I am looking at some (buggy) applications that use Btrfs, and this
> >> behavior seems to affect them.
> >
> >
> > There isn't a single answer for this one.
> >
> > You might have
> >
> > Thread A:
> >
> > ulink(foo);
> > rename(somefile, somefile2);
> > <crash>
> >
> > This should always have the rename happen before or in the same transaction
> > as the rename.
> >
> > Thread A:
> >
> > ulink(dirA/foo);
> > rename(dirB/somefile, dirB/somefile2);
> >
> > Here you're at the mercy of what is happening in dirB.  If someone fsyncs
> > that directory, it may hit the disk before the unlink.
> >
> > Thread A:
> >
> > ulink(foo);
> > rename(somefile, somefile2);
> > fsync(somefile);
> >
> > This one is even fuzzier.  Backrefs allow us to do some file fsyncs without
> > touching the directory, making it possible the unlink will hit disk after
> > the fsync.
> >
> > -chris

As I understand it POSIX only garanties that the in-core data is
updated by the syscalls in-order. On crash anything can happen. If the
application needs something to be commited to disk then it needs to
fsync(). Specifically it needs to fsync() the changed files AND
directories.

>From man fsync:

       Calling  fsync()  does  not  necessarily  ensure  that the entry in the
       directory containing the file has  also  reached  disk.   For  that  an
       explicit fsync() on a file descriptor for the directory is also needed.

So the fsync(somefile) above doesn't necessarily force the rename to
disk.


My experience with fuse tells me that at least fuse handles operations
in parallel and only blocks a later operation if it is affected by an
earlier operation. An unlink in one directory can (and will) run in
parallel to a rename in another directory. Then, depending on how
threads get scheduled, the rename can complete before the unlink.

My conclusion is that you need to fsync() the directory to ensure the
metadata update has made it to the disk if you require that. Otherwise
you have to be able to cope with (meta)data loss on crash.


Note: https://code.google.com/p/leveldb/issues/detail?id=189 talks a
lot about journaling and that any yournaling filesystem should
preserve the order. I think that is rather pointless for two reasons:

1) The journal gets replayed after a crash so in whatever order the
two journal entries are written doesn't matter. They both make it to
disk. You can't see one without the other. This is assuming you
fsync()ed the dirs so force the metadata change into the journal in
the first place.

2) btrfs afaik doesn't have any journal since COW already garanties
atomic updates and crash protection.


Overall I also think the fear of fsync() is overrated for this issue.
This would only happen on programm start or whenever you open a
database. Not somthing that happens every second.

MfG
	Goswin
