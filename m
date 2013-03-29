Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:61438 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3C2N35 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 09:29:57 -0400
Received: by mail-ve0-f170.google.com with SMTP id 15so539275vea.29
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2013 06:29:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130329132603.GD1876@localhost.localdomain>
References: <515563D7.3020706@petaramesh.org>
	<20130329125832.GB1876@localhost.localdomain>
	<515591D9.5010802@petaramesh.org>
	<20130329132603.GD1876@localhost.localdomain>
Date: Fri, 29 Mar 2013 07:29:56 -0600
Message-ID: <CAE5mzviWOBbiRE4pS+QH++Xji0m-2sMppDSRBq0d5dFWtAhRwQ@mail.gmail.com>
Subject: Re: scrub "correcting" tons of errors ?
From: cwillu <cwillu@cwillu.com>
To: Josef Bacik <jbacik@fusionio.com>,
        =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Actually instead of netconsole we have an awesome service provided by Carey, you
> can just do
>
> nc cwillu.com 10101 < /dev/kmsg

... at a root prompt.

> after you've run sysrq+w and then reply with the URL it spits out.  Thanks,
