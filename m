Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:58909 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3FTIry (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 04:47:54 -0400
Received: by mail-vc0-f176.google.com with SMTP id ha12so4584011vcb.35
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 01:47:53 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 20 Jun 2013 10:47:53 +0200
Message-ID: <CAFvQSYRgvsqMxk_yZf6cPyoECJsUzn2g+cW-j7ktrWnhRL+0jA@mail.gmail.com>
Subject: Two identical copies of an image mounted result in changes to both
 images if only one is modified
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've observed a rather strange behaviour while trying to mount two
identical copies of the same image to different mount points.
Each modification to one image is also performed in the second one.

Example:
dd if=/dev/sda? of=image1 bs=1M
cp image1 image2
mount -o loop image1 m1
mount -o loop image2 m2

touch m2/hello
ls -la m1  //will now also include a file calles "hello"

Is this behaviour intentional and known or should I create a bug-report?
I've deleted quite a bunch of files on my production system because of this...

Thanks, Clemens
