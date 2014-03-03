Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2850 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420AbaCCRjj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 12:39:39 -0500
Message-ID: <5314BF28.5040209@fb.com>
Date: Mon, 3 Mar 2014 12:43:04 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <madthanu@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Ordering of directory operations maintained across system crashes
 in Btrfs?
References: <CAJ6LpRpbKyETTOicfXjTXe15u0pqwe7rMkLcAUKrH1xyHOB1Vw@mail.gmail.com>
In-Reply-To: <CAJ6LpRpbKyETTOicfXjTXe15u0pqwe7rMkLcAUKrH1xyHOB1Vw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/25/2014 09:01 PM, thanumalayan mad wrote:
> Hi all,
>
> Slightly complicated question.
>
> Assume I do two directory operations in a Btrfs partition (such as an
> unlink() and a rename()), one after the other, and a crash happens
> after the rename(). Can Btrfs (the current version) send the second
> operation to the disk first, so that after the crash, I observe the
> effects of rename() but not the effects of the unlink()?
>
> I think I am observing Btrfs re-ordering an unlink() and a rename(),
> and I just want to confirm that my observation is true. Also, if Btrfs
> does send directory operations to disk out of order, is there some
> limitation on this? Like, is this restricted to only unlink() and
> rename()?
>
> I am looking at some (buggy) applications that use Btrfs, and this
> behavior seems to affect them.

There isn't a single answer for this one.

You might have

Thread A:

ulink(foo);
rename(somefile, somefile2);
<crash>

This should always have the rename happen before or in the same 
transaction as the rename.

Thread A:

ulink(dirA/foo);
rename(dirB/somefile, dirB/somefile2);

Here you're at the mercy of what is happening in dirB.  If someone 
fsyncs that directory, it may hit the disk before the unlink.

Thread A:

ulink(foo);
rename(somefile, somefile2);
fsync(somefile);

This one is even fuzzier.  Backrefs allow us to do some file fsyncs 
without touching the directory, making it possible the unlink will hit 
disk after the fsync.

-chris




