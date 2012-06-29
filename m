Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:38332 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab2F2OYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 10:24:43 -0400
Received: from mac-mini.config (87-194-60-202.bethere.co.uk [87.194.60.202])
	by smtp.webfaction.com (Postfix) with ESMTP id 3D573211F83C
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 09:23:15 -0500 (CDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1084)
Subject: Re: Kernel panic from "btrfs subvolume delete"
From: Richard Cooper <richard@richardcooper.net>
In-Reply-To: <CAG1y0seoS2c7d=jQgrZNF0aAJPrgTKbL1v6JzFigCk9ZMZ7H+w@mail.gmail.com>
Date: Fri, 29 Jun 2012 15:23:13 +0100
Message-Id: <1E782A38-6632-406F-A5BB-D42E78F5AAE3@richardcooper.net>
References: <B53F1BEB-C285-4A01-A61A-4B324CB6FA7F@richardcooper.net> <CAG1y0seoS2c7d=jQgrZNF0aAJPrgTKbL1v6JzFigCk9ZMZ7H+w@mail.gmail.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 29 Jun 2012, at 11:42, Fajar A. Nugraha wrote:
>> What should I do now? Do I need to upgrade to a more recent btrfs?
> 
> Yep
> 
>> If so, how?
> 
> https://blogs.oracle.com/linux/entry/oracle_unbreakable_enterprise_kernel_release
> http://elrepo.org/tiki/kernel-ml

Perfect, thank you! I was looking for a mainline kernel yum repo but my google-fu was failing me. That looks like just what I need.

I've installed kernel v3.4.4 from http://elrepo.org/tiki/kernel-ml and that seems to have fixed my kernel panic. I'm still using the default Cent OS 6 versions of the btrfs userspace programs (v0.19). Any reason why that might be a bad idea?

Thanks again,

- Rich