Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38665 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889Ab2JCRqr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 13:46:47 -0400
Received: by wibhr7 with SMTP id hr7so2794894wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 10:46:45 -0700 (PDT)
Date: Wed, 3 Oct 2012 20:46:43 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
Message-ID: <20121003174643.GB2890@zambezi.lan>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
 <20121003150117.GA1978@zambezi.lan>
 <506C6BC8.5050809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <506C6BC8.5050809@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 06:46:00PM +0200, Goffredo Baroncelli wrote:
> On 10/03/2012 05:01 PM, Ilya Dryomov wrote:
> >"Type" for the first column is probably enough.
> >
> >Why is the third column called Chunk-size?  If my understanding is
> >correct, it's just a break down of Disk_allocated from the summary
> >section.  If so, why not call it Disk_allocated to avoid confusion?
> 
> Using everywhere Disk_<something> was my first attempt. But after
> some thoughts I decided that these are two different kind of
> information. It is true that Disk_allocated is the sum of
> Chunk-Sizes... But my feels is that this is a kind of
> "implementation details". If some other type of allocation unit will
> be added to BTRFS, then these will be added to Disk_allocated, but
> not to Chunk list...
> I prefer to not change the wording until an enough critical mass of
> people converge to a unique solution .

It is the chunks that is the implementation detail that we want to hide.
Average Btrfs user wouldn't want to know anything about chunks, the only
thing he'd be interested in is Disk_allocated and similar fields.

Moreover, I am pretty sure "Chunk-Size" would actually confuse people.
I stared at your example output for a few seconds trying to comprehend a
21GB Chunk-Size on a 72GB partition.  What you call "Chunk-Size" is
actually a sum of sizes of chunks of that particular type, and a few
lines above you call the same exact sum (only this time over all types
of chunks) "Disk_allocated".  So I think it's only logical to rename the
column in question to "Disk_allocated" to match the summary section.

Thanks,

		Ilya
