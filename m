Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42366 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3JBUMl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Oct 2013 16:12:41 -0400
Received: by mail-ie0-f174.google.com with SMTP id u16so3080507iet.19
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Oct 2013 13:12:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131002115222.GC2562@localhost.localdomain>
References: <20130929131224.GM18681@localhost.localdomain> <CAEx9m47a_kXvsmOOvSud8ERycB-5D04Nu0ZTHgYzP8RtawBYgg@mail.gmail.com>
 <20130930201125.GA27490@localhost.localdomain> <CAEx9m47DFKxUQP6k6qdei1FpPe17hyGGGxZNbANZPiK9qrKoxw@mail.gmail.com>
 <20130930204738.GB27490@localhost.localdomain> <CAEx9m46QXYSHjCAF3enUom__SwR8vDNsw_qmzFqXZPnPwxF_1w@mail.gmail.com>
 <20131001173416.GF27490@localhost.localdomain> <CAEx9m47fk2zwpAdPq2gFx1Y5DDV9rqtWzo=QxmCUgeTS83fBOQ@mail.gmail.com>
 <CAEx9m4649eJR0kAXRoQx9myUw+8ZBXi71pm3aYRsquZ69+ULZA@mail.gmail.com>
 <CAEx9m46UY3HiTgO-mt8x2Ykj=jn3_Sf=4SCSdJTwAHS0BfLkwQ@mail.gmail.com> <20131002115222.GC2562@localhost.localdomain>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Wed, 2 Oct 2013 22:12:20 +0200
