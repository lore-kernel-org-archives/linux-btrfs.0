Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41145 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab3I3VHl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 17:07:41 -0400
Received: by mail-ie0-f174.google.com with SMTP id u16so11640642iet.33
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 14:07:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130930204738.GB27490@localhost.localdomain>
References: <CAEx9m45FDjNCBLEYM0x7fY36R7QJesS0F-fzWzNi=d_cBSOjOQ@mail.gmail.com>
 <20130929004252.GL18681@localhost.localdomain> <CAEx9m440QMtfkaZjc5Qgu6jv+TsejheKG5nVuYhAEe_vqgp0MQ@mail.gmail.com>
 <20130929131224.GM18681@localhost.localdomain> <CAEx9m47a_kXvsmOOvSud8ERycB-5D04Nu0ZTHgYzP8RtawBYgg@mail.gmail.com>
 <20130930201125.GA27490@localhost.localdomain> <CAEx9m47DFKxUQP6k6qdei1FpPe17hyGGGxZNbANZPiK9qrKoxw@mail.gmail.com>
 <20130930204738.GB27490@localhost.localdomain>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Mon, 30 Sep 2013 23:07:20 +0200
Message-ID: <CAEx9m46QXYSHjCAF3enUom__SwR8vDNsw_qmzFqXZPnPwxF_1w@mail.gmail.com>
Subject: Re: Questions regarding logging upon fsync in btrfs
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 30 September 2013 22:47, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Sep 30, 2013 at 10:30:59PM +0200, Aastha Mehta wrote:
>> On 30 September 2013 22:11, Josef Bacik <jbacik@fusionio.com> wrote:
>> > On Mon, Sep 30, 2013 at 09:32:54PM +0200, Aastha Mehta wrote:
>> >> On 29 September 2013 15:12, Josef Bacik <jbacik@fusionio.com> wrote:
>> >> > On Sun, Sep 29, 2013 at 11:22:36AM +0200, Aastha Mehta wrote:
>> >> >> Thank you very much for the reply. That clarifies a lot of things.
>> >> >>
>> >> >> I was trying a small test case that opens a file, writes a block of
>> >> >> data, calls fsync and then closes the file. If I understand correctly,
>> >> >> fsync would return only after all in-memory buffers have been
>> >> >> committed to disk. I have added few print statements in the
>> >> >> __extent_writepage function, and I notice that the function gets
>> >> >> called a bit later after fsync returns. It seems that I am not
>> >> >> guaranteed to see the data going to disk by the time fsync returns.
>> >> >>
>> >> >> Am I doing something wrong, or am I looking at the wrong place for
>> >> >> disk write? This happens both with tree logging enabled as well as
>> >> >> with notreelog.
>> >> >>
>> >> >
>> >> > So 3.1 was a long time ago and to be sure it had issues I don't think it was
>> >> > _that_ broken.  You are probably better off instrumenting a recent kernel, 3.11
>> >> > or just build btrfs-next from git.  But if I were to make a guess I'd say that
>> >> > __extent_writepage was how both data and metadata was written out at the time (I
>> >> > don't think I changed it until 3.2 or something later) so what you are likely
>> >> > seeing is the normal transaction commit after the fsync.  In the case of
>> >> > notreelog we are likely starting another transaction and you are seeing that
>> >> > commit (at the time the transaction kthread would start a transaction even if
>> >> > none had been started yet.)  Thanks,
>> >> >
>> >> > Josef
>> >>
>> >> Is there any special handling for very small file write, less than 4K? As
>> >> I understand there is an optimization to inline the first extent in a file if
>> >> it is smaller than 4K, does it affect the writeback on fsync as well? I did
>> >> set the max_inline mount option to 0, but even then it seems there is
>> >> some difference in fsync behaviour for writing first extent of less than 4K
>> >> size and writing 4K or more.
>> >>
>> >
>> > Yeah if the file is an inline extent then it will be copied into the log
>> > directly and the log will be written out, no going through the data write path
>> > at all.  Max inline == 0 should make it so we don't inline, so if it isn't
>> > honoring that then that may be a bug.  Thanks,
>> >
>> > Josef
>>
>> I tried it on 3.12-rc2 release, and it seems there is a bug then.
>> Please find attached logs to confirm.
>> Also, probably on the older release.
>>
>
> Oooh ok I understand, you have your printk's in the wrong place ;).
> do_writepages doesn't necessarily mean you are writing something.  If you want
> to see if stuff got written to the disk I'd put a printk at run_delalloc_range
> and have it spit out the range it is writing out since thats what we think is
> actually dirty.  Thanks,
>
> Josef

No, but I also placed dump_stack() in the beginning of
__extent_writepage. run_delalloc_range is being called only from
__extent_writepage, if it were to be called, the dump_stack() at the
top of __extent_writepage would have printed as well, no?

Thanks

-- 
Aastha Mehta
MPI-SWS, Germany
E-mail: aasthakm@mpi-sws.org
