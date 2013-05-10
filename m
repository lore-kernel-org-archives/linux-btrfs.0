Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc1-s15.bay0.hotmail.com ([65.54.190.26]:32049 "EHLO
	bay0-omc1-s15.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861Ab3EJN57 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 May 2013 09:57:59 -0400
Message-ID: <BAY172-DS77BDBEADA4D3971B47F29B0A50@phx.gbl>
From: "Kyle Gates" <kylegates@hotmail.com>
To: <bo.li.liu@oracle.com>
Cc: <linux-btrfs@vger.kernel.org>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com> <h1rh5a-1lg.ln1@hurikhan.ath.cx> <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com> <BAY172-DS142AB5E40D200CC3946388B0A40@phx.gbl> <20130510051500.GB5615@liubo.jp.oracle.com>
In-Reply-To: <20130510051500.GB5615@liubo.jp.oracle.com>
Subject: Re: nocow 'C' flag ignored after balance
Date: Fri, 10 May 2013 08:58:17 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 10, 2013 Liu Bo wrote:
> On Thu, May 09, 2013 at 03:41:49PM -0500, Kyle Gates wrote:
>> I'll preface that I'm running Ubuntu 13.04 with the standard 3.8
>> series kernel so please disregard if this has been fixed in higher
>> versions. This is on a btrfs RAID1 with 3 then 4 disks.
>>
>> My use case is to set the nocow 'C' flag on a directory and copy in
>> some files, then make lots of writes (same file sizes) and note that
>> the number of extents stays the same, good.
>> Then run a balance (I added a disk) and start making writes again,
>> now the number of extents starts climbing, boo.
>> Is this standard behavior? I realize a balance will cow the files.
>> Are they also being checksummed thereby breaking the nocow flag?
>>
>> I have made no snapshots and made no writes to said files while the
>> balance was running.
>
> Hi Kyle,
>
> It's hard to say if it's standard, it is a side effect casued by balance.
>
> During balance, our reloc root works like a snapshot, so we set
> last_snapshot on the fs root, and this makes new nocow writes think that
> we have to do cow as the extent is created before taking snapshot.
>
> But the nocow 'C' flag on the file is still there, if you make new
> writes on the new extent after balance, you still get the same number of
> extents.
>
> thanks,
> liubo

Thank you for the explanation.
On my machine this didn't happen however. IIRC one 10GiB file had 24 extents 
before balance, 26 extents after balance, and 1000+ and growing when I 
checked the following day.
I'll add that I am running a relatively recent version of btrfs-tools from a 
ppa. 

