Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:52693 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbbJTVCt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 17:02:49 -0400
Date: Tue, 20 Oct 2015 15:54:38 -0500
From: Tim Walberg <twalberg@comcast.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
Message-ID: <20151020205438.GC4598@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
 <201510201545.50705.russell@coker.com.au>
 <56263B0B.4050502@gmail.com>
 <201510210015.54337.russell@coker.com.au>
 <562648B5.2020401@gmail.com>
 <pan$6a87$d56eafce$4f04d0c$30b17c06@cox.net>
 <56269D1C.5080006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56269D1C.5080006@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/20/2015 15:59 -0400, Austin S Hemmelgarn wrote:
>>      .........
>>	With a 32-bit checksum and a 4k block (the math is easier with
>>	smaller numbers), that's 4128 bits, which means that a random
>>	single bit error will have a approximately 0.24% chance of
>>	occurring in a given bit, which translates to an approximately
>>	7.75% chance that it will occur in one of the checksum bits.  For a
>>	16k block it's smaller of course (around 1.8% I think, but that's
>>	just a guess), but it's still sufficiently statistically likely
>>	that it should be considered.
>>      .........



Last I checked, a 4 kilo-BYTE block consisted of 32768 BITs... So the
percentages should in fact be considerably smaller than that.


-- 
twalberg@gmail.com
