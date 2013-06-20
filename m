Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40728 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3FTJLq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 05:11:46 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj3so6114727pad.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 02:11:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
References: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
Date: Thu, 20 Jun 2013 16:11:45 +0700
Message-ID: <CAG1y0sffFzSZY_VxE4PkKZp2ZowNtkcb9xzgAb9Fwj=1BX0X+g@mail.gmail.com>
Subject: Re: Two identical copies of an image mounted result in changes to
 both images if only one is modified
From: "Fajar A. Nugraha" <list@fajar.net>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 20, 2013 at 3:47 PM, Clemens Eisserer <linuxhippy@gmail.com> wrote:
> Hi,
>
> I've observed a rather strange behaviour while trying to mount two
> identical copies of the same image to different mount points.
> Each modification to one image is also performed in the second one.
>
> Example:
> dd if=/dev/sda? of=image1 bs=1M
> cp image1 image2
> mount -o loop image1 m1
> mount -o loop image2 m2
>
> touch m2/hello
> ls -la m1  //will now also include a file calles "hello"

What do you get if you unmount BOTH m1 and m2, and THEN mount m1
again? Is the file still there?

>
> Is this behaviour intentional and known or should I create a bug-report?
> I've deleted quite a bunch of files on my production system because of this...

I'm pretty sure this is a known behavior in btrfs.
http://markmail.org/message/i522sdkrhlxhw757#query:+page:1+mid:ksdi5d4v26eqgxpi+state:results

-- 
Fajar
