Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:4484 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887AbaATPpB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 10:45:01 -0500
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by server (Postfix) with ESMTPSA id 42E7E313CE
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 10:41:16 -0500 (EST)
Message-ID: <52DD426A.5020104@shiftmail.org>
Date: Mon, 20 Jan 2014 16:36:10 +0100
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs and ECC RAM
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com> <52DC9453.4000705@gmail.com> <96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de>
In-Reply-To: <96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/01/2014 15:57, Ian Hinder wrote:
> i.e. that there is parity information stored with every piece of data, 
> and ZFS will "correct" errors automatically from the parity information. 

So this is not just parity data to check correctness but there are many 
more additional bits to actually correct these errors, based on an 
algorithm like reed-solomon ?

Where can I find information on how much "parity" is stored in ZFS ?

> I start to suspect that there is confusion here between checksumming 
> for data integrity and parity information. If this is really how ZFS 
> works, then if memory corruption interferes with this process, then I 
> can see how a scrub could be devastating. 

I don't . If you have additional bits to correct errors (other than 
detect errors), this will never be worse than having less of them.
All algorithms I know of, don't behave any worse if the erroneous bits 
are in the checksum part, or if the algorithm is correct+detect instead 
of just detect.
If the algorithm stores X+2Y extra bits (supposed ZFS case) in order to 
detect&correct Y erroneous bits and detect additional X erroneous bits, 
this will not be worse than having just X checksum bits (btrfs case).

So does ZFS really uses detect&correct parity? I'd expect this to be 
quite a lot computationally expensive

> I don't know if ZFS really works like this. It sounds very odd to do 
> this without an additional checksum check. This sounds very different 
> to what you say below that btrfs does, which is only to check against 
> redundantly-stored copies, which I agree sounds much safer. The second 
> link above from the ZFS FAQ just says that if you place a very high 
> value on data integrity, you should be using ECC memory anyway, which 
> I'm sure we can all agree with. 
> hxxp://zfsonlinux.org/faq.html#DoIHaveToUseECCMemory:
>> 1.16 Do I have to use ECC memory for ZFS?
>> Using ECC memory for ZFS is strongly recommended for enterprise environments where the strongest data integrity guarantees are required. Without ECC memory rare random bit flips caused by cosmic rays or by faulty memory can go undetected. If this were to occur ZFS (or any other filesystem) will write the damaged data to disk and be unable to automatically detect the corruption.

The above sentence imho means that the data can get corrupted just prior 
to its first write.
This is obviously applicable to every filesystem on earth, without ECC, 
especially if it happens prior to the computation of the parity.

BM

