Return-Path: <SRS0=taZz=QO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E5BC282C2
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 18:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E64E2175B
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Feb 2019 18:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dirtcellar.net header.i=@dirtcellar.net header.b="LGwyZVzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfBGSxH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Feb 2019 13:53:07 -0500
Received: from smtp.domeneshop.no ([194.63.252.55]:41990 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfBGSxH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Feb 2019 13:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dirtcellar.net; s=ds201810;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Reply-To; bh=vFip3Y9faQZd4zE3aioj3gNNz710W13bj57/vxkKE+U=;
        b=LGwyZVzoWv8E4/c9+0A0DcYnw1ivj92kPuYINNM4STbB5zqdQgtZGDM1jTfolND5zoofdi6h5+3Lyx+PHrjfwZBP2UUjv2uuSnSgh92OHeAPN15KibEcbE+9rnxMbEEewIH6h0+U58rCdz63NeWtH2UoeeYVdjh8oAFCGecFLSeGmSvqPmmRGSVT5AVSH380uYzbd/WNLVElNTnENcIInZXA42NChFHSzt54fMgtMYWkERDhh+htCZQGLGIdbd908tqquisGGLMwKLS/WjlHt9xk9Gs39wdFgfm+bhXfSmSONvlJcECa+UE8NYROl0ckYGlMqWlS3CJIgTrFYMymhA==;
Received: from 0.79-161-197.customer.lyse.net ([79.161.197.0]:21771 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1gronI-0006lc-1Z; Thu, 07 Feb 2019 19:53:04 +0100
Reply-To: waxhead@dirtcellar.net
Subject: Re: btrfs as / filesystem in RAID1
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Stefan K <shadow_7@gmx.net>, linux-btrfs@vger.kernel.org
References: <33679024.u47WPbL97D@t460-skr>
 <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr>
 <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
From:   waxhead <waxhead@dirtcellar.net>
Message-ID: <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net>
Date:   Thu, 7 Feb 2019 19:53:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Firefox/52.0 SeaMonkey/2.49.4
MIME-Version: 1.0
In-Reply-To: <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



Austin S. Hemmelgarn wrote:
> On 2019-02-07 06:04, Stefan K wrote:
>> Thanks, with degraded  as kernel parameter and also ind the fstab it 
>> works like expected
>>
>> That should be the normal behaviour, cause a server must be up and 
>> running, and I don't care about a device loss, thats why I use a 
>> RAID1. The device-loss problem can I fix later, but its important that 
>> a server is up and running, i got informed at boot time and also in 
>> the logs files that a device is missing, also I see that if you use a 
>> monitoring program.
> No, it shouldn't be the default, because:
> 
> * Normal desktop users _never_ look at the log files or boot info, and 
> rarely run monitoring programs, so they as a general rule won't notice 
> until it's already too late.  BTRFS isn't just a server filesystem, so 
> it needs to be safe for regular users too.

I am willing to argue that whatever you refer to as normal users don't 
have a clue how to make a raid1 filesystem, nor do they care about what 
underlying filesystem their computer runs. I can't quite see how a 
limping system would be worse than a failing system in this case. 
Besides "normal" desktop users use Windows anyway, people that run on 
penguin powered stuff generally have at least some technical knowledge.

> * It's easily possible to end up mounting degraded by accident if one of 
> the constituent devices is slow to enumerate, and this can easily result 
> in a split-brain scenario where all devices have diverged and the volume 
> can only be repaired by recreating it from scratch.

Am I wrong or would not the remaining disk have the generation number 
bumped on every commit? would it not make sense to ignore (previously) 
stale disks and require a manual "re-add" of the failed disks. From a 
users perspective with some C coding knowledge this sounds to me (in 
principle) like something as quite simple.
E.g. if the superblock UUID match for all devices and one (or more) 
devices has a lower generation number than the other(s) then the disk(s) 
with the newest generation number should be considered good and the 
other disks with a lower generation number should be marked as failed.

> * We have _ZERO_ automatic recovery from this situation.  This makes 
> both of the above mentioned issues far more dangerous.

See above, would this not be as simple as auto-deleting disks from the 
pool that has a matching UUID and a mismatch for the superblock 
generation number? Not exactly a recovery, but the system should be able 
to limp along.

> * It just plain does not work with most systemd setups, because systemd 
> will hang waiting on all the devices to appear due to the fact that they 
> refuse to acknowledge that the only way to correctly know if a BTRFS 
> volume will mount is to just try and mount it.

As far as I have understood this BTRFS refuses to mount even in 
redundant setups without the degraded flag. Why?! This is just plain 
useless. If anything the degraded mount option should be replaced with 
something like failif=X where X would be anything from 'never' which 
should get a 2 disk system up with exclusively raid1 profiles even if 
only one device is working. 'always' in case any device is failed or 
even 'atrisk' when loss of one more device would keep any raid chunk 
profile guarantee. (this get admittedly complex in a multi disk raid1 
setup or when subvolumes perhaps can be mounted with different "raid" 
profiles....)

> * Given that new kernels still don't properly generate half-raid1 chunks 
> when a device is missing in a two-device raid1 setup, there's a very 
> real possibility that users will have trouble recovering filesystems 
> with old recovery media (IOW, any recovery environment running a kernel 
> before 4.14 will not mount the volume correctly).
Sometimes you have to break a few eggs to make an omelette right? If 
people want to recover their data they should have backups, and if they 
are really interested in recovering their data (and don't have backups) 
then they will probably find this on the web by searching anyway...

> * You shouldn't be mounting writable and degraded for any reason other 
> than fixing the volume (or converting it to a single profile until you 
> can fix it), even aside from the other issues.

Well in my opinion the degraded mount option is counter intuitive. 
Unless otherwise asked for the system should mount and work as long as 
it can guarantee the data can be read and written somehow (regardless if 
any redundancy guarantee is not met). If the user is willing to accept 
more or less risk they should configure it!
