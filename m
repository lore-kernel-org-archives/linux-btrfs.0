Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35.italiaonline.it ([212.48.25.163]:48180 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751777AbcGRS4b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 14:56:31 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5
References: <20160716155111.GA9751@ks392938.kimsufi.com>
To: Jarkko Lavinen <jlavi@iki.fi>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <cc93fc7e-2bbf-40c3-807e-2b7d0b962335@libero.it>
Date: Mon, 18 Jul 2016 20:56:22 +0200
MIME-Version: 1.0
In-Reply-To: <20160716155111.GA9751@ks392938.kimsufi.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

On 2016-07-16 17:51, Jarkko Lavinen wrote:
> On 07/12/2016 05:50 PM, Goffredo Baroncelli wrote:
>> Using "btrfs insp phy" I developed a script to trigger the bug.
> 
> Thank you for the script and all for sharing the raid5 and scrubbing
> issues. I have been using two raid5 arrays and ran scrub occasionally
> without any problems lately and been in false confidence. I converted
> successfully raid5 arrays into raid10 without any glitch.
> 
> I tried to modify the shell script so that instead of corrupting data
> with dd, a simulated bad block is created with device mapper. Modern
> disks are likely to either return the correct data or an error if
> they cannot.


You are right; but doing so we are complicating further the test case:
- my tests show what happen when there is a corruption, but the drive behaves well
- your tests show what happen when there is a corruption AND the drive has a failure

I agree that your simulation is more realistic, but I fear that doing so we are complicating the bug finding.

> 
> The modified script behaves very much like the original dd version.
> With dd version I see wrong data instead of expected data. 

When toy say "I see wrong data", you means with 
1) "cat mnt/out.txt" 
or 2) with "dd if=/dev/loop....." ?

In the first case I see always good data; in the second case I see wrong data but of course no reading error

> With simulated bad block I see no data at all instead of expected data
> since dd quits on read error.
> 
> Jarkko Lavinen
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


