Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbbA2Moj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Jan 2015 07:44:39 -0500
Date: Thu, 29 Jan 2015 13:44:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Pavel Volkov <sailor@lists.xtsubasa.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Linux documentation: btrfs.txt
Message-ID: <20150129124437.GK3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d39d1736-4e2a-49cd-b6ef-5fdcab90bcaa@lists.xtsubasa.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d39d1736-4e2a-49cd-b6ef-5fdcab90bcaa@lists.xtsubasa.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 28, 2015 at 08:04:39PM +0300, Pavel Volkov wrote:
> In my 3.18.3 sources the file at Documentation/filesystems/btrfs.txt says:
> 
> "Btrfs is under heavy development, and is not suitable for
> any uses other than benchmarking and review. The Btrfs disk format is
> not yet finalized."
> 
> btrfs is no longer marked experimental in kernel and the file format is 
> stable. It is suited for general use except some features.
> Maybe it's time to update btrfs.txt?

Yeah, the text hasn't been changed since 2009 and we've missed it during
the dangerous & experimental label removal. Thanks.
