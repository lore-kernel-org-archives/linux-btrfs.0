Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40623 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2EYUmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 16:42:21 -0400
MIME-Version: 1.0
In-Reply-To: <4FBFEB49.7050901@brockmann-consult.de>
References: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
	<CAB9VWqAV+TohoMP0pcP6D6SEWB4o40XbHQssO1_Mbz3d_kUHaA@mail.gmail.com>
	<4FBFEB49.7050901@brockmann-consult.de>
Date: Fri, 25 May 2012 22:42:21 +0200
Message-ID: <CAB9VWqAnv2vyQDmw6+JKzj61+W-mWWV3ZmX-PNECm2RMEpkyqQ@mail.gmail.com>
Subject: Re: atime and filesystems with snapshots (especially Btrfs)
From: Alexander Block <ablock84@googlemail.com>
To: Peter Maloney <peter.maloney@brockmann-consult.de>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2012 at 10:27 PM, Peter Maloney
<peter.maloney@brockmann-consult.de> wrote:
> On 05/25/2012 09:10 PM, Alexander Block wrote:
>> Just to show some numbers I made a simple test on a fresh btrfs fs. I
>> copied my hosts /usr (4 gig) folder to that fs and checked metadata
>> usage with "btrfs fi df /mnt", which was around 300m. Then I created
>> 10 snapshots and checked metadata usage again, which didn't change
>> much. Then I run "grep foobar /mnt -R" to update all files atime.
>> After this was finished, metadata usage was 2.59 gig. So I lost 2.2
>> gig just because I searched for something. If someone already has
>> nearly no space left, he probably won't be able to move some data to
>> another disk, as he may get ENOSPC while copying the data.
>>
>> Here is the output of the final "btrfs fi df":
>>
>> # btrfs fi df /mnt
>> Data: total=6.01GB, used=4.19GB
>> System, DUP: total=8.00MB, used=4.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=3.25GB, used=2.59GB
>> Metadata: total=8.00MB, used=0.00
>>
>> I don't know much about other filesystems that support snapshots, but
>> I have the feeling that most of them would have the same problem. Also
>> all other filesystems in combination with LVM snapshots may cause
>> problems (I'm not very familiar with LVM). Filesystem image formats,
>> like qcow, vmdk, vbox and so on may also have problems with atime.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Did you run the recursive grep after each snapshot (which I would expect
> would result in 11 times as many metadata blocks, max 3.3 GB), or just
> once after all 10 snapshots (which I think would mean only 2x as many
> metadata blocks, max 600 MB)?
>

I've run it only once after creating all snapshots. My expectation is that
in both cases the result is the same. If all snapshots have the file /foo/bar,
then each individual snapshotted copy of it would have a different atime
and thus an own metadata block for it. As this happens with all files, no
matter how i iterated the files, then nearly all metadata blocks get their
own copy.
