From: Henning Rohlfs <x+btrfs@xehonk.de>
Subject: Re: Abysmal Performance
Date: Tue, 21 Jun 2011 11:26:19 +0200
Message-ID: <d16814520f76be9fb5650ce47b52e2e4@localhost>
References: <7da312412980843ba746e4e8809060f8@localhost>
 <20110621080058.GA29265@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110621080058.GA29265@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

 On Tue, 21 Jun 2011 10:00:59 +0200, Sander wrote:
> Henning Rohlfs wrote (ao):
>> - space_cache was enabled, but it seemed to make the problem worse.
>> It's no longer in the mount options.
>
> space_cache is a one time mount option which enabled space_cache. Not
> supplying it anymore as a mount option has no effect (dmesg | grep 
> btrfs).

 I'm sure that after the first reboot after removing the flag from the 
 mount options, the system was faster for a while. That must have been a 
 coincidence (or just an error on my part).

 Anyway, I rebooted with clear_cache as mount option and there was no 
 improvement either.


 Thanks for pointing this out,
 Henning
