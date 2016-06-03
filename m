Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:40502 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbcFCKBN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 06:01:13 -0400
Subject: Re: Recommended why to use btrfs for production?
To: Martin <rc6encrypted@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <57515566.5050809@mendix.com>
Date: Fri, 3 Jun 2016 12:01:10 +0200
MIME-Version: 1.0
In-Reply-To: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

On 06/03/2016 11:49 AM, Martin wrote:
>
> We would like to use urBackup to make laptop backups, and they mention
> btrfs as an option.
>
> [...]
>
> And a bonus question: How stable is raid6 and detecting and replacing
> failed drives?

Before trying RAID5/6 in production, be sure to read posts like these:

http://www.spinics.net/lists/linux-btrfs/msg55642.html

o/

Hans van Kranenburg
