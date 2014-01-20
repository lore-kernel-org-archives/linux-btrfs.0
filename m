Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46480 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaATQE1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 11:04:27 -0500
Received: by mail-ie0-f180.google.com with SMTP id at1so5300680iec.25
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 08:04:27 -0800 (PST)
Message-ID: <52DD4907.5070207@gmail.com>
Date: Mon, 20 Jan 2014 11:04:23 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Bob Marley <bobmarley@shiftmail.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com> <52DC9453.4000705@gmail.com> <96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de> <52DD426A.5020104@shiftmail.org>
In-Reply-To: <52DD426A.5020104@shiftmail.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-20 10:36, Bob Marley wrote:
> On 20/01/2014 15:57, Ian Hinder wrote:
>> i.e. that there is parity information stored with every piece of data,
>> and ZFS will "correct" errors automatically from the parity information. 
> 
> So this is not just parity data to check correctness but there are many
> more additional bits to actually correct these errors, based on an
> algorithm like reed-solomon ?
> 
> Where can I find information on how much "parity" is stored in ZFS ?
> 
>> I start to suspect that there is confusion here between checksumming
>> for data integrity and parity information. If this is really how ZFS
>> works, then if memory corruption interferes with this process, then I
>> can see how a scrub could be devastating. 
> 
> I don't . If you have additional bits to correct errors (other than
> detect errors), this will never be worse than having less of them.
> All algorithms I know of, don't behave any worse if the erroneous bits
> are in the checksum part, or if the algorithm is correct+detect instead
> of just detect.
> If the algorithm stores X+2Y extra bits (supposed ZFS case) in order to
> detect&correct Y erroneous bits and detect additional X erroneous bits,
> this will not be worse than having just X checksum bits (btrfs case).
> 
> So does ZFS really uses detect&correct parity? I'd expect this to be
> quite a lot computationally expensive
> 
>> I don't know if ZFS really works like this. It sounds very odd to do
>> this without an additional checksum check. This sounds very different
>> to what you say below that btrfs does, which is only to check against
>> redundantly-stored copies, which I agree sounds much safer. The second
>> link above from the ZFS FAQ just says that if you place a very high
>> value on data integrity, you should be using ECC memory anyway, which
>> I'm sure we can all agree with.
>> hxxp://zfsonlinux.org/faq.html#DoIHaveToUseECCMemory:
>>> 1.16 Do I have to use ECC memory for ZFS?
>>> Using ECC memory for ZFS is strongly recommended for enterprise
>>> environments where the strongest data integrity guarantees are
>>> required. Without ECC memory rare random bit flips caused by cosmic
>>> rays or by faulty memory can go undetected. If this were to occur ZFS
>>> (or any other filesystem) will write the damaged data to disk and be
>>> unable to automatically detect the corruption.
> 
> The above sentence imho means that the data can get corrupted just prior
> to its first write.
> This is obviously applicable to every filesystem on earth, without ECC,
> especially if it happens prior to the computation of the parity.
> 
> BM
I apparently misunderstood what I had read about ZFS.  As for the parity
though, it's equivalent to RAID5, RAID6, or distributed striped
triple-parity RAID.  Looking further into ZFS itself, I'm starting to
wonder why ECC would be recommended for ZFS in cases other than using it
on a single disk, it should be able to handle SEU's as long as they
don't hit the executable code itself (it uses SHA256, which makes the
chances of a single-bit error going undetected astronomical in scale).

