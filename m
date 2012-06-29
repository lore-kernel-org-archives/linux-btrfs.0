Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37119 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2F2O3C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 10:29:02 -0400
Received: by dady13 with SMTP id y13so4448603dad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 07:29:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1E782A38-6632-406F-A5BB-D42E78F5AAE3@richardcooper.net>
References: <B53F1BEB-C285-4A01-A61A-4B324CB6FA7F@richardcooper.net>
	<CAG1y0seoS2c7d=jQgrZNF0aAJPrgTKbL1v6JzFigCk9ZMZ7H+w@mail.gmail.com>
	<1E782A38-6632-406F-A5BB-D42E78F5AAE3@richardcooper.net>
Date: Fri, 29 Jun 2012 21:29:02 +0700
Message-ID: <CAG1y0seDT6Ldn5kdmSOZwyjwnPdORMfS5GLr_7c-MEOWX=9NzA@mail.gmail.com>
Subject: Re: Kernel panic from "btrfs subvolume delete"
From: "Fajar A. Nugraha" <list@fajar.net>
To: Richard Cooper <richard@richardcooper.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 9:23 PM, Richard Cooper
<richard@richardcooper.net> wrote:
>>> If so, how?
>>
>> https://blogs.oracle.com/linux/entry/oracle_unbreakable_enterprise_kernel_release
>> http://elrepo.org/tiki/kernel-ml
>
> Perfect, thank you! I was looking for a mainline kernel yum repo but my google-fu was failing me. That looks like just what I need.
>
> I've installed kernel v3.4.4 from http://elrepo.org/tiki/kernel-ml and that seems to have fixed my kernel panic. I'm still using the default Cent OS 6 versions of the btrfs userspace programs (v0.19). Any reason why that might be a bad idea?

At the very least, newer version of btrfsck has --repair, which you
might need later in the future.
There's also features lke forcing a certain compression (e.g. zlib) on
a file as part of "btrfs filesystem defrag" command.

Just grab updated btrfs-progs (or whatever it's called) from Oracle's repo.

-- 
Fajar
