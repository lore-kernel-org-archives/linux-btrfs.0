Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10a-lesia.wadns.net ([196.220.39.109]:17836 "EHLO
	fw10a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751806AbaEKOMI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 10:12:08 -0400
Message-ID: <536F852C.3000100@swiftspirit.co.za>
Date: Sun, 11 May 2014 16:11:56 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: russell@coker.com.au, linux-btrfs@vger.kernel.org
Subject: Re: -musage=>0 means always reporting relocation
References: <201405111943.16913.russell@coker.com.au> <201405111952.43458.russell@coker.com.au>
In-Reply-To: <201405111952.43458.russell@coker.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/11 11:52 AM, Russell Coker wrote:
> On Sun, 11 May 2014, Russell Coker <russell@coker.com.au> wrote:
>> Below is the output of running a balance a few times on a 120G SSD.
> Sorry forgot to mention that's kernel 3.14.1 Debian package.
>
Please send the output of the two following command:
btrfs fi df /

This will give more information on your current chunk situation. I 
suspect this is a case where a system chunk (which is included when 
specifying metadata) that is not actually being relocated. This is a bug 
that I believe was already fixed, though I'm not sure in which version.

The pathological case is where you have a chunk that is 1% full and 
*every* other in-use chunk on the device is 100% full. In that 
situation, a balance will simply move that data into a new chunk (which 
will only ever reach 1% full). Thus, all subsequent balances will 
relocate that same data again to another new chunk.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

