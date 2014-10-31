Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:34504 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbaJaIfT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 04:35:19 -0400
Message-ID: <545349C4.2020104@pobox.com>
Date: Fri, 31 Oct 2014 01:35:16 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Zack Coffey <tech42.clickwir@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: RAID1 fails to recover chunk tree
References: <544FFD52.6010604@gmail.com> <5451699B.4020507@pobox.com> <54517338.7090606@pobox.com> <54523D86.5040906@gmail.com>
In-Reply-To: <54523D86.5040906@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2014 06:30 AM, Zack Coffey wrote:
> Rob, That second drive was immediately put to use elsewhere. I figured
> having only the metadata on that drive, it wouldn't matter. The data
> stayed single and wasn't part of the second drive, only the metadata
> was. I must not be capable of understanding why that wouldn't work.
>
> I thought all I was doing was removing a duplication of metadata and the
> worst I would see is a message complaining about a drive missing. Never
> thought the data or access to it could be compromised in what seemed to
> be a simple situation.
>
> Anand, I get the same output with mount -o recovery,ro.

Your data is gone if your other drive is gone.

Single doesn't mean what you think it means. Single means "one single 
copy of your data", but it has _nothing_ to do with "one single drive". 
That would mean that after a "btrfs device add" the default would be to 
never, ever, use that added drive.

So RAID0 means "striped", so there are chunks, then chunk=0 is on 
drive=0 at offset zero. Chunk=1 is on drive=1 at offset zero. (where 
there are N drives.) Chunk=N is on drive=N at offset zero. Chunk=N+1 is 
on drive=0 at offset Chunk_Size+1. And so on.

Concatenation is that drive=N follows drive=N-1 at offset 
sum(sizeofeach(all drives less than N)). So Byte=0 is on drive=0 at 
offset0; and Byte=(sizeof drive0) is on drive=1 at byte=0.

The RAID standard never addressed bulk concatenation, so there is no 
"raid-number" for the one whole drive after another. BTRFS uses 
"single", others use other words.

So if you had a 100G drive, and you added a second 100G drive, you'd 
have a logically 200G drive, where the first 100G is on drive one, and 
the second is on drive two.

You've basically obliterated the second half of the filesystem storage 
when you physically removed the drive without semantically removing it 
first. Might as well have erased it with a magnet, and all the data with 
it. Worse still, if you did any sort of balance or defrag you likely 
moved huge numbers of "the _single_ copy of your data" clusters onto 
that other device.

So the layout option isn't about limiting storage, that wouldn't make 
sense, that's what device add/delete is about. Its about how the data is 
laid out across all the drives.

All those unreachable addresses are on that now-defunct drive. No mount 
option will ever get you that data back.
