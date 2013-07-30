Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40586 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3G3CHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 22:07:20 -0400
Date: Tue, 30 Jul 2013 10:07:06 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Online data deduplication
Message-ID: <20130730020705.GA32721@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAG_LFoDN2bsvfyE_FY9yvyFMLDeUDpB6FkaSy81PU02dvfAdKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG_LFoDN2bsvfyE_FY9yvyFMLDeUDpB6FkaSy81PU02dvfAdKw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 29, 2013 at 09:05:42PM +0530, Hemanth Kumar wrote:
> Hello,
> I am willing to perform QA on online data deduplication. From where
> can i download the patches?

Hi Hemanth Kumar H C,

I really appreciate this :)

Right now I'm planning v5 version patch set, which will come out probably in
this week(Only one bug is left on my hands)

v5 version will have a big change on disk format, performance, btw.

For v4 you can find it in the following url:
https://patchwork.kernel.org/patch/2565601/
https://patchwork.kernel.org/patch/2565591/

thanks,
-liubo
