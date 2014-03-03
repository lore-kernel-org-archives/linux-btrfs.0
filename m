Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:52622 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaCCSDu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Mar 2014 13:03:50 -0500
Received: by mail-qc0-f170.google.com with SMTP id c9so4187953qcz.15
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Mar 2014 10:03:49 -0800 (PST)
MIME-Version: 1.0
Reply-To: madthanu@gmail.com
In-Reply-To: <5314BF28.5040209@fb.com>
References: <CAJ6LpRpbKyETTOicfXjTXe15u0pqwe7rMkLcAUKrH1xyHOB1Vw@mail.gmail.com>
 <5314BF28.5040209@fb.com>
From: thanumalayan mad <madthanu@gmail.com>
Date: Mon, 3 Mar 2014 11:56:49 -0600
Message-ID: <CAJ6LpRoe8mA2QPrKK3zmeFqF07Va2DLbCiQeyOuZ+HpCAZ4OCQ@mail.gmail.com>
Subject: Re: Ordering of directory operations maintained across system crashes
 in Btrfs?
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Great, thanks. Any guesses whether other filesystems (disk-based) do
things similar to the last two examples you pointed out? Saying "we
think 3 normal filesystems reorder stuff" seems to motivate
application developers to fix bugs ...

Also, just for more information, the sequence we observed was,

Thread A:

unlink(foo)
rename(somefile X, somefile Y)
fsync(somefile Z)

The source and destination of the renamed file are unrelated to the
fsync. But the rename happens in the fsync()'s transaction, while
unlink() is delayed. I guess this has something to do with backrefs
too.

Thanks,
Thanu

On Mon, Mar 3, 2014 at 11:43 AM, Chris Mason <clm@fb.com> wrote:
> On 02/25/2014 09:01 PM, thanumalayan mad wrote:
>>
>> Hi all,
>>
>> Slightly complicated question.
>>
>> Assume I do two directory operations in a Btrfs partition (such as an
>> unlink() and a rename()), one after the other, and a crash happens
>> after the rename(). Can Btrfs (the current version) send the second
>> operation to the disk first, so that after the crash, I observe the
>> effects of rename() but not the effects of the unlink()?
>>
>> I think I am observing Btrfs re-ordering an unlink() and a rename(),
>> and I just want to confirm that my observation is true. Also, if Btrfs
>> does send directory operations to disk out of order, is there some
>> limitation on this? Like, is this restricted to only unlink() and
>> rename()?
>>
>> I am looking at some (buggy) applications that use Btrfs, and this
>> behavior seems to affect them.
>
>
> There isn't a single answer for this one.
>
> You might have
>
> Thread A:
>
> ulink(foo);
> rename(somefile, somefile2);
> <crash>
>
> This should always have the rename happen before or in the same transaction
> as the rename.
>
> Thread A:
>
> ulink(dirA/foo);
> rename(dirB/somefile, dirB/somefile2);
>
> Here you're at the mercy of what is happening in dirB.  If someone fsyncs
> that directory, it may hit the disk before the unlink.
>
> Thread A:
>
> ulink(foo);
> rename(somefile, somefile2);
> fsync(somefile);
>
> This one is even fuzzier.  Backrefs allow us to do some file fsyncs without
> touching the directory, making it possible the unlink will hit disk after
> the fsync.
>
> -chris
>
>
>
>
