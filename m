Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34795 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754633AbcIVUmY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Sep 2016 16:42:24 -0400
Subject: Re: btrfs rare silent data corruption with kernel data leak
To: Paul Jones <paul@pauljones.id.au>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20160921045556.GN21290@hungrycats.org>
 <ME1PR01MB13788B5A79BF88786A1D571D9EF60@ME1PR01MB1378.ausprd01.prod.outlook.com>
From: Chris Mason <clm@fb.com>
Message-ID: <c47741e6-76d4-0900-e126-2be4862233db@fb.com>
Date: Thu, 22 Sep 2016 16:42:06 -0400
MIME-Version: 1.0
In-Reply-To: <ME1PR01MB13788B5A79BF88786A1D571D9EF60@ME1PR01MB1378.ausprd01.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/21/2016 07:14 AM, Paul Jones wrote:
>> -----Original Message-----
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> owner@vger.kernel.org] On Behalf Of Zygo Blaxell
>> Sent: Wednesday, 21 September 2016 2:56 PM
>> To: linux-btrfs@vger.kernel.org
>> Subject: btrfs rare silent data corruption with kernel data leak
>>
>> Summary:
>>
>> There seem to be two btrfs bugs here: one loses data on writes, and the
>> other leaks data from the kernel to replace it on reads.  It all happens after
>> checksums are verified, so the corruption is entirely silent--no EIO errors,
>> kernel messages, or device event statistics.
>>
>> Compressed extents are corrupted with kernel data leak.  Uncompressed
>> extents may not be corrupted, or may be corrupted by deterministically
>> replacing data bytes with zero, or may not be corrupted.  No preconditions
>> for corruption are known.  Less than one file per hundred thousand seems to
>> be affected.  Only specific parts of any file can be affected.
>> Kernels v4.0..v4.5.7 tested, all have the issue.

Zygo, could you please bounce me your original email?  Somehow exchange 
ate it.

If you're seeing this databases that use fsync, it could be related to 
the fsync fix I put into the last RC.  On my boxes it caused crashes, 
but memory corruptions aren't impossible.

Any chance you can do a controlled experiment to rule out compression?

-chris
