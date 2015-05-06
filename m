Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbbEFIgv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 04:36:51 -0400
Message-ID: <5549D20F.1030607@oracle.com>
Date: Wed, 06 May 2015 16:34:23 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com> <5549CCD8.2010000@cn.fujitsu.com>
In-Reply-To: <5549CCD8.2010000@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks Qu for confirming it working in 4.x. It put me on my toes
for a while, and I am still upgrading my ws.


On 05/06/2015 04:12 PM, Qu Wenruo wrote:
> Works for me.
> Although with a lot of annoying extra missing device warning:

Yep. Its from 915902c5002485fb13d27c4b699a73fb66cc0f09
after various objections I made it still got in.

