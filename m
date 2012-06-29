Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41675 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab2F2Km1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 06:42:27 -0400
Received: by dady13 with SMTP id y13so4206127dad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 03:42:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B53F1BEB-C285-4A01-A61A-4B324CB6FA7F@richardcooper.net>
References: <B53F1BEB-C285-4A01-A61A-4B324CB6FA7F@richardcooper.net>
Date: Fri, 29 Jun 2012 17:42:26 +0700
Message-ID: <CAG1y0seoS2c7d=jQgrZNF0aAJPrgTKbL1v6JzFigCk9ZMZ7H+w@mail.gmail.com>
Subject: Re: Kernel panic from "btrfs subvolume delete"
From: "Fajar A. Nugraha" <list@fajar.net>
To: Richard Cooper <richard@richardcooper.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 5:11 PM, Richard Cooper
<richard@richardcooper.net> wrote:
> Hi All,
>
> I have two machines where I've been testing various btrfs based backup strategies. They are both Cent OS 6 with the standard kernel and btrfs-progs RPMs from the CentOS repos.
>
> - kernel-2.6.32-220.17.1.el6.x86_64
> - btrfs-progs-0.19-12.el6.x86_64

In btrfs terms, 2.6.32 is ... stone age :P

> What should I do now? Do I need to upgrade to a more recent btrfs?

Yep

> If so, how?

https://blogs.oracle.com/linux/entry/oracle_unbreakable_enterprise_kernel_release
http://elrepo.org/tiki/kernel-ml

-- 
Fajar
