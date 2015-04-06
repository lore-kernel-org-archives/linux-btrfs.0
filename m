Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33547 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbbDFPpL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 11:45:11 -0400
Received: by ignm3 with SMTP id m3so21587547ign.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2015 08:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10997785.A11jaNpIP8@malu-aspire-v3-771>
References: <10997785.A11jaNpIP8@malu-aspire-v3-771>
Date: Mon, 6 Apr 2015 09:45:10 -0600
Message-ID: <CAJCQCtRLN8_Qe+0Hh0o-NCoc7KFWMu_wWbP8fObB3hq_xNgoFw@mail.gmail.com>
Subject: Re: recover corrupt BTRFS
From: Chris Murphy <lists@colorremedies.com>
To: Martin <develop@imagmbh.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 6, 2015 at 5:40 AM, Martin <develop@imagmbh.de> wrote:
> Hello!
>
> I have to recover a corrupt btrfs. The size is approx 4.5 TB. The fs became
> corrupt by failure of a hardware-raid.

What raid level? What kind of failure? What is the current raid
status? What was the mkfs.btrfs command used to create the file system
OR what is the current profile used for data and metadata?

-- 
Chris Murphy
