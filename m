Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:35617 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbcFMEvp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jun 2016 00:51:45 -0400
Received: by mail-lf0-f41.google.com with SMTP id u74so77291250lff.2
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 21:51:44 -0700 (PDT)
Subject: Re: dd on wrong device, 1.9 GiB from the beginning has been
 overwritten, how to restore partition?
To: Henk Slager <eye1tm@gmail.com>,
        =?UTF-8?Q?Maximilian_B=c3=b6hm?= <winlux@gmail.com>
References: <CACvw6BEt1bkXaB=G27beS+H1UcMVk-Fkko3s3Y08dq_CyNGP4g@mail.gmail.com>
 <CAPmG0jZxM65Fn3WsUMEO-EJ8oVEEW7DT=S09q2fLv8cXkoqUGA@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <575E3BDD.5000405@gmail.com>
Date: Mon, 13 Jun 2016 07:51:41 +0300
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZxM65Fn3WsUMEO-EJ8oVEEW7DT=S09q2fLv8cXkoqUGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

13.06.2016 01:49, Henk Slager пишет:
> On Sun, Jun 12, 2016 at 11:22 PM, Maximilian Böhm <winlux@gmail.com> wrote:
>> Hi there, I did something terribly wrong, all blame on me. I wanted to
>> write to an USB stick but /dev/sdc wasn't the stick in this case but
>> an attached HDD with GPT and an 8 TB btrfs partition…
> 
> GPT has a secondary copy at the end of the device, so maybe gdisk can
> reconstruct in first main one at the beginning of the disk, I don't
> know all gdisk commands. 

kernel should automatically fall back to secondary GPT if booted with
gpt=1 parameter. Otherwise it is 'x' for expert mode and 'b' to rebuild
primary GPT from secondary copy. Also 'c' to load partition information
from secondary (without writing anything). But note that kernel will
also check for valid PMBR (unless gpt is force with parameter mentioned
above), so you will need yet another 'x' to enter second expert mode and
'n' to create new protective MBR.


