Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:64482 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3HMQDe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 12:03:34 -0400
Received: by mail-oa0-f42.google.com with SMTP id i18so11740005oag.15
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 09:03:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130813141542.GF2150@localhost.localdomain>
References: <CAKcLGm_DXiwJrAMYG66ZiEmXtSKe0z0LUPfxat0Repb0jfDnNA@mail.gmail.com>
	<20130813141542.GF2150@localhost.localdomain>
Date: Tue, 13 Aug 2013 11:03:33 -0500
Message-ID: <CAKcLGm99PdyuurtmA6_ZW1PQOaH4piQSK-VYQMT-0PJkgDf-Yw@mail.gmail.com>
Subject: Re: Kernel BUG on Snapshot Deletion (3.11.0-rc5)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Let me work on making that script more portable, and hopefully quicker
to reproduce.

On Tue, Aug 13, 2013 at 9:15 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Aug 12, 2013 at 11:06:27PM -0500, Mitch Harder wrote:
>> I'm hitting a btrfs Kernel BUG running a snapshot stress script with
>> linux-3.11.0-rc5.
>>
>
> I can haz script?  Thanks,
>
> Josef
