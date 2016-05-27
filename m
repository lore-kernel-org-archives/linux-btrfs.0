Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36030 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483AbcE0SM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 14:12:56 -0400
Received: by mail-oi0-f41.google.com with SMTP id j1so185896139oih.3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 11:12:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1970914.zjZ5YKPDft@whitehead.beowulf.uwo.ca>
References: <1970914.zjZ5YKPDft@whitehead.beowulf.uwo.ca>
Date: Fri, 27 May 2016 12:12:54 -0600
Message-ID: <CAJCQCtTcns_Oq=ku2zx_Dhm8hbfJBDzj57ybDLDZ2=fQ1W0Vow@mail.gmail.com>
Subject: Re: Scrub aborts on newer kernels
From: Chris Murphy <lists@colorremedies.com>
To: Tyson Whitehead <twhitehead@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 11:55 AM, Tyson Whitehead <twhitehead@gmail.com> wrote:
> Under the last several kernels versions (4.6 and I believe 4.4 and, 4.5) btrfs scrub aborts before completing.

I can't reproduce this with btrfs-progs 4.5.2 and kernel 4.6.0.

I think the bigger issue is the lack of information why a scrub is aborted.



-- 
Chris Murphy
