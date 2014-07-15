Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3603 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752536AbaGORng (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Jul 2014 13:43:36 -0400
Message-ID: <53C5673F.6010702@fb.com>
Date: Tue, 15 Jul 2014 13:39:11 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Morten Stevens <mstevens@fedoraproject.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs kernel workqueues performance regression
References: <CAKSJeFKteZNUnJmN3dnYaHLnayQhZNNTKX5co_smMqwy1JgQNA@mail.gmail.com>
In-Reply-To: <CAKSJeFKteZNUnJmN3dnYaHLnayQhZNNTKX5co_smMqwy1JgQNA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/15/2014 11:26 AM, Morten Stevens wrote:
> Hi,
> 
> I see that btrfs is using kernel workqueues since linux 3.15. After
> some tests I noticed performance regressions with fs_mark.
> 
> mount options: rw,relatime,compress=lzo,space_cache
> 
> fs_mark on Kernel 3.14.9:
> 
> # fs_mark  -d  /mnt/btrfs/fsmark  -D  512  -t  16  -n  4096  -s  51200  -L5  -S0
> FSUse%        Count         Size    Files/sec     App Overhead
>      1        65536        51200      17731.4           723894
>      1       131072        51200      16832.6           685444
>      1       196608        51200      19604.5           652294
>      1       262144        51200      18663.6           630067
>      1       327680        51200      20112.2           692769
> 
> The results are really nice! compress=lzo performs very good.
> 
> fs_mark after upgrading to Kernel 3.15.4:
> 
> # fs_mark  -d  /mnt/btrfs/fsmark  -D  512  -t  16  -n  4096  -s  51200  -L5  -S0
> FSUse%        Count         Size    Files/sec     App Overhead
>      0        65536        51200      10718.1           749540
>      0       131072        51200       8601.2           853050
>      0       196608        51200      11623.2           558546
>      0       262144        51200      11534.2           536342
>      0       327680        51200      11167.4           578562
> 
> That's really a big performance regression :(
> 
> What do you think? It's easy to reproduce with fs_mark.

I wasn't able to trigger regressions here when we first merged it, but I
was sure that something would pop up.  fs_mark is sensitive to a few
different factors outside just the worker threads, so it could easily be
another change as well.

With 16 threads, the btree locking also has a huge impact, and we've
made change there too.

I'll reproduce here, thanks for sending it in.

-chris


