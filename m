Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35270 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbcCLBUO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Mar 2016 20:20:14 -0500
Received: by mail-io0-f175.google.com with SMTP id g203so166031115iof.2
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Mar 2016 17:20:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD=QJKi7=R92UP4PKH4UAYH1HUB0Pr8DwO+MsyLNamKryYuZVA@mail.gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
	<pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
	<CAD=QJKjkzh4U5Gmp=PJMiR8w3by12BVCDZ+MN2S+Ekk_EksjAg@mail.gmail.com>
	<CAD=QJKi7=R92UP4PKH4UAYH1HUB0Pr8DwO+MsyLNamKryYuZVA@mail.gmail.com>
Date: Fri, 11 Mar 2016 18:20:13 -0700
Message-ID: <CAJCQCtR60t=XN1vXaRoMA_YBAy=jje6ns9EoUO1wG_+Zk02LZw@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Chris Murphy <lists@colorremedies.com>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 11, 2016 at 5:10 PM, Nicholas D Steeves <nsteeves@gmail.com> wrote:
> P.S. Rather than parity, I mean instead of distributing into stripes, do a copy!

raid56 by definition are parity based, so I'd say no that's confusing
to turn it into something it's not.

-- 
Chris Murphy
