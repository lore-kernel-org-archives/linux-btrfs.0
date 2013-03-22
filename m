Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52106 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3CVGYT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Mar 2013 02:24:19 -0400
Received: by mail-ie0-f173.google.com with SMTP id 9so4472166iec.18
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 23:24:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130322121356.237e57e8@natsu>
References: <514ABEB8.3090104@profihost.ag>
	<20130321180020.30044.84729@localhost.localdomain>
	<967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag>
	<20130321190249.30044.79438@localhost.localdomain>
	<514B62A4.1030201@profihost.ag>
	<20130322121356.237e57e8@natsu>
Date: Fri, 22 Mar 2013 00:24:18 -0600
Message-ID: <CAE5mzvizzxotHP2OikoBZ1+OuHm_WBgMVHuWnm+Unr+DfAfXxQ@mail.gmail.com>
Subject: Re: No space left on device (28)
From: cwillu <cwillu@cwillu.com>
To: Roman Mamedov <rm@romanrm.ru>, Stefan Priebe <s.priebe@profihost.ag>
Cc: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 22, 2013 at 12:13 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Thu, 21 Mar 2013 20:42:28 +0100
> Stefan Priebe <s.priebe@profihost.ag> wrote:
>
> I might be wrong here, but doesn't this
>
>> rsync: rename
>> "/mnt/.software/kernel/linux-3.9-rc3/drivers/infiniband/hw/amso1100/""
>> ->
>> ".software/kernel/linux-3.9-rc3/drivers/infiniband/hw/amso1100/c2_ae.h":
>
> ...try to move a file from
>
>   "/mnt/.software/"
>
> to
>
>   ".software/"
>
> (relative to current dir)??

No; that's rsync giving the full path, and then the target path
relative to the command it was given.  The filename itself
(".c2_ae.h.WEhLGP") is a semi-random filename rsync uses to write to
temporarily, so it can mv it over the original in an atomic fashion...

Stefan: ...which means that the actual copy succeeded, which suggests
that this is more of a metadata enospc thing.

You might try btrfs balance start -musage=5 (instead of -dusage), and
if that doesn't report any chunks balanced, try a high number until it
does.
