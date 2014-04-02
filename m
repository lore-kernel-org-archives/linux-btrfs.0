Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28320 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758708AbaDBNYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Apr 2014 09:24:25 -0400
Message-ID: <533C0F7A.7010004@fb.com>
Date: Wed, 2 Apr 2014 09:24:10 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/02/2014 04:29 AM, Qu Wenruo wrote:
> Convert the old btrfs man pages to new asciidoc and split the huge
> btrfs man page into subcommand man page.
>
> The asciidoc style and Makefile things are mostly simplified from git
> Documentation, which only supports man page output and remove html output,
> since html output is somewhat overkilled for btrfs.

Thanks for doing this.  I've never liked roff, but I'll give people on 
the list a chance to complain before taking this one.

-chris
