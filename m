Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:59395 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751220AbeEBTEq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 15:04:46 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID56 - 6 parity raid
To: waxhead@dirtcellar.net, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
References: <CAJH6TXi96F=kwZS4imACiOrkeoHz2LVjPpi2W0fWw781Fba3hA@mail.gmail.com>
 <pan$13d50$86fb3347$db26ba71$62968586@cox.net>
 <0931730f-be41-e63b-f7f9-85fd111d0470@libero.it>
 <bf58f92b-4d38-91dc-e515-eef5ab969dde@dirtcellar.net>
 <66dceb8e-7a43-10cc-2ec6-e477a55b4deb@inwind.it>
 <52465207-6c06-ef4b-b212-94b2199811a0@dirtcellar.net>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <8a40c582-7745-029c-f828-f07ce7ddc1c1@inwind.it>
Date: Wed, 2 May 2018 21:04:43 +0200
MIME-Version: 1.0
In-Reply-To: <52465207-6c06-ef4b-b212-94b2199811a0@dirtcellar.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/02/2018 08:17 PM, waxhead wrote:
> Goffredo Baroncelli wrote:
>> On 05/02/2018 06:55 PM, waxhead wrote:
>>>>
>>>> So again, which problem would solve having the parity checksummed ? On the best of my knowledge nothing. In any case the data is checksummed so it is impossible to return corrupted data (modulo bug :-) ).
>>>>
>>> I am not a BTRFS dev , but this should be quite easy to answer. Unless you checksum the parity there is no way to verify that that the data (parity) you use to reconstruct other data is correct.
>>
>> In any case you could catch that the compute data is wrong, because the data is always checksummed. And in any case you must check the data against their checksum.
>>
> What if you lost an entire disk? or had corruption for both data AND checksum? How do you plan to safely reconstruct that without checksummed parity?

As general rule, the returned data is *always* check against their checksum. So in any case wrong data is never returned. Let me to say in another words: having the parity checksummed doesn't increase the reliability and or the safety of the RAID rebuilding. I want to repeat again: even if the parity is corrupted, the rebuild (wrong) data fails the check against its checksum and it is not returned !

Back to your questions:

1) Loosing 1 disks -> 1 fault
2) Loosing both data and checksum -> 2 faults

RAID5 is single fault prof. So if case #2 happens, raid5 can't protect you. However BTRFS is capable to detect that the data is wrong due to checksum.
In case #1, there is no problem, because for each stripe you have enough data to rebuild the missing one.

Because I read several time that the checksum parity would increase the reliability and/or the safety of the raid5/6 profile, let me to explain the logic:

read_from_disk() {
	data = read_data()
	if (data != ERROR && check_checksum(data))
		return data;
	/* checksum mismatch or data is missing */
	full_stripe = read_full_stripe()
	if (raid5_profile) {
		/* raid5 has only one way of rebuilding data */
		data = rebuild_raid5_data(full_stripe)
		if (data != ERROR && check_checksum(data)) {
			rebuild_stripe(data, full_stripe)
			return data;
		}
		/* parity and/or another data is corrupted/missed */
		return ERROR
	}

	for_each raid6_rebuilding_strategies(full_stripe) {
		/* 
		 * raid6 might have more than one way of rebuilding data 
		 * depending by the degree of failure
		 */
		data = rebuild_raid6_data(full_stripe)
		if (data != ERROR && check_checksum(data)) {
			rebuild_stripe(data, full_stripe)
			/* data is good, return it */
			return data;
		}
	}
	return ERROR	
}

In case of raid5, there is only one way of rebuild the data. In case of raid6 and 1 fault, there are several way of rebuilding data (however in case of two failure, there are only one way). So more possibilities have to be tested for rebuilding the data.
If the parity is corrupted, the rebuild data is corrupted too, and it fails the check against its checksum.


> 
>> My point is that storing the checksum is a cost that you pay *every time*. Every time you update a part of a stripe you need to update the parity, and then in turn the parity checksum. It is not a problem of space occupied nor a computational problem. It is a a problem of write amplification...
> How much of a problem is this? no benchmarks have been run since the feature is not yet there I suppose.

It is simple, for each stripe touched you need to update the parity(1); then you need to update parity checksums(1) (which in turn would requires an update of the parity(2) of the stripe where is stored the parity(1) checksums, which in turn would requires to update the parity(2) checksum... and so on)

> 
>>
>> The only gain is to avoid to try to use the parity when
>> a) you need it (i.e. when the data is missing and/or corrupted)
> I'm not sure I can make out your argument here , but with RAID5/6 you don't have another copy to restore from. You *have* to use the parity to reconstruct data and it is a good thing if this data is trusted.
I never say the opposite

> 
>> and b) it is corrupted.
>> But the likelihood of this case is very low. And you can catch it during the data checksum check (which has to be performed in any case !).
>>
>> So from one side you have a *cost every time* (the write amplification), to other side you have a gain (cpu-time) *only in case* of the parity is corrupted and you need it (eg. scrub or corrupted data)).
>>
>> IMHO the cost are very higher than the gain, and the likelihood the gain is very lower compared to the likelihood (=100% or always) of the cost.
>>
> Then run benchmarks and considering making parity checksums optional (but pretty please dipped in syrup with sugar on top - keep in on by default).
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