Message-ID: <CAEx9m46z0U0bfPMSF-pwOfkXP01EaA-qyNkaW=O2esjaDt3ciw@mail.gmail.com>
Subject: Re: Questions regarding logging upon fsync in btrfs
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2 October 2013 13:52, Josef Bacik <jbacik@fusionio.com> wrote:
> On Tue, Oct 01, 2013 at 10:13:25PM +0200, Aastha Mehta wrote:
>> On 1 October 2013 21:42, Aastha Mehta <aasthakm@gmail.com> wrote:
>> > On 1 October 2013 21:40, Aastha Mehta <aasthakm@gmail.com> wrote:
>> >> On 1 October 2013 19:34, Josef Bacik <jbacik@fusionio.com> wrote:
>> >>> On Mon, Sep 30, 2013 at 11:07:20PM +0200, Aastha Mehta wrote:
>> >>>> On 30 September 2013 22:47, Josef Bacik <jbacik@fusionio.com> wrote:
>> >>>> > On Mon, Sep 30, 2013 at 10:30:59PM +0200, Aastha Mehta wrote:
>> >>>> >> On 30 September 2013 22:11, Josef Bacik <jbacik@fusionio.com> wrote:
>> >>>> >> > On Mon, Sep 30, 2013 at 09:32:54PM +0200, Aastha Mehta wrote:
>> >>>> >> >> On 29 September 2013 15:12, Josef Bacik <jbacik@fusionio.com> wrote:
>> >>>> >> >> > On Sun, Sep 29, 2013 at 11:22:36AM +0200, Aastha Mehta wrote:
>> >>>> >> >> >> Thank you very much for the reply. That clarifies a lot of things.
>> >>>> >> >> >>
>> >>>> >> >> >> I was trying a small test case that opens a file, writes a block of
>> >>>> >> >> >> data, calls fsync and then closes the file. If I understand correctly,
>> >>>> >> >> >> fsync would return only after all in-memory buffers have been
>> >>>> >> >> >> committed to disk. I have added few print statements in the
>> >>>> >> >> >> __extent_writepage function, and I notice that the function gets
>> >>>> >> >> >> called a bit later after fsync returns. It seems that I am not
>> >>>> >> >> >> guaranteed to see the data going to disk by the time fsync returns.
>> >>>> >> >> >>
>> >>>> >> >> >> Am I doing something wrong, or am I looking at the wrong place for
>> >>>> >> >> >> disk write? This happens both with tree logging enabled as well as
>> >>>> >> >> >> with notreelog.
>> >>>> >> >> >>
>> >>>> >> >> >
>> >>>> >> >> > So 3.1 was a long time ago and to be sure it had issues I don't think it was
>> >>>> >> >> > _that_ broken.  You are probably better off instrumenting a recent kernel, 3.11
>> >>>> >> >> > or just build btrfs-next from git.  But if I were to make a guess I'd say that
>> >>>> >> >> > __extent_writepage was how both data and metadata was written out at the time (I
>> >>>> >> >> > don't think I changed it until 3.2 or something later) so what you are likely
>> >>>> >> >> > seeing is the normal transaction commit after the fsync.  In the case of
>> >>>> >> >> > notreelog we are likely starting another transaction and you are seeing that
>> >>>> >> >> > commit (at the time the transaction kthread would start a transaction even if
>> >>>> >> >> > none had been started yet.)  Thanks,
>> >>>> >> >> >
>> >>>> >> >> > Josef
>> >>>> >> >>
>> >>>> >> >> Is there any special handling for very small file write, less than 4K? As
>> >>>> >> >> I understand there is an optimization to inline the first extent in a file if
>> >>>> >> >> it is smaller than 4K, does it affect the writeback on fsync as well? I did
>> >>>> >> >> set the max_inline mount option to 0, but even then it seems there is
>> >>>> >> >> some difference in fsync behaviour for writing first extent of less than 4K
>> >>>> >> >> size and writing 4K or more.
>> >>>> >> >>
>> >>>> >> >
>> >>>> >> > Yeah if the file is an inline extent then it will be copied into the log
>> >>>> >> > directly and the log will be written out, no going through the data write path
>> >>>> >> > at all.  Max inline == 0 should make it so we don't inline, so if it isn't
>> >>>> >> > honoring that then that may be a bug.  Thanks,
>> >>>> >> >
>> >>>> >> > Josef
>> >>>> >>
>> >>>> >> I tried it on 3.12-rc2 release, and it seems there is a bug then.
>> >>>> >> Please find attached logs to confirm.
>> >>>> >> Also, probably on the older release.
>> >>>> >>
>> >>>> >
>> >>>> > Oooh ok I understand, you have your printk's in the wrong place ;).
>> >>>> > do_writepages doesn't necessarily mean you are writing something.  If you want
>> >>>> > to see if stuff got written to the disk I'd put a printk at run_delalloc_range
>> >>>> > and have it spit out the range it is writing out since thats what we think is
>> >>>> > actually dirty.  Thanks,
>> >>>> >
>> >>>> > Josef
>> >>>>
>> >>>> No, but I also placed dump_stack() in the beginning of
>> >>>> __extent_writepage. run_delalloc_range is being called only from
>> >>>> __extent_writepage, if it were to be called, the dump_stack() at the
>> >>>> top of __extent_writepage would have printed as well, no?
>> >>>>
>> >>>
>> >>> Ok I've done the same thing and I'm not seeing what you are seeing.  Are you
>> >>> using any mount options other than notreelog and max_inline=0?  Could you adjust
>> >>> your printk to print out the root objectid for the inode as well?  It could be
>> >>> possible that this is the writeout for the space cache or inode cache.  Thanks,
>> >>>
>> >>> Josef
>> >>
>> >> I actually printed the stack only when the root objectid is 5. I have
>> >> attached another log for writing the first 500 bytes in a file. I also
>> >> print the root objectid for the inode in run_delalloc and
>> >> __extent_writepage.
>> >>
>> >> Thanks
>> >>
>> >
>> > Just to clarify, in the latest logs, I allowed printing of debug
>> > printk's and stack dump for all root objectid's.
>>
>> Actually, it is the same behaviour when I write anything less than 4K
>> long, no matter what offset, except if I straddle the page boundary.
>> To summarise:
>> 1. write 4K -> write in the fsync path
>> 2. write less than 4K, within a single page -> bdi_writeback by flush worker
>> 3. small write that straddles a page boundary or write 4K+delta -> the
>> first page gets written in the fsync path, the remaining length that
>> straddles the page boundary is written in the bdi_writeback path
>>
>> Please let me know, if I am trying out incorrect cases.
>>
>> Sorry for too many mails.
>>
>
> This has been bugging me so much I was dreaming about it and now here I am
> writing an email at 4:45 in the morning ;).  So I couldn't reproduce earlier
> with any of these scenarios and then I realized something, I'm doing something
> like this
>
> xfs_io -f -c "pwrite 0 54" -c "fsync" /mnt/btrfs-test/foo
>
> and it is working perfectly.  But I bet what you are doing is something like
> this
>
> file = fopen("/mnt/btrfs-test/foo");
> fwrite(buf, 54, 1, file);
> fsync(fileno(file));
> fclose(file);
>
> right?  Please say yes :).  If this is the case then it is likely that these
> small writes are getting buffered in the userspace buffering that comes with
> fwrite, and so when you fsync it is only flushing the data that is actually in
> the kernel, not what is buffered in userspace.  Then when you fclose it flushes
> what is in the userspace buffers out to the kernel and then later on the
> background writer comes in and writes out the dirty data.  To fix this you want
> to do fflush() and then fsync().  Hopefully that is what you are doing and I can
> go back to sleep, thanks,
>
> Josef

Indeed!! :)

I did mention I am using f* version of the POSIX API. Sorry for the
confusion. Calling fflush before fsync seems to write everything
perfectly. It works even without notreelog option, as it should have.
I was under the misconception that fflush and fsync do the same thing.

Thanks a lot for your quick help.

Regards,

-- 
Aastha Mehta
MPI-SWS, Germany
E-mail: aasthakm@mpi-sws.org
